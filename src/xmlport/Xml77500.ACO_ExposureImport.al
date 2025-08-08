xmlport 77500 "ACO_ExposureImport"
{
    //#region "Documentation"
    //1.1.0.2018 LBR 11/06/2019 - New object crated for Quantum to NAV functionality (Initial Spec point 3.2);
    //#endregion "Documentation"

    Caption = 'Exposure Import';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {


        textelement(root)
        {
            tableelement(DummyCustomer; Customer)
            {
                XmlName = 'DummyCustomer';
                UseTemporary = true;
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;

                textelement(Column_CustomerNo)
                {
                }
                textelement(Column2)
                {
                }
                textelement(Column3)
                {
                }
                textelement(Column4)
                {
                }
                textelement(Column5)
                {
                }
                textelement(Column6)
                {
                }
                textelement(Column7)
                {
                }
                textelement(Column8)
                {
                }
                textelement(Column9)
                {
                }
                textelement(Column10)
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
                textelement(Column14)
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
                textelement(Column_Exposure)
                {
                }
                textelement(Column20)
                {
                    //>>1.3.1.2018 LBR 25/07/2019
                    MinOccurs = Zero;
                    //<<1.3.1.2018 LBR 25/07/2019
                }



                trigger OnBeforeInsertRecord();
                var
                    lCustomerNo: Code[20];
                    lExposure: Decimal;
                    lCustomer: Record Customer;
                begin
                    if(StrPos(UPPERCASE(Column_CustomerNo), 'ACCOUNTREF') = 0) then begin
                        // If find record then update NAV values:
                        if Column_CustomerNo <> '' then
                            EVALUATE(lCustomerNo, Column_CustomerNo);

                        if lCustomerNo <> '' then begin
                            if Column_Exposure <> '' then
                                EVALUATE(lExposure, Column_Exposure);

                            //if lExposure <> 0 then begin // FIX to allow import 0
                                if lCustomer.GET(lCustomerNo) then begin
                                    lCustomer.VALIDATE(ACO_Exposure, lExposure);
                                    lCustomer.MODIFY(FALSE);
                                end;
                            //end;
                        end;
                    end;

                    // Clear Variables After:
                    CLEAR(lCustomerNo);
                    CLEAR(lExposure);
                    CLEAR(Column_CustomerNo);
                    CLEAR(Column2);
                    CLEAR(Column3);
                    CLEAR(Column4);
                    CLEAR(Column5);
                    CLEAR(Column6);
                    CLEAR(Column7);
                    CLEAR(Column8);
                    CLEAR(Column9);
                    CLEAR(Column10);
                    CLEAR(Column11);
                    CLEAR(Column12);
                    CLEAR(Column13);
                    CLEAR(Column14);
                    CLEAR(Column15);
                    CLEAR(Column16);
                    CLEAR(Column17);
                    CLEAR(Column18);
                    CLEAR(Column_Exposure);
                    CLEAR(Column20);
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
          Setup.ACO_XMLPortTextEnconding::"MS-Dos" :
            begin
                currXMLport.TextEncoding := currXMLport.TextEncoding::MSDos;
            end;  //>> End MS-DOS
            Setup.ACO_XMLPortTextEnconding::"UTF-16" :
            begin
                currXMLport.TextEncoding := currXMLport.TextEncoding::UTF16;
            end;
            Setup.ACO_XMLPortTextEnconding::"UTF-8" :
            begin
                currXMLport.TextEncoding := currXMLport.TextEncoding::UTF8;
            end;
            Setup.ACO_XMLPortTextEnconding::Windows :
            begin
                currXMLport.TextEncoding := currXMLport.TextEncoding::Windows;
            end;
            end;  //>> End Case
        end;
    end;

    //#endregion "XMLPort Functions" 

}

