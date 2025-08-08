tableextension 77101 ACO_VendorBankAccount_Ext002 extends "Vendor Bank Account"
{
    //#region "Documentation"
    //3.0.9.2018 MAR 25/02/2020 - CHG003417 - Add beneficiary information fields on the Payment Export data definition
    //#endregion "Documentation"

    fields
    {
        field(77000; ACO_InfoBeneficiary; Text[100])
        {
            Caption = 'Information for Beneficiary';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(77001; ACO_InfoBeneficiary2; Text[100])
        {
            Caption = 'Information for Beneficiary 2';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(77002; ACO_InfoBeneficiary3; Text[100])
        {
            Caption = 'Information for Beneficiary 3';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
    }
}
