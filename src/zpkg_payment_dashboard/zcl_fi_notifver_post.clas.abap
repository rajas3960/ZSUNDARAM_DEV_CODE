        CLASS zcl_fi_notifver_post DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'NOTIFVER'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Pay Status data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_FVER_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_FVER_ALOGS_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

    METHODS constructor.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_FI_NOTIFVER_POST IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    TRY.
        application_log = cl_bali_log=>create_with_header(
                               header = cl_bali_header_setter=>create( object = 'ZAPP_NOTIFVER_01_LOG'
                                                                       subobject = 'ZAPP_NOTIFVER_01_SUB'
                                                                       external_id = 'NOTIFVER' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA lv_xtring TYPE string.
    DATA: content(1024).
    DATA: body        TYPE string,
          l_mail      TYPE cl_bcs_mail_message=>ty_address,
          lt_notiflog TYPE TABLE OF zdt_pay_notif,
          lt_selopt   TYPE RANGE OF char15,
          l_date      TYPE datum,
          l_fiscalyear TYPE n LENGTH 4.

    "=====================================================================
    "Verifier - KZ First Level
    SELECT a1~Supplier,a~AccountingDocument AS Accountingdoc,a~FiscalYear AS Fiscalyear,a~CompanyCode AS Companycode,
    d~PaymentRunID AS paymentrunid,a~PostingDate AS postingdate,f~SupplierName AS suppliername,
    SUM( a~AmountInCompanyCodeCurrency ) AS AmountInCompanyCodeCurrency,a~CompanyCodeCurrency,d~PayeeBankKey,
    CASE WHEN c~accountingdoc IS NOT INITIAL THEN 'X' ELSE 'Y' END AS accdoc,c~status,z~type,e~BankName,e~BankAccountNumber AS BankNumber
    FROM zv_payment_head_l2 AS a
    INNER JOIN zv_payment_head_l3 AS a1
    ON ( a1~AccountingDocument = a~AccountingDocument AND a1~FiscalYear = a~FiscalYear
         AND a1~CompanyCode = a~CompanyCode )
    LEFT OUTER JOIN I_PaymentProposalPayment  AS d ON  ( d~PaymentDocument      = a~AccountingDocument
                                                         AND d~PayingCompanyCode    = a~CompanyCode
                                                         AND d~FinancialAccountType = 'K' )
    LEFT OUTER JOIN I_HouseBankAccountLinkage AS e ON (
      e~CompanyCode          = a~CompanyCode
      AND e~HouseBank        = a~HouseBank
      AND e~HouseBankAccount = a~HouseBankAccount
    )
    LEFT OUTER JOIN i_supplier AS f ON ( f~Supplier = a1~Supplier )
    LEFT OUTER JOIN zdt_payment_head AS c ON ( c~accountingdoc = a~AccountingDocument
                                                         AND c~fiscalyear    = a~FiscalYear
                                                         AND c~companycode   = a~CompanyCode )
    LEFT OUTER JOIN zdt_pay_notif AS z ON ( z~accountingdoc = a~AccountingDocument
                                                         AND z~fiscalyear    = a~FiscalYear
                                                         AND z~companycode   = a~CompanyCode
                                                         AND z~type = 'V')
    WHERE ( a~AccountingDocumentType = 'KZ' ) AND ( a~FiscalYear >= '2025')
    GROUP BY a1~Supplier,a~AccountingDocument,a~FiscalYear,a~CompanyCode,d~PaymentRunID,a~PostingDate,f~SupplierName,
    a~CompanyCodeCurrency,d~PayeeBankKey,c~accountingdoc,c~status,z~type,e~BankName,e~BankAccountNumber
    INTO TABLE @DATA(lt_notif).
    IF sy-subrc EQ 0.
      DELETE lt_notif WHERE accdoc = 'X'. "Delete the documents carried forward for processing
      DATA(l_count) = REDUCE #( INIT s TYPE int8 FOR wa IN lt_notif WHERE ( type = '' ) NEXT s = s + 1 ).
      IF l_count EQ 0. "Delete All
        DELETE lt_notif WHERE accountingdoc IS NOT INITIAL.
      ENDIF.
*      DELETE lt_notif WHERE type = 'V'.
      SORT lt_notif BY supplier accountingdoc fiscalyear companycode.
      DELETE ADJACENT DUPLICATES FROM lt_notif COMPARING supplier accountingdoc fiscalyear companycode.
    ENDIF.


    IF lt_notif[] IS NOT INITIAL.
      body = '<html><body>Dear All,<br>Below are the Payments Pending for Verification.Please login to the below URL & Verify.<br>'.
      IF sy-sysid = 'YYQ'.
        body = body && '<p><b>Link: https://my402420.s4hana.cloud.sap/ui#zfipaymentdash-display</p><br>'.
      ELSEIF sy-sysid = 'X6V'.
        body = body && '<p><b>Link: https://my403791.s4hana.cloud.sap/ui#zfipaymentdash-display</p><br>'.
      ELSEIF sy-sysid = 'XDA'.
        body = body && '<p><b>Link: https://my404341.s4hana.cloud.sap/ui#zfipaymentdash-display</p><br>'.
      ENDIF.
      body = body && '<table border = "1">'.
      body = body && '<tr><th style="background-color: #C3F8FF">Accounting Doc</th>'.
      body = body && '<th style="background-color: #C3F8FF">Fiscal Year</th>'.
      body = body && '<th style="background-color: #C3F8FF">Company Code</th>'.
      body = body && '<th style="background-color: #C3F8FF">Run ID</th>'.
      body = body && '<th style="background-color: #C3F8FF">Posting Date</th>'.
      body = body && '<th style="background-color: #C3F8FF">Supplier</th>'.
      body = body && '<th style="background-color: #C3F8FF">Supplier Name</th>'.
      body = body && '<th style="background-color: #C3F8FF">Amount</th>'.
      body = body && '<th style="background-color: #C3F8FF">Currency</th>'.
      body = body && '<th style="background-color: #C3F8FF">Bank</th>'.
      body = body && '<th style="background-color: #C3F8FF">Bank Account</th>'.
      body = body && '<th style="background-color: #C3F8FF">Payment Method</th></tr>'.
      SORT lt_notif BY Supplier.
      LOOP AT lt_notif INTO DATA(ls_notif).
        DATA(ls_notif_temp) = ls_notif.
        body = body && '<tr><td>' && ls_notif-Accountingdoc && '</td>'.
        body = body && '<td>' && ls_notif-Fiscalyear && '</td>'.
        body = body && '<td>' && ls_notif-CompanyCode && '</td>'.
        body = body && '<td>' && ls_notif-PaymentRunID && '</td>'.
        body = body && '<td>' && ls_notif-PostingDate+6(2) && '/' && ls_notif-PostingDate+4(2) && '/' &&
               ls_notif-PostingDate+0(4) && '</td>'.
        body = body && '<td>' && ls_notif-Supplier && '</td>'.
        body = body && '<td>' && ls_notif-SupplierName && '</td>'.

        ls_notif-amountincompanycodecurrency = COND #( WHEN ls_notif-amountincompanycodecurrency < 0 THEN
        (  ls_notif-amountincompanycodecurrency * -1 ) ELSE ls_notif-amountincompanycodecurrency ).

        body = body && '<td>' && ls_notif-AmountInCompanyCodeCurrency && '</td>'.
        body = body && '<td>' && ls_notif-CompanyCodeCurrency && '</td>'.
        body = body && '<td>' && ls_notif-BankName && '</td>'.
        body = body && '<td>' && ls_notif-BankNumber && '</td>'.

        IF ls_notif-PayeeBankKey CS 'HDFC'.
          body = body && '<td>' && 'Intra Bank Transfer' && '</td></tr>'.
        ELSE.
          IF ls_notif-amountincompanycodecurrency > 200000.
            body = body && '<td>' && 'RTGS' && '</td></tr>'.
          ELSE.
            body = body && '<td>' && 'NEFT' && '</td></tr>'.
          ENDIF.
        ENDIF.
        AT END OF supplier.
          DATA(l_amtsub) = REDUCE #( INIT a TYPE dmbtr FOR wa IN lt_notif WHERE ( supplier = ls_notif_temp-Supplier )
          NEXT a = a + wa-AmountInCompanyCodeCurrency ).
          l_amtsub = COND #( WHEN l_amtsub < 0 THEN ( l_amtsub * -1 ) ELSE l_amtsub ).
          body = body && '<tr><td style="font-weight: bold;background-color: #FEDE93">Sub Total</td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93">' && l_amtsub && '</td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td></tr>'.
        ENDAT.
      ENDLOOP.
      DATA(l_amt) = REDUCE #( INIT a TYPE dmbtr FOR wa IN lt_notif NEXT a = a + wa-AmountInCompanyCodeCurrency ).
      l_amt = COND #( WHEN l_amt < 0 THEN ( l_amt * -1 ) ELSE l_amt ).
      body = body && '<tr><td style="font-weight: bold;background-color: #FA8072">Grand Total</td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072">' && l_amt && '</td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td></tr></table></b>'.
      ENDIF.

      "Verifier - ZP Payment Proposal
      l_date  = sy-datum - 15.
      SELECT a~Supplier,concat( a~PaymentRunDate,a~PaymentRunID ) AS uuid,a~PaymentRunDate,a~PaymentRunID,a~PayingCompanyCode,e~BankName,
      e~BankAccountNumber AS BankNumber,
      f~SupplierName AS suppliername,SUM( a~PaymentAmountInPaytCurrency ) AS Amount,a~PaymentCurrency,a~PayeeBankKey,
      concat( right( a~PaymentRunDate,5 ) ,a~PaymentRunID ) AS tuuid,z~type
      FROM I_PaymentProposalPayment AS a
      LEFT OUTER JOIN I_HouseBankAccountLinkage AS e ON (
      e~CompanyCode          = a~PayingCompanyCode
      AND e~HouseBank        = a~HouseBank
      AND e~HouseBankAccount = a~HouseBankAccount )
      LEFT OUTER JOIN i_supplier AS f ON ( f~Supplier = a~Supplier )
      LEFT OUTER JOIN zdt_pay_notif AS z ON
      ( z~accountingdoc = concat( right( a~PaymentRunDate,5 ) ,a~PaymentRunID )
                                                         AND z~companycode   = a~PayingCompanyCode
                                                         AND z~type = 'P')
      WHERE ( a~PaymentRunIsProposal = 'X' AND a~PaymentDocument <> '' ) AND ( a~PaymentRunDate >= @l_date )
      GROUP BY a~PaymentRunDate,a~PaymentRunID,a~PayingCompanyCode,a~Supplier,e~BankName,e~BankAccountNumber,f~SupplierName,
      a~PaymentCurrency,a~PayeeBankKey,z~type
      ORDER BY a~PaymentRunDate,a~PaymentRunID
      INTO TABLE @DATA(lt_proposal).
      IF sy-subrc EQ 0.
        SELECT 'I' AS sign,'EQ' AS option,concat( a~PaymentRunDate,a~PaymentRunID ) AS low
        FROM I_PaymentProposalPayment AS a
        WHERE ( a~PaymentRunIsProposal <> 'X' ) AND ( a~PaymentRunDate >= @l_date )
        GROUP BY a~PaymentRunDate,a~PaymentRunID
        INTO TABLE @lt_selopt.
        IF sy-subrc EQ 0.
          DELETE lt_proposal WHERE uuid IN lt_selopt.
        ENDIF.
        l_count = REDUCE #( INIT s TYPE int8 FOR wa1 IN lt_proposal WHERE ( type = '' ) NEXT s = s + 1 ).
        IF l_count EQ 0. "Delete All
           DELETE lt_proposal WHERE uuid IS NOT INITIAL.
        ENDIF.
      ENDIF.

      SORT lt_proposal BY Supplier PaymentRunDate PaymentRunID.
      DELETE ADJACENT DUPLICATES FROM lt_proposal COMPARING Supplier PaymentRunDate PaymentRunID.
      "=============

      IF lt_proposal[] IS NOT INITIAL.
       IF lt_notif[] IS INITIAL.
        body = '<html><body>Dear All,'.
       ENDIF.
      body = body && '<br>Following are the Payments Pending for Verification in Manage Automatic Payments App.Please login to the below URL & Verify.<br>'.
      IF sy-sysid = 'YYQ'.
        body = body && '<p><b>Link: https://my402420.s4hana.cloud.sap/ui#AutomaticPayment-schedulePaymentProposal</p><br>'.
      ELSEIF sy-sysid = 'X6V'.
        body = body && '<p><b>Link: https://my403791.s4hana.cloud.sap/ui#AutomaticPayment-schedulePaymentProposal</p><br>'.
      ELSEIF sy-sysid = 'XDA'.
        body = body && '<p><b>Link: https://my404341.s4hana.cloud.sap/ui#AutomaticPayment-schedulePaymentProposal</p><br>'.
      ENDIF.
      body = body && '<table border = "1">'.
      body = body && '<tr><th style="background-color: #C3F8FF">Fiscal Year</th>'.
      body = body && '<th style="background-color: #C3F8FF">Company Code</th>'.
      body = body && '<th style="background-color: #C3F8FF">Run ID</th>'.
      body = body && '<th style="background-color: #C3F8FF">Proposal Date</th>'.
      body = body && '<th style="background-color: #C3F8FF">Supplier</th>'.
      body = body && '<th style="background-color: #C3F8FF">Supplier Name</th>'.
      body = body && '<th style="background-color: #C3F8FF">Amount</th>'.
      body = body && '<th style="background-color: #C3F8FF">Currency</th>'.
      body = body && '<th style="background-color: #C3F8FF">Bank</th>'.
      body = body && '<th style="background-color: #C3F8FF">Bank Account</th>'.
      body = body && '<th style="background-color: #C3F8FF">Payment Method</th></tr>'.
      SORT lt_notif BY Supplier.
      LOOP AT lt_proposal INTO DATA(ls_proposal).
        DATA(ls_proposal_temp) = ls_proposal.
        IF ( ls_proposal-PaymentRunDate+4(2) = '01' ) OR ( ls_proposal-PaymentRunDate+4(2) = '02' ) OR ( ls_proposal-PaymentRunDate+4(2) = '03' ).
        l_fiscalyear = ls_proposal-PaymentRunDate+0(4).
        l_fiscalyear = l_fiscalyear - 1.
        ELSE.
        l_fiscalyear = ls_proposal-PaymentRunDate+0(4).
        ENDIF.
        body = body && '<tr><td>' && l_fiscalyear && '</td>'.
        body = body && '<td>' && ls_proposal-PayingCompanyCode && '</td>'.
        body = body && '<td>' && ls_proposal-PaymentRunID && '</td>'.
        body = body && '<td>' && ls_proposal-PaymentRunDate+6(2) && '/' && ls_proposal-PaymentRunDate+4(2) && '/' &&
               ls_proposal-PaymentRunDate+0(4) && '</td>'.
        body = body && '<td>' && ls_proposal-Supplier && '</td>'.
        body = body && '<td>' && ls_proposal-SupplierName && '</td>'.

        ls_proposal-Amount = COND #( WHEN ls_proposal-Amount < 0 THEN (  ls_proposal-Amount * -1 ) ELSE ls_proposal-Amount ).

        body = body && '<td>' && ls_proposal-Amount && '</td>'.
        body = body && '<td>' && ls_proposal-PaymentCurrency && '</td>'.
        body = body && '<td>' && ls_proposal-BankName && '</td>'.
        body = body && '<td>' && ls_proposal-BankNumber && '</td>'.

        IF ls_proposal-PayeeBankKey CS 'HDFC'.
          body = body && '<td>' && 'Intra Bank Transfer' && '</td></tr>'.
        ELSE.
          IF ls_proposal-Amount > 200000.
            body = body && '<td>' && 'RTGS' && '</td></tr>'.
          ELSE.
            body = body && '<td>' && 'NEFT' && '</td></tr>'.
          ENDIF.
        ENDIF.
        AT END OF supplier.
          l_amtsub = REDUCE #( INIT a TYPE dmbtr FOR wa1 IN lt_proposal WHERE ( supplier = ls_proposal_temp-Supplier )
          NEXT a = a + wa1-Amount ).
          l_amtsub = COND #( WHEN l_amtsub < 0 THEN ( l_amtsub * -1 ) ELSE l_amtsub ).
          body = body && '<tr><td style="font-weight: bold;background-color: #FEDE93">Sub Total</td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93">' && l_amtsub && '</td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td>'.
          body = body && '<td style="font-weight: bold;background-color: #FEDE93"></td></tr>'.
        ENDAT.
      ENDLOOP.
      l_amt = REDUCE #( INIT a TYPE dmbtr FOR wa1 IN lt_proposal NEXT a = a + wa1-Amount ).
      l_amt = COND #( WHEN l_amt < 0 THEN ( l_amt * -1 ) ELSE l_amt ).
      body = body && '<tr><td style="font-weight: bold;background-color: #FA8072">Grand Total</td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072">' && l_amt && '</td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td>'.
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td></tr></table></b>'.
      ENDIF.

       body = body && '</body><br>Best Regards,<br>Dhunseri Poly Films Private Limited<br>'
                  && 'NOTE : This is a system generated mail, please do not reply.<br></html>'.
      "=============
      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
          lo_mail->set_sender( 'no-reply@aspetindia.com' ).

          SELECT b~EmailAddress FROM ztmg_appr_matrix AS a
          INNER JOIN I_BusPartEmailAddressTP_3 AS b
          ON ( b~BusinessPartner = right( a~userid,10 ) )
          WHERE a~apprlevel   = '1' AND a~final = 'X'
          ORDER BY b~EmailAddress
          INTO TABLE @DATA(lt_mail).
          IF sy-subrc EQ 0.
            DELETE ADJACENT DUPLICATES FROM lt_mail COMPARING EmailAddress.
          ENDIF.

          IF lt_mail[] IS NOT INITIAL.
            LOOP AT lt_mail INTO DATA(ls_mail).
              l_mail = ls_mail-EmailAddress.
              lo_mail->add_recipient( l_mail ).
            ENDLOOP.

*        lo_mail->add_recipient( iv_address = 'naresh.agarwal@dhunseripolyfilms.com'
*                                iv_copy    = cl_bcs_mail_message=>cc ).
*        lo_mail->add_recipient( iv_address = 'rajesh.poddar@aspetindia.com'
*                                iv_copy    = cl_bcs_mail_message=>cc ).

            CLEAR content.
            content = 'Payments || Pending for Verification'.
            lo_mail->set_subject( content ).
            lo_mail->set_main(
                cl_bcs_mail_textpart=>create_instance(
                    iv_content      = body
                    iv_content_type = 'text/html' ) ).

            " TODO: variable is assigned but never used (ABAP cleaner)
            IF lt_proposal[] IS INITIAL AND lt_notif[] IS INITIAL.
            ELSE.
            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
            COMMIT WORK.
            IF sy-subrc IS INITIAL.
            ENDIF.
            lt_notiflog[] = VALUE #( FOR wa IN lt_notif ( accountingdoc = wa-accountingdoc
                                                          fiscalyear    = wa-fiscalyear companycode = wa-companycode type = 'V' senton = sy-datum
                                                          sentat        = sy-uzeit      sentby      = sy-uname ) ).
            LOOP AT lt_proposal INTO ls_proposal.
                APPEND VALUE #( accountingdoc = ls_proposal-tuuid companycode = ls_proposal-PayingCompanyCode type = 'P'
                senton = sy-datum sentat = sy-uzeit sentby = sy-uname ) TO lt_notiflog.
            ENDLOOP.
            MODIFY zdt_pay_notif FROM TABLE @lt_notiflog[].
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
            ENDIF.
          ENDIF.
        CATCH cx_bcs_mail INTO DATA(lx_mail). " TODO: variable is assigned but never used (ABAP cleaner)
          " handle exceptions here
      ENDTRY.
      " TODO: remove needless CLEAR (ABAP cleaner)

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
