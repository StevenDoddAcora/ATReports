tableextension 50909 "ACO_AdditionalSetup_Ext002" extends ACO_AdditionalSetup //MyTargetTableId
{

    //#region "Documentation"
    //ABS001 - 1.3.0.2018 - This table extension extends additional setup table (89.000)
    //                      - Field " ACO_XMLPortTextEnconding" added to establish the Text Enconding to be used for XMLPorts
    //3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Carry line descriptions to G/L entries when posting, 
    //      new functionality added to prevent purchase/Sales lines compression
    //#endregion "Documentation"

    fields
    {
        field(50950; ACO_XMLPortTextEnconding; Option)
        {
            Caption = 'XMLPort Text Encoding';
            DataClassification = CustomerContent;
            OptionMembers = "MS-Dos","UTF-8","UTF-16","Windows";
            OptionCaption = 'MS-Dos,UTF-8,UTF-16,Windows';
            Description = 'It indicates which Text Enconding should be used when Exporting/Importing XMLPorts';
        }

        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Purchase Line compression</summary>
        field(50951; ACO_PreventPurchLineCompression; Boolean)
        {
            Caption = 'Prevent Purchase Line Compression';
            DataClassification = CustomerContent;
            Description = 'It determines whether Purchase Line compression should be prevented';
            Editable = true;
        }

        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Purchase Line compression</summary>
        field(50952; ACO_PreventPurchLineCompDimCode; Code[20])
        {
            Caption = 'Prevent Purchase Line Compression Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
            Description = 'It determines which Dimension should be used as part of the Prevention of Purchase Line Compression';
            Editable = true;
        }
        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Sales Line compression</summary>
        field(50953; ACO_PreventSalesLineCompression; Boolean)
        {
            Caption = 'Prevent Sales Line Compression';
            DataClassification = CustomerContent;
            Description = 'It determines whether Sales Line compression should be prevented';
            Editable = true;
        }

        ///<summary>3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Field to prevent Sales Line compression</summary>
        field(50954; ACO_PreventSalesLineCompDimCode; Code[20])
        {
            Caption = 'Prevent Sales Line Compression Dimension';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
            Description = 'It determines which Dimension should be used as part of the Prevention of Sales Line Compression';
            Editable = true;
        }
    }

}