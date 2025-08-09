pageextension 50965 "ACO_VendorLedgerEntry_Ext002" extends "Vendor Ledger Entries"
{
    //#region "Documentation"
    // 1.3.2.2018 LBR 23/08/2019 - new action to print Remittance report
    // 1.3.5.2018 LBR 01/10/2019 - new action added to allow send email
    //#endregion "Documentation"

    layout
    {
    }

    actions
    {
        modify("&Rem. Advice")
        {
            Visible = false;
            Enabled = false;
        }

        addlast("F&unctions")
        {
            action(ACO_PrintRemittanceAdvice)
            {
                ApplicationArea = All;
                Caption = 'Avtrade Rem. Advice';
                ToolTip = 'View which documents have been included in the payment.';
                Image = PrintAttachment;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                begin
                    CurrPage.SETSELECTIONFILTER(VendLedgEntry);
                    VendLedgEntry.COPYFILTERS(Rec);
                    VendLedgEntry.SETRANGE("Document Type", VendLedgEntry."Document Type"::Payment);
                    REPORT.RUN(REPORT::ACO_AVTRemittAdviceEntries, TRUE, FALSE, VendLedgEntry);
                end;
            }
            //>>1.3.5.2018
            action(ACO_EmailRemittanceAdvice)
            {
                ApplicationArea = All;
                Caption = 'Avtrade Email Rem. Advice';
                ToolTip = 'Email the remittance advice per Vendor';
                Image = Email;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    IntegrationMgt: Codeunit ACO_IntegrationMgt;
                    VendLedgEntries: Record "Vendor Ledger Entry";
                begin
                    VendLedgEntries.RESET;
                    VendLedgEntries.CopyFilters(Rec);
                    VendLedgEntries.SETRANGE("Document Type", VendLedgEntries."Document Type"::Payment);

                    IntegrationMgt.EmailRemittanceEntries(VendLedgEntries);
                end;
            }
            //<<1.3.5.2018
        }
    }
    //#region "Page Functions"

    //#endregion "Page Functions"

    //#region "Page Triggers"

    //#endregion "Page Triggers"

    var
}