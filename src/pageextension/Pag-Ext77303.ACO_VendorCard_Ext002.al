namespace Acora.AvTrade.ReportsAndIntegration;

using System;
using Microsoft.Purchases.Vendor;
using Acora.AvTrade.MainApp;
using Microsoft.Foundation.Reporting;


pageextension 50903 "ACO_VendorCard_Ext002" extends "Vendor Card"
{
    //#region "Documentation"
    // 1.3.5.2018 LBR 01/10/2019 - new object created for CHG003332 (E-mailing Remittance). We do want to use standard NAV to send emials, however
    //      this version of NAV does not allow to extends standard option fields, therfore we will use P.Arch. Quote,P.Arch. Order for bespoke report purpose
    //#endregion "Documentation"

    layout
    {

    }

    actions
    {
        addafter(VendorReportSelections)
        {
            action(SpecialVendorReportSelections)
            {
                Caption = 'Special Document Layouts';
                ApplicationArea = all;
                Image = Quote;

                trigger OnAction();
                var
                    CustomReportSelection: Record "Custom Report Selection";
                begin
                    CustomReportSelection.SETRANGE("Source Type", DATABASE::Vendor);
                    CustomReportSelection.SETRANGE("Source No.", Rec."No.");
                    PAGE.RUNMODAL(PAGE::ACO_SpecialVendRepSelPurch, CustomReportSelection);
                end;
            }
        }
    }
}
