page 77200 "ACO_QuantumImportLog"
{
    //#region "Documentation"
    // 1.3.6.2018 LBR 08/10/2019 - captions has been changed
    // 1.3.8.2018 LBR 24/10/2019 - Snagging New document Date added;
    //#endregion "Documentation"

    PageType = List;
    Caption = 'Import Log';
    ApplicationArea = All;
    UsageCategory = History;
    //TODO make it not editable
    //Editable = false;
    SourceTable = ACO_ImportLog;
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ACO_ImportType; ACO_ImportType)
                {
                    ApplicationArea = All;
                }
                field(ACO_ImportNo; ACO_ImportNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_FileName; ACO_FileName)
                {
                    ApplicationArea = All;
                }
                field(ACO_EntryNo; ACO_EntryNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_FileLineNo; ACO_FileLineNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_PostingDate; ACO_PostingDate)
                {
                    Caption = 'Posting Date';
                    ApplicationArea = All;
                }
                //>>1.3.8.2018
                field(ACO_DocumentDate; ACO_DocumentDate)
                 {
                     Caption = 'Document Date (Date)';
                     ApplicationArea = All;
                }
                //<<1.3.8.2018
                field(ACO_DocumentNo; ACO_DocumentNo)
                {
                    //>>1.3.6.2018
                    Caption = 'Document No. (InvRef)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_CustomerNo; ACO_CustomerNo)
                {
                    //>>1.3.6.2018
                    Caption = 'Customer No. (AccountRef)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_ExternalDocumentNo; ACO_ExternalDocumentNo)
                {
                    //>>1.3.6.2018
                    Caption = 'External Doc. No. (CustOrderNo)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_ProductNo; ACO_ProductNo)
                {
                    //>>1.3.6.2018
                    Caption = 'Item No. (Product)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_NormCode; ACO_NormCode)
                {
                    //>>1.3.6.2018
                    Caption = 'G/L Account No. (NomCode)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_Quantity; ACO_Quantity)
                {
                    //>>1.3.6.2018
                    Caption = 'Quantity (Qty)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_UnitPrice; ACO_UnitPrice)
                {
                    //>>1.3.6.2018
                    Caption = 'Unit Price (UnitPrice)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_TaxCode; ACO_TaxCode)
                {
                    //>>1.3.6.2018
                    Caption = 'VAT Product Posting Gr. (TaxCode)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_CurrencyCode; ACO_CurrencyCode)
                {
                    //>>1.3.6.2018
                    Caption = 'Currency Code (CurrCode)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_ImportDate; ACO_ImportDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_ImportTime; ACO_ImportTime)
                {
                    ApplicationArea = All;
                }
                field(ACO_Error; ACO_Error)
                {
                    ApplicationArea = All;
                }
                field(ACO_ErrorDescription; ACO_ErrorDescription)
                {
                    ApplicationArea = All;
                    Width = 200;
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(OpenUnpostedDocuments)
            {
                Caption = 'Open Related Unposted Documents';
                ApplicationArea = All;
                Image = ReturnRelated;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesInvList: page "Sales Invoice List";
                    SalesCreditList: page "Sales Credit Memos";
                begin
                    if ACO_ImportType = ACO_ImportType::Invoice then begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                        SalesHeader.SetRange(ACO_ImportNo, ACO_ImportNo);

                        SalesInvList.LookupMode(true);
                        SalesInvList.SetTableView(SalesHeader);
                        SalesInvList.Run();
                    end;
                    if ACO_ImportType = ACO_ImportType::Credit then begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                        SalesHeader.SetRange(ACO_ImportNo, ACO_ImportNo);

                        SalesCreditList.LookupMode(true);
                        SalesCreditList.SetTableView(SalesHeader);
                        SalesCreditList.Run();
                    end;
                end;
            }
            action(OpenPostedDocuments)
            {
                Caption = 'Open Related Posted Documents';
                ApplicationArea = All;
                Image = RelatedInformation;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    PostedSalesInvList: page "Posted Sales Invoices";
                    SalesCMHeader: Record "Sales Cr.Memo Header";
                    PostedSalesCreditList: page "Posted Sales Credit Memos";
                begin
                    if ACO_ImportType = ACO_ImportType::Invoice then begin
                        SalesInvHeader.SetCurrentKey(ACO_ImportNo);
                        SalesInvHeader.SetRange(ACO_ImportNo, ACO_ImportNo);

                        PostedSalesInvList.LookupMode(true);
                        PostedSalesInvList.SetTableView(SalesInvHeader);
                        PostedSalesInvList.Run();
                    end;
                    if ACO_ImportType = ACO_ImportType::Credit then begin
                        SalesCMHeader.SetCurrentKey(ACO_ImportNo);
                        SalesCMHeader.SetRange(ACO_ImportNo, ACO_ImportNo);

                        PostedSalesCreditList.LookupMode(true);
                        PostedSalesCreditList.SetTableView(SalesCMHeader);
                        PostedSalesCreditList.Run();
                    end;
                end;
            }
        }
    }
}