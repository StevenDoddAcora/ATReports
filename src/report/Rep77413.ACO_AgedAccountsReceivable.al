report 50925 "ACO_AgedAccountsReceivable"
{
    //#region "Documentation"
    // 1.3.5.2018 LBR 01/10/2019 - CHG003322 (new report created for Aged Accounts Receivable) - it based on the standard report.
    // 1.3.8.2018 LBR 24/10/2019 - Snagging (Corrected Report aged acc recivable to deal per currency);
    // 1.4.2.2018 LBR 06/11/2019 - GO LIVE Snagging (Report “Aged Accounts Receivable”, the credit limit is showing as LCY however they would like TCY)
    //#endregion "Documentation"

    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layouts/Rep50925.AVT_AgedAccountsReceivable.rdlc';
    Caption = 'Aged Accounts Receivable (Avtrade)';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Currency Filter";

            column(TodayFormatted; TodayFormatted)
            {
            }
            column(CompanyName; CompanyDisplayName)
            {
            }
            column(FormatEndingDate; STRSUBSTNO(Text006, FORMAT(EndingDate, 0, 4)))
            {
            }
            column(PostingDate; STRSUBSTNO(Text007, SELECTSTR(AgingBy + 1, Text009)))
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(TableCaptnCustFilter; TABLECAPTION + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(AgingByDueDate; AgingBy = AgingBy::"Due Date")
            {
            }
            column(AgedbyDocumnetDate; STRSUBSTNO(Text004, SELECTSTR(AgingBy + 1, Text009)))
            {
            }
            column(HeaderText5; HeaderText[5])
            {
            }
            column(HeaderText4; HeaderText[4])
            {
            }
            column(HeaderText3; HeaderText[3])
            {
            }
            column(HeaderText2; HeaderText[2])
            {
            }
            column(HeaderText1; HeaderText[1])
            {
            }
            column(PrintDetails; PrintDetails)
            {
            }
            column(GrandTotalCLE5RemAmt; GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE4RemAmt; GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE3RemAmt; GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE2RemAmt; GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1RemAmt; GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLEAmtLCY; GrandTotalCustLedgEntry[1]."Amount (LCY)")
            {
                AutoFormatType = 1;
            }
            column(GrandTotalCLE1CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE2CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE3CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE4CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(GrandTotalCLE5CustRemAmtLCY; Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
            {
            }
            column(AgedAccReceivableCptn; AgedAccReceivableCptnLbl)
            {
            }
            column(CurrReportPageNoCptn; CurrReportPageNoCptnLbl)
            {
            }
            column(AllAmtinLCYCptn; AllAmtinLCYCptnLbl)
            {
            }
            column(AgedOverdueAmtCptn; AgedOverdueAmtCptnLbl)
            {
            }
            column(CLEEndDateAmtLCYCptn; CLEEndDateAmtLCYCptnLbl)
            {
            }
            column(CLEEndDateDueDateCptn; CLEEndDateDueDateCptnLbl)
            {
            }
            column(CLEEndDateDocNoCptn; CLEEndDateDocNoCptnLbl)
            {
            }
            column(CLEEndDatePstngDateCptn; CLEEndDatePstngDateCptnLbl)
            {
            }
            column(CLEEndDateDocTypeCptn; CLEEndDateDocTypeCptnLbl)
            {
            }
            column(OriginalAmtCptn; OriginalAmtCptnLbl)
            {
            }
            column(TotalLCYCptn; TotalLCYCptnLbl)
            {
            }
            column(NewPagePercustomer; NewPagePercustomer)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            //>>1.4.2.2018
            //column(CreditLimit_Customer;Customer."Credit Limit (LCY)")
            //{
            //}
            column(CreditLimit_Customer; Customer.ACO_CreditLimitTCY)
            {
            }
            //<<1.4.2.2018
            column(AvgDays_Customer; AvgDaysToPay[1])
            {
            }
            //>>1.3.8.2018
            column(GrandTotalCLE5RemAmtInCurr; gGrandTotalCustLedgEntryInCurr[5]."Remaining Amt. (LCY)")
            {
            }
            column(GrandTotalCLE4RemAmtInCurr; gGrandTotalCustLedgEntryInCurr[4]."Remaining Amt. (LCY)")
            {
            }
            column(GrandTotalCLE3RemAmtInCurr; gGrandTotalCustLedgEntryInCurr[3]."Remaining Amt. (LCY)")
            {
            }
            column(GrandTotalCLE2RemAmtInCurr; gGrandTotalCustLedgEntryInCurr[2]."Remaining Amt. (LCY)")
            {
            }
            column(GrandTotalCLE1RemAmtInCurr; gGrandTotalCustLedgEntryInCurr[1]."Remaining Amt. (LCY)")
            {
            }
            column(GrandTotalCLEAmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[1]."Amount (LCY)")
            {
            }
            column(gTotalCurrencyCode; gTotalCurrencyCode)
            {
            }
            //<<1.3.8.2018
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", "Posting Date", "Currency Code");

                trigger OnAfterGetRecord();
                var
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                    CustLedgEntry.SETRANGE("Closed by Entry No.", "Entry No.");
                    CustLedgEntry.SETRANGE("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromCustomer(CustLedgEntry);
                    //>>1.3.8.2018
                    IF Customer.GETFILTER("Currency Filter") <> '' THEN
                        Customer.COPYFILTER("Currency Filter", CustLedgEntry."Currency Code");
                    //<<1.3.8.2018
                    if CustLedgEntry.FINDSET(false, false) then
                        repeat
                            InsertTemp(CustLedgEntry);
                        until CustLedgEntry.NEXT = 0;

                    if "Closed by Entry No." <> 0 then begin
                        CustLedgEntry.SETRANGE("Closed by Entry No.", "Closed by Entry No.");
                        if CustLedgEntry.FINDSET(false, false) then
                            repeat
                                InsertTemp(CustLedgEntry);
                            until CustLedgEntry.NEXT = 0;
                    end;

                    CustLedgEntry.RESET;
                    CustLedgEntry.SETRANGE("Entry No.", "Closed by Entry No.");
                    CustLedgEntry.SETRANGE("Posting Date", 0D, EndingDate);
                    CopyDimFiltersFromCustomer(CustLedgEntry);
                    //>>1.3.8.2018
                    IF Customer.GETFILTER("Currency Filter") <> '' THEN
                        Customer.COPYFILTER("Currency Filter", CustLedgEntry."Currency Code");
                    //<<1.3.8.2018
                    if CustLedgEntry.FINDSET(false, false) then
                        repeat
                            InsertTemp(CustLedgEntry);
                        until CustLedgEntry.NEXT = 0;
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem();
                begin
                    SETRANGE("Posting Date", EndingDate + 1, DMY2DATE(31, 12, 9999));
                    CopyDimFiltersFromCustomer("Cust. Ledger Entry");

                    //>>1.3.8.2018
                    IF Customer.GETFILTER("Currency Filter") <> '' THEN
                        Customer.COPYFILTER("Currency Filter", "Cust. Ledger Entry"."Currency Code");
                    //<<1.3.8.2018
                end;
            } //Cust. Ledger Entry
            dataitem(OpenCustLedgEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemTableView = SORTING("Customer No.", Open, Positive, "Due Date", "Currency Code");

                trigger OnAfterGetRecord();
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        CALCFIELDS("Remaining Amt. (LCY)");
                        if "Remaining Amt. (LCY)" = 0 then
                            CurrReport.SKIP;
                    end;

                    InsertTemp(OpenCustLedgEntry);
                    CurrReport.SKIP;
                end;

                trigger OnPreDataItem();
                begin
                    if AgingBy = AgingBy::"Posting Date" then begin
                        SETRANGE("Posting Date", 0D, EndingDate);
                        SETRANGE("Date Filter", 0D, EndingDate);
                    end;
                    CopyDimFiltersFromCustomer(OpenCustLedgEntry);
                    //>>1.3.8.2018
                    IF Customer.GETFILTER("Currency Filter") <> '' THEN
                        Customer.COPYFILTER("Currency Filter", OpenCustLedgEntry."Currency Code");
                    //<<1.3.8.2018
                end;
            } // OpenCustLedgEntry DataItem
            dataitem(CurrencyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                PrintOnlyIfDetail = true;
                dataitem(TempCustLedgEntryLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                    column(Name1_Cust; Customer.Name)
                    {
                        IncludeCaption = true;
                    }
                    column(No_Cust; Customer."No.")
                    {
                        IncludeCaption = true;
                    }
                    column(CLEEndDateRemAmtLCY; CustLedgEntryEndingDate."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE1RemAmtLCY; AgedCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE2RemAmtLCY; AgedCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE3RemAmtLCY; AgedCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE4RemAmtLCY; AgedCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AgedCLE5RemAmtLCY; AgedCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CLEEndDateAmtLCY; CustLedgEntryEndingDate."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CLEEndDueDate; FORMAT(CustLedgEntryEndingDate."Due Date"))
                    {
                    }
                    column(CLEEndDateDocNo; CustLedgEntryEndingDate."Document No.")
                    {
                    }
                    column(CLEDocType; FORMAT(CustLedgEntryEndingDate."Document Type"))
                    {
                    }
                    column(CLEPostingDate; FORMAT(CustLedgEntryEndingDate."Posting Date"))
                    {
                    }
                    column(AgedCLE5TempRemAmt; AgedCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE4TempRemAmt; AgedCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE3TempRemAmt; AgedCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE2TempRemAmt; AgedCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(AgedCLE1TempRemAmt; AgedCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(RemAmt_CLEEndDate; CustLedgEntryEndingDate."Remaining Amount")
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(CLEEndDate; CustLedgEntryEndingDate.Amount)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(Name_Cust; STRSUBSTNO(Text005, Customer.Name))
                    {
                    }
                    column(TotalCLE1AmtLCY; TotalCustLedgEntry[1]."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE1RemAmtLCY; TotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE2RemAmtLCY; TotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE3RemAmtLCY; TotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE4RemAmtLCY; TotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE5RemAmtLCY; TotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(CurrrencyCode; CurrencyCode)
                    {
                        AutoFormatExpression = CurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalCLE5RemAmt; TotalCustLedgEntry[5]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE4RemAmt; TotalCustLedgEntry[4]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE3RemAmt; TotalCustLedgEntry[3]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE2RemAmt; TotalCustLedgEntry[2]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE1RemAmt; TotalCustLedgEntry[1]."Remaining Amount")
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCLE1Amt; TotalCustLedgEntry[1].Amount)
                    {
                        AutoFormatType = 1;
                    }
                    column(TotalCheck; CustFilterCheck)
                    {
                    }
                    column(GrandTotalCLE1AmtLCY; GrandTotalCustLedgEntry[1]."Amount (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE5PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE3PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE2PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE1PctRemAmtLCY; Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)", GrandTotalCustLedgEntry[1]."Amount (LCY)"))
                    {
                    }
                    column(GrandTotalCLE5RemAmtLCY; GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE4RemAmtLCY; GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE3RemAmtLCY; GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE2RemAmtLCY; GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(GrandTotalCLE1RemAmtLCY; GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)")
                    {
                        AutoFormatType = 1;
                    }
                    column(AvgDays; 'AvgDays')
                    {
                    }
                    //>>1.3.8.2018
                    column(GrandTotalCLE1AmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[1]."Amount (LCY)")
                    {
                    }
                    column(GrandTotalCLE5RemAmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[5]."Remaining Amt. (LCY)")
                    {
                    }
                    column(GrandTotalCLE4RemAmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[4]."Remaining Amt. (LCY)")
                    {
                    }
                    column(GrandTotalCLE3RemAmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[3]."Remaining Amt. (LCY)")
                    {
                    }
                    column(GrandTotalCLE2RemAmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[2]."Remaining Amt. (LCY)")
                    {
                    }
                    column(GrandTotalCLE1RemAmtLCYInCurr; gGrandTotalCustLedgEntryInCurr[1]."Remaining Amt. (LCY)")
                    {
                    }
                    //<<1.3.8.2018

                    trigger OnAfterGetRecord();
                    var
                        PeriodIndex: Integer;
                        Currency: Record Currency;
                        CurrExchRate: Record "Currency Exchange Rate";
                        lValue: Decimal;
                    begin
                        if Number = 1 then begin
                            if not TempCustLedgEntry.FINDSET(false, false) then
                                CurrReport.BREAK;
                        end else
                            if TempCustLedgEntry.NEXT = 0 then
                                CurrReport.BREAK;

                        CustLedgEntryEndingDate := TempCustLedgEntry;
                        DetailedCustomerLedgerEntry.SETRANGE("Cust. Ledger Entry No.", CustLedgEntryEndingDate."Entry No.");
                        if DetailedCustomerLedgerEntry.FINDSET(false, false) then
                            repeat
                                if (DetailedCustomerLedgerEntry."Entry Type" =
                                    DetailedCustomerLedgerEntry."Entry Type"::"Initial Entry") and
                                   (CustLedgEntryEndingDate."Posting Date" > EndingDate) and
                                   (AgingBy <> AgingBy::"Posting Date")
                                then begin
                                    if CustLedgEntryEndingDate."Document Date" <= EndingDate then
                                        DetailedCustomerLedgerEntry."Posting Date" :=
                                          CustLedgEntryEndingDate."Document Date"
                                    else
                                        if (CustLedgEntryEndingDate."Due Date" <= EndingDate) and
                                           (AgingBy = AgingBy::"Due Date")
                                        then
                                            DetailedCustomerLedgerEntry."Posting Date" :=
                                              CustLedgEntryEndingDate."Due Date"
                                end;

                                if (DetailedCustomerLedgerEntry."Posting Date" <= EndingDate) or
                                   (TempCustLedgEntry.Open and
                                    (AgingBy = AgingBy::"Due Date") and
                                    (CustLedgEntryEndingDate."Due Date" > EndingDate) and
                                    (CustLedgEntryEndingDate."Posting Date" <= EndingDate))
                                then begin
                                    if DetailedCustomerLedgerEntry."Entry Type" in
                                       [DetailedCustomerLedgerEntry."Entry Type"::"Initial Entry",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Unrealized Loss",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Unrealized Gain",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Realized Loss",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Realized Gain",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                        DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                    then begin
                                        CustLedgEntryEndingDate.Amount := CustLedgEntryEndingDate.Amount + DetailedCustomerLedgerEntry.Amount;
                                        CustLedgEntryEndingDate."Amount (LCY)" :=
                                          CustLedgEntryEndingDate."Amount (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                                    end;
                                    if DetailedCustomerLedgerEntry."Posting Date" <= EndingDate then begin
                                        CustLedgEntryEndingDate."Remaining Amount" :=
                                          CustLedgEntryEndingDate."Remaining Amount" + DetailedCustomerLedgerEntry.Amount;
                                        CustLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                          CustLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                                    end;
                                end;
                            until DetailedCustomerLedgerEntry.NEXT = 0;

                        if CustLedgEntryEndingDate."Remaining Amount" = 0 then
                            CurrReport.SKIP;

                        case AgingBy of
                            AgingBy::"Due Date":
                                PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Due Date");
                            AgingBy::"Posting Date":
                                PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Posting Date");
                            AgingBy::"Document Date":
                                begin
                                    if CustLedgEntryEndingDate."Document Date" > EndingDate then begin
                                        CustLedgEntryEndingDate."Remaining Amount" := 0;
                                        CustLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                        CustLedgEntryEndingDate."Document Date" := CustLedgEntryEndingDate."Posting Date";
                                    end;
                                    PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Document Date");
                                end;
                        end;
                        CLEAR(AgedCustLedgEntry);
                        AgedCustLedgEntry[PeriodIndex]."Remaining Amount" := CustLedgEntryEndingDate."Remaining Amount";
                        AgedCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalCustLedgEntry[PeriodIndex]."Remaining Amount" += CustLedgEntryEndingDate."Remaining Amount";
                        TotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        TotalCustLedgEntry[1].Amount += CustLedgEntryEndingDate."Remaining Amount";
                        TotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        GrandTotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";

                        //>>1.3.8.2018//>> 
                        //Total in Currency Calcualtion
                        IF gTotalCurrencyCode <> '' THEN BEGIN
                            IF gTotalCurrencyCode <> CustLedgEntryEndingDate."Currency Code" THEN BEGIN
                                Currency.GET(gTotalCurrencyCode);
                                lValue := 0;

                                IF CustLedgEntryEndingDate."Currency Code" = '' THEN BEGIN
                                    lValue := CurrExchRate.ExchangeAmtLCYToFCY(
                                                                CustLedgEntryEndingDate."Posting Date",
                                                                gTotalCurrencyCode,
                                                                CustLedgEntryEndingDate."Remaining Amount",
                                                                CurrExchRate.GetCurrentCurrencyFactor(gTotalCurrencyCode));
                                END ELSE BEGIN
                                    lValue := CurrExchRate.ExchangeAmtFCYToFCY(
                                                                CustLedgEntryEndingDate."Posting Date",
                                                                CustLedgEntryEndingDate."Currency Code",
                                                                gTotalCurrencyCode,
                                                                CustLedgEntryEndingDate."Remaining Amount");
                                END;
                            END ELSE BEGIN
                                lValue := CustLedgEntryEndingDate."Remaining Amount";
                            END;

                            lValue := ROUND(lValue, Currency."Amount Rounding Precision");

                            gGrandTotalCustLedgEntryInCurr[PeriodIndex]."Remaining Amt. (LCY)" += lValue;
                            gGrandTotalCustLedgEntryInCurr[1]."Amount (LCY)" += lValue;
                        END ELSE BEGIN
                            gGrandTotalCustLedgEntryInCurr[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                            gGrandTotalCustLedgEntryInCurr[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                        END;
                        //<<1.3.8.2018
                    end;

                    trigger OnPostDataItem();
                    begin
                        if not PrintAmountInLCY then
                            UpdateCurrencyTotals;
                    end;

                    trigger OnPreDataItem();
                    begin
                        if not PrintAmountInLCY then begin
                            if (TempCurrency.Code = '') or (TempCurrency.Code = GLSetup."LCY Code") then
                                TempCustLedgEntry.SETFILTER("Currency Code", '%1|%2', GLSetup."LCY Code", '')
                            else
                                TempCustLedgEntry.SETRANGE("Currency Code", TempCurrency.Code);
                        end;

                        PageGroupNo := NextPageGroupNo;
                        if NewPagePercustomer and (NumberOfCurrencies > 0) then
                            NextPageGroupNo := PageGroupNo + 1;
                    end;
                }  //TempCustLedgEntryLoop Dataitem

                trigger OnAfterGetRecord();
                begin
                    CLEAR(TotalCustLedgEntry);

                    if Number = 1 then begin
                        if not TempCurrency.FINDSET(false, false) then
                            CurrReport.BREAK;
                    end else
                        if TempCurrency.NEXT = 0 then
                            CurrReport.BREAK;

                    if TempCurrency.Code <> '' then
                        CurrencyCode := TempCurrency.Code
                    else
                        CurrencyCode := GLSetup."LCY Code";

                    NumberOfCurrencies := NumberOfCurrencies + 1;
                end;

                trigger OnPreDataItem();
                begin
                    NumberOfCurrencies := 0;
                end;
            } // CurrencyLoop Dataitem

            trigger OnAfterGetRecord();
            begin
                if NewPagePercustomer then
                    PageGroupNo += 1;
                TempCurrency.RESET;
                TempCurrency.DELETEALL;
                TempCustLedgEntry.RESET;
                TempCustLedgEntry.DELETEALL;

                //>>1.3.5.2018
                AdditionalSetup.GET();
                CLEAR(GeneralFunctions);
                GeneralFunctions.CalculateCustomerAvgDaysToPay(Customer, AvgDaysToPay, AdditionalSetup.ACO_AvgCollectionPeriodCalc::Year, WorkDate);
                //<<1.3.5.2018

            end;
        } // Customer Dataitem
        dataitem(CurrencyTotals; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
            column(CurrNo; Number = 1)
            {
            }
            column(TempCurrCode; TempCurrency2.Code)
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE6RemAmt; AgedCustLedgEntry[6]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE1RemAmt; AgedCustLedgEntry[1]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE2RemAmt; AgedCustLedgEntry[2]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE3RemAmt; AgedCustLedgEntry[3]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE4RemAmt; AgedCustLedgEntry[4]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(AgedCLE5RemAmt; AgedCustLedgEntry[5]."Remaining Amount")
            {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
            }
            column(CurrSpecificationCptn; CurrSpecificationCptnLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Number = 1 then begin
                    if not TempCurrency2.FINDSET(false, false) then
                        CurrReport.BREAK;
                end else
                    if TempCurrency2.NEXT = 0 then
                        CurrReport.BREAK;

                CLEAR(AgedCustLedgEntry);
                TempCurrencyAmount.SETRANGE("Currency Code", TempCurrency2.Code);
                if TempCurrencyAmount.FINDSET(false, false) then
                    repeat
                        if TempCurrencyAmount.Date <> DMY2DATE(31, 12, 9999) then
                            AgedCustLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                              TempCurrencyAmount.Amount
                        else
                            AgedCustLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                    until TempCurrencyAmount.NEXT = 0;
            end;
        } // CurrencyTotals dataitem
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AgedAsOf; EndingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged As Of';
                        ToolTip = 'Specifies the date that you want the ageing calculated for.';
                    }
                    field(Agingby; AgingBy)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ageing by';
                        OptionCaption = 'Due Date,Posting Date,Document Date';
                        ToolTip = 'Specifies if the ageing will be calculated from the due date, the posting date, or the document date.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.';
                    }
                    field(AmountsinLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY';
                        ToolTip = 'Specifies if you want the report to specify the ageing per customer ledger entry.';
                    }
                    field(PrintDetails; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details';
                        //>>1.3.8.2018
                        Visible = false;
                        //<<1.3.8.2018
                        ToolTip = 'Specifies if you want the report to show the detailed entries that add up the total balance for each customer.';
                    }
                    field(HeadingType; HeadingType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Heading Type';
                        OptionCaption = 'Date Interval,Number of Days';
                        ToolTip = 'Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.';
                    }
                    field(perCustomer; NewPagePercustomer)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer''s information is printed on a new page if you have chosen two or more customers to be included in the report.';
                    }
                    //>>1.3.8.2018
                    field(gTotalCurrencyCode; gTotalCurrencyCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Total Currency Code';
                        Visible = true;
                        TableRelation = Currency.Code;
                        ToolTip = 'Specifies if you want see report totals by different currency than LCY';
                    }
                    //<<1.3.8.2018
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if EndingDate = 0D then
                EndingDate := WORKDATE;
            if FORMAT(PeriodLength) = '' then
                EVALUATE(PeriodLength, '<1M>');

            HeadingType := HeadingType::"Number of Days";

            //>>1.3.8.2018
            PrintDetails := False;
            //<<1.3.8.2018
        end;
    }

    labels
    {
        BalanceCaption = 'Balance'; DateLbl = 'Date'; TimeLbl = 'Time'; CustomerFromLbl = 'Customer From'; CustomerToLbl = 'Customer To'; DateFromLbl = 'Date From'; DateToLbl = 'Date To'; TransactionFromLbl = 'Transaction From'; TransactionToLbl = 'Transaction To'; RegionFromLbl = 'Region From'; RegionToLbl = 'Region To'; IncFutureTranLbl = 'Inc Future Tran?'; ExcLaterPaymentsLbl = 'Exc Later Payments'; ACLbl = 'A/C'; NameLbl = 'Name'; CreditLimitLbl = 'Credit Limit'; BalanceLbl = 'Balance'; CurrentLbl = 'Current'; Period1Lbl = 'Period 1'; Period2Lbl = 'Period 2'; Period3Lbl = 'Period 3'; OlderLbl = 'Older'; AvgDaysLbl = 'Avg Days'; TotalForRegionLbl = 'Total for Region'; ReportTotalsLbl = 'Report Totals';
    }

    trigger OnPreReport();
    var
        CaptionManagement: Codeunit CaptionManagement;
    begin
        CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);

        GLSetup.GET;

        CalcDates;
        CreateHeadings;

        PageGroupNo := 1;
        NextPageGroupNo := 1;
        CustFilterCheck := (CustFilter <> 'No.');

        TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f');
        CompanyDisplayName := COMPANYPROPERTY.DISPLAYNAME;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        CustLedgEntryEndingDate: Record "Cust. Ledger Entry";
        TotalCustLedgEntry: array[5] of Record "Cust. Ledger Entry";
        GrandTotalCustLedgEntry: array[5] of Record "Cust. Ledger Entry";
        AgedCustLedgEntry: array[6] of Record "Cust. Ledger Entry";
        TempCurrency: Record Currency temporary;
        TempCurrency2: Record Currency temporary;
        TempCurrencyAmount: Record "Currency Amount" temporary;
        DetailedCustomerLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        TypeHelper: Codeunit "Type Helper";
        CustFilter: Text;
        PrintAmountInLCY: Boolean;
        EndingDate: Date;
        AgingBy: Option "Due Date","Posting Date","Document Date";
        PeriodLength: DateFormula;
        PrintDetails: Boolean;
        HeadingType: Option "Date Interval","Number of Days";
        NewPagePercustomer: Boolean;
        PeriodStartDate: array[5] of Date;
        PeriodEndDate: array[5] of Date;
        HeaderText: array[5] of Text[30];
        Text000: Label 'Not Due';
        Text001: Label 'Before';
        CurrencyCode: Code[10];
        Text002: Label 'days';
        Text003: Label 'More than';
        Text004: Label 'Aged by %1';
        Text005: Label 'Total for %1';
        Text006: Label 'Aged as of %1';
        Text007: Label 'Aged by %1';
        NumberOfCurrencies: Integer;
        Text009: Label 'Due Date,Posting Date,Document Date';
        Text010: Label 'The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CustFilterCheck: Boolean;
        Text032: Label '-%1';
        AgedAccReceivableCptnLbl: Label 'Aged Accounts Receivable';
        CurrReportPageNoCptnLbl: Label 'Page';
        AllAmtinLCYCptnLbl: Label 'All Amounts in LCY';
        AgedOverdueAmtCptnLbl: Label 'Aged Overdue Amounts';
        CLEEndDateAmtLCYCptnLbl: Label 'Original Amount ';
        CLEEndDateDueDateCptnLbl: Label 'Due Date';
        CLEEndDateDocNoCptnLbl: Label 'Document No.';
        CLEEndDatePstngDateCptnLbl: Label 'Posting Date';
        CLEEndDateDocTypeCptnLbl: Label 'Document Type';
        OriginalAmtCptnLbl: Label 'Currency Code';
        TotalLCYCptnLbl: Label 'Total (LCY)';
        CurrSpecificationCptnLbl: Label 'Currency Specification';
        EnterDateFormulaErr: Label 'Enter a date formula in the Period Length field.';
        TodayFormatted: Text;
        CompanyDisplayName: Text;
        GenLedgerSetup: Record "General Ledger Setup";
        AdditionalSetup: Record "ACO_AdditionalSetup";
        GeneralFunctions: Codeunit ACO_GeneralFunctions;
        AvgDaysToPay: array[3] of Decimal;
        gGrandTotalCustLedgEntryInCurr: array[5] of Record "Cust. Ledger Entry";
        gTotalCurrencyCode: Code[20];

    local procedure CalcDates();
    var
        i: Integer;
        PeriodLength2: DateFormula;
    begin
        if not EVALUATE(PeriodLength2, STRSUBSTNO(Text032, PeriodLength)) then
            ERROR(EnterDateFormulaErr);
        if AgingBy = AgingBy::"Due Date" then begin
            PeriodEndDate[1] := DMY2DATE(31, 12, 9999);
            PeriodStartDate[1] := EndingDate + 1;
        end else begin
            PeriodEndDate[1] := EndingDate;
            PeriodStartDate[1] := CALCDATE(PeriodLength2, EndingDate + 1);
        end;
        for i := 2 to ARRAYLEN(PeriodEndDate) do begin
            PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
            PeriodStartDate[i] := CALCDATE(PeriodLength2, PeriodEndDate[i] + 1);
        end;
        PeriodStartDate[i] := 0D;

        for i := 1 to ARRAYLEN(PeriodEndDate) do
            if PeriodEndDate[i] < PeriodStartDate[i] then
                ERROR(Text010, PeriodLength);
    end;

    local procedure CreateHeadings();
    var
        i: Integer;
    begin
        if AgingBy = AgingBy::"Due Date" then begin
            HeaderText[1] := Text000;
            i := 2;
        end else
            i := 1;
        while i < ARRAYLEN(PeriodEndDate) do begin
            if HeadingType = HeadingType::"Date Interval" then
                HeaderText[i] := STRSUBSTNO('%1\..%2', PeriodStartDate[i], PeriodEndDate[i])
            else
                HeaderText[i] :=
                  STRSUBSTNO('%1 - %2 %3', EndingDate - PeriodEndDate[i] + 1, EndingDate - PeriodStartDate[i] + 1, Text002);
            i := i + 1;
        end;
        if HeadingType = HeadingType::"Date Interval" then
            HeaderText[i] := STRSUBSTNO('%1 %2', Text001, PeriodStartDate[i - 1])
        else
            HeaderText[i] := STRSUBSTNO('%1 \%2 %3', Text003, EndingDate - PeriodStartDate[i - 1] + 1, Text002);
    end;

    local procedure InsertTemp(var CustLedgEntry: Record "Cust. Ledger Entry");
    var
        Currency: Record Currency;
    begin
        with TempCustLedgEntry do begin
            if GET(CustLedgEntry."Entry No.") then
                exit;
            TempCustLedgEntry := CustLedgEntry;
            INSERT;
            if PrintAmountInLCY then begin
                CLEAR(TempCurrency);
                TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
                if TempCurrency.INSERT then;
                exit;
            end;
            if TempCurrency.GET("Currency Code") then
                exit;
            if TempCurrency.GET('') and ("Currency Code" = GLSetup."LCY Code") then
                exit;
            if TempCurrency.GET(GLSetup."LCY Code") and ("Currency Code" = '') then
                exit;
            if "Currency Code" <> '' then
                Currency.GET("Currency Code")
            else begin
                CLEAR(Currency);
                Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
            end;
            TempCurrency := Currency;
            TempCurrency.INSERT;
        end;
    end;

    local procedure GetPeriodIndex(Date: Date): Integer;
    var
        i: Integer;
    begin
        for i := 1 to ARRAYLEN(PeriodEndDate) do
            if Date in [PeriodStartDate[i] .. PeriodEndDate[i]] then
                exit(i);
    end;

    local procedure Pct(a: Decimal; b: Decimal): Text[30];
    begin
        if b <> 0 then
            exit(FORMAT(ROUND(100 * a / b, 0.1), 0, '<Sign><Integer><Decimals,2>') + '%');
    end;

    local procedure UpdateCurrencyTotals();
    var
        i: Integer;
    begin
        TempCurrency2.Code := CurrencyCode;
        if TempCurrency2.INSERT then;
        with TempCurrencyAmount do begin
            for i := 1 to ARRAYLEN(TotalCustLedgEntry) do begin
                "Currency Code" := CurrencyCode;
                Date := PeriodStartDate[i];
                if FIND then begin
                    Amount := Amount + TotalCustLedgEntry[i]."Remaining Amount";
                    MODIFY;
                end else begin
                    "Currency Code" := CurrencyCode;
                    Date := PeriodStartDate[i];
                    Amount := TotalCustLedgEntry[i]."Remaining Amount";
                    INSERT;
                end;
            end;
            "Currency Code" := CurrencyCode;
            Date := DMY2DATE(31, 12, 9999);
            if FIND then begin
                Amount := Amount + TotalCustLedgEntry[1].Amount;
                MODIFY;
            end else begin
                "Currency Code" := CurrencyCode;
                Date := DMY2DATE(31, 12, 9999);
                Amount := TotalCustLedgEntry[1].Amount;
                INSERT;
            end;
        end;
    end;

    procedure InitializeRequest(NewEndingDate: Date; NewAgingBy: Option; NewPeriodLength: DateFormula; NewPrintAmountInLCY: Boolean; NewPrintDetails: Boolean; NewHeadingType: Option; NewPagePercust: Boolean);
    begin
        EndingDate := NewEndingDate;
        AgingBy := NewAgingBy;
        PeriodLength := NewPeriodLength;
        PrintAmountInLCY := NewPrintAmountInLCY;
        PrintDetails := NewPrintDetails;
        HeadingType := NewHeadingType;
        NewPagePercustomer := NewPagePercust;
    end;

    local procedure CopyDimFiltersFromCustomer(var CustLedgerEntry: Record "Cust. Ledger Entry");
    begin
        if Customer.GETFILTER("Global Dimension 1 Filter") <> '' then
            CustLedgerEntry.SETFILTER("Global Dimension 1 Code", Customer.GETFILTER("Global Dimension 1 Filter"));
        if Customer.GETFILTER("Global Dimension 2 Filter") <> '' then
            CustLedgerEntry.SETFILTER("Global Dimension 2 Code", Customer.GETFILTER("Global Dimension 2 Filter"));
    end;
}

