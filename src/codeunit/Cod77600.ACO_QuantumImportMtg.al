namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using System.IO;
using System.Utilities;
using Microsoft.Utilities;
using Acora.AvTrade.MainApp;
using Microsoft.Sales.Document;
using Microsoft.Sales.Posting;
using Microsoft.Sales.Customer;
using Microsoft.Finance.Currency;
using Microsoft.Finance.GeneralLedger.Account;


Codeunit 50900 "ACO_QuantumImportMtg"
{
    //#region "Documentation"
    // 1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    // 1.3.3.2018 LBR 12/09/2019 - Change the Invoice/Credit Import to update currency even if is blank
    // 1.3.4.2018 LBR 13/09/2019 - CHG003321 (Import Log) Import Data Validation table for error log;
    // 1.3.5.2018 LBR 01/10/2019 - The import logic is no longer using items. Norm Code is GL code use for import purpose.
    // MODERNIZED: TempBlob to Temp Blob for BC compatibility
    //#endregion "Documentation"
    //////////////////// INVOICE /////////////////////////////
    //#region QuantumInvoiceImportFunctions
    local procedure _____INVOICE_____();
    begin
        // Dummy function for outline view purpose
    end;

    procedure ManuallyImportQuantumInvoiceFile()
    var
    begin
        if GuiAllowed then begin
            gDialog.Open(gProgressBarLbl);
        end;
        // If manual import the parameter should be blank
        ImportQuantumInvoiceFile('');
        // Show summary message;
        IF GuiAllowed then begin
            gDialog.Close();
            if gNoOfDocToImport <> 0 then
                Message(gInfoLbl, gNoOfDocToImport, gNoOfDocCreated, gNoOfDocPosted);
        end;
    end;

    procedure AutoImportQuantumInvoice();
    var
        tempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        ImportFileName: Text;
        // File Mgt codeunit is using dot net therfore for BC upgraded it should be replaced with Azure functions instead
        fileMgt: Codeunit "File Management";
        fileList: Record "Name/Value Buffer" temporary;
    begin
        if GuiAllowed then begin
            gDialog.Open(gProgressBarLbl);
        end;
        GetAdditionalSetup();
        AdditionalSetup.TESTFIELD(ACO_InvoiceFileSource);
        AdditionalSetup.TESTFIELD(ACO_InvoiceFileProcessed);
        // Get all filse in the directory
        fileMgt.GetServerDirectoryFilesList(fileList, AdditionalSetup.ACO_InvoiceFileSource);
        if fileList.findset() then begin
            repeat
            begin
                if (UpperCase(CopyStr(fileList.Name, StrLen(fileList.Name) - 2)) = 'CSV') then begin
                    // Import File
                    ImportQuantumInvoiceFile(fileList.Name);
                    // Move File to Archive
                    fileMgt.CopyServerFile(fileList.Name,
                        GeneralFunctions.AddSlashAtTheEnd(AdditionalSetup.ACO_InvoiceFileProcessed) +
                        Format(CurrentDateTime, 0, '<year4><month,2><day,2>_<hours24><minutes,2>_') +
                        GetFileName(fileList.Name),
                        true);
                    fileMgt.DeleteServerFile(fileList.Name);
                end;
            end;
            until fileList.Next() = 0;
        end;
        // Show summary message;
        IF GuiAllowed then begin
            gDialog.Close();
            if gNoOfDocToImport <> 0 then
                Message(gInfoLbl, gNoOfDocToImport, gNoOfDocCreated, gNoOfDocPosted);
        end;
    end;

    local procedure ImportQuantumInvoiceFile(pFile: text)
    var
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        ImportFileName: Text;
        xmlInvoiceImport: XmlPort ACO_InvoiceImport;
        InvImportBuffer: Record ACO_ImportBuffer temporary;
        ImportNo: Integer;
        fileMgt: Codeunit "File Management";
    begin
        // IF the parameter have a value then it is auto-import otherwise run xml port in the normal way to ask for a file
        if (pFile <> '') then begin
            //Modern TempBlob codeunit usage - load file data first
            fileMgt.BLOBImportFromServerFile(tempBlob, pFile);
            tempBlob.CreateInStream(inStr);
            xmlInvoiceImport.SetSource(inStr);
            xmlInvoiceImport.SetgFileName(pFile);
            xmlInvoiceImport.Import();
        end else begin
            // Run Xml Port
            xmlInvoiceImport.Run();
        end;
        // Get Imported Buffer
        xmlInvoiceImport.GetImportLogNo(ImportNo);
        // Proceed with Buffer
        ProceedImportedQuantumInvoices(ImportNo);
    end;

    procedure ProceedImportedQuantumInvoices(ImportNo: Integer);
    var
        lImportLog: Record ACO_ImportLog;
        lCustomerNo: code[20];
        lDocumentNo: code[20];
        lCurrencyCode: code[20];
        lQuantumImportProceed: Codeunit ACO_QuantumImportProceed;
        lSalesHeaderForPosting: Record "Sales Header";
        lSalesPost: Codeunit "Sales-Post";
    begin
        // Validation has been done during XML import therfore is not needed here
        //
        // Review all lines and update error tick to not import invoices if any line have an validation error
        UpdateImportLogErrorInfo(lImportLog.ACO_ImportType::Invoice, ImportNo);
        // Find lines without error and create Sales document
        with lImportLog do begin
            SetCurrentKey(ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode, ACO_Error);
            SetRange(ACO_ImportType, lImportLog.ACO_ImportType::Invoice);
            SetRange(ACO_ImportNo, ImportNo);
            SetRange(Aco_error, false);
            if findset(true) then begin
                repeat
                begin
                    ClearLastError();
                    if (lDocumentNo <> ACO_DocumentNo) OR (lCustomerNo <> ACO_CustomerNo) OR (lCurrencyCode <> ACO_CurrencyCode)
                    then begin
                        // This is needed for document creation
                        Commit();
                        // Create Document in NAV if any error appear update import log
                        clear(lQuantumImportProceed);
                        if not lQuantumImportProceed.run(lImportLog) then begin
                            Validate(ACO_ErrorDescription, GetLastErrorText);
                            Modify(true);
                        end else begin
                            // Udate statistics
                            gNoOfDocCreated += 1;
                            // Mark for posting
                            lSalesHeaderForPosting.Get(lSalesHeaderForPosting."Document Type"::Invoice, ACO_DocumentNo);
                            lSalesHeaderForPosting.Mark(True);
                        end;
                        // Update group values
                        lDocumentNo := ACO_DocumentNo;
                        lCustomerNo := ACO_CustomerNo;
                        lCurrencyCode := ACO_CurrencyCode;
                    end;
                end;
                until Next() = 0;
            end;
        end;
        // Review all lines and update error tick correctly per import after document creation
        UpdateImportLogErrorInfo(lImportLog.ACO_ImportType::Invoice, ImportNo);
        // Update Statistics:
        UpdateTotalNoOfDocInFile(lImportLog.ACO_ImportType::Invoice, ImportNo);
        // This is needed for posting
        Commit();
        // Post Document
        if AdditionalSetup.ACO_AutoPostInvoiceFile then begin
            lSalesHeaderForPosting.MarkedOnly(True);
            if lSalesHeaderForPosting.findset() then begin
                repeat
                begin
                    Clear(lSalesPost);
                    IF NOT lSalesPost.Run(lSalesHeaderForPosting) THEN begin
                        // If required add upadte import log to see what has been posted and what not
                    end else begin
                        // Udate statistics
                        gNoOfDocPosted += 1;
                    end;
                end;
                until lSalesHeaderForPosting.next() = 0;
            end;
        end;
    end;
    //#endregion QuantumInvoiceImportFunctions
    //////////////////// CREDIT /////////////////////////////
    //#region QuantumCreditImportFunctions
    local procedure _____CREDIT_____();
    begin
        // Dummy function for outline view purpose
    end;

    procedure ManuallyImportQuantumCreditFile()
    var
    begin
        if GuiAllowed then begin
            gDialog.Open(gProgressBarLbl);
        end;
        // If manual import the parameter should be blank
        ImportQuantumCreditFile('');
        // Show summary message;
        IF GuiAllowed then begin
            gDialog.Close();
            if gNoOfDocToImport <> 0 then
                Message(gInfoLbl, gNoOfDocToImport, gNoOfDocCreated, gNoOfDocPosted);
        end;
    end;

    procedure AutoImportQuantumCredit();
    var
        tempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        ImportFileName: Text;
        // File Mgt codeunit is using dot net therfore for BC upgraded it should be replaced with Azure functions instead
        fileMgt: Codeunit "File Management";
        fileList: Record "Name/Value Buffer" temporary;
    begin
        if GuiAllowed then begin
            gDialog.Open(gProgressBarLbl);
        end;
        GetAdditionalSetup();
        AdditionalSetup.TESTFIELD(ACO_CreditFileSource);
        AdditionalSetup.TESTFIELD(ACO_CreditFileProcessed);
        // Get all filse in the directory
        fileMgt.GetServerDirectoryFilesList(fileList, AdditionalSetup.ACO_CreditFileSource);
        if fileList.findset() then begin
            repeat
            begin
                if (UpperCase(CopyStr(fileList.Name, StrLen(fileList.Name) - 2)) = 'CSV') then begin
                    // Import File
                    ImportQuantumCreditFile(fileList.Name);
                    // Move File to Archive
                    fileMgt.CopyServerFile(fileList.Name,
                        GeneralFunctions.AddSlashAtTheEnd(AdditionalSetup.ACO_CreditFileProcessed) +
                        Format(CurrentDateTime, 0, '<year4><month,2><day,2>_<hours24><minutes,2>_') +
                        GetFileName(fileList.Name),
                        true);
                    fileMgt.DeleteServerFile(fileList.Name);
                end;
            end;
            until fileList.Next() = 0;
        end;
        // Show summary message;
        IF GuiAllowed then begin
            gDialog.Close();
            if gNoOfDocToImport <> 0 then
                Message(gInfoLbl, gNoOfDocToImport, gNoOfDocCreated, gNoOfDocPosted);
        end;
    end;

    local procedure ImportQuantumCreditFile(pFile: text)
    var
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        ImportFileName: Text;
        xmlCreditImport: XmlPort ACO_CreditImport;
        InvImportBuffer: Record ACO_ImportBuffer temporary;
        ImportNo: Integer;
        fileMgt: Codeunit "File Management";
    begin
        // IF the parameter have a value then it is auto-import otherwise run xml port in the normal way to ask for a file
        if (pFile <> '') then begin
            //Modern TempBlob codeunit usage - load file data first
            fileMgt.BLOBImportFromServerFile(tempBlob, pFile);
            tempBlob.CreateInStream(inStr);
            //Import File
            xmlCreditImport.SetSource(inStr);
            xmlCreditImport.SetgFileName(pFile);
            xmlCreditImport.Import();
        end else begin
            // Run Xml Port
            xmlCreditImport.Run();
        end;
        // Get Imported Buffer
        xmlCreditImport.GetImportLogNo(ImportNo);
        // Proceed with Buffer
        ProceedImportedQuantumCredits(ImportNo);
    end;

    procedure ProceedImportedQuantumCredits(ImportNo: Integer);
    var
        lImportLog: Record ACO_ImportLog;
        lCustomerNo: code[20];
        lDocumentNo: code[20];
        lCurrencyCode: code[20];
        lQuantumImportProceed: Codeunit ACO_QuantumImportProceed;
        lSalesHeaderForPosting: Record "Sales Header";
        lSalesPost: Codeunit "Sales-Post";
    begin
        // Validation has been done during XML import therfore is not needed here
        //
        // Review all lines and update error tick to not import Credits if any line have an validation error
        UpdateImportLogErrorInfo(lImportLog.ACO_ImportType::Credit, ImportNo);
        // Find lines without error and create Sales document
        with lImportLog do begin
            SetCurrentKey(ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode, ACO_Error);
            SetRange(ACO_ImportType, lImportLog.ACO_ImportType::Credit);
            SetRange(ACO_ImportNo, ImportNo);
            SetRange(Aco_error, false);
            if findset(true) then begin
                repeat
                begin
                    ClearLastError();
                    if (lDocumentNo <> ACO_DocumentNo) OR (lCustomerNo <> ACO_CustomerNo) OR (lCurrencyCode <> ACO_CurrencyCode)
                    then begin
                        // This is needed for document creation
                        Commit();
                        // Create Document in NAV if any error appear update import log
                        clear(lQuantumImportProceed);
                        if not lQuantumImportProceed.run(lImportLog) then begin
                            Validate(ACO_ErrorDescription, GetLastErrorText);
                            Modify(true);
                        end else begin
                            // Udate statistics
                            gNoOfDocCreated += 1;
                            // Mark for posting
                            lSalesHeaderForPosting.Get(lSalesHeaderForPosting."Document Type"::"Credit Memo", ACO_DocumentNo);
                            lSalesHeaderForPosting.Mark(True);
                        end;
                        // Update group values
                        lDocumentNo := ACO_DocumentNo;
                        lCustomerNo := ACO_CustomerNo;
                        lCurrencyCode := ACO_CurrencyCode;
                    end;
                end;
                until Next() = 0;
            end;
        end;
        // Review all lines and update error tick correctly per import after document creation
        UpdateImportLogErrorInfo(lImportLog.ACO_ImportType::Credit, ImportNo);
        // Update Statistics:
        UpdateTotalNoOfDocInFile(lImportLog.ACO_ImportType::Credit, ImportNo);
        // This is needed for posting
        Commit();
        // Post Document
        if AdditionalSetup.ACO_AutoPostCreditFile then begin
            lSalesHeaderForPosting.MarkedOnly(True);
            if lSalesHeaderForPosting.findset() then begin
                repeat
                begin
                    Clear(lSalesPost);
                    IF NOT lSalesPost.Run(lSalesHeaderForPosting) THEN begin
                        // If required add upadte import log to see what has been posted and what not
                    end else begin
                        // Udate statistics
                        gNoOfDocPosted += 1;
                    end;
                end;
                until lSalesHeaderForPosting.next() = 0;
            end;
        end;
    end;
    //#endregion QuantumCreditImportFunctions
    //////////////////// EXPOSURE /////////////////////////////
    //#region QuantumExposureImportFunctions
    local procedure _____EXPOSURE_____();
    begin
        // Dummy function for outline view purpose
    end;

    procedure ManuallyImportQuantumExposureFile()
    begin
        // Clear counters before import
        gNoOfDocToImport := 0;
        gNoOfDocCreated := 0;
        gNoOfDocPosted := 0;

        //If the param is blank the system will run xml port as per run
        ImportQuantumExposureFile('');

        // Show summary message after import
        if GuiAllowed then begin
            if gNoOfDocToImport <> 0 then
                Message(gInfoLbl, gNoOfDocToImport, gNoOfDocCreated, gNoOfDocPosted);
        end;
    end;

    procedure AutoImportQuantumExposure();
    var
        tempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        ImportFileName: Text;
        // File Mgt codeunit is using dot net therfore for BC upgraded it should be replaced with Azure functions instead
        fileMgt: Codeunit "File Management";
        fileList: Record "Name/Value Buffer" temporary;
        counter: Integer;
        NoOfFilesImpLbl: Label 'Number of files imported: %1';
    begin
        GetAdditionalSetup();
        AdditionalSetup.TESTFIELD(ACO_ExposureFileSource);
        AdditionalSetup.TESTFIELD(ACO_ExposureFileProcessed);
        // Get all filse in the directory
        fileMgt.GetServerDirectoryFilesList(fileList, AdditionalSetup.ACO_ExposureFileSource);
        if fileList.findset() then begin
            repeat
            begin
                if (UpperCase(CopyStr(fileList.Name, StrLen(fileList.Name) - 2)) = 'CSV') then begin
                    // Import File
                    ImportQuantumExposureFile(fileList.Name);
                    // Move File to Archive
                    fileMgt.CopyServerFile(fileList.Name,
                        GeneralFunctions.AddSlashAtTheEnd(AdditionalSetup.ACO_ExposureFileProcessed) +
                        Format(CurrentDateTime, 0, '<year4><month,2><day,2>_<hours24><minutes,2>_') +
                        fileList.Value,
                        true);
                    fileMgt.DeleteServerFile(fileList.Name);
                    counter += 1;
                end;
            end;
            until fileList.Next() = 0;
        end;
        if GuiAllowed then
            Message(NoOfFilesImpLbl, counter);
    end;

    local procedure ImportQuantumExposureFile(pFile: text)
    var
        tempBlob: Codeunit "Temp Blob";
        inStr: InStream;
        ImportFileName: Text;
        xmlExposureImport: XmlPort ACO_ExposureImport;
        fileMgt: Codeunit "File Management";
    begin
        // IF the parameter have a value then it is auto-import otherwise run xml port in the normal way to ask for a file
        if (pFile <> '') then begin
            //Prepare File - RESTORED 2018 NAV APPROACH
            fileMgt.BLOBImportFromServerFile(tempBlob, pFile);
            tempBlob.CreateInStream(inStr);
            //Import File using XMLPort (same as 2018 NAV)
            xmlExposureImport.SetSource(inStr);
            xmlExposureImport.Import();
        end else begin
            //Xmlport.Run(XMLPort::ACO_ExposureImport, false, true);
            xmlExposureImport.Run();
        end;
    end;
    //#endregion QuantumExposureImportFunctions
    //////////////////// HELPER /////////////////////////////
    //#region HelpFunctions
    local procedure _____HELPER_____();
    begin
        // Dummy function for outline view purpose
    end;

    procedure GetFileName(FileName: Text) ReturnValue: Text;
    var
        fileMgt: Codeunit "File Management";
    begin
        exit(fileMgt.GetFileName(FileName));
    end;

    procedure UpdateTotalNoOfDocInFile(ImportType: Integer; ImportNo: Integer);
    var
        lImportLog: Record ACO_ImportLog;
        lCustomerNo: code[20];
        lDocumentNo: code[20];
        lCurrencyCode: code[20];
    begin
        with lImportLog do begin
            SetCurrentKey(ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode, ACO_Error);
            SetRange(ACO_ImportType, ImportType);
            SetRange(ACO_ImportNo, ImportNo);
            if findset(false) then begin
                repeat
                begin
                    if (lDocumentNo <> ACO_DocumentNo) OR (lCustomerNo <> ACO_CustomerNo) OR (lCurrencyCode <> ACO_CurrencyCode)
                    then begin
                        gNoOfDocToImport += 1;
                        // Update group values
                        lDocumentNo := ACO_DocumentNo;
                        lCustomerNo := ACO_CustomerNo;
                        lCurrencyCode := ACO_CurrencyCode;
                    end;
                end;
                until Next() = 0;
            end;
        end;
    end;

    procedure UpdateImportLogErrorInfo(ImportType: Integer; ImportNo: Integer);
    var
        lImportLog: Record ACO_ImportLog;
        lImportLogTMP: Record ACO_ImportLog temporary;
    begin
        // Find all entries with error
        with lImportLog do begin
            SetCurrentKey(ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode, ACO_Error);
            SetRange(ACO_ImportType, ImportType);
            SetRange(ACO_ImportNo, ImportNo);
            SetRange(Aco_error, true);
            if findset(false) then begin
                repeat
                begin
                    lImportLogTMP.TransferFields(lImportLog);
                    lImportLogTMP.Insert();
                end;
                until Next() = 0;
            end;
        end;
        // Update outstanding records to adjust with error
        with lImportLogTMP do begin
            Reset();
            if findset(false) then begin
                repeat
                begin
                    // other filters are already pre-set
                    lImportLog.SetRange(ACO_DocumentNo, ACO_DocumentNo);
                    lImportLog.SetRange(ACO_CustomerNo, ACO_CustomerNo);
                    lImportLog.SetRange(ACO_CurrencyCode, ACO_CurrencyCode);
                    lImportLog.SetRange(Aco_error, false);
                    lImportLog.ModifyAll(ACO_Error, true);
                end;
                until lImportLog.Next() = 0;
            end;
        end;
    end;

    local procedure GetAdditionalSetup()
    begin
        If not AdditionalSetup.get() then
            AdditionalSetup.init();
    end;

    procedure GetCustomerNo(Column_CustomerNo: Text; var ReturnValue: Code[20]) ErrorTxt: Text;
    var
        Customer: Record Customer;
        ErrorLbl: Label 'Customer code %1 does not exist.';
    begin
        // Find correct Customer code
        ReturnValue := '';
        if (STRLEN(Column_CustomerNo) > 20) then
            Column_CustomerNo := CopyStr(Column_CustomerNo, 1, 20);
        if Customer.get(Column_CustomerNo) then
            ReturnValue := Customer."No."
        else begin
            ReturnValue := '';
            ErrorTxt := StrSubstNo(ErrorLbl, Column_CustomerNo);
        end;
    END;

    procedure GetCurrencyCode(Column_CurrencyCode: Text; var ReturnValue: Code[20]) ErrorTxt: Text;
    var
        Currency: Record Currency;
        ErrorLbl: Label 'Currency code %1 does not exist.';
    begin
        // Find correct currency code
        ReturnValue := '';
        if (STRLEN(Column_CurrencyCode) > 2) then begin
            ReturnValue := CopyStr(Column_CurrencyCode, 1, 3);
            IF NOT Currency.GET(ReturnValue) THEN begin
                Currency.RESET();
                Currency.Setfilter(Description, '*@%1*', Column_CurrencyCode);
                IF Currency.FINDFIRST() then
                    ReturnValue := Currency.Code
                else begin
                    ReturnValue := '';
                    ErrorTxt := StrSubstNo(ErrorLbl, Column_CurrencyCode);
                end;
            END;
        end;
    end;

    procedure GetDecimalValue(Column_Value: Text; var ReturnValue: Decimal) ErrorTxt: Text;
    var
        ErrorLbl: Label 'Value %1 cannot be evaluated';
    begin
        if Column_Value = '' then begin
            ReturnValue := 0;
            exit;
        end;
        if not Evaluate(ReturnValue, Column_Value) then
            ErrorTxt := StrSubstNo(ErrorLbl, Column_Value);
    end;

    procedure GetDateValue(Column_Value: Text; var ReturnValue: Date) ErrorTxt: Text;
    var
        ErrorLbl: Label 'Value %1 cannot be evaluated';
    begin
        if not Evaluate(ReturnValue, Column_Value) then
            ErrorTxt := StrSubstNo(ErrorLbl, Column_Value);
    end;

    procedure GetCode10Value(Column_Value: Text; var ReturnValue: Code[10]) ErrorTxt: Text;
    var
        ErrorLbl: Label 'Value %1 cannot be evaluated';
    begin
        if not Evaluate(ReturnValue, Column_Value) then
            ErrorTxt := StrSubstNo(ErrorLbl, Column_Value);
    end;

    procedure GetCode20Value(Column_Value: Text; var ReturnValue: Code[20]) ErrorTxt: Text;
    var
        ErrorLbl: Label 'Value %1 cannot be evaluated';
    begin
        if not Evaluate(ReturnValue, Column_Value) then
            ErrorTxt := StrSubstNo(ErrorLbl, Column_Value);
    end;

    procedure GetText35Value(Column_Value: Text; var ReturnValue: Code[35]) ErrorTxt: Text;
    var
        ErrorLbl: Label 'Value %1 cannot be evaluated';
    begin
        if not Evaluate(ReturnValue, Column_Value) then
            ErrorTxt := StrSubstNo(ErrorLbl, Column_Value);
    end;
    //>>1.3.5.2018
    // procedure GetProductCode(Column_ItemNo: Text; var ReturnValue: Code[20]) ErrorTxt: Text;
    // var
    //     Item: Record Item;
    //     ErrorLbl: Label 'Item code %1 does not exist.';
    // begin
    //     // Find correct Customer code
    //     ReturnValue := '';
    //     if (STRLEN(Column_ItemNo) > 20) then
    //         Column_ItemNo := CopyStr(Column_ItemNo, 1, 20);
    //     if Item.get(Column_ItemNo) then
    //         ReturnValue := Item."No."
    //     else begin
    //         ReturnValue := '';
    //         ErrorTxt := StrSubstNo(ErrorLbl, Column_ItemNo);
    //     end;
    // END;
    procedure GetGLAccountCode(Column_NormCode: Text; var ReturnValue: Code[20]) ErrorTxt: Text;
    var
        GLAccount: Record "G/L Account";
        ErrorLbl: Label 'G/L Account code %1 does not exist.';
    begin
        // Find correct Customer code
        ReturnValue := '';
        if (STRLEN(Column_NormCode) > 20) then
            Column_NormCode := CopyStr(Column_NormCode, 1, 20);
        if GLAccount.get(Column_NormCode) then
            ReturnValue := GLAccount."No."
        else begin
            ReturnValue := '';
            ErrorTxt := StrSubstNo(ErrorLbl, Column_NormCode);
        end;
    END;
    //<<1.3.5.2018
    procedure UpdateInvoiceUnitPrice(CustomerNo: Code[20]; var UnitPrice: Decimal) ErrorTxt: Text;
    var
        AdditionalSetup: record ACO_AdditionalSetup;
        Customer: Record Customer;
    begin
        if UnitPrice = 0 then
            exit;
        if not AdditionalSetup.get() then
            AdditionalSetup.init();
        // If value is near to 0 then it should be special case
        if (UnitPrice > (-1 * AdditionalSetup.ACO_UnitPriceRoundToZeroTol)) and (UnitPrice < AdditionalSetup.ACO_UnitPriceRoundToZeroTol)
        then begin
            // Customer must exist
            Customer.Get(CustomerNo);
            if Customer.ACO_CancelledInvoicePosting = Customer.ACO_CancelledInvoicePosting::"As Zero Line" then
                UnitPrice := 0
        end;
    end;

    procedure UpdateInvoiceProductCode(CustomerNo: Code[20]; UnitPrice: Decimal; var ProductCode: Code[20]) ErrorTxt: Text;
    var
        AdditionalSetup: Record ACO_AdditionalSetup;
        Customer: Record Customer;
    begin
        if ProductCode = '' then
            exit;
        if (UnitPrice = 0) then begin
            // Customer must exist
            Customer.Get(CustomerNo);
            // Get correct product code
            ProductCode := Customer.ACO_ZeroLineItemNo;
            // At that stage this fields needs to have value
            AdditionalSetup.TestField(ACO_DefaultZeroLineItemNo);
            if ProductCode = '' then begin
                ProductCode := AdditionalSetup.ACO_DefaultZeroLineItemNo;
            end;
        end;
    end;
    //#endregion HelpFunctions
    var
        AdditionalSetup: Record ACO_AdditionalSetup;
        GeneralFunctions: Codeunit ACO_GeneralFunctions;
        gDialog: Dialog;
        gProgressBarLbl: Label 'Processing ...';
        gInfoLbl: Label 'IMPORT SUMMARY:\No. of documents in file(s): %1\No. of documents created: %2\No. of documents posted: %3';
        gNoOfDocToImport: Integer;
        gNoOfDocCreated: Integer;
        gNoOfDocPosted: Integer;
}

