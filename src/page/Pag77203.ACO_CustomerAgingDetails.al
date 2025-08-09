page 50907 "ACO_CustomerAgingDetails"
{
    //#region Documentation
    // 1.3.7.2018 LBR 16/10/2019 - CHG003339 (Customer Average Collection Period) - new page for calculation puprose added;
    // 1.4.6.2018 LBR 16/11/2019 - CHG003378 (Customer Avg Collection Period) - new fields added;
    //#endregion Documentation

    Caption = 'Customer Aging Details';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = ACO_AgingDetails;
    //Customer filter
    //SourceTableView = WHERE (ACO_Type = filter(= Customer));
    //Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ACO_Type; Rec.ACO_Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ACO_RunAtDate; Rec.ACO_RunAtDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_No; Rec.ACO_No)
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                }
                //>>1.4.6.2018
                field(ACO_Name; Rec.ACO_Name)
                {
                    ApplicationArea = All;
                }
                field(ACO_LastPaidDate; Rec.ACO_LastPaidDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_NoOfDisputedInv; Rec.ACO_NoOfDisputedInv)
                {
                    ApplicationArea = All;
                }
                //<<1.4.6.2018

                // LCY
                field(ACO_CurrentBalanceLCY; Rec.ACO_CurrentBalanceLCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod1LCY; Rec.ACO_AgedValuePeriod1LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod2LCY; Rec.ACO_AgedValuePeriod2LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod3LCY; Rec.ACO_AgedValuePeriod3LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod4LCY; Rec.ACO_AgedValuePeriod4LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod5LCY; Rec.ACO_AgedValuePeriod5LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalInvValueOverdueLCY; Rec.ACO_TotalInvValueOverdueLCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalAmountDueLCY; Rec.ACO_TotalAmountDueLCY)
                {
                    ApplicationArea = All;
                }
                //>>1.4.6.2018
                field(ACO_CreditLimitLCY; Rec.ACO_CreditLimitLCY)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //<<1.4.6.2018
                // TCY
                field(ACO_CurrencyCodeTCY; Rec.ACO_CurrencyCodeTCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_CurrentBalanceTCY; Rec.ACO_CurrentBalanceTCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod1TCY; Rec.ACO_AgedValuePeriod1TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod2TCY; Rec.ACO_AgedValuePeriod2TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod3TCY; Rec.ACO_AgedValuePeriod3TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod4TCY; Rec.ACO_AgedValuePeriod4TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod5TCY; Rec.ACO_AgedValuePeriod5TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalInvValueOverdueTCY; Rec.ACO_TotalInvValueOverdueTCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalAmountDueTCY; Rec.ACO_TotalAmountDueTCY)
                {
                    ApplicationArea = All;
                }
                //>>1.4.6.2018
                field(ACO_CreditLimitTCY; Rec.ACO_CreditLimitTCY)
                {
                    ApplicationArea = All;
                }
                //<<1.4.6.2018
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RecalculateData)
            {
                Caption = 'Recalculate';
                ApplicationArea = All;
                Image = Recalculate;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                //Enabled = false;
                //Visible = false;

                trigger OnAction()
                var
                    IntegrationMgt: Codeunit ACO_IntegrationMgt;
                begin
                    IntegrationMgt.UpdateCustomerAgingData(WorkDate);
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SETRANGE(ACO_Type, Rec.Aco_Type::Customer);
    end;
}