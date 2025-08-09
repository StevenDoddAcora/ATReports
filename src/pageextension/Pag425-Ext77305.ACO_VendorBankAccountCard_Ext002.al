pageextension 50962 ACO_BankAccountCard_Ext002 extends "Vendor Bank Account Card"
{
    //#region "Documentation"
    //3.0.9.2018 MAR 25/02/2020 - CHG003417 - Add beneficiary information fields on the Payment Export data definition
    //#endregion "Documentation"

    layout
    {
        addlast(Transfer)
        {
            field(ACO_InfoBeneficiary; Rec.ACO_InfoBeneficiary)
            {
                ApplicationArea = All;
            }
            field(ACO_InfoBeneficiary2; Rec.ACO_InfoBeneficiary2)
            {
                ApplicationArea = All;
            }
            field(ACO_InfoBeneficiary3; Rec.ACO_InfoBeneficiary3)
            {
                ApplicationArea = All;
            }
        }
    }
}