report 77407 "ACO_CustCurrencyDataExport"
{
    Caption = 'Customer Currency Data Export';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Customer; Customer){
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnPreDataItem();
            var
                QuantumExportMtg: Codeunit ACO_QuantumExportMtg;
            begin
                QuantumExportMtg.CreateFilterForExportCustomerCurrData(Customer);
                QuantumExportMtg.ManuallyExportCustomerCurrData();
                CurrReport.Break();
            end;
        }
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

    // trigger OnPreReport();
    // var
    //     QuantumExportMtg: Codeunit ACO_QuantumExportMtg;
    // begin
    //     QuantumExportMtg.ManuallyExportCustomerCurrData();
    // end;
}

