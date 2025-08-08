pageextension 77304 "ACO_CustomerList_Ext002" extends "Customer List"
{
    //#region "Documentation"
    // 1.3.7.2018 LBR 16/10/2019 - Snagging: added Avtrade Aged Accounts Receivable action;
    //#endregion "Documentation"
    
    layout
    {
        
    }
    
    actions
    {
        modify("Aged Accounts Receivable"){
            Visible = false;
            Enabled = false;
        }

        addafter("Aged Accounts Receivable"){
            action(AvtradeAgedAccountsReceivable){
                Caption = 'Avtrade Aged Accounts Receivable';
                ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                ApplicationArea = all;
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction();
                var
                    AvtAgedAccountsReceivable: Report ACO_AgedAccountsReceivable;
                    Customer: record Customer;
                begin
                    Customer.setrange("No.", "No.");
                    Report.run(Report::ACO_AgedAccountsReceivable, true, false, Customer);
                end;
            }
        }
    }
}