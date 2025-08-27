namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Purchases.Vendor;
using Acora.AvTrade.MainApp;
using System.Utilities;
using System.Globalization;
using System.EMail;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Setup;
using Microsoft.Purchases.Posting;
using Microsoft.Sales.Customer;
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
using Microsoft.Utilities;


report 50924 "ACO_VendorFilter"
{
    //#region "Documentation"
    // 1.3.5.2018 LBR 01/10/2019 - new object created for CHG003332 (E-mailing Remittance). We do want to use standard NAV to send emials, however
    //      this version of NAV does not allow to extends standard option fields, therfore we will use P.Arch. Quote,P.Arch. Order for bespoke report purpose
    //#endregion "Documentation"

    Caption = 'Vendor (Filter)';
    ProcessingOnly = true;
    ShowPrintStatus = false;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
            DataItemTableView = SORTING("No.");

            trigger OnPreDataItem();
            begin
                gVendor.CopyFilters(Vendor);
                gRepRun := true;
            end;

            trigger OnAfterGetRecord();
            begin

                CurrReport.Break;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            /*
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; SourceExpression)
                    {
                        ApplicationArea = All;
                        
                    }
                }
            }
            */
        }
    }

    procedure GetVendor(var rVendor: Record vendor): boolean;
    begin
        rVendor.CopyFilters(gVendor);
        exit(gRepRun);
    end;

    var
        gVendor: Record vendor;
        gRepRun: Boolean;
}
