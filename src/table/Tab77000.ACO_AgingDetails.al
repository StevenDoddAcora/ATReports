table 50908 "ACO_AgingDetails"
{
    //#region Documentation
    // 1.3.7.2018 LBR 16/10/2019 - CHG003339 (Customer Average Collection Period) - new page for calculation puprose added;
    // 1.4.6.2018 LBR 16/11/2019 - CHG003378 (Customer Avg Collection Period) - new fields added;
    //#endregion Documentation

    Caption = 'Aging Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; ACO_Type; Option)
        {
            Caption = 'Type';
            OptionMembers = "Customer","Vendor";
            OptionCaption = 'Customer,Vendor';
            DataClassification = ToBeClassified;
        }
        field(20; ACO_No; Code[20])
        {
            Caption = 'No';
            DataClassification = ToBeClassified;
        }
        field(30; ACO_RunAtDate; Date)
        {
            Caption = 'Run at Date';
            DataClassification = ToBeClassified;
        }
        //>>1.4.6.2018
        field(40; ACO_Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(50; ACO_LastPaidDate; Date)
        {
            Caption = 'Last Paid Date';
            DataClassification = ToBeClassified;
        }
        field(60; ACO_NoOfDisputedInv; Integer)
        {
            Caption = 'No. of Disputed Invoices';
            DataClassification = ToBeClassified;
        }
        //<<1.4.6.2018
        // LCY
        field(100; ACO_CurrentBalanceLCY; Decimal)
        {
            Caption = 'Current Balance (LCY)';
            DataClassification = ToBeClassified;
        }
        field(110; ACO_AgedValuePeriod1LCY; Decimal)
        {
            Caption = 'Aged Debt 1-30 Days (LCY)';
            DataClassification = ToBeClassified;
        }
        field(120; ACO_AgedValuePeriod2LCY; Decimal)
        {
            Caption = 'Aged Debt 31-60 Days (LCY)';
            DataClassification = ToBeClassified;
        }
        field(130; ACO_AgedValuePeriod3LCY; Decimal)
        {
            Caption = 'Aged Debt 61-90 Days (LCY)';
            DataClassification = ToBeClassified;
        }
        field(140; ACO_AgedValuePeriod4LCY; Decimal)
        {
            Caption = 'Aged Debt 91-120 Days (LCY)';
            DataClassification = ToBeClassified;
        }
        field(150; ACO_AgedValuePeriod5LCY; Decimal)
        {
            Caption = 'Aged Debt 121+ Days (LCY)';
            DataClassification = ToBeClassified;
        }
        field(200; ACO_TotalInvValueOverdueLCY; Decimal)
        {
            Caption = 'Total Inv. Value Overdue (LCY)';
            DataClassification = ToBeClassified;
        }
        field(210; ACO_TotalAmountDueLCY; Decimal)
        {
            Caption = 'Total Amount Due (LCY)';
            DataClassification = ToBeClassified;
        }
        //>>1.4.6.2018
        field(220; ACO_CreditLimitLCY; Decimal)
        {
            Caption = 'Credit Limit (LCY)';
            DataClassification = ToBeClassified;
        }
        //<<1.4.6.2018

        // TCY
        field(299; ACO_CurrencyCodeTCY; Code[20])
        {
            Caption = 'Currency Code (TCY)';
            DataClassification = ToBeClassified;
        }
        field(300; ACO_CurrentBalanceTCY; Decimal)
        {
            Caption = 'Current Balance (TCY)';
            DataClassification = ToBeClassified;
        }
        field(310; ACO_AgedValuePeriod1TCY; Decimal)
        {
            Caption = 'Aged Debt 1-30 Days (TCY)';
            DataClassification = ToBeClassified;
        }
        field(320; ACO_AgedValuePeriod2TCY; Decimal)
        {
            Caption = 'Aged Debt 31-60 Days (TCY)';
            DataClassification = ToBeClassified;
        }
        field(330; ACO_AgedValuePeriod3TCY; Decimal)
        {
            Caption = 'Aged Debt 61-90 Days (TCY)';
            DataClassification = ToBeClassified;
        }
        field(340; ACO_AgedValuePeriod4TCY; Decimal)
        {
            Caption = 'Aged Debt 91-120 Days (TCY)';
            DataClassification = ToBeClassified;
        }
        field(350; ACO_AgedValuePeriod5TCY; Decimal)
        {
            Caption = 'Aged Debt 121+ Days (TCY)';
            DataClassification = ToBeClassified;
        }
        field(400; ACO_TotalInvValueOverdueTCY; Decimal)
        {
            Caption = 'Total Inv. Value Overdue (TCY)';
            DataClassification = ToBeClassified;
        }
        field(410; ACO_TotalAmountDueTCY; Decimal)
        {
            Caption = 'Total Amount Due (TCY)';
            DataClassification = ToBeClassified;
        }
        //>>1.4.6.2018
        field(500; ACO_CreditLimitTCY; Decimal)
        {
            Caption = 'Credit Limit (TCY)';
            DataClassification = ToBeClassified;
        }
        //<<1.4.6.2018
    }

    keys
    {
        key(PK; ACO_Type, ACO_No)
        {
            Clustered = true;
        }
    }

}