codeunit 50904 "ACO_PmtExpMgtGJL"
{
    //#region "Documentation"
    // 1.4.2.2018 KNH 14/11/2019 - CHG003382 (Change curr code on BACS payments where bank acc curr code
    //                             diff from bank curr code
    // 1.4.6.2018 LBR 15/11/2019 - Copied Keith fix code from STANDARD nav object
    // 3.0.8.2018 LBR 30/01/2020 - Export Payment logic changed to infrom user about payments not balanced with the applied entries
    // 3.0.9.2018 MAR 25/02/2020 - CHG003417 - Add beneficiary information fields on the Payment Export data definition
    //#region "Documentation"

    trigger OnRun()
    begin

    end;

    //>>3.0.8.2018
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Pmt Export Mgt Gen. Jnl Line", 'OnCheckGenJnlLine', '', true, true)]
    local procedure OnCheckGenJnlLineBeforePaymentExport(GenJournalLine: Record "Gen. Journal Line");
    var
    begin
        CheckApplyAmtOnPaymentGenJnlLine(GenJournalLine);
    end;

    local procedure CheckApplyAmtOnPaymentGenJnlLine(GenJournalLine: Record "Gen. Journal Line")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        AmountToApply: Decimal;
    begin
        AmountToApply := 0;
        If GenJournalLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find related amount to apply for single document
            VendLedgEntry.RESET();
            VendLedgEntry.SetCurrentKey("Document Type", "Vendor No.", "Posting Date", "Currency Code");
            VendLedgEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
            VendLedgEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
            VendLedgEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            IF VendLedgEntry.FindFirst() then
                AmountToApply := ABS(VendLedgEntry."Amount to Apply");
        END ELSE BEGIN
            IF GenJournalLine."Applies-to ID" <> '' THEN BEGIN
                // Find related amount to apply for multi documents
                VendLedgEntry.RESET();
                VendLedgEntry.SetCurrentKey("Vendor No.", "Applies-to ID", "Open", "Positive", "Due Date");
                VendLedgEntry.SetRange("Vendor No.", GenJournalLine."Account No.");
                VendLedgEntry.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
                IF VendLedgEntry.FindSet(false) then begin
                    repeat
                    begin
                        AmountToApply += VendLedgEntry."Amount to Apply";
                    end;
                    until VendLedgEntry.Next() = 0;
                end;
                AmountToApply := ABS(AmountToApply);
            END;
        END;

        // Compare it with payment    
        IF ABS(GenJournalLine.Amount) <> AmountToApply then
            IF NOT Confirm(StrSubstNo('Payment Amount and Amount to Apply is not this same for Vendor No = %1 and Document No = %2. Do you want to continue?',
                                GenJournalLine."Account No.", GenJournalLine."Document No."))
                Then
                ERROR('');
    end;

    procedure CheckApplyAmtOnPaymentGenJnl(pGenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        AmountToApply: Decimal;
    begin
        GenJnlLine.SETRANGE("Journal Template Name", pGenJournalLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", pGenJournalLine."Journal Batch Name");
        if GenJnlLine.FindSet(FALSE) then begin
            repeat
            begin
                CheckApplyAmtOnPaymentGenJnlLine(GenJnlLine);
            end;
            until GenJnlLine.next() = 0;
        end;
    end;
    //<<3.0.8.2018

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Pmt Export Mgt Gen. Jnl Line", 'OnBeforeInsertPmtExportDataJnlFromGenJnlLine', '', true, true)]
    local procedure OnBeforeInsertPmtExportDataJnlFromGenJnlLine(Var PaymentExportData: Record "Payment Export Data"; GenJournalLine: Record "Gen. Journal Line";
    GeneralLedgerSetup: Record "General Ledger Setup")
    var
        BankAccount: Record "Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        //>>1.4.6.2018
        BankAccount.GET(GenJournalLine."Bal. Account No.");

        IF VendorBankAccount.GET(GenJournalLine."Account No.", GenJournalLine."Recipient Bank Account") THEN BEGIN
            IF BankAccount."Country/Region Code" = VendorBankAccount."Country/Region Code" THEN BEGIN
                //ABSXXX KNH 19/11/19 --> Temporary fix until it can be included in Extension
                //Amount := GenJnlLine."Amount (LCY)";
                PaymentExportData.Amount := GenJournalLine.Amount;
                //ABSXXX KNH 19/11/19 <-- Temporary fix until it can be included in Extension
            END;

            // 3.0.9.2018 MAR 25/02/2020 - CHG003417 -->
            PaymentExportData.ACO_InfoBeneficiary := VendorBankAccount.ACO_InfoBeneficiary;
            PaymentExportData.ACO_InfoBeneficiary2 := VendorBankAccount.ACO_InfoBeneficiary2;
            PaymentExportData.ACO_InfoBeneficiary3 := VendorBankAccount.ACO_InfoBeneficiary3;
            PaymentExportData."Recipient Bank City" := VendorBankAccount.City;
            PaymentExportData."Recipient Bank Post Code" := VendorBankAccount."Post Code";
            PaymentExportData.ACO_IntermediarySWIFTCode := VendorBankAccount."SWIFT Code";
            // 3.0.9.2018 MAR 25/02/2020 - CHG003417 <--
        END;
        //<<1.4.6.2018

        IF (PaymentExportData."Currency Code" <> GenJournalLine."Currency Code") And (GenJournalLine."Currency Code" <> '') then
            PaymentExportData."Currency Code" := GenJournalLine."Currency Code";
    end;
}