page 50900 "ACO_QuantumImportLog"
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
                field(ACO_ImportType; Rec.ACO_ImportType)
                {
                    ApplicationArea = All;
                }
                field(ACO_ImportNo; Rec.ACO_ImportNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_FileName; Rec.ACO_FileName)
                {
                    ApplicationArea = All;
                }
                field(ACO_EntryNo; Rec.ACO_EntryNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_FileLineNo; Rec.ACO_FileLineNo)
                {
                    ApplicationArea = All;
                }
                field(ACO_PostingDate; Rec.ACO_PostingDate)
                {
                    Caption = 'Posting Date';
                    ApplicationArea = All;
                }
                //>>1.3.8.2018
                field(ACO_DocumentDate; Rec.ACO_DocumentDate)
                {
                    Caption = 'Document Date (Date)';
                    ApplicationArea = All;
                }
                //<<1.3.8.2018
                field(ACO_DocumentNo; Rec.ACO_DocumentNo)
                {
                    //>>1.3.6.2018
                    Caption = 'Document No. (InvRef)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_CustomerNo; Rec.ACO_CustomerNo)
                {
                    //>>1.3.6.2018
                    Caption = 'Customer No. (AccountRef)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_ExternalDocumentNo; Rec.ACO_ExternalDocumentNo)
                {
                    //>>1.3.6.2018
                    Caption = 'External Doc. No. (CustOrderNo)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_ProductNo; Rec.ACO_ProductNo)
                {
                    //>>1.3.6.2018
                    Caption = 'Item No. (Product)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_NormCode; Rec.ACO_NormCode)
                {
                    //>>1.3.6.2018
                    Caption = 'G/L Account No. (NomCode)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_Quantity; Rec.ACO_Quantity)
                {
                    //>>1.3.6.2018
                    Caption = 'Quantity (Qty)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_UnitPrice; Rec.ACO_UnitPrice)
                {
                    //>>1.3.6.2018
                    Caption = 'Unit Price (UnitPrice)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_TaxCode; Rec.ACO_TaxCode)
                {
                    //>>1.3.6.2018
                    Caption = 'VAT Product Posting Gr. (TaxCode)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_CurrencyCode; Rec.ACO_CurrencyCode)
                {
                    //>>1.3.6.2018
                    Caption = 'Currency Code (CurrCode)';
                    //<<1.3.6.2018
                    ApplicationArea = All;
                }
                field(ACO_ImportDate; Rec.ACO_ImportDate)
                {
                    ApplicationArea = All;
                }
                field(ACO_ImportTime; Rec.ACO_ImportTime)
                {
                    ApplicationArea = All;
                }
                field(ACO_Error; Rec.ACO_Error)
                {
                    ApplicationArea = All;
                }
                field(ACO_ErrorDescription; Rec.ACO_ErrorDescription)
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
                    if Rec.ACO_ImportType = Rec.ACO_ImportType::Invoice then begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                        SalesHeader.SetRange(ACO_ImportNo, Rec.ACO_ImportNo);

                        SalesInvList.LookupMode(true);
                        SalesInvList.SetTableView(SalesHeader);
                        SalesInvList.Run();
                    end;
                    if Rec.ACO_ImportType = Rec.ACO_ImportType::Credit then begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                        SalesHeader.SetRange(ACO_ImportNo, Rec.ACO_ImportNo);

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
                    if Rec.ACO_ImportType = Rec.ACO_ImportType::Invoice then begin
                        SalesInvHeader.SetCurrentKey(ACO_ImportNo);
                        SalesInvHeader.SetRange(ACO_ImportNo, Rec.ACO_ImportNo);

                        PostedSalesInvList.LookupMode(true);
                        PostedSalesInvList.SetTableView(SalesInvHeader);
                        PostedSalesInvList.Run();
                    end;
                    if Rec.ACO_ImportType = Rec.ACO_ImportType::Credit then begin
                        SalesCMHeader.SetCurrentKey(ACO_ImportNo);
                        SalesCMHeader.SetRange(ACO_ImportNo, Rec.ACO_ImportNo);

                        PostedSalesCreditList.LookupMode(true);
                        PostedSalesCreditList.SetTableView(SalesCMHeader);
                        PostedSalesCreditList.Run();
                    end;
                end;
            }
        }
    }
}