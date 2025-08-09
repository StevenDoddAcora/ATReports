report 50912 "ACO_ExposureAutoImport"
{
    Caption = 'Exposure Auto-Import';
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
        QuantumImportMtg: Codeunit ACO_QuantumImportMtg;
    begin
        QuantumImportMtg.AutoImportQuantumExposure();
    end;
}

