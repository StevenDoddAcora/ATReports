report 50921 "ACO_AvtradeStatement"
{
    //#region "Documentation"
    // 1.3.2.2018 LBR 23/08/2019 - new object (Reports added for Statement, Remittance and Purch Order)
    // 1.3.4.2018 LBR 13/09/2019 - report snagging (layout changes )
    // 1.3.5.2018 LBR 01/10/2019 - report snagging (added hide closed entries option), 
    // 1.3.6.2018 LBR 10/10/2019 - Change the statement to work per currency (note currency flow filter is not working with new email functionality);
    // 1.3.7.2018 LBR 16/10/2019 - Snagging, added aging by Document Date; CHG003339 (Customer Average Collection Period) - logic added
    // 1.3.9.2018 LBR 29/10/2019 - Snagging to show correct agind data
    // 1.4.0.2018 LBR 04/11/2019 - GO LIVE Snagging (Days over value should be always calcualted based on the due date and end date)
    // 1.4.1.2018 LBR 05/11/2019 - GO LIVE Snagging (Balance should be calculated based on the remaining amount)
    // 1.4.6.2018 LBR 16/11/2019 - CHG003378 (Customer Avg Collection Period) - new code added to populate name;
    // 1.4.8.2018 LBR 29/11/2019 - Aging Summary table should be cleared if the "Recalculate" action is call
    // 3.0.1.2018 LBR 24/01/2020 - Corrected Statement issue for finding customer currencies
    // 3.0.7.2018 LBR 30/01/2020 - Correct statment to work for GBP as well
    //#endregion "Documentation"

    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layouts/Rep50921.AvtradeStatement.rdlc';
    Caption = 'Statement';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Customer; Customer) //1.3.6.2018
        {
            DataItemTableView = SORTING("No.");
            RequestFilterHeading = 'Customer Filters';
            RequestFilterFields = "No.", "Search Name", "Print Statements";

            dataitem(CurrencyGroup; Integer) //1.3.6.2018
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(Code_CurrencyGroup; gCurrencyGroupTMP.Code)
                {
                }

                dataitem(Customer2; Customer)
                {
                    DataItemTableView = SORTING("No.");
                    //>>1.3.6.2018
                    DataItemLinkReference = "Customer";
                    DataItemLink = "No." = FIELD("No.");
                    //PrintOnlyIfDetail = true;
                    //<<1.3.6.2018

                    column(No_Cust; "No.")
                    {
                    }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        PrintOnlyIfDetail = true;
                        column(CompanyInfo1Picture; CompanyInfo1.Picture)
                        {
                        }
                        column(CompanyInfo2Picture; CompanyInfo2.Picture)
                        {
                        }
                        column(CompanyInfo3Picture; CompanyInfo3.Picture)
                        {
                        }
                        column(CustAddr1; CustAddr[1])
                        {
                        }
                        column(CompanyAddr1; CompanyAddr[1])
                        {
                        }
                        column(CustAddr2; CustAddr[2])
                        {
                        }
                        column(CompanyAddr2; CompanyAddr[2])
                        {
                        }
                        column(CustAddr3; CustAddr[3])
                        {
                        }
                        column(CompanyAddr3; CompanyAddr[3])
                        {
                        }
                        column(CustAddr4; CustAddr[4])
                        {
                        }
                        column(CompanyAddr4; CompanyAddr[4])
                        {
                        }
                        column(CustAddr5; CustAddr[5])
                        {
                        }
                        column(PhoneNo_CompanyInfo; CompanyInfo."Phone No.")
                        {
                        }
                        column(CustAddr6; CustAddr[6])
                        {
                        }
                        column(CompanyInfoEmail; CompanyInfo."E-Mail")
                        {
                        }
                        column(CompanyInfoHomePage; CompanyInfo."Home Page")
                        {
                        }
                        column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
                        {
                        }
                        column(GiroNo_CompanyInfo; CompanyInfo."Giro No.")
                        {
                        }
                        column(BankName_CompanyInfo; CompanyInfo."Bank Name")
                        {
                        }
                        column(BankAccNo_CompanyInfo; CompanyInfo."Bank Account No.")
                        {
                        }
                        column(No1_Cust; Customer2."No.")
                        {
                        }
                        column(TodayFormatted; FORMAT(TODAY))
                        {
                        }
                        column(StartDate; FORMAT(StartDate))
                        {
                        }
                        column(EndDate; FORMAT(EndDate))
                        {
                        }
                        column(LastStatmntNo_Cust; FORMAT(Customer2."Last Statement No."))
                        {
                            //DecimalPlaces = 0:0;
                        }
                        column(CustAddr7; CustAddr[7])
                        {
                        }
                        column(CustAddr8; CustAddr[8])
                        {
                        }
                        column(CompanyAddr7; CompanyAddr[7])
                        {
                        }
                        column(CompanyAddr8; CompanyAddr[8])
                        {
                        }
                        column(StatementCaption; StatementCaptionLbl)
                        {
                        }
                        column(PhoneNo_CompanyInfoCaption; PhoneNo_CompanyInfoCaptionLbl)
                        {
                        }
                        column(VATRegNo_CompanyInfoCaption; VATRegNo_CompanyInfoCaptionLbl)
                        {
                        }
                        column(GiroNo_CompanyInfoCaption; GiroNo_CompanyInfoCaptionLbl)
                        {
                        }
                        column(BankName_CompanyInfoCaption; BankName_CompanyInfoCaptionLbl)
                        {
                        }
                        column(BankAccNo_CompanyInfoCaption; BankAccNo_CompanyInfoCaptionLbl)
                        {
                        }
                        column(No1_CustCaption; No1_CustCaptionLbl)
                        {
                        }
                        column(StartDateCaption; StartDateCaptionLbl)
                        {
                        }
                        column(EndDateCaption; EndDateCaptionLbl)
                        {
                        }
                        column(LastStatmntNo_CustCaption; LastStatmntNo_CustCaptionLbl)
                        {
                        }
                        column(PostDate_DtldCustLedgEntriesCaption; PostDate_DtldCustLedgEntriesCaptionLbl)
                        {
                        }
                        column(DocNo_DtldCustLedgEntriesCaption; DtldCustLedgEntries.FIELDCAPTION("Document No."))
                        {
                        }
                        column(Desc_CustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION(Description))
                        {
                        }
                        column(DueDate_CustLedgEntry2Caption; DueDate_CustLedgEntry2CaptionLbl)
                        {
                        }
                        column(RemainAmtCustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION("Remaining Amount"))
                        {
                        }
                        column(CustBalanceCaption; CustBalanceCaptionLbl)
                        {
                        }
                        column(OriginalAmt_CustLedgEntry2Caption; CustLedgEntry2.FIELDCAPTION("Original Amount"))
                        {
                        }
                        column(CompanyInfoHomepageCaption; CompanyInfoHomepageCaptionLbl)
                        {
                        }
                        column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
                        {
                        }
                        column(DocDateCaption; DocDateCaptionLbl)
                        {
                        }
                        column(Total_Caption2; Total_CaptionLbl)
                        {
                        }
                        column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                        {
                        }
                        column(Desc_PaymentTerms; PaymentTerms.Description)
                        {
                        }
                        column(Picture_CompanyInfo; CompanyInfo.Picture)
                        {
                        }
                        column(gBankFooter1; gBankFooter1)
                        {
                        }
                        column(gBankFooter2; gBankFooter2)
                        {
                        }
                        column(gBankFooter3; gBankFooter3)
                        {
                        }
                        //>>1.3.6.2018
                        column(HeaderText1; HeaderText[1])
                        {
                        }
                        column(HeaderText2; HeaderText[2])
                        {
                        }
                        column(HeaderText3; HeaderText[3])
                        {
                        }
                        column(HeaderText4; HeaderText[4])
                        {
                        }
                        column(HeaderText5; HeaderText[5])
                        {
                        }
                        //<<1.3.6.2018
                        dataitem(CurrencyLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            PrintOnlyIfDetail = true;
                            dataitem(CustLedgEntryHdr; "Integer")
                            {
                                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                                column(Currency2Code_CustLedgEntryHdr; STRSUBSTNO(Text001, CurrencyCode3))
                                {
                                }
                                column(StartBalance; StartBalance)
                                {
                                    AutoFormatExpression = Currency2.Code;
                                    AutoFormatType = 1;
                                }
                                column(CurrencyCode3; CurrencyCode3)
                                {
                                }
                                column(CustBalance_CustLedgEntryHdr; CustBalance)
                                {
                                }
                                column(PrintLine; PrintLine)
                                {
                                }
                                column(DtldCustLedgEntryType; FORMAT(DtldCustLedgEntries."Entry Type", 0, 2))
                                {
                                }
                                column(EntriesExists; EntriesExists)
                                {
                                }
                                column(IsNewCustCurrencyGroup; IsNewCustCurrencyGroup)
                                {
                                }
                                dataitem(DtldCustLedgEntries; "Detailed Cust. Ledg. Entry")
                                {
                                    DataItemTableView = SORTING("Customer No.", "Posting Date", "Entry Type", "Currency Code");
                                    column(PostDate_DtldCustLedgEntries; FORMAT("Posting Date"))
                                    {
                                    }
                                    column(DocNo_DtldCustLedgEntries; "Document No.")
                                    {
                                    }
                                    column(Description; Description)
                                    {
                                    }
                                    column(DueDate_DtldCustLedgEntries; FORMAT(DueDate))
                                    {
                                    }
                                    column(CurrCode_DtldCustLedgEntries; "Currency Code")
                                    {
                                    }
                                    column(Amt_DtldCustLedgEntries; Amount)
                                    {
                                        AutoFormatExpression = "Currency Code";
                                        AutoFormatType = 1;
                                    }
                                    column(RemainAmt_DtldCustLedgEntries; RemainingAmount)
                                    {
                                        AutoFormatExpression = "Currency Code";
                                        AutoFormatType = 1;
                                    }
                                    column(CustBalance; CustBalance)
                                    {
                                        AutoFormatExpression = "Currency Code";
                                        AutoFormatType = 1;
                                    }
                                    column(Currency2Code; Currency2.Code)
                                    {
                                    }
                                    column(gDaysOver; gDaysOver)
                                    {
                                    }
                                    column(gPurchaseOrderNo; gPurchaseOrderNo)
                                    {
                                    }
                                    column(gDebit; gDebit)
                                    {
                                    }
                                    column(gCredit; gCredit)
                                    {
                                    }
                                    //>>1.3.7.2018
                                    column(DocumentDate_DtldCustLedgEntries; FORMAT(DocumentDate))
                                    {
                                    }
                                    //<<1.3.7.2018

                                    trigger OnAfterGetRecord(); //DtldCustLedgEntries
                                    var
                                        CustLedgerEntry: Record "Cust. Ledger Entry";
                                    begin
                                        if SkipReversedUnapplied(DtldCustLedgEntries) or (Amount = 0) then
                                            CurrReport.SKIP;
                                        RemainingAmount := 0;
                                        PrintLine := true;
                                        case "Entry Type" of
                                            "Entry Type"::"Initial Entry":
                                                begin
                                                    CustLedgerEntry.GET("Cust. Ledger Entry No.");
                                                    Description := CustLedgerEntry.Description;
                                                    DueDate := CustLedgerEntry."Due Date";
                                                    //>>1.3.7.2018
                                                    DocumentDate := CustLedgerEntry."Document Date";
                                                    //<<1.3.7.2018
                                                    CustLedgerEntry.SETRANGE("Date Filter", 0D, EndDate);
                                                    CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                                    RemainingAmount := CustLedgerEntry."Remaining Amount";
                                                end;
                                            "Entry Type"::Application:
                                                begin
                                                    DtldCustLedgEntries2.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type");
                                                    DtldCustLedgEntries2.SETRANGE("Customer No.", "Customer No.");
                                                    DtldCustLedgEntries2.SETRANGE("Posting Date", "Posting Date");
                                                    DtldCustLedgEntries2.SETRANGE("Entry Type", "Entry Type"::Application);
                                                    DtldCustLedgEntries2.SETRANGE("Transaction No.", "Transaction No.");
                                                    DtldCustLedgEntries2.SETFILTER("Currency Code", '<>%1', "Currency Code");
                                                    if not DtldCustLedgEntries2.ISEMPTY then begin
                                                        Description := Text005;
                                                        DueDate := 0D;
                                                        //>>1.3.7.2018
                                                        DocumentDate := 0D;
                                                        //<<1.3.7.2018
                                                    end else
                                                        PrintLine := false;
                                                end;
                                            "Entry Type"::"Payment Discount",
                                            "Entry Type"::"Payment Discount (VAT Excl.)",
                                            "Entry Type"::"Payment Discount (VAT Adjustment)",
                                            "Entry Type"::"Payment Discount Tolerance",
                                            "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                            "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                                begin
                                                    Description := Text006;
                                                    DueDate := 0D;
                                                    //>>1.3.7.2018
                                                    DocumentDate := 0D;
                                                    //<<1.3.7.2018
                                                end;
                                            "Entry Type"::"Payment Tolerance",
                                            "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                            "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                                begin
                                                    Description := Text014;
                                                    DueDate := 0D;
                                                    //>>1.3.7.2018
                                                    DocumentDate := 0D;
                                                    //<<1.3.7.2018
                                                end;
                                            "Entry Type"::"Appln. Rounding",
                                            "Entry Type"::"Correction of Remaining Amount":
                                                begin
                                                    Description := Text007;
                                                    DueDate := 0D;
                                                    //>>1.3.7.2018
                                                    DocumentDate := 0D;
                                                    //<<1.3.7.2018
                                                end;
                                        end;

                                        //>>
                                        gDaysOver := 0;
                                        gPurchaseOrderNo := '';
                                        gDebit := 0;
                                        gCredit := 0;

                                        if RemainingAmount = 0 then
                                            CurrReport.SKIP();

                                        if RemainingAmount > 0 then
                                            gDebit := RemainingAmount
                                        else
                                            gCredit := -RemainingAmount;

                                        if CustLedgerEntry."Document Type" IN
                                          [CustLedgerEntry."Document Type"::Invoice, CustLedgerEntry."Document Type"::"Credit Memo"]
                                        then
                                            //>>1.4.0.2018
                                            ////>>1.3.9.2018
                                            ////gDaysOver := EndDate - DueDate;
                                            //gDaysOver := EndDate - GetDate("Posting Date", DueDate, DocumentDate);
                                            ////<<1.3.9.2018
                                            gDaysOver := EndDate - DueDate;
                                        //<<1.4.0.2018
                                        if gDaysOver < 0 then
                                            gDaysOver := 0;

                                        gPurchaseOrderNo := CustLedgerEntry."External Document No.";
                                        //<<

                                        if PrintLine then begin
                                            //>>1.4.1.2018
                                            //CustBalance := CustBalance + Amount;
                                            CustBalance := CustBalance + RemainingAmount;
                                            //<<1.4.1.2018
                                            IsNewCustCurrencyGroup := IsFirstPrintLine;
                                            IsFirstPrintLine := false;
                                            ClearCompanyPicture;
                                        end;

                                        //>>1.3.5.2018
                                        if gHideClosedEntries then begin
                                            if RemainingAmount = 0 then
                                                CurrReport.Skip();
                                        end;
                                        //<<1.3.5.2018

                                    end;

                                    trigger OnPreDataItem(); //DtldCustLedgEntries
                                    begin
                                        SETRANGE("Customer No.", Customer2."No.");
                                        SETRANGE("Posting Date", StartDate, EndDate);
                                        SETRANGE("Currency Code", Currency2.Code);

                                        if Currency2.Code = '' then begin
                                            GLSetup.TESTFIELD("LCY Code");
                                            CurrencyCode3 := GLSetup."LCY Code"
                                        end else
                                            CurrencyCode3 := Currency2.Code;

                                        IsFirstPrintLine := true;
                                    end;
                                }
                            }
                            dataitem(CustLedgEntryFooter; "Integer")
                            {
                                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                                column(CurrencyCode3_CustLedgEntryFooter; CurrencyCode3)
                                {
                                }
                                column(Total_Caption; Total_CaptionLbl)
                                {
                                }
                                column(CustBalance_CustLedgEntryHdrFooter; CustBalance)
                                {
                                    AutoFormatExpression = Currency2.Code;
                                    AutoFormatType = 1;
                                }
                                column(EntriesExistsl_CustLedgEntryFooterCaption; EntriesExists)
                                {
                                }

                                trigger OnAfterGetRecord();
                                begin
                                    ClearCompanyPicture;
                                end;
                            }
                            dataitem(CustLedgEntry2; "Cust. Ledger Entry")
                            {
                                DataItemLink = "Customer No." = FIELD("No.");
                                DataItemLinkReference = Customer2;
                                DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date");
                                column(OverDueEntries; STRSUBSTNO(Text002, Currency2.Code))
                                {
                                }
                                column(RemainAmt_CustLedgEntry2; "Remaining Amount")
                                {
                                    AutoFormatExpression = "Currency Code";
                                    AutoFormatType = 1;
                                }
                                column(PostDate_CustLedgEntry2; FORMAT("Posting Date"))
                                {
                                }
                                column(DocNo_CustLedgEntry2; "Document No.")
                                {
                                }
                                column(Desc_CustLedgEntry2; Description)
                                {
                                }
                                column(DueDate_CustLedgEntry2; FORMAT("Due Date"))
                                {
                                }
                                column(OriginalAmt_CustLedgEntry2; "Original Amount")
                                {
                                    AutoFormatExpression = "Currency Code";
                                }
                                column(CurrCode_CustLedgEntry2; "Currency Code")
                                {
                                }
                                column(PrintEntriesDue; PrintEntriesDue)
                                {
                                }
                                column(Currency2Code_CustLedgEntry2; Currency2.Code)
                                {
                                }
                                column(CurrencyCode3_CustLedgEntry2; CurrencyCode3)
                                {
                                }
                                column(CustNo_CustLedgEntry2; "Customer No.")
                                {
                                }
                                //>>1.3.7.2018
                                column(DocumentDate_CustLedgEntry2; FORMAT("Document Date"))
                                {
                                }
                                //<<1.3.7.2018

                                trigger OnAfterGetRecord();
                                var
                                    CustLedgEntry: Record "Cust. Ledger Entry";
                                begin
                                    if IncludeAgingBand then begin
                                        if ("Posting Date" > EndDate) and ("Due Date" >= EndDate)
                                        //>>1.3.9.2018
                                        and ("Document Date" > EndDate)
                                        //<<1.3.9.2018
                                        then
                                            CurrReport.SKIP;
                                        if DateChoice = DateChoice::"Due Date" then
                                            if "Due Date" >= EndDate then
                                                CurrReport.SKIP;
                                        //>>1.3.9.2018
                                        if DateChoice = DateChoice::"Document Date" then
                                            if "Document Date" > EndDate then
                                                CurrReport.SKIP;
                                        //<<1.3.9.2018
                                    end;
                                    CustLedgEntry := CustLedgEntry2;
                                    CustLedgEntry.SETRANGE("Date Filter", 0D, EndDate);
                                    CustLedgEntry.CALCFIELDS("Remaining Amount");
                                    "Remaining Amount" := CustLedgEntry."Remaining Amount";
                                    if CustLedgEntry."Remaining Amount" = 0 then
                                        CurrReport.SKIP;

                                    if IncludeAgingBand and ("Posting Date" <= EndDate) then begin
                                        UpdateBuffer(Currency2.Code, GetDate("Posting Date", "Due Date", "Document Date"), "Remaining Amount");
                                        //>>1.3.7.2018
                                        TryUpdateCustomerAgingData(CustLedgEntry."Customer No.", Currency2.Code, "Posting Date", GetDate("Posting Date", "Due Date", "Document Date"), "Remaining Amount", ("On Hold" <> ''));
                                        //<<1.3.7.2018
                                    end;
                                    if "Due Date" >= EndDate then
                                        CurrReport.SKIP;

                                    ClearCompanyPicture;
                                    //>>
                                    TotalValueOverdue += "Remaining Amount";
                                    //<<
                                end;

                                trigger OnPreDataItem();
                                begin
                                    //>>
                                    TotalValueOverdue := 0;
                                    //<<
                                    CurrReport.CREATETOTALS("Remaining Amount");
                                    if not IncludeAgingBand then
                                        SETRANGE("Due Date", 0D, EndDate - 1);
                                    SETRANGE("Currency Code", Currency2.Code);
                                    if (not PrintEntriesDue) and (not IncludeAgingBand) then
                                        CurrReport.BREAK;
                                end;
                            }

                            trigger OnAfterGetRecord(); //CurrencyLoop
                            var
                                CustLedgerEntry: Record "Cust. Ledger Entry";
                            begin
                                if Number = 1 then
                                    Currency2.FINDFIRST;

                                repeat
                                begin
                                    if not IsFirstLoop then
                                        IsFirstLoop := true
                                    else
                                        if Currency2.NEXT = 0 then
                                            CurrReport.BREAK;
                                    CustLedgerEntry.SETRANGE("Customer No.", Customer2."No.");
                                    CustLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
                                    CustLedgerEntry.SETRANGE("Currency Code", Currency2.Code);
                                    EntriesExists := not CustLedgerEntry.ISEMPTY;
                                end;
                                until EntriesExists;

                                Cust2 := Customer2;
                                Cust2.SETRANGE("Date Filter", 0D, StartDate - 1);
                                Cust2.SETRANGE("Currency Filter", Currency2.Code);
                                Cust2.CALCFIELDS("Net Change");
                                StartBalance := Cust2."Net Change";
                                CustBalance := Cust2."Net Change";
                            end;

                            trigger OnPreDataItem(); //CurrencyLoop
                            begin
                                //>>1.3.6.2018
                                //Customer.COPYFILTER("Currency Filter",Currency2.Code);
                                Currency2.SETRANGE(Code, gCurrencyGroupTMP.code);
                                //<<1.3.6.2018
                            end;
                        }
                        dataitem(AgingBandLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(AgingDate1; FORMAT(AgingDate[1] + 1))
                            {
                            }
                            column(AgingDate2; FORMAT(AgingDate[2]))
                            {
                            }
                            column(AgingDate21; FORMAT(AgingDate[2] + 1))
                            {
                            }
                            column(AgingDate3; FORMAT(AgingDate[3]))
                            {
                            }
                            column(AgingDate31; FORMAT(AgingDate[3] + 1))
                            {
                            }
                            column(AgingDate4; FORMAT(AgingDate[4]))
                            {
                            }
                            column(AgingBandEndingDate; STRSUBSTNO(Text011, AgingBandEndingDate, PeriodLength, SELECTSTR(DateChoice + 1, Text013)))
                            {
                            }
                            column(AgingDate41; FORMAT(AgingDate[4] + 1))
                            {
                            }
                            column(AgingDate5; FORMAT(AgingDate[5]))
                            {
                            }
                            column(AgingBandBufCol1Amt; AgingBandBuf."Column 1 Amt.")
                            {
                                AutoFormatExpression = AgingBandBuf."Currency Code";
                                AutoFormatType = 1;
                            }
                            column(AgingBandBufCol2Amt; AgingBandBuf."Column 2 Amt.")
                            {
                                AutoFormatExpression = AgingBandBuf."Currency Code";
                                AutoFormatType = 1;
                            }
                            column(AgingBandBufCol3Amt; AgingBandBuf."Column 3 Amt.")
                            {
                                AutoFormatExpression = AgingBandBuf."Currency Code";
                                AutoFormatType = 1;
                            }
                            column(AgingBandBufCol4Amt; AgingBandBuf."Column 4 Amt.")
                            {
                                AutoFormatExpression = AgingBandBuf."Currency Code";
                                AutoFormatType = 1;
                            }
                            column(AgingBandBufCol5Amt; AgingBandBuf."Column 5 Amt.")
                            {
                                AutoFormatExpression = AgingBandBuf."Currency Code";
                                AutoFormatType = 1;
                            }
                            column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                            {
                            }
                            column(beforeCaption; beforeCaptionLbl)
                            {
                            }
                            //>>
                            column(TotalValueOverdue; TotalValueOverdue)
                            {
                            }
                            column(TotalAmountDue; CustBalance)
                            {

                            }
                            //<<

                            trigger OnAfterGetRecord(); //AgingBandLoop
                            begin
                                if Number = 1 then begin
                                    ClearCompanyPicture;
                                    if not AgingBandBuf.FIND('-') then
                                        CurrReport.BREAK;
                                end else
                                    if AgingBandBuf.NEXT = 0 then
                                        CurrReport.BREAK;
                                AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                                if AgingBandCurrencyCode = '' then
                                    AgingBandCurrencyCode := GLSetup."LCY Code";
                            end;

                            trigger OnPreDataItem(); //AgingBandLoop
                            begin
                                if not IncludeAgingBand then
                                    CurrReport.BREAK;
                                //>>1.3.7.2018
                                // This is to show total if no aging is found
                                if AgingBandBuf.Count() = 0 then begin
                                    AgingBandBuf.init();
                                    AgingBandBuf.insert();
                                end;
                                //TODO Deal with the total amount Due for Customer Aging Detials calculations

                                //<<1.3.7.2018
                            end;
                        }
                    }

                    trigger OnAfterGetRecord(); // Customer2 DataItem
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                        LanguageRec: Record Language;
                    begin
                        //>>
                        if not PaymentTerms.GET("Payment Terms Code") then
                            PaymentTerms.INIT();
                        //<<

                        AgingBandBuf.DELETEALL;

                        // Modern BC language handling - replace deprecated GetLanguageCode
                        if LanguageRec.Get("Language Code") then
                            CurrReport.Language := LanguageRec."Windows Language ID"
                        else
                            CurrReport.Language := GlobalLanguage();

                        PrintLine := false;
                        Cust2 := Customer2;
                        //>>1.3.6.2018
                        //COPYFILTER("Currency Filter",Currency2.Code);
                        Currency2.SETRANGE(Code, gCurrencyGroupTMP.code);
                        //<<1.3.6.2018
                        if PrintAllHavingBal then begin
                            if Currency2.FIND('-') then
                                repeat
                                begin
                                    Cust2.SETRANGE("Date Filter", 0D, EndDate);
                                    Cust2.SETRANGE("Currency Filter", Currency2.Code);
                                    Cust2.CALCFIELDS("Net Change");
                                    PrintLine := Cust2."Net Change" <> 0;
                                end;
                                until (Currency2.NEXT = 0) or PrintLine;
                        end;
                        if (not PrintLine) and PrintAllHavingEntry then begin
                            CustLedgerEntry.SETRANGE("Customer No.", "No.");
                            CustLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
                            //>>1.3.6.2018
                            //COPYFILTER("Currency Filter",CustLedgerEntry."Currency Code");
                            CustLedgerEntry.SETRANGE("Currency Code", gCurrencyGroupTMP.code);
                            //<<1.3.6.2018
                            PrintLine := not CustLedgerEntry.ISEMPTY;
                        end;
                        if not PrintLine then
                            CurrReport.SKIP;

                        FormatAddr.Customer(CustAddr, Customer2);
                        CurrReport.PAGENO := 1;

                        if not IsReportInPreviewMode then begin
                            LOCKTABLE;
                            FIND;
                            "Last Statement No." := "Last Statement No." + 1;
                            MODIFY;
                            COMMIT;
                        end else
                            "Last Statement No." := "Last Statement No." + 1;

                        if LogInteraction then begin
                            if not IsReportInPreviewMode then begin
                                SegManagement.LogDocument(
7, FORMAT("Last Statement No."), 0, 0, DATABASE::Customer, "No.", "Salesperson Code", '',
                              Text003 + FORMAT("Last Statement No."), '');
                            end;
                        end;
                        IsFirstLoop := false;

                        //>>1.3.7.2018
                        TryClearAndInsertNewCustAgingDetailsRecord("No.");
                        //<<1.3.7.2018
                    end;

                    trigger OnPreDataItem();  // Customer2 DataItem
                    var
                        BankAddress: text;
                    begin

                        // This is needed as req page rememebr wrong filter
                        //Customer2.RESET();
                        //Customer2.CopyFilters(Customer);

                        VerifyDates;
                        AgingBandEndingDate := EndDate;
                        CalcAgingBandDates;

                        //>>1.3.6.2018

                        CreateHeadings();

                        //Currency2.Code := '';
                        //Currency2.INSERT;
                        Currency2.DELETEALL();

                        IF (gCurrencyGroupTMP.Code = '') THEN BEGIN
                            Currency2.Code := '';
                            Currency2.INSERT;
                        END;

                        //COPYFILTER("Currency Filter",Currency.Code);
                        Currency.SETRANGE(Code, gCurrencyGroupTMP.Code);
                        //<<1.3.6.2018
                        if Currency.FIND('-') then begin
                            repeat
                            begin
                                Currency2 := Currency;
                                Currency2.INSERT;
                            end;
                            until Currency.NEXT = 0;
                        end;

                        //>>1.3.4.2018
                        GetCurrencyBankDetails(gBankAccountTMP, gCurrencyGroupTMP.Code);

                        if gBankAccountTMP."Address" <> '' then
                            BankAddress := BankAddress + ', ' + gBankAccountTMP."Address";
                        if gBankAccountTMP."Address 2" <> '' then
                            BankAddress := BankAddress + ', ' + gBankAccountTMP."Address 2";
                        if gBankAccountTMP."City" <> '' then
                            BankAddress := BankAddress + ', ' + gBankAccountTMP."City";
                        if gBankAccountTMP."County" <> '' then
                            BankAddress := BankAddress + ', ' + gBankAccountTMP."County";
                        if gBankAccountTMP."Post Code" <> '' then
                            BankAddress := BankAddress + ', ' + gBankAccountTMP."Post Code";
                        if gBankAccountTMP."Country/Region Code" <> '' then
                            BankAddress := BankAddress + ', ' + gBankAccountTMP."Country/Region Code";

                        gBankFooter1 := gBankAccountTMP."Name" + BankAddress;
                        gBankFooter2 := STRSUBSTNO(Footer1Text, gBankAccountTMP."Bank Account No.", gBankAccountTMP.IBAN);
                        gBankFooter3 := STRSUBSTNO(Footer2Text, gBankAccountTMP."SWIFT Code", gBankAccountTMP."Bank Branch No.");
                        //<<1.3.4.2018
                    end;
                }
                trigger OnPreDataItem(); //CurrencyGroup
                var
                    lCustLedgEntry: Record "Cust. Ledger Entry";
                    lCurrency: Record Currency;
                begin
                    //>>1.3.6.2018
                    gCurrencyTMP.DeleteAll();
                    gCurrencyGroupTMP.DeleteAll();

                    //>>3.0.1.2018
                    // Find all curencies for open transactions
                    // lCustLedgEntry.SetCurrentKey("Customer No.", "Open", "Positive", "Due Date", "Currency Code");
                    // lCustLedgEntry.SetRange("Customer No.", Customer."No.");
                    // lCustLedgEntry.SetRange(Open, true);
                    // lCustLedgEntry.setrange("Posting Date", StartDate, EndDate);
                    // if lCustLedgEntry.FindSet() then begin
                    //     repeat
                    //         if not gCurrencyTMP.GET(lCustLedgEntry."Currency Code") then begin
                    //             gCurrencyTMP.Code := lCustLedgEntry."Currency Code";
                    //             gCurrencyTMP.INSERT;
                    //         end;
                    //     until lCustLedgEntry.Next() = 0;
                    // end;

                    //>>3.0.7.2018
                    // Deal wtih LCY
                    lCustLedgEntry.RESET();
                    lCustLedgEntry.SetCurrentKey("Customer No.", "Open", "Positive", "Due Date", "Currency Code");
                    lCustLedgEntry.SetRange("Customer No.", Customer."No.");
                    lCustLedgEntry.setrange("Posting Date", StartDate, EndDate);
                    lCustLedgEntry.setrange("Currency Code", '');
                    if lCustLedgEntry.FindFirst() then begin
                        if not gCurrencyTMP.GET(lCustLedgEntry."Currency Code") then begin
                            gCurrencyTMP.Code := lCustLedgEntry."Currency Code";
                            gCurrencyTMP.INSERT;
                        end;
                    end;
                    //<<3.0.7.2018

                    // Deal with other currencies
                    lCurrency.RESET();
                    IF lCurrency.FINDSET(FALSE) THEN BEGIN
                        REPEAT
                        BEGIN
                            lCustLedgEntry.RESET();
                            lCustLedgEntry.SetCurrentKey("Customer No.", "Open", "Positive", "Due Date", "Currency Code");
                            lCustLedgEntry.SetRange("Customer No.", Customer."No.");
                            lCustLedgEntry.setrange("Posting Date", StartDate, EndDate);
                            lCustLedgEntry.setrange("Currency Code", lCurrency.Code);
                            if lCustLedgEntry.FindFirst() then begin
                                if not gCurrencyTMP.GET(lCustLedgEntry."Currency Code") then begin
                                    gCurrencyTMP.Code := lCustLedgEntry."Currency Code";
                                    gCurrencyTMP.INSERT;
                                end;
                            end;
                        END;
                        UNTIL lCurrency.NEXT() = 0;
                    END;
                    //<<3.0.1.2018

                    gCurrencyTMP.RESET();
                    //
                    //COPYFILTER("Currency Filter",Currency.Code);
                    //IF gCurrencyCode <> '' THEN
                    //  gCurrencyTMP.SETRANGE(Code, gCurrencyCode);
                    //
                    IF gCurrencyTMP.FIND('-') THEN
                        REPEAT
                        BEGIN
                            gCurrencyGroupTMP := gCurrencyTMP;
                            gCurrencyGroupTMP.INSERT;
                        END;
                        UNTIL gCurrencyTMP.NEXT = 0;

                    gCurrencyGroupTMP.RESET();
                    IF gCurrencyCode <> '' THEN
                        gCurrencyGroupTMP.SETRANGE(Code, gCurrencyCode);
                    //<<1.3.6.2018
                end;

                trigger OnAfterGetRecord(); //CurrencyGroup
                var
                    lCustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    //>>1.3.6.2018
                    IF Number = 1 THEN begin
                        IF NOT gCurrencyGroupTMP.FINDFIRST() THEN
                            CurrReport.BREAK();
                    end ELSE BEGIN
                        IF gCurrencyGroupTMP.NEXT() = 0 THEN
                            CurrReport.BREAK();
                    END;
                    //<<1.3.6.2018
                end;
            }   //CurrencyGroup

            //>>1.4.8.2018
            trigger OnPreDataItem();
            begin
                // Clear
                if UpdateAgingData then begin
                    gAgingDetails.SetRange(ACO_Type, gAgingDetails.Aco_Type::Customer);
                    gAgingDetails.LockTable();
                    gAgingDetails.DeleteAll(true);
                end;
            end;
            //<<1.4.8.2018

            trigger OnAfterGetRecord(); //CustomerFilters
            begin
                //Message("No.");
            end;
        }   //CustomerFilters
    }

    requestpage
    {
        //SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    //>>1.3.6.2018
                    field(gCurrencyCode; gCurrencyCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code';
                        ToolTip = 'Filter entries by Currency Code';
                    }
                    //<<1.3.6.2018
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = Basic, Suite;
                        Visible = false;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Specifies if you want overdue entries to be shown separately for each currency.';
                    }
                    group(Include)
                    {
                        Caption = 'Include';
                        field(IncludeAllCustomerswithLE; PrintAllHavingEntry)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Customers with Ledger Entries';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have ledger entries at the end of the selected period.';

                            trigger OnValidate();
                            begin
                                if not PrintAllHavingEntry then
                                    PrintAllHavingBal := true;
                            end;
                        }
                        field(IncludeAllCustomerswithBalance; PrintAllHavingBal)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Customers with a Balance';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have a balance at the end of the selected period.';

                            trigger OnValidate();
                            begin
                                if not PrintAllHavingBal then
                                    PrintAllHavingEntry := true;
                            end;
                        }
                        field(IncludeReversedEntries; PrintReversedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Reversed Entries';
                            ToolTip = 'Specifies if you want to include reversed entries in the report.';
                        }
                        field(IncludeUnappliedEntries; PrintUnappliedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Unapplied Entries';
                            ToolTip = 'Specifies if you want to include unapplied entries in the report.';
                        }
                        //>>1.3.5.2018
                        field(gHideClosedEntries; gHideClosedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Do not show Closed Entries';
                            ToolTip = 'Specifies if you want to hide closed entries.';
                        }
                        //<<1.3.5.2018
                    }
                    group("Aging Band")
                    {
                        Caption = 'Ageing Band';
                        field(IncludeAgingBand; IncludeAgingBand)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Ageing Band';
                            ToolTip = 'Specifies if you want an ageing band to be included in the document. If you place a check mark here, you must also fill in the Ageing Band Period Length and Ageing Band by fields.';
                        }
                        field(AgingBandPeriodLengt; PeriodLength)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ageing Band Period Length';
                            ToolTip = 'Specifies the length of each of the four periods in the ageing band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.';
                        }
                        //>>1.3.6.2018
                        field(HeadingType; HeadingType)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Heading Type';
                            ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                            OptionCaption = 'Date Interval,Number of Days';
                        }
                        //<<1.3.6.2018
                        field(AgingBandby; DateChoice)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band by';
                            //>>1.3.7.2018
                            //OptionCaption = 'Due Date,Posting Date';
                            OptionCaption = 'Due Date,Posting Date,Document Date';
                            //<<1.3.7.2018
                            ToolTip = 'Specifies if the ageing band will be calculated from the due date or from the posting date or form document date';
                        }
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                    //>>1.3.7.2018
                    field(UpdateAgingData; UpdateAgingData)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Update Aging Data';
                        //TODO uncomment it
                        Visible = false;
                        ToolTip = 'If field is ticked, the system is updating Customer Aging Details so user can review it on page instead of the report';
                    }
                    //<<1.3.7.2018
                }
                group("Output Options")
                {
                    Caption = 'Output Options';
                    field(ReportOutput; SupportedOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Output';
                        OptionCaption = 'Print,Preview,PDF,Email,Excel,XML';
                        ToolTip = 'Specifies the output of the scheduled report, such as PDF or Word.';

                        trigger OnValidate();
                        var
                            CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                        begin
                            ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);

                            case SupportedOutputMethod of
                                SupportedOutputMethod::Print:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
                                SupportedOutputMethod::Preview:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
                                SupportedOutputMethod::PDF:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
                                SupportedOutputMethod::Email:
                                    ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
                                SupportedOutputMethod::Excel:
                                    ChosenOutputMethod := CustomLayoutReporting.GetExcelOption;
                                SupportedOutputMethod::XML:
                                    ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
                            end;
                        end;
                    }
                    field(ChosenOutput; ChosenOutputMethod)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Chosen Output';
                        ToolTip = 'Specifies how to output the report, such as Print or Excel.';
                        Visible = false;
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses; PrintRemaining)
                        {
                            ApplicationArea = Advanced;
                            Caption = 'Print remaining statements';
                            ToolTip = 'Specifies if you want to print remaining statements.';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            InitRequestPageDataInternal;
        end;

        trigger OnInit();
        begin
            //>>1.3.4.2018
            IncludeAgingBand := true;
            PrintEntriesDue := true;
            //<<1.3.4.2018
            //>>1.3.5.2018
            gHideClosedEntries := true;
            //<<1.3.5.2018
            //>>1.3.6.2018
            HeadingType := HeadingType::"Number of Days";
            //<<1.3.6.2018
            //>>1.3.7.2018
            //PeriodLength := '30D';
            //<<1.3.7.2018
        end;
    }

    labels
    {
        RepTitleLbl = 'STATEMENT'; TelLb = 'Tel:'; AccsTelLbl = 'Accs Tel:'; EmailLbl = 'Email:'; ToLbl = 'To'; AgreedTandCLbl = 'Agreed Terms:'; RunAsAtDateLbl = 'Run as at Date:'; PrintDateLbl = 'Print Date:'; AllValusAreShownInLbl = 'All values are shown in'; InvDateLbl = 'Invoice Date'; InvRefLbl = 'Invoice Ref'; DateDueLbl = 'Date Due'; DaysOverLbl = 'Days Over'; PurchOrderLbl = 'Purchase Order'; DebitLbl = 'Debit'; CreditLbl = 'Credit'; BalanceLbl = 'Balance'; CurrentLbl = 'Current'; A_DaysLbl = '30 - 59 days'; B_DaysLbl = '60 - 89 days'; C_DaysLbl = '90 - 119 days'; D_DaysLbl = '120+ days'; InvValueOverdueLbl = 'Invoice Value Overdue'; TotalAmtDueLbl = 'Total Amount Due'; PleaseRemitToLbl = 'Please remit to:'; AccNoLbl = 'Account No:'; IBANLbl = 'IBAN:'; SwiftLbl = 'Swift:'; BankSortLbl = 'Bank Sort:'; DateLbl = 'Date';
    }

    trigger OnInitReport();
    begin
        GLSetup.GET;
        SalesSetup.GET;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                end;
        end;

        //>>1.3.4.2018
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);

        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyAddr[7] := STRSUBSTNO(TelText, CompanyInfo."Phone No.");
        CompanyAddr[8] := STRSUBSTNO(EmailText, CompanyInfo."E-Mail");
        COMPRESSARRAY(CompanyAddr);
        //<<1.3.4.2018
        LogInteractionEnable := true;
    end;

    trigger OnPreReport();
    begin
        InitRequestPageDataInternal;
    end;

    var
        Text001: Label 'Entries %1';
        Text002: Label 'Overdue Entries %1';
        Text003: Label 'Statement ';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Cust2: Record Customer;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        gLanguage: Record Language;
        DtldCustLedgEntries2: Record "Detailed Cust. Ledg. Entry";
        AgingBandBuf: Record "Aging Band Buffer" temporary;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        DueDate: Date;
        CustAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        Description: Text[50];
        StartBalance: Decimal;
        CustBalance: Decimal;
        RemainingAmount: Decimal;
        CurrencyCode3: Code[10];
        Text005: Label 'Multicurrency Application';
        Text006: Label 'Payment Discount';
        Text007: Label 'Rounding';
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date","Document Date";
        AgingDate: array[5] of Date;
        Text008: Label 'You must specify the Ageing Band Period Length.';
        AgingBandEndingDate: Date;
        Text010: Label 'You must specify Ageing Band Ending Date.';
        Text011: Label 'Aged Summary by %1 (%2 by %3)';
        IncludeAgingBand: Boolean;
        Text012: Label 'Period Length is out of range.';
        AgingBandCurrencyCode: Code[20];
        Text013: Label 'Due Date,Posting Date,Document Date';
        Text014: Label 'Application Writeoffs';
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text036: Label '-%1';
        StatementCaptionLbl: Label 'Statement';
        PhoneNo_CompanyInfoCaptionLbl: Label 'Phone No.';
        VATRegNo_CompanyInfoCaptionLbl: Label 'VAT Registration No.';
        GiroNo_CompanyInfoCaptionLbl: Label 'Giro No.';
        BankName_CompanyInfoCaptionLbl: Label 'Bank';
        BankAccNo_CompanyInfoCaptionLbl: Label 'Account No.';
        No1_CustCaptionLbl: Label 'Customer No.';
        StartDateCaptionLbl: Label 'Starting Date';
        EndDateCaptionLbl: Label 'Ending Date';
        LastStatmntNo_CustCaptionLbl: Label 'Statement No.';
        PostDate_DtldCustLedgEntriesCaptionLbl: Label 'Posting Date';
        DueDate_CustLedgEntry2CaptionLbl: Label 'Due Date';
        CustBalanceCaptionLbl: Label 'Balance';
        beforeCaptionLbl: Label '..before';
        isInitialized: Boolean;
        CompanyInfoHomepageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'Email';
        DocDateCaptionLbl: Label 'Document Date';
        Total_CaptionLbl: Label 'Total';
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        IsFirstLoop: Boolean;
        CurrReportPageNoCaptionLbl: Label 'Page';
        IsFirstPrintLine: Boolean;
        IsNewCustCurrencyGroup: Boolean;
        SupportedOutputMethod: Option Print,Preview,PDF,Email,Excel,XML;
        ChosenOutputMethod: Integer;
        PrintRemaining: Boolean;
        [InDataSet]
        ShowPrintRemaining: Boolean;
        FirstCustomerPrinted: Boolean;
        TelText: Label 'Tel: %1';
        EmailText: Label 'Email: %1';
        PaymentTerms: Record "Payment Terms";
        gDaysOver: Integer;
        gPurchaseOrderNo: Text;
        gDebit: Decimal;
        gCredit: Decimal;
        gBankFooter1: Text;
        gBankFooter2: Text;
        gBankFooter3: Text;
        Footer1Text: Label 'Account No: %1, IBAN: %2';
        Footer2Text: Label 'Swift: %1, Bank Sort: %2';
        gBankAccountTMP: Record "Bank Account" temporary;
        gHideClosedEntries: Boolean;
        gCurrencyCode: Code[10];
        gCurrencyTMP: Record Currency temporary;
        gCurrencyGroupTMP: Record Currency temporary;
        HeadingType: Option "Date Interval","Number of Days";
        HeaderText: array[5] of Text;
        TotalValueOverdue: Decimal;
        TotalAmountDue: Decimal;
        //>>1.3.7.2018
        DocumentDate: Date;
        UpdateAgingData: Boolean;
        gAgingDetails: Record ACO_AgingDetails;
        GenLedgerSetup: Record "General Ledger Setup";
        gCustomerTMP: Record Customer temporary;
    //<<1.3.7.2018

    //>>1.4.6.2018
    local procedure GetLastPaidDate(pCustomerNo: Code[20]): Date;
    var
        lCustomerLedgerEntry: Record "Cust. Ledger Entry";
    begin
        lCustomerLedgerEntry.SETCURRENTKEY("Document Type", "Customer No.", "Posting Date", "Currency Code");
        lCustomerLedgerEntry.SETRANGE("Customer No.", pCustomerNo);
        lCustomerLedgerEntry.SETRANGE("Document Type", lCustomerLedgerEntry."Document Type"::Payment);
        if lCustomerLedgerEntry.FINDLAST() then
            exit(lCustomerLedgerEntry."Posting Date");
    end;
    //<<1.4.6.2018

    //>>1.3.7.2018
    local procedure TryUpdateCustomerAgingData(CustNo: Code[20]; CurrCode: code[20]; pPostingDate: Date; pAgingDate: Date; pAmount: Decimal; pOnHold: Boolean);
    var
        I: Integer;
        GoOn: Boolean;
        CurrExchRate: record "Currency Exchange Rate";
        lAmountLCY: Decimal;
        lAmountTCY: Decimal;
    begin
        if NOT (UpdateAgingData) then
            exit;

        // At that stage record mus exist!
        gAgingDetails.Get(gAgingDetails.Aco_Type::Customer, CustNo);

        //>>1.4.6.2018
        if pOnHold then
            gAgingDetails.ACO_NoOfDisputedInv += 1;
        //<<1.4.6.2018

        // Update Amount as per required currency
        if (CurrCode = '') or (CurrCode = 'GBP') then begin
            lAmountLCY := pAmount;
            if (gAgingDetails.ACO_CurrencyCodeTCY = '') or (gAgingDetails.ACO_CurrencyCodeTCY = 'GBP') then
                lAmountTCY := lAmountLCY
            else
                lAmountTCY := ROUND(CurrExchRate.ExchangeAmtLCYToFCY(
                                                pPostingDate, gAgingDetails.ACO_CurrencyCodeTCY,
                                                pAmount,
                                                CurrExchRate.ExchangeRate(pPostingDate, gAgingDetails.ACO_CurrencyCodeTCY)),
                                            GenLedgerSetup."Amount Rounding Precision");
        end else begin
            lAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(pPostingDate, CurrCode, pAmount, CurrExchRate.ExchangeRate(pPostingDate, CurrCode)),
                                            GenLedgerSetup."Amount Rounding Precision");
            if (gAgingDetails.ACO_CurrencyCodeTCY = '') or (gAgingDetails.ACO_CurrencyCodeTCY = 'GBP') then
                lAmountTCY := lAmountLCY
            else
                lAmountTCY := ROUND(CurrExchRate.ExchangeAmtFCYToFCY(
                                                pPostingDate, CurrCode, gAgingDetails.ACO_CurrencyCodeTCY,
                                                pAmount),
                                            GenLedgerSetup."Amount Rounding Precision");
        end;

        // Update cal fields
        I := 1;
        GoOn := true;
        while (I <= 5) and GoOn do begin
            if pAgingDate <= AgingDate[I] then
                if I = 1 then begin
                    gAgingDetails.ACO_AgedValuePeriod5LCY := gAgingDetails.ACO_AgedValuePeriod5LCY + lAmountLCY;
                    gAgingDetails.ACO_AgedValuePeriod5TCY := gAgingDetails.ACO_AgedValuePeriod5TCY + lAmountTCY;
                    GoOn := false;
                end;
            if pAgingDate <= AgingDate[I] then
                if I = 2 then begin
                    gAgingDetails.ACO_AgedValuePeriod4LCY := gAgingDetails.ACO_AgedValuePeriod4LCY + lAmountLCY;
                    gAgingDetails.ACO_AgedValuePeriod4TCY := gAgingDetails.ACO_AgedValuePeriod4TCY + lAmountTCY;
                    GoOn := false;
                end;
            if pAgingDate <= AgingDate[I] then
                if I = 3 then begin

                    gAgingDetails.ACO_AgedValuePeriod3LCY := gAgingDetails.ACO_AgedValuePeriod3LCY + lAmountLCY;
                    gAgingDetails.ACO_AgedValuePeriod3TCY := gAgingDetails.ACO_AgedValuePeriod3TCY + lAmountTCY;
                    GoOn := false;
                end;
            if pAgingDate <= AgingDate[I] then
                if I = 4 then begin

                    gAgingDetails.ACO_AgedValuePeriod2LCY := gAgingDetails.ACO_AgedValuePeriod2LCY + lAmountLCY;
                    gAgingDetails.ACO_AgedValuePeriod2TCY := gAgingDetails.ACO_AgedValuePeriod2TCY + lAmountTCY;
                    GoOn := false;
                end;
            if pAgingDate <= AgingDate[I] then
                if I = 5 then begin

                    gAgingDetails.ACO_AgedValuePeriod1LCY := gAgingDetails.ACO_AgedValuePeriod1LCY + lAmountLCY;
                    gAgingDetails.ACO_AgedValuePeriod1TCY := gAgingDetails.ACO_AgedValuePeriod1TCY + lAmountTCY;
                    GoOn := false;
                end;
            I := I + 1;
        end;

        With gAgingDetails do begin
            ACO_TotalInvValueOverdueLCY := ACO_AgedValuePeriod2LCY + ACO_AgedValuePeriod3LCY + ACO_AgedValuePeriod4LCY + ACO_AgedValuePeriod5LCY;
            ACO_TotalInvValueOverdueTCY := ACO_AgedValuePeriod2TCY + ACO_AgedValuePeriod3TCY + ACO_AgedValuePeriod4TCY + ACO_AgedValuePeriod5TCY;

            ACO_TotalAmountDueLCY := ACO_AgedValuePeriod1LCY + ACO_TotalInvValueOverdueLCY;
            ACO_TotalAmountDueTCY := ACO_AgedValuePeriod1TCY + ACO_TotalInvValueOverdueTCY;
        end;

        gAgingDetails.MODIFY;
    end;

    local procedure TryClearAndInsertNewCustAgingDetailsRecord(CustNo: Code[20]);
    var
        lCustomer: Record Customer;
    begin
        if NOT (UpdateAgingData) then
            exit;

        lCustomer.get(CustNo);

        // Clear only if not already exist
        IF gCustomerTMP.get(lCustomer."No.") then
            exit;

        lCustomer.CalcFields(Balance, "Balance (LCY)");

        gCustomerTMP.Init();
        gCustomerTMP.TransferFields(lCustomer);
        gCustomerTMP.Insert();


        // Clear
        gAgingDetails.SetRange(ACO_Type, gAgingDetails.Aco_Type::Customer);
        gAgingDetails.SetRange(ACO_No, CustNo);
        // Ensure noone is using the table
        gAgingDetails.LockTable();
        if gAgingDetails.FindSet(TRUE, TRUE) then
            gAgingDetails.Delete(true);

        // Insert new
        gAgingDetails.init();
        gAgingDetails.ACO_Type := gAgingDetails.Aco_Type::Customer;
        gAgingDetails.ACO_No := lCustomer."No.";
        //>>1.4.6.2018
        gAgingDetails.ACO_Name := lCustomer.Name;
        gAgingDetails.ACO_LastPaidDate := GetLastPaidDate(lCustomer."No.");
        gAgingDetails.ACO_CreditLimitLCY := lCustomer."Credit Limit (LCY)";
        gAgingDetails.ACO_CreditLimitTCY := lCustomer.ACO_CreditLimitTCY;
        //<<1.4.6.2018
        gAgingDetails.ACO_RunAtDate := EndDate;
        gAgingDetails.ACO_CurrencyCodeTCY := lCustomer."Currency Code";
        gAgingDetails.ACO_CurrentBalanceLCY := lCustomer."Balance (LCY)";
        gAgingDetails.ACO_CurrentBalanceTCY := lCustomer.Balance;
        gAgingDetails.INSERT();
    end;
    //<<1.3.7.2018

    //>>1.3.4.2018
    local procedure GetCurrencyBankDetails(var rBankAccount: Record "Bank Account" temporary; pCurrencyCode: code[10]);
    var
        lCompanyInfo: Record "Company Information";
        lBankAccount: Record "Bank Account";
    begin
        lBankAccount.setrange(ACO_Default, true);
        lBankAccount.setrange("currency code", pCurrencyCode);
        if lBankAccount.findfirst() then begin
            rBankAccount.TransferFields(lBankAccount);
            exit;
        end else begin
            lCompanyInfo.get();
            rBankAccount.init();
            rBankAccount.Name := lCompanyInfo."Bank Name";
            //rBankAccount.Address := CompanyInfo."Bank Address";
            //rBankAccount.Address := CompanyInfo."Bank Address";
            //rBankAccount."Address 2" := CompanyInfo."Bank Address 2";
            //rBankAccount.City := CompanyInfo."Bank City";
            //rBankAccount."Post Code" := CompanyInfo."Bank Post Code";
            //rBankAccount."County" := CompanyInfo."Bank County";
            //rBankAccount."Country" := CompanyInfo."Bank Country";
            rBankAccount.IBAN := lCompanyInfo.IBAN;
            rBankAccount."SWIFT Code" := lCompanyInfo."SWIFT Code";
            rBankAccount."Bank Branch No." := lCompanyInfo."Bank Branch No.";
            // other bank fields here        
            // other bank fields here        
        end;
    end;
    //<<1.3.4.2018

    local procedure GetDate(PostingDate: Date; DueDate: Date; DocumentDate: Date): Date;
    begin
        if DateChoice = DateChoice::"Posting Date" then
            exit(PostingDate);
        //>>1.3.7.2018
        if DateChoice = DateChoice::"Document Date" then
            exit(DocumentDate);
        //<<1.3.7.2018

        exit(DueDate);
    end;

    local procedure CalcAgingBandDates();
    begin
        if not IncludeAgingBand then
            exit;
        if AgingBandEndingDate = 0D then
            ERROR(Text010);
        if FORMAT(PeriodLength) = '' then
            ERROR(Text008);
        EVALUATE(PeriodLength2, STRSUBSTNO(Text036, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CALCDATE(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CALCDATE(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CALCDATE(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CALCDATE(PeriodLength2, AgingDate[2]);
        if AgingDate[2] <= AgingDate[1] then
            ERROR(Text012);
    end;

    //>>1.3.6.2018
    LOCAL procedure CreateHeadings();
    var
        i: Integer;
        beforeLbl: Label 'Before';
        moreThanLbl: Label 'More than';
        daysLbl: Label 'days';
    begin
        IF HeadingType = HeadingType::"Date Interval" THEN begin
            HeaderText[1] := STRSUBSTNO('%1\..%2', AgingDate[4] + 1, AgingDate[5]);
            HeaderText[2] := STRSUBSTNO('%1\..%2', AgingDate[3] + 1, AgingDate[4]);
            HeaderText[3] := STRSUBSTNO('%1\..%2', AgingDate[2] + 1, AgingDate[3]);
            HeaderText[4] := STRSUBSTNO('%1\..%2', AgingDate[1] + 1, AgingDate[2]);
            HeaderText[5] := STRSUBSTNO('%1\%2', beforeLbl, AgingDate[1] + 1);
        end else begin
            // HeaderText[1] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[4] + 1, EndDate - AgingDate[5] + 1, daysLbl);
            // HeaderText[2] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[3] + 1, EndDate - AgingDate[4] + 1, daysLbl);
            // HeaderText[3] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[2] + 1, EndDate - AgingDate[3] + 1, daysLbl);
            // HeaderText[4] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[1] + 1, EndDate - AgingDate[2] + 1, daysLbl);
            //HeaderText[1] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[5] + 1, EndDate - AgingDate[4], daysLbl);
            HeaderText[1] := 'Current';
            HeaderText[2] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[4] + 1, EndDate - AgingDate[3], daysLbl);
            HeaderText[3] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[3] + 1, EndDate - AgingDate[2], daysLbl);
            HeaderText[4] := STRSUBSTNO('%1 - %2 %3', EndDate - AgingDate[2] + 1, EndDate - AgingDate[1], daysLbl);
            HeaderText[5] := STRSUBSTNO('%1\%2 %3', moreThanLbl, EndDate - AgingDate[1], daysLbl);
        end;
    end;
    //<<1.3.6.2018

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal);
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code" := CurrencyCode;
        if not AgingBandBuf.FIND then
            AgingBandBuf.INSERT;
        I := 1;
        GoOn := true;
        while (I <= 5) and GoOn do begin
            if Date <= AgingDate[I] then
                if I = 1 then begin
                    AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 2 then begin
                    AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 3 then begin
                    AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 4 then begin
                    AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
                    GoOn := false;
                end;
            if Date <= AgingDate[I] then
                if I = 5 then begin
                    AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
                    GoOn := false;
                end;
            I := I + 1;
        end;
        AgingBandBuf.MODIFY;
    end;

    procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record "Detailed Cust. Ledg. Entry"): Boolean;
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if PrintReversedEntries and PrintUnappliedEntries then
            exit(false);
        if not PrintUnappliedEntries then
            if DtldCustLedgEntries.Unapplied then
                exit(true);
        if not PrintReversedEntries then begin
            CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.");
            if CustLedgEntry.Reversed then
                exit(true);
        end;
        exit(false);
    end;

    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean; NewStartDate: Date; NewEndDate: Date; pUpdateAgingData: boolean);
    begin
        InitRequestPageDataInternal;
        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        IncludeAgingBand := NewIncludeAgingBand;
        EVALUATE(PeriodLength, NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteraction := NewLogInteraction;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        //>>1.3.7.2018
        UpdateAgingData := pUpdateAgingData;
        //<<1.3.7.2018
    end;

    local procedure IsReportInPreviewMode(): Boolean;
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.PREVIEW or MailManagement.IsHandlingGetEmailBody);
    end;

    procedure InitRequestPageDataInternal();
    begin
        if isInitialized then
            exit;

        isInitialized := true;

        if (not PrintAllHavingEntry) and (not PrintAllHavingBal) then
            PrintAllHavingBal := true;

        LogInteraction := SegManagement.FindInteractionTemplateCode(7) <> '';
        LogInteractionEnable := LogInteraction;
        // //>>1.3.4.2018
        // IncludeAgingBand := true;
        // PrintEntriesDue := true;
        // //<<1.3.4.2018
        // //>>1.3.5.2018
        // gHideClosedEntries := true;
        // //<<1.3.5.2018
        // //>>1.3.6.2018
        // HeadingType := HeadingType::"Number of Days";
        // //<<1.3.6.2018
        //>>1.3.7.2018
        if not GenLedgerSetup.get() then
            GenLedgerSetup.init();
        //<<1.3.7.2018

        if FORMAT(PeriodLength) = '' then
            EVALUATE(PeriodLength, '<1M+CM>');

        ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);
    end;

    local procedure VerifyDates();
    begin
        if StartDate = 0D then
            ERROR(BlankStartDateErr);
        if EndDate = 0D then
            ERROR(BlankEndDateErr);
        if StartDate > EndDate then
            ERROR(StartDateLaterTheEndDateErr);
    end;

    local procedure ClearCompanyPicture();
    begin
        if FirstCustomerPrinted then begin
            CLEAR(CompanyInfo.Picture);
            CLEAR(CompanyInfo1.Picture);
            CLEAR(CompanyInfo2.Picture);
            CLEAR(CompanyInfo3.Picture);
        end;
        FirstCustomerPrinted := true;
    end;
}

