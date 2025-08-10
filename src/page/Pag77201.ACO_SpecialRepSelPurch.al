page 50901 "ACO_SpecialRepSelPurch"
{
    //#region "Documentation"
    // 1.3.5.2018 LBR 01/10/2019 - new object created for CHG003332 (E-mailing Remittance). We do want to use standard NAV to send emials, however
    //      this version of NAV does not allow to extends standard option fields, therfore we will use P.Arch. Quote,P.Arch. Order for bespoke report purpose
    //#endregion "Documentation"

    Caption = 'Special Report Selection - Purchase';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    ApplicationArea = all;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field(ReportUsage2; ReportUsage2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Usage';
                //>>
                OptionCaption = 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Receipt,Return Shipment,Purchase Document - Test,Prepayment Document - Test,Remittance Jnl,Remittance Entries,P. Arch. Return Order';
                //<<
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate();
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = Basic, Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the object ID of the report.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the display name of the report.';
                }
                field("Use for Email Body"; Rec."Use for Email Body")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that summarised information, such as invoice number, due date, and payment service link, will be inserted in the body of the email that you send.';
                }
                field("Use for Email Attachment"; Rec."Use for Email Attachment")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the related document will be attached to the email.';
                }
                field("Email Body Layout Code"; Rec."Email Body Layout Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the email body layout that is used.';
                    Visible = false;
                }
                field("Email Body Layout Description"; Rec."Email Body Layout Description")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the email body layout that is used.';

                    trigger OnDrillDown();
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if CustomReportLayout.LookupLayoutOK(Rec."Report ID") then
                            Rec.VALIDATE("Email Body Layout Code", CustomReportLayout.Code);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.NewRecord();
    end;

    trigger OnOpenPage();
    begin
        SetUsageFilter(false);
    end;

    var
        ReportUsage2: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo",Receipt,"Return Shipment","Purchase Document - Test","Prepayment Document - Test","Remittance Jnl","Remittance Entries","P. Arch. Return Order";

    local procedure SetUsageFilter(ModifyRec: Boolean);
    begin
        if ModifyRec then
            if Rec.MODIFY then;
        Rec.FILTERGROUP(2);
        case ReportUsage2 of
            ReportUsage2::Quote:
                Rec.SETRANGE(Usage, Rec.Usage::"P.Quote");
            ReportUsage2::"Blanket Order":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Blanket");
            ReportUsage2::Order:
                Rec.SETRANGE(Usage, Rec.Usage::"P.Order");
            ReportUsage2::Invoice:
                Rec.SETRANGE(Usage, Rec.Usage::"P.Invoice");
            ReportUsage2::"Return Order":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Return");
            ReportUsage2::"Credit Memo":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Cr.Memo");
            ReportUsage2::Receipt:
                Rec.SETRANGE(Usage, Rec.Usage::"P.Receipt");
            ReportUsage2::"Return Shipment":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Ret.Shpt.");
            ReportUsage2::"Purchase Document - Test":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Test");
            ReportUsage2::"Prepayment Document - Test":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Test Prepmt.");
            //>>
            ReportUsage2::"Remittance Jnl":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Arch.Quote");
            ReportUsage2::"Remittance Entries":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Arch.Order");
            //<<
            ReportUsage2::"P. Arch. Return Order":
                Rec.SETRANGE(Usage, Rec.Usage::"P.Arch.Return");
        end;
        Rec.FILTERGROUP(0);
        CurrPage.UPDATE;
    end;
}

