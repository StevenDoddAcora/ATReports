report 50916 "ACO_ExposureImport"
{
    Caption = 'Exposure Import';
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
        QuantumImportMtg.ManuallyImportQuantumExposureFile();
    end;
}

