namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Sales.Customer;
using Acora.AvTrade.MainApp;
using Microsoft.Utilities;
using System.Utilities;
using System.Globalization;
using System.EMail;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Posting;
using Microsoft.Sales.Setup;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.Currency;
using Microsoft.Finance.VAT.Calculation;
using Microsoft.Finance.Dimension;
using Microsoft.Finance.ReceivablesPayables;
using Microsoft.Bank.BankAccount;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.Address;
using Microsoft.CRM.Team;
using Microsoft.CRM.Segment;


xmlport 50929 "ACO_CustDataExport"
{
    //#region "Documentation"
    //1.1.0.2018 LBR 11/06/2019 - New object crated for Export to CSV (Initial Spec point 3.3);
    //1.3.3.2018 LBR 12/09/2019 - The field delimiter should be none (Req by James)
    //1.3.9.2018 LBR 29/10/2019 - Snagging (Export issue corrected to format numbers as text)
    //#endregion "Documentation"

    Caption = 'Customer Data Export';
    Direction = Export;
    Format = VariableText;
    //>>1.3.3.2018
    FieldDelimiter = '';
    //<<1.3.3.2018
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement(Customer; Customer)
            {
                XmlName = 'Customer';
                AutoReplace = false;
                AutoSave = false;
                AutoUpdate = false;

                fieldelement(Column_CustomerNo; Customer."No.")
                {
                }
                fieldelement(Column_CustomeName; Customer.Name)
                {
                }
                // This change was reqested by James Verdon
                //fieldelement(Column_ACO_CreditLimitECY; Customer.ACO_CreditLimitECY)
                //>>1.3.9.2018
                // fieldelement(Column_ACO_CreditLimitTCY; Customer.ACO_CreditLimitTCY)
                // {
                // }
                // fieldelement(Column_ACO_BalanceECY; Customer.ACO_BalanceECY)
                // {
                // }
                textelement(ColumnACOCreditLimitTCY)
                {
                }
                textelement(ColumnACOBalanceECY)
                {
                }
                //<<1.3.9.2018
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

                //Export
                trigger OnAfterGetRecord();
                begin
                    //>>1.3.9.2018
                    ColumnACOCreditLimitTCY := DELCHR(FORMAT(Customer.ACO_CreditLimitTCY), '=', ',');
                    ColumnACOBalanceECY := DELCHR(FORMAT(Customer.ACO_BalanceECY), '=', ',');
                    //<<1.3.9.2018
                    Column5 := '0';
                    Column6 := '0';
                    Column7 := '0';
                    Column8 := '0';
                    Column9 := '0';
                    Column10 := '0';
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

    //#endregion "XMLPort Functions" 


    var
        LineNo: Integer;
        InvImportBuffer: Record "ACO_ImportBuffer" temporary;

    procedure GetImpInvoiceBuffer(var pInvImportBuffer: Record "ACO_ImportBuffer" temporary)
    begin
        pInvImportBuffer.copy(InvImportBuffer, true);
    end;
}

