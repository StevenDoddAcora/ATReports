namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Purchases.Document;
using Acora.AvTrade.MainApp;
using Microsoft.Sales.Document;
using System.Utilities;
using System.Globalization;
using System.EMail;
using Microsoft.Purchases.Vendor;
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


tableextension 50909 "ACO_AdditionalSetup_Ext002" extends ACO_AdditionalSetup //MyTargetTableId
{

    //#region "Documentation"
    //ABS001 - 1.3.0.2018 - This table extension extends additional setup table (89.000)
    //                      - Field " ACO_XMLPortTextEnconding" added to establish the Text Enconding to be used for XMLPorts
    //3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Carry line descriptions to G/L entries when posting, 
    //      new functionality added to prevent purchase/Sales lines compression
    //#endregion "Documentation"

    fields
    {
        field(50950; ACO_XMLPortTextEnconding; Option)
        {
            Caption = 'XMLPort Text Encoding';
            DataClassification = CustomerContent;
            OptionMembers = "MS-Dos","UTF-8","UTF-16","Windows";
            OptionCaption = 'MS-Dos,UTF-8,UTF-16,Windows';
            Description = 'It indicates which Text Enconding should be used when Exporting/Importing XMLPorts';
        }

        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Purchase Line compression</summary>
        field(50951; ACO_PreventPurchLineCompression; Boolean)
        {
            Caption = 'Prevent Purchase Line Compression';
            DataClassification = CustomerContent;
            Description = 'It determines whether Purchase Line compression should be prevented';
            Editable = true;
        }

        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Purchase Line compression</summary>
        field(50952; ACO_PreventPurchLineCompDimCode; Code[20])
        {
            Caption = 'Prevent Purchase Line Compression Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
            Description = 'It determines which Dimension should be used as part of the Prevention of Purchase Line Compression';
            Editable = true;
        }
        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Sales Line compression</summary>
        field(50953; ACO_PreventSalesLineCompression; Boolean)
        {
            Caption = 'Prevent Sales Line Compression';
            DataClassification = CustomerContent;
            Description = 'It determines whether Sales Line compression should be prevented';
            Editable = true;
        }

        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Sales Line compression</summary>
        field(50954; ACO_PreventSalesLineCompDimCode; Code[20])
        {
            Caption = 'Prevent Sales Line Compression Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
            Description = 'It determines which Dimension should be used as part of the Prevention of Sales Line Compression';
            Editable = true;
        }
    }

}
