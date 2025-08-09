pageextension 50966 "ACO_PaymentJournal_Ext002" extends "Payment Journal"
{
    //#region "Documentation"
    // 1.3.2.2018 LBR 23/08/2019 - new action to print Remittance report
    // 1.3.5.2018 LBR 01/10/2019 - new action added to allow send email
    // 1.4.8.2018 LBR 05/12/2019 - CHG003386 (Payment Journals) - new "Manual Export" logic added;
    //#endregion "Documentation"

    layout
    {
    }

    actions
    {
        modify("Print Remi&ttance Advice")
        {
            Visible = false;
            //>>1.4.8.2018
            Enabled = false;
            //<<1.4.8.2018
        }

        //>>1.4.8.2018
        modify(ExportPaymentsToFile)
        {
            Visible = false;
            Enabled = false;
        }

        addbefore(VoidPayments)
        {
            action(AvtExportPaymentsToFile)
            {
                Caption = 'Export';
                ToolTip = 'Export a file with the payment information on the journal lines.';
                ApplicationArea = All;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                Ellipsis = true;

                trigger OnAction();
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    Rec.CheckIfPrivacyBlocked;
                    GenJnlLine.COPYFILTERS(Rec);
                    GenJnlLine.SetRange(ACO_ManualPaymentExp, false);
                    IF GenJnlLine.FINDFIRST THEN
                        GenJnlLine.ExportPaymentFile;
                end;
            }
        }
        //<<1.4.8.2018

        addlast("&Payments")
        {
            action(ACO_PrintRemittanceAdvice)
            {
                ApplicationArea = All;
                Caption = 'Avtrade Rem. Advice';
                ToolTip = 'Print the remittance advice before posting a payment journal and after posting a payment. This advice displays vendor invoice numbers, which helps vendors to perform reconciliations.';
                Image = PrintAttachment;
                PromotedIsBig = true;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RUN(REPORT::"ACO_AVTRemittanceAdviceJnl", TRUE, FALSE, GenJnlLine);
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
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.RESET;
                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");

                    IntegrationMgt.EmailRemittanceJnl(GenJnlLine);
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