page 77202 "ACO_SpecialVendRepSelPurch"
{
    //#region "Documentation"
    // 1.3.5.2018 LBR 01/10/2019 - new object created for CHG003332 (E-mailing Remittance). We do want to use standard NAV to send emials, however
    //      this version of NAV does not allow to extends standard option fields, therfore we will use P.Arch. Quote,P.Arch. Order for bespoke report purpose
    //#endregion "Documentation"

    Caption = 'Vendor Special Report Selections';
    DataCaptionFields = "Source No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Custom Report Selection";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = "Custom Report Description";
                field(Usage2; Usage2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Usage';
                    OptionCaption = 'Remittance Jnl,Remittance Entries';
                    ToolTip = 'Specifies which type of document the report is used for.';

                    trigger OnValidate();
                    begin
                        case Usage2 of
                            Usage2::"Remittance Jnl":
                                Usage := Usage::"P.Arch. Quote";
                            Usage2::"Remittance Entries":
                                Usage := Usage::"P.Arch. Order";
                        end;
                    end;
                }
                field(ReportID; "Report ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report ID';
                    ToolTip = 'Specifies the ID of the report.';
                }
                field(ReportCaption; "Report Caption")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Caption';
                    ToolTip = 'Specifies the name of the report.';
                }
                field("Custom Report Description"; "Custom Report Description")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Custom Layout Description';
                    DrillDown = true;
                    Lookup = true;
                    ToolTip = 'Specifies a description of the custom report layout.';

                    trigger OnDrillDown();
                    begin
                        LookupCustomReportDescription;
                        CurrPage.UPDATE(true);
                    end;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        LookupCustomReportDescription;
                        CurrPage.UPDATE(true);
                    end;

                    trigger OnValidate();
                    var
                        CustomReportLayout: Record "Custom Report Layout";
                    begin
                        if "Custom Report Description" = '' then begin
                            VALIDATE("Custom Report Layout Code", '');
                            MODIFY(true);
                        end else begin
                            CustomReportLayout.SETRANGE("Report ID", "Report ID");
                            CustomReportLayout.SETFILTER(Description, STRSUBSTNO('@*%1*', "Custom Report Description"));
                            if not CustomReportLayout.FINDFIRST then
                                ERROR(CouldNotFindCustomReportLayoutErr, "Custom Report Description");

                            VALIDATE("Custom Report Layout Code", CustomReportLayout.Code);
                            MODIFY(true);
                        end;
                    end;
                }
                field(SendToEmail; "Send To Email")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send To Email';
                    ToolTip = 'Specifies that the report is used when sending emails.';
                }
                field("Use for Email Body"; "Use for Email Body")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that summarised information, such as invoice number, due date, and payment service link, will be inserted in the body of the email that you send.';
                }
                field("Email Body Layout Code"; "Email Body Layout Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the ID of the email body layout that is used.';
                    Visible = false;
                }
                field("Email Body Layout Description"; "Email Body Layout Description")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = true;
                    Lookup = true;
                    ToolTip = 'Specifies a description of the email body layout that is used.';

                    trigger OnDrillDown();
                    begin
                        LookupEmailBodyDescription;
                        CurrPage.UPDATE(true);
                    end;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        LookupEmailBodyDescription;
                        CurrPage.UPDATE(true);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        MapTableUsageValueToPageValue;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        // Set the default usage to the same as the page default.
        if Usage = 0 then
            Usage := Usage::"P.Arch. Quote";

        MapTableUsageValueToPageValue;
    end;

    var
        Usage2: Option "Remittance Jnl","Remittance Entries";
        CouldNotFindCustomReportLayoutErr: Label 'There is no custom report layout with %1 in the description.';

    local procedure MapTableUsageValueToPageValue();
    var
        CustomReportSelection: Record "Custom Report Selection";
    begin
        case Usage of
            CustomReportSelection.Usage::"P.Arch. Quote":
                Usage2 := Usage2::"Remittance Jnl";
            CustomReportSelection.Usage::"P.Arch. Order":
                Usage2 := Usage2::"Remittance Entries";
        end;
    end;
}

