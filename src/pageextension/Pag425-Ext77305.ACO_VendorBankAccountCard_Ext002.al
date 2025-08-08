pageextension 77305 ACO_BankAccountCard_Ext002 extends "Vendor Bank Account Card"
{
    //#region "Documentation"
    //3.0.9.2018 MAR 25/02/2020 - CHG003417 - Add beneficiary information fields on the Payment Export data definition
    //#endregion "Documentation"

    layout
    {
        addlast(Transfer)
        {
            field(ACO_InfoBeneficiary; ACO_InfoBeneficiary)
            {
                ApplicationArea = All;
            }
            field(ACO_InfoBeneficiary2; ACO_InfoBeneficiary2)
            {
                ApplicationArea = All;
            }
            field(ACO_InfoBeneficiary3; ACO_InfoBeneficiary3)
            {
                ApplicationArea = All;
            }
        }
    }
}