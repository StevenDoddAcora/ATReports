namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using System.IO;
using System.Utilities;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Finance.Currency;
using Microsoft.Utilities;
using Acora.AvTrade.MainApp;
using Microsoft.Finance.GeneralLedger.Setup;


codeunit 50901 "ACO_QuantumExportMtg"
{
    //#region "Documentation"
    //1.2.0.2018 LBR 13/06/2019 - New object created for NAV to Excel export (Init Spec point 3.3)
    //#endregion "Documentation"

    Permissions = TableData "Cust. Ledger Entry" = r, TableData "Detailed Cust. Ledg. Entry" = r;

    //#region QuantumExportFunctions
    procedure CreateFilterForExportCustomerCurrData(var Customer: Record Customer)
    begin
        gCustomer.CopyFilters(Customer);
    end;

    procedure ManuallyExportCustomerCurrData()
    var
        GeneralFunctions: Codeunit ACO_GeneralFunctions;
    begin
        // Calc Customer Currency Data
        GeneralFunctions.RecalculateCustomerCurrencyData(gCustomer, Today);

        ExportCustomerCurrData('');
    end;

    procedure AutoExportCustomerCurrData();
    var
        tempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        inStr: InStream;
        ImportFileName: Text;
        // File Mgt codeunit is using dot net therfore for BC upgraded it should be replaced with Azure functions instead
        Customer: Record Customer;
        counter: Integer;
        GeneralFunctions: Codeunit ACO_GeneralFunctions;
        NoOfFilesExpLbl: Label 'Number of files exported: %1';
        FileNamLbl: Label 'NAV to Quantum Export_';

    begin
        GetAdditionalSetup();
        AdditionalSetup.TESTFIELD(ACO_QuantumExportLocation);

        // Calc Customer Currency Data
        GeneralFunctions.RecalculateCustomerCurrencyData(gCustomer, Today);

        // Export File
        ExportCustomerCurrData(GeneralFunctions.AddSlashAtTheEnd(AdditionalSetup.ACO_QuantumExportLocation) +
            FileNamLbl +
            Format(CurrentDateTime, 0, '<year4><month,2><day,2>_<hours24><minutes,2>.csv'));

        // Move File to Archive
        counter += 1;

        if GuiAllowed then
            Message(NoOfFilesExpLbl, counter);
    end;

    local procedure ExportCustomerCurrData(pFile: text)
    var
        tempBlob: Codeunit "Temp Blob";
        outStr: OutStream;
        CustDataExport: XmlPort ACO_CustDataExport;
    begin
        // IF the parameter have a value then it is auto-export otherwise run xml port in the normal way to ask for a file
        if (pFile <> '') then begin
            //Modern TempBlob codeunit usage
            tempBlob.CreateOutStream(outStr);
            //Import File
            CustDataExport.Filename := pFile;
            CustDataExport.SetDestination(outStr);
            //CustDataExport.Run()
            CustDataExport.Export();

            // Modern file export would require different approach with File System
            // tempBlob.CreateInStream and file operations
        end else begin
            if (gCustomer.GetFilters() <> '') then
                CustDataExport.SetTableView(gCustomer);
            // Run Xml Port
            CustDataExport.Run();
        end;
    end;
    //#endregion QuantumExportFunctions

    //#region HelpFunctions

    local procedure CalcCustomerBalance(pCustomerCode: Code[20]; pCurrencyCode: code[20]; pDate: Date) ReturnValue: Decimal;
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        GetGenrealLegerSetup();

        DetailedCustLedgEntry.SETRANGE("Customer No.", pCustomerCode);
        //DetailedCustLedgEntry.SETFILTER(COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
        //DetailedCustLedgEntry.SETFILTER(COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
        if (pDate <> 0D) then
            DetailedCustLedgEntry.SETFILTER("Posting Date", '<=%1', pDate);
        if (pCurrencyCode = '') or (pCurrencyCode = GenLedgerSetup."LCY Code") then
            DetailedCustLedgEntry.SETFILTER("Currency Code", '%1|%2', '', pCurrencyCode)
        else
            DetailedCustLedgEntry.SETRANGE("Currency Code", pCurrencyCode);
        DetailedCustLedgEntry.CalcSums(Amount);

        exit(DetailedCustLedgEntry.Amount);
    end;

    local procedure GetActiveExchRate(pCurrCode: Code[20]) ReturnValue: Decimal;
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.SetRange("Currency Code", pCurrCode);
        if CurrExchRate.FindLast() then
            exit(CurrExchRate."Exchange Rate Amount");

        exit(0);
    end;

    local procedure GetAdditionalSetup()
    begin
        if AdditionalSetup.ACO_ExportCurrency = '' then
            AdditionalSetup.GET();
    end;

    local procedure GetGenrealLegerSetup()
    begin
        if (GenLedgerSetup."LCY Code" = '') then
            GenLedgerSetup.GET();
    end;
    //#endregion HelpFunctions

    var
        AdditionalSetup: Record ACO_AdditionalSetup;
        GenLedgerSetup: Record "General Ledger Setup";
        gCustomer: Record Customer;

}
