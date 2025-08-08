report 77403 "ACO_CustCurrencyDataAutoExport"
{
    Caption = 'Customer Currency Data Auto-Export';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = false;

    dataset
    {
        // Do nothing
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    var
        QuantumExportMtg: Codeunit ACO_QuantumExportMtg;
    begin
        QuantumExportMtg.AutoExportCustomerCurrData();
    end;
}

