pageextension 50967 "ACO_AddtionalSetup_Ext002" extends ACO_AdditionalSetup
{
    //#region Documentation
    //1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    //1.2.0.2018 LBR 13/06/2019 - New fields added for NAV to Excel export (Init Spec point 3.3)
    //3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Carry line descriptions to G/L entries when posting, 
    //      new functionality added to prevent purchase/Sales lines compression
    //#endregion Documentation

    layout
    {
        addbefore(ACO_AvgCollectionPeriodCalc)
        {
            field(ACO_XMLPortTextEnconding; Rec.ACO_XMLPortTextEnconding)
            {
                ApplicationArea = All;
                ToolTip = 'It indicates which Text Enconding should be used when Exporting/Importing XMLPorts';

            }
        }

        addlast(content)
        {
            //VERSION 1.13.0.2018 - This group has been added by this version
            group(PurchGroup)
            {
                Caption = 'Purchase';
                Visible = true;

                ///<summary>Group added by change ABS006</summary>
                group(PreventLineCompression)
                {
                    Caption = 'Prevent Line Compression';
                    Visible = true;

                    field(ACO_PreventPurchLineCompression; Rec.ACO_PreventPurchLineCompression)
                    {
                        Caption = 'Enable';
                        ApplicationArea = All;
                        ToolTip = 'It determines if the sytem should prevent purchase line compression during posting purchase documents';
                    }
                    field(ACO_PreventPurchLineCompDimCode; Rec.ACO_PreventPurchLineCompDimCode)
                    {
                        Caption = 'Dimension Code';
                        ApplicationArea = All;
                        ToolTip = 'It determines what dimensions code should be used to prevent purchase line compression during posting purchase documents. This field is mandatory if prevent purchase line compression is enabled';
                    }
                }
            }
            group(SalesGroup)
            {
                Caption = 'Sales';
                Visible = true;

                ///<summary>Group added by change ABS006</summary>
                group(PreventSalesLineCompression)
                {
                    Caption = 'Prevent Line Compression';
                    Visible = true;

                    field(ACO_PreventSalesLineCompression; Rec.ACO_PreventSalesLineCompression)
                    {
                        Caption = 'Enable';
                        ApplicationArea = All;
                        ToolTip = 'It determines if the sytem should prevent Sales line compression during posting Sales documents';
                    }
                    field(ACO_PreventSalesLineCompDimCode; Rec.ACO_PreventSalesLineCompDimCode)
                    {
                        Caption = 'Dimension Code';
                        ApplicationArea = All;
                        ToolTip = 'It determines what dimensions code should be used to prevent Sales line compression during posting Sales documents. This field is mandatory if prevent Sales line compression is enabled';
                    }
                }
            }
        }
    }

    actions
    {
        addlast(Creation)
        {
            //////////////////// EXPOSURE IMPORT /////////////////////
            group(Exposure)
            {
                Caption = 'Exposure (TEST)';
                Image = TestFile;

                action(ActionQuantumExposureManualImport)
                {
                    ApplicationArea = All;
                    Caption = 'Quantum Exposure Manual-Import (TEST)';
                    ToolTip = 'It runs test Quantum Exposure Manual-Import based on the client fiels';
                    Image = Import;

                    trigger OnAction();
                    var
                        quantumImportMtg: codeunit "ACO_QuantumImportMtg";
                    begin
                        quantumImportMtg.ManuallyImportQuantumExposureFile();
                    end;
                }
                action(ActionQuantumExposureAutoImport)
                {
                    ApplicationArea = All;
                    Caption = 'Quantum Exposure Auto-Import (TEST)';
                    ToolTip = 'It runs test Quantum Exposure Auto-Import based on the server files';
                    Image = ImportExcel;

                    trigger OnAction();
                    var
                        quantumImportMtg: codeunit "ACO_QuantumImportMtg";
                    begin
                        quantumImportMtg.AutoImportQuantumExposure();
                    end;
                }
            }
            //////////////////// INVOICE IMPORT /////////////////////
            group(Invoice)
            {
                Caption = 'Invoice (TEST)';
                Image = TestReport;
                action(ActionQuantumInvoiceManualImport)
                {
                    ApplicationArea = All;
                    Caption = 'Quantum Invoice Manual-Import (TEST)';
                    ToolTip = 'It runs test Quantum Invoice Manual-Import based on the client fiels';
                    Image = Import;

                    trigger OnAction();
                    var
                        quantumImportMtg: codeunit "ACO_QuantumImportMtg";
                    begin
                        quantumImportMtg.ManuallyImportQuantumInvoiceFile();
                    end;
                }
                action(ActionQuantumInvoiceAutoImport)
                {
                    ApplicationArea = All;
                    Caption = 'Quantum Invoice Auto-Import (TEST)';
                    ToolTip = 'It runs test Quantum Invoice Auto-Import based on the server files';
                    Image = ImportExcel;

                    trigger OnAction();
                    var
                        quantumImportMtg: codeunit "ACO_QuantumImportMtg";
                    begin
                        quantumImportMtg.AutoImportQuantumInvoice();
                    end;
                }
            }
            //////////////////// CREDIT IMPORT /////////////////////
            group(Credit)
            {
                Caption = 'Credit (TEST)';
                Image = TestDatabase;
                action(QuantumCreditManualImport)
                {
                    ApplicationArea = All;
                    Caption = 'Quantum Credit Manual-Import (TEST)';
                    ToolTip = 'It runs test Quantum Credit Manual-Import based on the client fiels';
                    Image = Import;

                    trigger OnAction();
                    var
                        quantumImportMtg: codeunit "ACO_QuantumImportMtg";
                    begin
                        quantumImportMtg.ManuallyImportQuantumCreditFile();
                    end;
                }
                action(QuantumCreditAutoImport)
                {
                    ApplicationArea = All;
                    Caption = 'Quantum Credit Auto-Import (TEST)';
                    ToolTip = 'It runs test Quantum Credit Auto-Import based on the server files';
                    Image = ImportExcel;

                    trigger OnAction();
                    var
                        quantumImportMtg: codeunit "ACO_QuantumImportMtg";
                    begin
                        quantumImportMtg.AutoImportQuantumCredit();
                    end;
                }
            }
            //////////////////// Customer Currency EXPORT /////////////////////
            group(Export)
            {
                Caption = 'Export (TEST)';
                Image = TestDatabase;
                action(ManuallCustomerCurrencyExport)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Currency Manual-Export (TEST)';
                    ToolTip = 'It runs test Quantum Customer Currency Manual-Export based on the customer records';
                    Image = Export;

                    trigger OnAction();
                    var
                        QuantumExportMtg: codeunit ACO_QuantumExportMtg;
                    begin
                        QuantumExportMtg.ManuallyExportCustomerCurrData();
                    end;
                }
                action(AutoCustomerCurrencyExport)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Currency Auto-Export (TEST)';
                    ToolTip = 'It runs test Quantum Customer Currency Auto-Export based on the customer records';
                    Image = ExportFile;

                    trigger OnAction();
                    var
                        QuantumExportMtg: codeunit ACO_QuantumExportMtg;
                    begin
                        QuantumExportMtg.AutoExportCustomerCurrData();
                    end;
                }
            }
        }
    }

    local procedure RecreateTESTData();
    var
        AdditionalSetup: Record ACO_AdditionalSetup;
    begin
        //Additional Setup
        if not AdditionalSetup.get() then begin
            AdditionalSetup.init();
        end;

        AdditionalSetup.ACO_ExposureFileSource := 'C:\tmp\Avtrade\Import\Exposure';
        AdditionalSetup.ACO_ExposureFileProcessed := 'C:\tmp\Avtrade\Import\Exposure\Archive';
        AdditionalSetup.ACO_InvoiceFileSource := 'C:\tmp\Avtrade\Import\Invoice';
        AdditionalSetup.ACO_InvoiceFileProcessed := 'C:\tmp\Avtrade\Import\Invoice\Archive';
        AdditionalSetup.ACO_ImportedInvoicePostedSeriesNo := 'S-INV-LBR';
        AdditionalSetup.ACO_CreditFileSource := 'C:\tmp\Avtrade\Import\Credit';
        AdditionalSetup.ACO_CreditFileProcessed := 'C:\tmp\Avtrade\Import\Credit\Archive';
        AdditionalSetup.ACO_ImportedCreditPostedSeriesNo := 'S-CM-LBR';
        AdditionalSetup.ACO_ExportCurrency := 'EUR';
        AdditionalSetup.ACO_CustomerReportCurrency1 := 'GBP';
        AdditionalSetup.ACO_CustomerReportCurrency2 := 'USD';
        AdditionalSetup.ACO_CustomerReportCurrency3 := 'EUR';
        AdditionalSetup.ACO_QuantumExportLocation := 'C:\tmp\Avtrade\Export';
        if not AdditionalSetup.Insert() then AdditionalSetup.Modify();


        //Any other init data for testing here:
    end;
}

