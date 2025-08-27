namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Sales.Customer;
using Microsoft.Finance.Currency;
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


report 50915 "ACO_CustCurrencyDataAutoExport"
{
    Caption = 'Customer Currency Data Auto-Export';
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
        QuantumExportMtg: Codeunit ACO_QuantumExportMtg;
    begin
        QuantumExportMtg.AutoExportCustomerCurrData();
    end;
}

