codeunit 50903 "ACO_IntegrationMgt"
{
    //#region "Documentation"
    // 1.3.5.2018 LBR 01/10/2019 - new object created for CHG003332 (E-mailing Remittance). We do want to use standard NAV to send emials, however
    //      this version of NAV does not allow to extends standard option fields, therfore we will use P.Arch. Quote,P.Arch. Order for bespoke report purpose
    // 1.3.7.2018 LBR 29/10/2019 - CHG003339 (Customer Average Collection Period) New code added to support NAS;
    // 1.4.8.2018 LBR 05/12/2019 - (Payment Journals) - Fixed issue related to not showing message once email is sent
    // 3.1.4.2018 - MAR 16/03/2020 - CHG003421 - Carry line descriptions to G/L entries when posting, 
    //      new functionality added to prevent purchase/Sales lines compression. 
    ///     Using this codeunit as additional codeunits are not available in the current license. Added Change CHG003421 region
    // 3.1.9.2018 KNH 07/10/2020 - If Remittance report usage is false then set variable Handled to false as email not sent

    //#endregion "Documentation"

    //>>1.3.7.2018
    TableNo = "Job Queue Entry";
    //<<1.3.7.2018

    trigger OnRun();
    var
        ErrorLbl: Label 'Job Queue Parameter String is not supported';
    begin
        //>>1.3.7.2018
        if (Uppercase(Rec."Parameter String") = 'UPDATECUSTOMERAGINGDATA') THEN BEGIN
            UpdateCustomerAgingData(Today);
        END else begin
            Error(ErrorLbl);
        end;
        //<<1.3.7.2018
    end;

    //#region AutoRoutines
    local procedure _____AutoRoutinesFunctions_____();
    begin

    end;

    procedure UpdateCustomerAgingData(pDate: Date);
    var
        lAvtradeStatement: report ACO_AvtradeStatement;
        lDialog: Dialog;
        lProcessingLbl: Label 'Processing ...';
        lCustomer: RecordRef;
        lFileMgt: Codeunit "File Management";
    begin
        if GuiAllowed() then
            lDialog.Open(lProcessingLbl);

        lAvtradeStatement.InitializeRequest(true, //PrintEntriesDue
                                                        true, //PrintAllHavingEntry
                                                        true, //PrintAllHavingBal
                                                        false, //PrintReversedEntries
                                                        false, //PrintUnappliedEntries
                                                        true, //IncludeAgingBand
                                                        '30D', //PeriodLength
                                                        2, //DateChoice
                                                        false, //LogInteraction
                                                        CalcDate('<-10Y>', pDate), //StartDate
                                                        pDate,
                                                        true // Update Customer Aging Detials
                                                        );
        lAvtradeStatement.UseRequestPage(false);
        //AvtradeStatement.run();         
        //AvtradeStatement.Execute(AvtradeStatement.RunRequestPage(),lCustomer);
        //Save the file as PDF to dummy file as we only care about the code which is updateding the aging data inside the customer statment report
        lAvtradeStatement.SaveAsPdf(lFileMgt.ServerTempFileName('pdf'));

        if GuiAllowed() then
            lDialog.Close();
    end;

    //#endregion AutoRoutines

    //#region Email Remittance Main Functions
    local procedure _____EmailRemittanceMainFunctions_____();
    begin
    end;

    procedure EmailRemittanceJnl(var GenJnlLine: Record "Gen. Journal Line");
    var
        Vend: Record Vendor;
        TempVend: Record Vendor temporary;
        ReportSelections: Record "Report Selections";
        lDialog: Dialog;
        lProcessingLbl: Label 'Processing ...';
        VendorFilter: report ACO_VendorFilter;
    begin
        // Find all vendors
        if GenJnlLine.findset() then begin
            repeat
            begin
                IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) AND (GenJnlLine."Account No." <> '')
                THEN begin
                    IF NOT TempVend.GET(GenJnlLine."Account No.") THEN BEGIN
                        Vend.GET(GenJnlLine."Account No.");
                        TempVend := Vend;
                        TempVend.INSERT;
                    END;
                end;
            end;
            until GenJnlLine.next() = 0;
        end;

        // Allow user to filter by vendor
        Clear(VendorFilter);
        VendorFilter.RunModal();
        if not VendorFilter.GetVendor(TempVend) then
            exit;

        // If only one then proceed with email body
        if TempVend.Count() = 1 then begin
            TempVend.findset();
            // Ensure only specific vendor is pickup
            GenJnlLine.SetRange("Account No.", TempVend."No.");

            ReportSelections.SendEmailToVendor(
                GetRemittanceJnlReportUsage(), GenJnlLine, GenJnlLine."Document No.", 'Remittance', TRUE, TempVend."No.")
        end else begin
            // If batch then proceed with batch sending one by one
            if TempVend.findset() then begin
                if GuiAllowed() then
                    lDialog.open(lProcessingLbl);

                repeat
                begin
                    // Ensure only specific vendor is pickup
                    GenJnlLine.SetRange("Account No.", TempVend."No.");

                    CLEAR(ReportSelections);
                    ReportSelections.SendEmailToVendor(
                        GetRemittanceJnlReportUsage(), GenJnlLine, GenJnlLine."Document No.", 'Remittance', FALSE, TempVend."No.")
                end;
                until TempVend.next() = 0;
                if GuiAllowed() then
                    lDialog.close();
            end;
        end;

        //>>1.4.8.2018
        If GuiAllowed() then
            Message(lEmailSentLbl);
        //<<1.4.8.2018
    end;

    procedure EmailRemittanceEntries(var VendLedgEntries: Record "Vendor Ledger Entry");
    var
        Vend: Record Vendor;
        TempVend: Record Vendor temporary;
        ReportSelections: Record "Report Selections";
        lDialog: Dialog;
        lProcessingLbl: Label 'Processing ...';
        VendorFilter: report ACO_VendorFilter;
    begin
        // Find all vendors
        if VendLedgEntries.findset() then begin
            repeat
            begin
                IF (VendLedgEntries."Vendor No." <> '')
                THEN begin
                    IF NOT TempVend.GET(VendLedgEntries."Vendor No.") THEN BEGIN
                        Vend.GET(VendLedgEntries."Vendor No.");
                        TempVend := Vend;
                        TempVend.INSERT;
                    END;
                end;
            end;
            until VendLedgEntries.next() = 0;
        end;

        // Allow user to filter by vendor
        Clear(VendorFilter);
        VendorFilter.RunModal();
        if not VendorFilter.GetVendor(TempVend) then
            exit;

        // If only one then proceed with email body
        if TempVend.Count() = 1 then begin
            TempVend.findset();
            // Ensure only specific vendor is pickup
            VendLedgEntries.SetRange("Vendor No.", TempVend."No.");
            ReportSelections.SendEmailToVendor(
                GetRemittanceJnlReportUsage(), VendLedgEntries, VendLedgEntries."Document No.", 'Remittance', TRUE, TempVend."No.")
        end else begin
            // If batch then proceed with batch sending one by one
            if TempVend.findset() then begin
                if GuiAllowed() then
                    lDialog.open(lProcessingLbl);

                repeat
                begin
                    // Ensure only specific vendor is pickup
                    VendLedgEntries.SetRange("Vendor No.", TempVend."No.");

                    CLEAR(ReportSelections);
                    ReportSelections.SendEmailToVendor(
                        GetRemittanceJnlReportUsage(), VendLedgEntries, VendLedgEntries."Document No.", 'Remittance', FALSE, TempVend."No.")
                end;
                until TempVend.next() = 0;
                if GuiAllowed() then
                    lDialog.close();
            end;
        end;

        //>>1.4.8.2018
        If GuiAllowed() then
            Message(lEmailSentLbl);
        //<<1.4.8.2018
    end;
    //#endregion Email Remittance Main Functions


    //#region Email Subscriber
    local procedure _____EmailSubscriber_____();
    begin
    end;

    [EventSubscriber(ObjectType::Table, database::"Report Selections", 'OnBeforeSendEmailToVendor', '', FALSE, FALSE)]
    local procedure RunOnBeforeSendEmailToVendor(ReportUsage: Integer; RecordVariant: Variant; DocNo: Code[20]; DocName: Text[150]; ShowDialog: Boolean; VendorNo: Code[20]; VAR Handled: Boolean)
    var
        //ReportSelection: Record "Report Selections";
        //JobQueueEntry: Record "Job Queue Entry";
        //SMTPMail: Codeunit "SMTP Mail";
        //OfficeMgt: Codeunit "Office Management";
        RecRef: RecordRef;
    //VendorEmail: Text;
    begin
        RecRef.GETTABLE(RecordVariant);

        //This is special case for remittance. Standard does not allow to extend option field, thefore we are using standard options for new prupose
        if IsRemittanceReportUsage(ReportUsage) then begin
            SendEmailToVendorDirectly(ReportUsage, RecRef, DocNo, DocName, ShowDialog, VendorNo);
        end;

        // This code should in play if job queue is needed, but it should have own cu
        // RecRef.GETTABLE(RecordVariant);
        // JobQueueEntry.INIT;
        // JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        // JobQueueEntry."Object ID to Run" := CODEUNIT::"Document-Mailing";
        // JobQueueEntry."Maximum No. of Attempts to Run" := 3;
        // JobQueueEntry."Record ID to Process" := RecRef.RECORDID;
        // JobQueueEntry."Parameter String" := STRSUBSTNO('%1|%2|%3|%4|%5', ReportUsage, DocNo, DocName, VendorNo, 'Vendor');
        // JobQueueEntry.Description := COPYSTR(DocName, 1, MAXSTRLEN(JobQueueEntry.Description));
        // CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);

        //3.1.9.2018 KNH 07/10/2020 --> 
        IF not IsRemittanceReportUsage(ReportUsage) then
            Handled := false
        else
            //3.1.9.2018 KNH 07/10/2020 <--
            Handled := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Report Selections", 'OnBeforeGetVendorEmailAddress', '', False, False)]
    local procedure OnBeforeGetVendorEmailAddress(BuyFromVendorNo: Code[20]; VAR ToAddress: Text; VAR IsHandled: Boolean)
    var
        Vendor: Record Vendor;
    begin
        if not Vendor.get(BuyFromVendorNo) then begin
            IsHandled := false;
            exit;
        end;

        ToAddress := Vendor."E-Mail";
        IsHandled := (ToAddress <> '');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', false, false)]
    local procedure RunOnBeforeSendEmail(VAR TempEmailItem: Record "Email Item" TEMPORARY; IsFromPostedDoc: Boolean; PostedDocNo: Code[20]; HideDialog: Boolean; ReportUsage: Integer);
    var
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
    begin
        //if not Vendor.Get(PostedDocNo) then
        //    Vendor.init();
        // The subject is handled in modern email functionality
        if IsRemittanceReportUsage(ReportUsage) then begin
            TempEmailItem.Subject := 'Remittance Advice';
            if CompanyInfo.GET() then
                TempEmailItem.Subject := TempEmailItem.Subject + ' From ' + CompanyInfo.Name;
        end;
    end;

    //#endregion Email Subscriber

    //#region Help Functions
    local procedure _____HelpFunctions_____();
    begin
    end;

    // Funciton copided from standard table 77
    LOCAL procedure SendEmailToVendorDirectly(ReportUsage: Integer; RecordVariant: Variant; DocNo: Code[20]; DocName: Text[150]; ShowDialog: Boolean; VendorNo: Code[20]): Boolean
    var
        ReportSelection: Record "Report Selections";
        TempAttachReportSelections: record "Report Selections" temporary;
        CustomReportSelection: Record "Custom Report Selection";
        Email: Codeunit Email;
        FoundBody: Boolean;
        FoundAttachment: Boolean;
        ServerEmailBodyFilePath: Text;
        EmailAddress: text;
        ReportUsageEnum: Enum "Report Selection Usage";
    begin
        // Convert integer to enum for modern BC compatibility
        ReportUsageEnum := "Report Selection Usage".FromInteger(ReportUsage);

        FoundBody := ReportSelection.GetEmailBodyForVend(ServerEmailBodyFilePath, ReportUsageEnum, RecordVariant, VendorNo, EmailAddress);
        FoundAttachment := ReportSelection.FindEmailAttachmentUsageForVend(ReportUsageEnum, VendorNo, TempAttachReportSelections);

        CustomReportSelection.SETRANGE("Source Type", DATABASE::Vendor);
        CustomReportSelection.SETRANGE("Source No.", VendorNo);
        EXIT(SendEmailDirectly(
            ReportUsage, RecordVariant, DocNo, DocName, FoundBody, FoundAttachment, ServerEmailBodyFilePath, EmailAddress, ShowDialog,
            TempAttachReportSelections, CustomReportSelection));
    end;

    // Funciton copided from standard table 77
    LOCAL procedure SendEmailDirectly(ReportUsage: Integer; RecordVariant: Variant; DocNo: Code[20]; DocName: Text[150]; FoundBody: Boolean; FoundAttachment: Boolean; ServerEmailBodyFilePath: Text[250]; VAR DefaultEmailAddress: Text[250];
    ShowDialog: Boolean; VAR TempAttachReportSelections: Record "Report Selections" temporary; var CustomReportSelection: Record "Custom Report Selection" temporary) AllEmailsWereSuccessful: boolean;
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        OfficeAttachmentManager: Codeunit "Office Attachment Manager";
        ServerAttachmentFilePath: text;
        EmailAddress: text;
        ReportSelection: Record "Report Selections";
        MustSelectAndEmailBodyOrAttahmentErr: Label 'You must select an email body or attachment in report selection for %1.';
        EmailBodyText: Text;
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        AllEmailsWereSuccessful := TRUE;

        //>>
        //ShowNoBodyNoAttachmentError(ReportUsage,FoundBody,FoundAttachment);
        IF NOT (FoundBody OR FoundAttachment) THEN BEGIN
            ERROR(MustSelectAndEmailBodyOrAttahmentErr, ReportUsage);
        END;
        //<<

        IF FoundBody AND NOT FoundAttachment THEN BEGIN
            // Read email body from file for modern email
            if ServerEmailBodyFilePath <> '' then begin
                TempBlob.CreateInStream(InStr);
                InStr.ReadText(EmailBodyText);
            end;

            EmailMessage.Create(DefaultEmailAddress, 'Remittance Advice', EmailBodyText);
            AllEmailsWereSuccessful := Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        END;

        IF FoundAttachment THEN BEGIN
            WITH TempAttachReportSelections DO BEGIN
                OfficeAttachmentManager.IncrementCount(COUNT - 1);
                REPEAT
                begin
                    EmailAddress := COPYSTR(
                    GetNextEmailAddressFromCustomReportSelection(CustomReportSelection, DefaultEmailAddress, Usage.AsInteger(), Sequence), 1, MAXSTRLEN(EmailAddress));
                    ServerAttachmentFilePath := SaveReportAsPDF("Report ID", RecordVariant, "Custom Report Layout Code");

                    // Create modern email with attachment
                    Clear(EmailMessage);
                    if ServerEmailBodyFilePath <> '' then begin
                        TempBlob.CreateInStream(InStr);
                        InStr.ReadText(EmailBodyText);
                        EmailMessage.Create(EmailAddress, 'Remittance Advice', EmailBodyText);
                    end else begin
                        EmailMessage.Create(EmailAddress, 'Remittance Advice', '');
                    end;

                    EmailMessage.AddAttachment(ServerAttachmentFilePath, '', '');
                    AllEmailsWereSuccessful := AllEmailsWereSuccessful AND Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                end;
                UNTIL NEXT = 0;
            END;
        END;
        EXIT(AllEmailsWereSuccessful);
    end;

    // The Remittance is hidden behind standard option as it is not possible to extend it in this NAV version
    local procedure IsRemittanceReportUsage(ReportUsage: Integer) result: boolean;
    var
        ReportSelection: Record "Report Selections";
    begin
        // remittance journal - using numeric values for compatibility
        //if ReportUsage = 1116 then begin // P.Arch. Quote equivalent
        if ReportUsage = ReportSelection.Usage::"P.Arch.Quote".AsInteger() then begin
            exit(true);
        end;
        // remittance entries
        if ReportUsage = ReportSelection.Usage::"P.Arch.Order".AsInteger() then begin // P.Arch. Order equivalent
            Exit(true)
        end;

        Exit(false);
    end;

    procedure GetRemittanceJnlReportUsage() result: integer;
    var
        ReportSelection: Record "Report Selections";
    begin
        // remittance journal - using numeric value for compatibility
        Exit(ReportSelection.Usage::"P.Arch.Quote".AsInteger()); // P.Arch. Quote equivalent
    end;

    procedure GetRemittanceEntriesReportUsage() result: integer;
    var
        ReportSelection: Record "Report Selections";
    begin
        // remittance entries - using numeric value for compatibility
        Exit(ReportSelection.Usage::"P.Arch.Order".AsInteger()); // P.Arch. Order equivalent
    end;

    // Funciton copided from standard table 77
    LOCAL procedure SaveReportAsPDF(ReportID: Integer; RecordVariant: Variant; LayoutCode: Code[20]) FilePath: Text[250]
    var
        ReportLayoutSelection: record "Report Layout Selection";
        FileMgt: Codeunit "File Management";
    begin
        FilePath := COPYSTR(FileMgt.ServerTempFileName('pdf'), 1, 250);

        ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
        REPORT.SAVEASPDF(ReportID, FilePath, RecordVariant);
        ReportLayoutSelection.SetTempLayoutSelected('');

        COMMIT;
    end;

    // Funciton copided from standard table 77
    LOCAL procedure GetNextEmailAddressFromCustomReportSelection(VAR CustomReportSelection: Record "Custom Report Selection"; DefaultEmailAddress: Text; UsageValue: Integer; SequenceText: Text): Text
    var
        SequenceInteger: Integer;
    begin
        IF EVALUATE(SequenceInteger, SequenceText) THEN BEGIN
            CustomReportSelection.SETRANGE(Usage, UsageValue);
            CustomReportSelection.SETRANGE(Sequence, SequenceInteger);
            IF CustomReportSelection.FINDFIRST THEN
                IF CustomReportSelection."Send To Email" <> '' THEN
                    EXIT(CustomReportSelection."Send To Email");
        END;
        EXIT(DefaultEmailAddress);
    end;
    //#region Help Functions

    //#region "Change CHG003421"
    ///<summary>It subscribes to event OnBeforePostPurchaseDoc to change to check if the prevent line compression is on. If it is, the system will add dimension to it.</summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure PurchPost_OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
        TryPreventPurchCompression(PurchaseHeader);
    end;

    ///<summary>It implements the code required to prevent compression</summary>
    local procedure TryPreventPurchCompression(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        //DimShortCutNo: integer;
        DimValueCode: code[20];
        DimSetID: Integer;
    begin
        // Get Settings
        if NOT AdditionalSetup.Get then
            AdditionalSetup.Init();

        if NOT AdditionalSetup.ACO_PreventPurchLineCompression then
            exit;

        if AdditionalSetup.ACO_PreventPurchLineCompDimCode = '' then
            Error(Error001);

        PurchaseLine.setrange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.findset(true) then begin
            repeat
            begin
                DimValueCode := FORMAT(PurchaseLine."Line No.");

                // Try add dimension value if not already exist
                TryAddDimensionValue(AdditionalSetup.ACO_PreventPurchLineCompDimCode, DimValueCode);

                DimSetID := AddDimensionAndGetNewDimEntryNo(PurchaseLine."Dimension Set ID", AdditionalSetup.ACO_PreventPurchLineCompDimCode, DimValueCode, PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
                if DimSetID <> PurchaseLine."Dimension Set ID" then begin
                    PurchaseLine."Dimension Set ID" := DimSetID;
                    PurchaseLine.Modify;
                end;

            end;
            until PurchaseLine.next() = 0;
        end;
    end;

    ///<summary>It subscribes to event OnBeforePostSalesDoc to change to check if the prevent line compression is on. If it is, the system will add dimension to it.</summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure SalesPost_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        TryPreventSalesCompression(SalesHeader);
    end;

    ///<summary>It implements the code required to prevent compression</summary>
    local procedure TryPreventSalesCompression(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        //DimShortCutNo: integer;
        DimValueCode: code[20];
        DimSetID: Integer;
    begin
        // Get Settings
        if NOT AdditionalSetup.Get then
            AdditionalSetup.Init();

        if NOT AdditionalSetup.ACO_PreventSalesLineCompression then
            exit;

        if AdditionalSetup.ACO_PreventSalesLineCompDimCode = '' then
            Error(Error001);

        SalesLine.setrange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.findset(true) then begin
            repeat
            begin
                DimValueCode := FORMAT(SalesLine."Line No.");

                // Try add dimension value if not already exist
                TryAddDimensionValue(AdditionalSetup.ACO_PreventSalesLineCompDimCode, DimValueCode);

                DimSetID := AddDimensionAndGetNewDimEntryNo(SalesLine."Dimension Set ID", AdditionalSetup.ACO_PreventSalesLineCompDimCode, DimValueCode, SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
                if DimSetID <> SalesLine."Dimension Set ID" then begin
                    SalesLine."Dimension Set ID" := DimSetID;
                    SalesLine.Modify;
                end;

            end;
            until SalesLine.next() = 0;
        end;
    end;

    LOCAL procedure AddDimensionAndGetNewDimEntryNo(pDimSetID: Integer; pDimCode: code[20]; pDimValueCode: code[20]; var pGlobalDimValueCode1: code[20]; var pGlobalDimValueCode2: code[20]): Integer;
    var
        DimMgt: Codeunit DimensionManagement;
        DimSetEntryTMP: Record "Dimension Set Entry" temporary;
        DimNo: Integer;
    begin
        // Prepare Record        
        DimMgt.GetDimensionSet(DimSetEntryTmp, pDimSetID);

        // Try insert new dimension if not exist
        DimSetEntryTmp.INIT();
        DimSetEntryTMP."Dimension Set ID" := pDimSetID;
        DimSetEntryTMP.VALIDATE("Dimension Code", pDimCode);
        DimSetEntryTMP.VALIDATE("Dimension Value Code", pDimValueCode);
        IF DimSetEntryTMP.Insert() then;

        // Update Global Dimensions if needed
        DimNo := GetDimShortCutNo(pDimCode);
        if DimNo = 1 then begin
            if DimSetEntryTMP.get(pDimSetID, pDimCode) then
                pGlobalDimValueCode1 := DimSetEntryTMP."Dimension Value Code";
        end;
        if DimNo = 2 then begin
            if DimSetEntryTMP.get(pDimSetID, pDimCode) then
                pGlobalDimValueCode2 := DimSetEntryTMP."Dimension Value Code";
        end;

        // return new Dimension set ID
        exit(DimMgt.GetDimensionSetID(DimSetEntryTmp));
    end;

    LOCAL procedure GetDimShortCutNo(DimCode: code[20]): Integer;
    var
        GLSetup: Record "General Ledger Setup";
        i: Integer;
    begin
        GLSetup.GET;

        if DimCode = GLSetup."Shortcut Dimension 1 Code" then
            exit(1);
        if DimCode = GLSetup."Shortcut Dimension 2 Code" then
            exit(2);
        if DimCode = GLSetup."Shortcut Dimension 3 Code" then
            exit(3);
        if DimCode = GLSetup."Shortcut Dimension 4 Code" then
            exit(4);
        if DimCode = GLSetup."Shortcut Dimension 5 Code" then
            exit(5);
        if DimCode = GLSetup."Shortcut Dimension 6 Code" then
            exit(6);
        if DimCode = GLSetup."Shortcut Dimension 7 Code" then
            exit(7);
        if DimCode = GLSetup."Shortcut Dimension 8 Code" then
            exit(8);

        exit(-1)
    end;

    procedure TryAddDimensionValue(DimCode: code[20]; DimValueCode: code[20]);
    var
        DimValue: Record "Dimension Value";
    begin
        IF DimValue.GET(DimCode, DimValueCode) then
            exit;

        DimValue.Init();
        DimValue.Validate("Dimension Code", DimCode);
        DimValue.Validate("Code", DimValueCode);
        DimValue.Name := Text001;
        DimValue.Insert(true);
    end;

    ///<summary>It subscribes to event OnAfterCopyGLEntryFromGenJnlLine to change the description with the Sales or Purchase doc line description if the compression is enabled on the Additional setup</summary>
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(VAR GLEntry: Record "G/L Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    var
        SalesInvLine: Record "Sales Invoice Line";
        PurchInvLine: Record "Purch. Inv. Line";
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        AddSetup: Record ACO_AdditionalSetup;
        LineNo: Integer;
    begin
        if Not (AddSetup.Get) then
            exit;

        //checking whether we are considering a Sales or a Purchase Line
        case GenJournalLine."Gen. Posting Type" of
            GenJournalLine."Gen. Posting Type"::Sale:
                begin
                    //If we are considering an Invoice
                    if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then
                        //I will check whether the user enabled the compression and populated the dim code needed to get the Document Line No
                        If (AddSetup.ACO_PreventSalesLineCompression and (AddSetup.ACO_PreventSalesLineCompDimCode <> '')) then begin
                            DimMgt.GetDimensionSet(TempDimSetEntry, GLEntry."Dimension Set ID");
                            TempDimSetEntry.SetRange("Dimension Code", AddSetup.ACO_PreventSalesLineCompDimCode);
                            IF TempDimSetEntry.FindFirst then begin
                                //with the Document Type and Document No on the GL Entry and the Line No as Dimension, I will find the related invoice line
                                Evaluate(LineNo, TempDimSetEntry."Dimension Value Code");
                                if SalesInvLine.Get(GenJournalLine."Document No.", LineNo) then
                                    //and change the description with the Invoice line description
                                    GLEntry.Description := SalesInvLine.Description;
                            end;
                        end;
                end;

            //checking whether we are considering a Sales or a Purchase Line
            GenJournalLine."Gen. Posting Type"::Purchase:
                begin
                    //If we are considering an Invoice
                    if GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice then
                        //I will check whether the user enabled the compression and populated the dim code needed to get the Document Line No
                        If (AddSetup.ACO_PreventPurchLineCompression and (AddSetup.ACO_PreventPurchLineCompDimCode <> '')) then begin
                            DimMgt.GetDimensionSet(TempDimSetEntry, GLEntry."Dimension Set ID");
                            TempDimSetEntry.SetRange("Dimension Code", AddSetup.ACO_PreventPurchLineCompDimCode);
                            IF TempDimSetEntry.FindFirst then begin
                                //with the Document Type and Document No on the GL Entry and the Line No as Dimension, I will find the related invoice line
                                Evaluate(LineNo, TempDimSetEntry."Dimension Value Code");
                                if PurchInvLine.Get(GenJournalLine."Document No.", LineNo) then
                                    //and change the description with the Invoice line description
                                    GLEntry.Description := PurchInvLine.Description;
                            end;
                        end;
                end;
        end;
    end;

    //#endregion "Change CHG003421" 

    var
        lEmailSentLbl: Label 'An email message(s) has been sent';
        AdditionalSetup: record ACO_AdditionalSetup;
        Error001: Label 'The Dimension Code value is missing in the Prevent Line Compression configuration. Please review Additional Setup page';
        Text001: Label 'Created by System';
}