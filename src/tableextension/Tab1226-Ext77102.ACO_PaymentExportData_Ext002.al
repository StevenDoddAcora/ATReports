tableextension 50911 ACO_PaymentExportData_Ext002 extends "Payment Export Data"
{
    //#region "Documentation"
    //3.0.9.2018 MAR 25/02/2020 - CHG003417 - Add beneficiary information fields on the Payment Export data definition
    //#endregion "Documentation"

    fields
    {
        field(50958; ACO_InfoBeneficiary; Text[100])
        {
            Caption = 'Information for Beneficiary';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(50959; ACO_InfoBeneficiary2; Text[100])
        {
            Caption = 'Information for Beneficiary 2';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(50960; ACO_InfoBeneficiary3; Text[100])
        {
            Caption = 'Information for Beneficiary 3';
            DataClassification = CustomerContent;
            Description = 'It indicates additional beneficiary info';
        }
        field(50961; ACO_IntermediarySWIFTCode; Code[20])
        {
            Caption = 'Intermediary SWIFT Code';
            DataClassification = CustomerContent;
            Description = 'It indicates the intermediary SWIFT Code';
        }
        //Intermediary SWIFT Code
    }
}