namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Purchases.Vendor;
using Microsoft.Bank.BankAccount;
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
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Foundation.Company;
using Microsoft.Foundation.PaymentTerms;
using Microsoft.Foundation.Shipping;
using Microsoft.Foundation.Address;
using Microsoft.CRM.Team;
using Microsoft.CRM.Segment;
using Microsoft.Utilities;


tableextension 50910 ACO_VendorBankAccount_Ext002 extends "Vendor Bank Account"
{
    //#region "Documentation"
    //3.0.9.2018 MAR 25/02/2020 - CHG003417 - Add beneficiary information fields on the Payment Export data definition
    //#endregion "Documentation"

    fields
    {
        field(50955; ACO_InfoBeneficiary; Text[100])
        {
            Caption = 'Information for Beneficiary';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(50956; ACO_InfoBeneficiary2; Text[100])
        {
            Caption = 'Information for Beneficiary 2';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(50957; ACO_InfoBeneficiary3; Text[100])
        {
            Caption = 'Information for Beneficiary 3';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
    }
}
