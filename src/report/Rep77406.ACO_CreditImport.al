report 50918 "ACO_CreditImport"
{
    Caption = 'Credit Import';
    ProcessingOnly = true;
    ShowPrintStatus = false;
    UseRequestPage = false;
    UsageCategory = Tasks;

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
        QuantumImportMtg: Codeunit ACO_QuantumImportMtg;
    begin
        QuantumImportMtg.ManuallyImportQuantumCreditFile();
    end;
}

