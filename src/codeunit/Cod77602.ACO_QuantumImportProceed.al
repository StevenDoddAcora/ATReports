codeunit 50902 "ACO_QuantumImportProceed"
{
    //#region "Documentation"
    // 1.3.4.2018 LBR 13/09/2019 - CHG003321 (Import Log) Import Data Validation table for error log;
    // 1.3.5.2018 LBR 01/10/2019 - The import logic is no longer using items. Norm Code is GL code use for import purpose.
    // 1.3.6.2018 LBR 08/10/2019 - changed validation to VAT Prod. Posting Group" instead of VAT Bus. Posting Group"
    // 1.3.8.2018 LBR 24/10/2019 - Snagging New document Date added;
    // 1.3.9.2018 LBR 29/10/2019 - Snagging (corrected issue for document date import)
    // 3.0.0.2018 LBR 19/12/2019 - Adjust posting date based on special Avtrade rules
    //#endregion "Documentation"
    TableNo = ACO_ImportLog;
    trigger OnRun();
    begin
        // Copy Record
        gImportLog.COPY(Rec);
        // Get Settings
        GetAdditionalSetup();
        // Invoice
        if gImportLog.ACO_ImportType = gImportLog.ACO_ImportType::Invoice then begin
            gAdditionalSetup.TestField(ACO_ImportedInvoicePostedSeriesNo);
            ProceedImportedQuantumInvoiceCredit();
            exit;
        end;
        // Credit
        if gImportLog.ACO_ImportType = gImportLog.ACO_ImportType::Credit then begin
            gAdditionalSetup.TestField(ACO_ImportedCreditPostedSeriesNo);
            ProceedImportedQuantumInvoiceCredit();
            exit;
        end;
    end;

    procedure ProceedImportedQuantumInvoiceCredit();
    var
        lImportLog: Record ACO_ImportLog;
        lLineNo: Integer;
        lSalesHeader: Record "Sales Header";
        lSalesLine: Record "Sales Line";
        lReleaseSalesDocument: codeunit "Release Sales Document";
        lSalesPost: Codeunit "Sales-Post";
    begin
        // Create Documents
        with lImportLog do begin
            // Group by Document no and Customer No
            SetCurrentKey(ACO_DocumentNo, ACO_CustomerNo, ACO_CurrencyCode, ACO_Error);
            Setrange(ACO_ImportNo, gImportLog.ACO_ImportNo);
            Setrange(ACO_DocumentNo, gImportLog.ACO_DocumentNo);
            Setrange(ACO_CustomerNo, gImportLog.ACO_CustomerNo);
            Setrange(ACO_CurrencyCode, gImportLog.ACO_CurrencyCode);
            if FindSet(false) then begin
                lLineNo := 0;
                // Create Header
                lSalesHeader.init();
                lSalesHeader.SetHideValidationDialog(true);
                if ACO_ImportType = ACO_ImportType::Invoice then
                    lSalesHeader."Document Type" := lSalesHeader."Document Type"::Invoice;
                if ACO_ImportType = ACO_ImportType::Credit then
                    lSalesHeader."Document Type" := lSalesHeader."Document Type"::"Credit Memo";
                lSalesHeader."No." := ACO_DocumentNo;
                if ACO_ImportType = ACO_ImportType::Invoice then
                    lSalesHeader."No. Series" := gAdditionalSetup.ACO_ImportedInvoicePostedSeriesNo;
                if ACO_ImportType = ACO_ImportType::Credit then
                    lSalesHeader."No. Series" := gAdditionalSetup.ACO_ImportedCreditPostedSeriesNo;
                //>>1.3.9.2018
                //lSalesHeader.VALIDATE("Document Date", ACO_PostingDate);
                //<<1.3.9.2018
                //>>3.0.0.2018
                //lSalesHeader.VALIDATE("Posting Date", ACO_PostingDate);
                //Adjust posting date based on special Avtrade rules
                lSalesHeader.VALIDATE("Posting Date", GetAdjustedPostingDate(ACO_PostingDate, ACO_DocumentDate));
                //<<3.0.0.2018
                lSalesHeader.Insert(TRUE);
                lSalesHeader.Validate("Sell-to Customer No.", ACO_CustomerNo);
                //>>1.3.9.2018
                lSalesHeader.VALIDATE("Posting Date");
                lSalesHeader.VALIDATE("Document Date", ACO_DocumentDate);
                //<<1.3.9.2018
                lSalesHeader.Validate("External Document No.", ACO_ExternalDocumentNo);
                if ACO_ImportType = ACO_ImportType::Invoice then
                    lSalesHeader."Posting No. Series" := gAdditionalSetup.ACO_ImportedInvoicePostedSeriesNo;
                if ACO_ImportType = ACO_ImportType::Credit then
                    lSalesHeader."Posting No. Series" := gAdditionalSetup.ACO_ImportedCreditPostedSeriesNo;
                ;
                // Currency code is formated during import
                lSalesHeader.Validate("Currency Code", ACO_CurrencyCode);
                lSalesHeader.ACO_ImportNo := ACO_ImportNo;
                lSalesHeader.modify();
                // Lines
                repeat
                begin
                    lLineNo += 10000;
                    lSalesLine.init();
                    lSalesLine.SetHideValidationDialog(true);
                    lSalesLine.Validate("Document Type", lSalesHeader."Document Type");
                    lSalesLine.Validate("Document No.", lSalesHeader."No.");
                    lSalesLine."Line No." := lLineNo;
                    lSalesLine.Validate("Sell-to Customer No.", lSalesHeader."Sell-to Customer No.");
                    lSalesLine.Insert(TRUE);
                    //>>1.3.5.2018
                    //lSalesLine.Validate(Type, lSalesLine.Type::Item);
                    //lSalesLine.Validate("No.", ACO_ProductNo);
                    // Deal with 0 item line
                    if (ACO_ProductNo <> '') then begin
                        lSalesLine.Validate(Type, lSalesLine.Type::Item);
                        lSalesLine.Validate("No.", ACO_ProductNo);
                    end else begin
                        // Deal wtih any other case
                        lSalesLine.Validate(Type, lSalesLine.Type::"G/L Account");
                        lSalesLine.Validate("No.", ACO_NormCode);
                    end;
                    //<<1.3.5.2018
                    if (ACO_Quantity = 0) THEN
                        ACO_Quantity := 1;
                    lSalesLine.Validate(Quantity, ACO_Quantity);
                    lSalesLine.Validate("Unit Price", ACO_UnitPrice);
                    //>>1.3.6.2018
                    //lSalesLine.Validate("VAT Bus. Posting Group", ACO_TaxCode);
                    lSalesLine.Validate("VAT Prod. Posting Group", ACO_TaxCode);
                    //<<1.3.6.2018
                    lSalesLine.ACO_ImportNo := ACO_ImportNo;
                    lSalesLine.ACO_ImportEntryNo := ACO_EntryNo;
                    lSalesLine.Modify(true);
                end;
                until next() = 0;
            end;
        end;
        // Release Sales Document for posting
        clear(lReleaseSalesDocument);
        lReleaseSalesDocument.SetSkipCheckReleaseRestrictions();
        lReleaseSalesDocument.PerformManualRelease(lSalesHeader);
    end;
    //#region HelpFunctions
    //>>3.0.0.2018
    local procedure GetAdjustedPostingDate(pPostingDate: date; pDocumentDate: Date): Date;
    var
        lDayPD: Integer;
        lMonthPD: Integer;
        lMonthDD: Integer;
        lPrevMonthStartDate: Date;
        lPrevMonthEndDate: Date;
        lCurrMonthFirstWeekStartDate: Date;
        lCurrMonthFirstWeekEndDate: Date;
        lDate: Record "Date";
    begin
        //lDayPD := Date2DMY(pPostingDate, 1);
        lMonthPD := Date2DMY(pPostingDate, 2);
        lMonthDD := Date2DMY(pDocumentDate, 2);
        //1th of prev month
        lPrevMonthStartDate := CALCDATE('-CM-1M', pPostingDate);
        //Last of prev month
        lPrevMonthEndDate := CALCDATE('-CM-1M+CM', pPostingDate);
        //1th of curr month
        lCurrMonthFirstWeekStartDate := CALCDATE('-CM', pPostingDate);
        //7th of curr month
        lCurrMonthFirstWeekEndDate := CALCDATE('-CM+6D', pPostingDate);
        //If Posting date month = Document date month: then no change
        if lMonthPD = lMonthDD then
            exit(pPostingDate);
        //If Posting date is after first 7 days: then no change
        if pPostingDate > lCurrMonthFirstWeekEndDate then
            exit(pPostingDate);
        //If Document date is in previous month and Posting date is in the first 7 days of the current month: then return last day of prev month
        if (pDocumentDate >= lPrevMonthStartDate) and (pPostingDate <= lCurrMonthFirstWeekEndDate) then
            exit(lPrevMonthEndDate);
        //If Document date is eriler than previous month and Posting date is between first day of prev month and end day of the first week in curr month: then return last day of prev month
        if (pDocumentDate < lPrevMonthStartDate) and (pPostingDate >= lPrevMonthStartDate) and (pPostingDate <= lCurrMonthFirstWeekEndDate) then
            exit(lPrevMonthEndDate);
        //Any ohter case return default:
        exit(pPostingDate);
    end;
    //<<3.0.0.2018
    local procedure GetAdditionalSetup()
    begin
        If not gAdditionalSetup.get() then
            gAdditionalSetup.init();
    end;
    //#endregion HelpFunctions
    var
        gAdditionalSetup: Record ACO_AdditionalSetup;
        gGeneralFunctions: Codeunit ACO_GeneralFunctions;
        gImportLog: record ACO_ImportLog;
}
