report 77405 "ACO_InvoiceImport"
{
    Caption = 'Invoice Import';
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
        QuantumImportMtg.ManuallyImportQuantumInvoiceFile();
    end;
}

