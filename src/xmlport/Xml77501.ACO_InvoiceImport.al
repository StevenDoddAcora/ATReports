xmlport 77501 "ACO_InvoiceImport"
{
    //#region "Documentation"
    // 1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    // 1.3.5.2018 LBR 01/10/2019 - The import logic is no longer using items. Norm Code is GL code use for import purpose.
    // 1.3.8.2018 LBR 24/10/2019 - Snagging New document Date added;
    // 1.4.7.2018 LBR 16/11/2019 - INC0114178 Fix to import invoice/credit to show error in the import log if qty is 0;
    //#endregion "Documentation"

    Caption = 'Invoice Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(ACO_ImportBuffer; "ACO_ImportBuffer")
            {
                XmlName = 'ACO_ImportBuffer';
                UseTemporary = true;
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;

                textelement(Column1)
                {
                }
                // Customer No.
                textelement(Column_Customer)
                {
                }
                // Document No.
                textelement(Column_DocumentNo)
                {
                }
                textelement(Column4)
                {
                }
                // External Document No.
                textelement(Column_CustomerOrderNo)
                {
                }
                // Posting and Document Date
                textelement(Column_Date)
                {
                }
                textelement(Column7)
                {
                }
                // Item No.
                textelement(Column_Product)
                {
                }
                // Quantity
                textelement(Column_Quantity)
                {
                }
                textelement(Column_UnitPrice)
                {
                }
                textelement(Column11)
                {
                }
                textelement(Column12)
                {
                }
                textelement(Column13)
                {
                }
                // VAT Business Posting Group
                textelement(Column_TaxCode)
                {
                }
                textelement(Column15)
                {
                }
                textelement(Column16)
                {
                }
                textelement(Column17)
                {
                }
                textelement(Column18)
                {
                }
                // Not in use
                textelement(Column_NormCode)
                {
                }
                textelement(Column20)
                {
                }
                textelement(Column21)
                {
                }
                textelement(Column22)
                {
                }
                textelement(Column23)
                {
                }
                textelement(Column24)
                {
                }
                textelement(Column25)
                {
                }
                textelement(Column26)
                {
                }
                textelement(Column27)
                {
                }
                textelement(Column28)
                {
                }
                textelement(Column29)
                {
                }
                textelement(Column30)
                {
                }
                textelement(Column31)
                {
                }
                textelement(Column32)
                {
                }
                textelement(Column33)
                {
                }
                textelement(Column34)
                {
                }
                textelement(Column35)
                {
                }
                textelement(Column36)
                {
                }
                textelement(Column37)
                {
                }
                textelement(Column38)
                {
                }
                textelement(Column39)
                {
                }
                textelement(Column40)
                {
                }
                textelement(Column41)
                {
                }
                textelement(Column_CurrencyCode)
                {
                    //>>27/08/2019
                    MinOccurs = Zero;
                    //<<27/08/2019
                }

                trigger OnBeforeInsertRecord();
                var
                    DateValue: Date;
                    DecimalValue: Decimal;
                    QtyErrorLbl: Label 'Line Quantiy cannot be 0';
                begin
                    FileLineNo += 1;

                    // Skip lins which are not having product or is just caption line
                    if (StrPos(UPPERCASE(Column_Product), 'PRODUCT') = 0) AND
                       (StrLen(UPPERCASE(Column_Product)) > 0) // Some lines may be empty so should be skipped 
                    then begin
                        EntryNo += 1;

                        InvImportLog.INIT();
                        InvImportLog.ACO_ImportType := InvImportLog.ACO_ImportType::Invoice;
                        InvImportLog.ACO_ImportNo := ImportNo;
                        InvImportLog.ACO_EntryNo := EntryNo;
                        InvImportLog.ACO_FileName := QuantumImportMtg.GetFileName(gFileName);
                        InvImportLog.ACO_FileLineNo := FileLineNo;
                        InvImportLog.ACO_ImportDate := ImportDate;
                        InvImportLog.ACO_ImportTime := ImportTime;

                        // Document No.
                        InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetCode20Value(Column_DocumentNo, InvImportLog.ACO_DocumentNo));
                        //>>1.3.8.2018
                        //if not InvImportLog.ACO_Error then
                        //    InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetDateValue(Column_Date, InvImportLog.ACO_PostingDate));

                        // Posting Date is picked based if is imported manually or by NAS
                        if GuiAllowed then
                            InvImportLog.ACO_PostingDate := CalcDate('-1D', WorkDate)
                        else
                            InvImportLog.ACO_PostingDate := CalcDate('-1D', Today);
                        // Document Date
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetDateValue(Column_Date, InvImportLog.ACO_DocumentDate));
                        //<<1.3.8.2018
                        // Customer No.
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetCustomerNo(Column_Customer, InvImportLog.ACO_CustomerNo));
                        //>>1.3.5.2018
                        //// Product No.
                        //if not InvImportLog.ACO_Error then
                        //    InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetProductCode(Column_Product, InvImportLog.ACO_ProductNo));
                        // G/L Account
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetGLAccountCode(Column_NormCode, InvImportLog.ACO_NormCode));
                        //<<1.3.5.2018
                        // Quantity
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetDecimalValue(Column_Quantity, InvImportLog.ACO_Quantity));
                        //>>1.4.7.2018
                        if (not InvImportLog.ACO_Error) and (InvImportLog.ACO_Quantity = 0) then
                            InvImportLog.Validate(ACO_ErrorDescription, QtyErrorLbl);
                        //<<1.4.7.2018
                        // Unit Price
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetDecimalValue(Column_UnitPrice, InvImportLog.ACO_UnitPrice));
                        // Update Unit Price - The validation is here to deal with the cancelled invoices
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription,
                                QuantumImportMtg.UpdateInvoiceUnitPrice(InvImportLog.ACO_CustomerNo, InvImportLog.ACO_UnitPrice));
                        // Update Product Code - The validation is here to deal with the cancelled invoices
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription,
                                QuantumImportMtg.UpdateInvoiceProductCode(InvImportLog.ACO_CustomerNo, InvImportLog.ACO_UnitPrice, InvImportLog.ACO_ProductNo));
                        // External Document No
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetText35Value(Column_CustomerOrderNo, InvImportLog.ACO_ExternalDocumentNo));
                        // Tax Code
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetCode10Value(Column_TaxCode, InvImportLog.ACO_TaxCode));
                        // Find correct currency code
                        if not InvImportLog.ACO_Error then
                            InvImportLog.Validate(ACO_ErrorDescription, QuantumImportMtg.GetCurrencyCode(Column_CurrencyCode, InvImportLog.ACO_CurrencyCode));
                        //INSERT
                        InvImportLog.Insert();
                    end;

                    // Clear Variables (any new variables should be added here!)
                    begin
                        CLEAR(Column1);
                        CLEAR(Column_Customer);
                        CLEAR(Column_DocumentNo);
                        CLEAR(Column4);
                        CLEAR(Column_CustomerOrderNo);
                        CLEAR(Column_Date);
                        CLEAR(Column7);
                        CLEAR(Column_Product);
                        CLEAR(Column_Quantity);
                        CLEAR(Column_UnitPrice);
                        CLEAR(Column11);
                        CLEAR(Column12);
                        CLEAR(Column13);
                        CLEAR(Column_TaxCode);
                        CLEAR(Column15);
                        CLEAR(Column16);
                        CLEAR(Column17);
                        CLEAR(Column18);
                        CLEAR(Column_NormCode);
                        CLEAR(Column20);
                        CLEAR(Column21);
                        CLEAR(Column22);
                        CLEAR(Column23);
                        CLEAR(Column24);
                        CLEAR(Column25);
                        CLEAR(Column26);
                        CLEAR(Column27);
                        CLEAR(Column28);
                        CLEAR(Column29);
                        CLEAR(Column30);
                        CLEAR(Column31);
                        CLEAR(Column32);
                        CLEAR(Column33);
                        CLEAR(Column34);
                        CLEAR(Column35);
                        CLEAR(Column35);
                        CLEAR(Column36);
                        CLEAR(Column37);
                        CLEAR(Column38);
                        CLEAR(Column39);
                        CLEAR(Column40);
                        CLEAR(Column41);
                        CLEAR(Column_CurrencyCode);
                    end;
                end;
            }
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

    //#region "XMLPort Triggers"

    ///<summary>1.3.0.2018 - It sets the TextEncoding on XMLPort from the Setup</summary>
    trigger OnInitXmlPort();
    begin
        SetTextEnconding;
    end;

    trigger OnPreXmlPort();
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        ImportDate := Today;
        ImportTime := TIME;
        if gFileName = '' then
            gFileName := currXMLport.Filename;

        // Get next import no
        AdditionalSetup.LockTable();
        if not AdditionalSetup.get() then
            AdditionalSetup.Init();

        ImportNo := AdditionalSetup.ACO_LastInvoiceImportNo + 1;
        AdditionalSetup.ACO_LastInvoiceImportNo := ImportNo;
        AdditionalSetup.Modify;
    end;
    //#endregion "XMLPort Triggers"

    //#region "XMLPort Functions"

    ///<summary>1.3.0.2018 - It sets the Text Enconding from the Setup</summary>
    local procedure SetTextEnconding()
    var
        Setup: Record ACO_AdditionalSetup;
    begin
        if not Setup.Get then begin
            currXMLport.TextEncoding := currXMLport.TextEncoding::UTF8;
        end else begin
            case Setup.ACO_XMLPortTextEnconding of
                Setup.ACO_XMLPortTextEnconding::"MS-Dos":
                    begin
                        currXMLport.TextEncoding := currXMLport.TextEncoding::MSDos;
                    end;  //>> End MS-DOS
                Setup.ACO_XMLPortTextEnconding::"UTF-16":
                    begin
                        currXMLport.TextEncoding := currXMLport.TextEncoding::UTF16;
                    end;
                Setup.ACO_XMLPortTextEnconding::"UTF-8":
                    begin
                        currXMLport.TextEncoding := currXMLport.TextEncoding::UTF8;
                    end;
                Setup.ACO_XMLPortTextEnconding::Windows:
                    begin
                        currXMLport.TextEncoding := currXMLport.TextEncoding::Windows;
                    end;
            end;  //>> End Case
        end;
    end;

    procedure GetImportLogNo(var ImportLogNo: Integer);
    begin
        ImportLogNo := ImportNo;
    end;

    procedure SetgFileName(FileName: Text);
    begin
        gFileName := FileName;
    end;
    //#endregion "XMLPort Functions" 


    var
        gFileName: Text;
        FileLineNo: Integer;
        EntryNo: Integer;
        ImportNo: Integer;
        InvImportLog: Record ACO_ImportLog;
        ImportDate: Date;
        ImportTime: Time;
        AdditionalSetup: Record ACO_AdditionalSetup;
        QuantumImportMtg: Codeunit ACO_QuantumImportMtg;

}

