namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Acora.AvTrade.MainApp;
using Microsoft.Utilities;
using System.Utilities;
using System.Globalization;
using System.EMail;
using Microsoft.Purchases.Vendor;
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
using System.IO;


xmlport 50930 "ACO_ExportGenericCSV"
{
    //#region "Documentation"
    //1.1.5.2018 LBR 11/06/2019 - New object crated to export data exch without " sign
    //#endregion "Documentation"

    Caption = 'AVT Export Generic CSV';
    Direction = Export;
    Format = VariableText;
    TextEncoding = WINDOWS;
    UseRequestPage = false;
    FieldDelimiter = '';

    schema
    {
        textelement(root)
        {
            MinOccurs = Zero;
            tableelement("Data Exch. Field"; "Data Exch. Field")
            {
                XmlName = 'DataExchField';
                textelement(ColumnX)
                {
                    MinOccurs = Zero;
                    Unbound = true;

                    trigger OnBeforePassVariable();
                    begin
                        if QuitLoop then
                            currXMLport.BREAKUNBOUND;

                        if "Data Exch. Field"."Line No." <> LastLineNo then begin
                            if "Data Exch. Field"."Line No." <> LastLineNo + 1 then
                                ErrorText += LinesNotSequentialErr
                            else begin
                                LastLineNo := "Data Exch. Field"."Line No.";
                                PrevColumnNo := 0;
                                "Data Exch. Field".NEXT(-1);
                                Window.UPDATE(1, LastLineNo);
                            end;
                            currXMLport.BREAKUNBOUND;
                        end;

                        CheckColumnSequence;
                        ColumnX := "Data Exch. Field".Value;

                        if "Data Exch. Field".NEXT = 0 then
                            QuitLoop := true;
                    end;
                }
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

    trigger OnInitXmlPort();
    begin
        Window.OPEN(ProgressMsg);
    end;

    trigger OnPostXmlPort();
    begin
        if ErrorText <> '' then
            ERROR(ErrorText);

        Window.CLOSE;

        if DataExch.GET(DataExchEntryNo) then
            if DataExchDef.GET(DataExch."Data Exch. Def Code") then
                currXMLport.FILENAME := DataExchDef.Name + '.csv';
    end;

    trigger OnPreXmlPort();
    begin
        InitializeGlobals;
    end;

    var
        DataExchDef: Record "Data Exch. Def";
        DataExch: Record "Data Exch.";
        Window: Dialog;
        ErrorText: Text;
        DataExchEntryNo: Integer;
        LastLineNo: Integer;
        PrevColumnNo: Integer;
        QuitLoop: Boolean;
        ColumnsNotSequentialErr: Label 'The data to be exported is not structured correctly. The columns in the dataset must be sequential.';
        LinesNotSequentialErr: Label 'The data to be exported is not structured correctly. The lines in the dataset must be sequential.';
        ProgressMsg: Label 'Exporting line no. #1######';

    local procedure InitializeGlobals();
    begin
        DataExchEntryNo := "Data Exch. Field".GETRANGEMIN("Data Exch. No.");
        LastLineNo := 1;
        PrevColumnNo := 0;
        QuitLoop := false;
    end;

    [Scope('Personalization')]
    procedure CheckColumnSequence();
    begin
        if "Data Exch. Field"."Column No." <> PrevColumnNo + 1 then begin
            ErrorText += ColumnsNotSequentialErr;
            currXMLport.BREAKUNBOUND;
        end;

        PrevColumnNo := "Data Exch. Field"."Column No.";
    end;
}

