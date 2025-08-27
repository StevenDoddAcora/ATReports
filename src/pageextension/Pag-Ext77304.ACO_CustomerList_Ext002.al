namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Sales.Customer;
using Acora.AvTrade.MainApp;
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
using Microsoft.Utilities;


pageextension 50904 "ACO_CustomerList_Ext002" extends "Customer List"
{
    //#region "Documentation"
    // 1.3.7.2018 LBR 16/10/2019 - Snagging: added Avtrade Aged Accounts Receivable action;
    //#endregion "Documentation"

    layout
    {

    }

    actions
    {
        // modify("Aged Accounts Receivable")
        // {
        //     Visible = false;
        //     Enabled = false;
        // }

        addafter(Reminder)
        {
            action(AvtradeAgedAccountsReceivable)
            {
                Caption = 'Avtrade Aged Accounts Receivable';
                ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    AvtAgedAccountsReceivable: Report ACO_AgedAccountsReceivable;
                    Customer: record Customer;
                begin
                    Customer.setrange("No.", Rec."No.");
                    Report.run(Report::ACO_AgedAccountsReceivable, true, false, Customer);
                end;
            }
        }
    }
}
