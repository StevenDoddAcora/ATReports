page 77203 "ACO_CustomerAgingDetails"
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
                field(ACO_Type; ACO_Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(ACO_RunAtDate; ACO_RunAtDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_No; ACO_No)
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                }
                //>>1.4.6.2018
                field(ACO_Name; ACO_Name)
                {
                    ApplicationArea = All;
                }
                field(ACO_LastPaidDate; ACO_LastPaidDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_NoOfDisputedInv; ACO_NoOfDisputedInv)
                {
                    ApplicationArea = All;
                }
                //<<1.4.6.2018

                // LCY
                field(ACO_CurrentBalanceLCY; ACO_CurrentBalanceLCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod1LCY; ACO_AgedValuePeriod1LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod2LCY; ACO_AgedValuePeriod2LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod3LCY; ACO_AgedValuePeriod3LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod4LCY; ACO_AgedValuePeriod4LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod5LCY; ACO_AgedValuePeriod5LCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalInvValueOverdueLCY; ACO_TotalInvValueOverdueLCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalAmountDueLCY; ACO_TotalAmountDueLCY)
                {
                    ApplicationArea = All;
                }
                //>>1.4.6.2018
                field(ACO_CreditLimitLCY; ACO_CreditLimitLCY)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                //<<1.4.6.2018
                // TCY
                field(ACO_CurrencyCodeTCY; ACO_CurrencyCodeTCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_CurrentBalanceTCY; ACO_CurrentBalanceTCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod1TCY; ACO_AgedValuePeriod1TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod2TCY; ACO_AgedValuePeriod2TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod3TCY; ACO_AgedValuePeriod3TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod4TCY; ACO_AgedValuePeriod4TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_AgedValuePeriod5TCY; ACO_AgedValuePeriod5TCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalInvValueOverdueTCY; ACO_TotalInvValueOverdueTCY)
                {
                    ApplicationArea = All;
                }
                field(ACO_TotalAmountDueTCY; ACO_TotalAmountDueTCY)
                {
                    ApplicationArea = All;
                }
                //>>1.4.6.2018
                field(ACO_CreditLimitTCY; ACO_CreditLimitTCY)
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
        SETRANGE(ACO_Type, Aco_Type::Customer);
    end;
}