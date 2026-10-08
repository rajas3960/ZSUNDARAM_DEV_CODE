CLASS lhc_ZI_bank_stat_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ZI_bank_stat_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZI_bank_stat_head RESULT result.

    METHODS approve1 FOR MODIFY
      IMPORTING keys FOR ACTION ZI_bank_stat_head~approve1 RESULT result.
    METHODS approve2 FOR MODIFY
      IMPORTING keys FOR ACTION ZI_bank_stat_head~approve2 RESULT result.
    METHODS approve3 FOR MODIFY
      IMPORTING keys FOR ACTION ZI_bank_stat_head~approve3 RESULT result.
    METHODS Reject1 FOR MODIFY
      IMPORTING keys FOR ACTION ZI_bank_stat_head~Reject1 RESULT result.
ENDCLASS.

CLASS lhc_ZI_bank_stat_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD approve1.

    DATA lv_utr TYPE string.
    DATA:ls_head TYPE zdt_payment_head.
    TYPES: BEGIN OF ty_type,
             login_id       TYPE string,
             input_gcif     TYPE string,
             cbx_api_ref_no TYPE string,
             txndate        TYPE string,
           END OF ty_type.
    DATA: ls_paystat TYPE ty_type.
    DATA: lv_json_post TYPE string VALUE ''.

    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-Accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-Fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-Companycode OPTIONAL ).

    SELECT SINGLE * FROM zdt_payment_head WHERE accountingdoc = @l_accdoc
    AND fiscalyear = @l_fiscyear AND companycode = @l_comp
    INTO @DATA(l_head).
    IF l_head-appr1 = 'X' AND ( l_head-status = 'Sent to Bank' OR l_head-status = 'Failed' )." AND l_head-appr2 = 'X' AND l_head-appr3 = 'X'.

      " get status from bank
      IF sy-sysid = 'PZJ'.
        ls_paystat-input_gcif = 'CBXMGRT4'.
        ls_paystat-login_id = 'APIUSER@CBXMGRT4'.
      ELSEIF sy-sysid = 'A1S'.
        ls_paystat-input_gcif = 'CBXMGRT4'.
        ls_paystat-login_id = 'APIUSER@CBXMGRT4'.
      ELSEIF sy-sysid = 'AYR'.
        ls_paystat-input_gcif = 'DHUNSERIPCX'.
        ls_paystat-login_id = 'APIUSER'.
      ENDIF.
      ls_paystat-cbx_api_ref_no = l_accdoc && l_fiscyear && l_comp.
      ls_paystat-txndate = l_head-senton+0(4) && '-' && l_head-senton+4(2) && '-' && l_head-senton+6(2).

      /ui2/cl_json=>serialize( EXPORTING data = ls_paystat RECEIVING r_json = lv_json_post ).
      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_PAYSTATUS'
                                                                                           service_id    = 'ZFI_PAYSTATUS_REST' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          lo_request->set_text( lv_json_post ).
          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close(  ).
          CLEAR lv_json_post.

        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
      ENDTRY.
*
      TYPES: BEGIN OF ty_data_reject,
               input_user_no        TYPE string,
               lei_expiry_date      TYPE  string,
               od_txn_type          TYPE  string,
               od_bsn_prod          TYPE  string,
               initiatedate_time    TYPE  string,
               paymentrefno         TYPE  string,
               txn_status           TYPE  string,
               od_txn_ccy           TYPE  string,
               od_status_desc       TYPE  string,
               bene_narration       TYPE  string,
               lei_code             TYPE  string,
               od_acc_no            TYPE  string,
               od_maker_date        TYPE  string,
               od_gcif              TYPE  string,
               txn_ref_num          TYPE  string,
               status               TYPE  string,
               origin               TYPE  string,
               od_reject_reason     TYPE  string,
               od_channel_desc      TYPE  string,
               ifsc_code            TYPE  string,
               product              TYPE  string,
               od_bsn_code          TYPE  string,
               od_maker_id          TYPE  string,
               auth_allowed         TYPE  string,
               remark               TYPE  string,
               od_status            TYPE  string,
               parent_ref_no        TYPE  string,
               check_same_bene_flag TYPE  string,
               debit_acc_no         TYPE  string,
               sub_product          TYPE  string,
               od_lcy_amount        TYPE  string,
               bene_name            TYPE  string,
               od_amount            TYPE  string,
               od_value_date        TYPE  string,
               entitled             TYPE  string,
               transfer_type_desc   TYPE string,
               bene_acc_no          TYPE  string,
               action               TYPE  string,
               total_count          TYPE  string,
               od_maker_name        TYPE  string,
               transfer_type        TYPE  string,
               input_ver_no         TYPE  string,
               hold_remark_ind      TYPE  string,
               reference_no         TYPE  string,
               input_host_code      TYPE  string,
             END OF ty_data_reject.
      TYPES: BEGIN OF ty_data_success,
               host_file_ind       TYPE string,
               od_auth_date        TYPE string,
               input_user_no       TYPE string,
               initiatedate_time   TYPE string,
               paymentrefno        TYPE string,
               txn_status          TYPE string,
               credit_acc_no       TYPE string,
               business_prod_desc  TYPE string,
               txn_reference_no    TYPE string,
               lei_code            TYPE string,
               od_acc_no           TYPE string,
               origin              TYPE string,
               od_gcif             TYPE string,
               od_reject_reason    TYPE string,
               ifsc_code           TYPE string,
               nodal_approval      TYPE string,
               product             TYPE string,
               od_maker_id         TYPE string,
               handoff_code        TYPE string,
               org_pay_prod        TYPE string,
               currency            TYPE string,
               od_status           TYPE string,
               debit_acc_no        TYPE string,
               sub_product         TYPE string,
               od_auth_name        TYPE string,
               business_product_id TYPE string,
               od_amount           TYPE string,
               bene_name           TYPE string,
               maker_date          TYPE string,
               value_date          TYPE string,
               bene_nm_frm_host    TYPE string,
               batchrefno          TYPE string,
               transfer_type_desc  TYPE string,
               action              TYPE string,
               total_count         TYPE string,
               od_maker_name       TYPE string,
               transfer_type       TYPE string,
               input_ver_no        TYPE string,
               reference_no        TYPE string,
               utr_no              TYPE string,
             END OF ty_data_success.
      TYPES: BEGIN OF ty_errors,
               code       TYPE char10,
               field      TYPE char20,
               message    TYPE char255,
               resourceId TYPE char40,
             END OF ty_errors.

      DATA: ls_data TYPE ty_data_reject.
      DATA: ls_data_success TYPE ty_data_success.
      DATA: ls_errors   TYPE ty_errors,
            l_errors    TYPE flag,
            l_donothing TYPE flag.
      IF ls_result CS 'valErrors'.

        SPLIT ls_result AT '[' INTO DATA(lv_e1) DATA(lv_e2).
        SPLIT lv_e2 AT ']' INTO DATA(lv_e3) DATA(lv_e4).

        /ui2/cl_json=>deserialize( EXPORTING json = lv_e3 CHANGING data = ls_errors ).

        l_errors = 'X'.
        "  ELSE. "Might be rejected,Processed,Payload = Parse into a structure and handle that
      ELSEIF ls_result CS '"TXN_STATUS":"TXCOMP"' OR
             ls_result CS '"TXN_STATUS":"3"' OR
             ls_result CS '"TXN_STATUS":"TXDSETT"' OR
             ls_result CS '"TXN_STATUS":"Processed"' OR
               ( ls_result CS '"TXN_STATUS":"Completed"' AND sy-sysid <> 'AYR' ) OR
               ( ls_result CS '"TXN_STATUS":"Inquiry Initiated"' AND sy-sysid <> 'AYR' ).

        SPLIT ls_result AT '[' INTO DATA(lv_s1) DATA(lv_s2).
        SPLIT lv_s2 AT ']' INTO DATA(lv_s3) DATA(lv_s4).

        /ui2/cl_json=>deserialize( EXPORTING json = lv_S3 CHANGING data = ls_data_success ).

        IF ls_data_success-txn_status = 'TXCOMP' OR ls_data_success-txn_status = '3' OR ls_data_success-txn_status = 'TXDSETT'
           OR ls_data_success-txn_status = 'Processed'
             OR ( ls_data_success-txn_status = 'Completed' AND sy-sysid <> 'AYR' )
             OR ( ls_data_success-txn_status = 'Inquiry Initiated' AND sy-sysid <> 'AYR' ).
          IF l_head-payeebankkey CS 'HDFC'.
            lv_utr = ls_data_success-txn_reference_no.
          ELSE.
            lv_utr = ls_data_success-utr_no.
          ENDIF.
          DATA(lv_status1) =  ls_data_success-txn_status.
        ENDIF.

      ELSE.
        SPLIT ls_result AT '[' INTO DATA(lv1) DATA(lv2).
        SPLIT lv2 AT ']' INTO DATA(lv3) DATA(lv4).

        /ui2/cl_json=>deserialize( EXPORTING json = lv3 CHANGING data = ls_data ).

        IF ls_data-txn_status = '0' OR ls_data-txn_status = 'RV' OR ls_data-txn_status = 'RR' OR ls_data-txn_status = 'PR' OR
           ls_data-txn_status = 'DR' OR ls_data-txn_status = 'AO' OR ls_data-txn_status = 'RA' OR ls_data-txn_status = 'LK' OR
           ls_data-txn_status = 'TXPDAUTH' OR ls_data-txn_status = 'TXPARK' OR ls_data-txn_status = 'TXNVIP' OR
           ls_data-txn_status = 'TXDRHD' OR ls_data-txn_status = 'TXDBPR' OR ls_data-txn_status = 'TXBVSU' OR
           ls_data-txn_status = 'TXBVSP' OR ls_data-txn_status = 'TXAWRB' OR ls_data-txn_status = 'TXAUTH' OR
           ls_data-txn_status = 'TXAICN' OR ls_data-txn_status = 'TXAGWT' OR ls_data-txn_status = 'TRBLWT' OR
           ls_data-txn_status = 'TLCWT' OR ls_data-txn_status = 'PRTXINPR' OR ls_data-txn_status = 'NDF' OR
           ls_data-txn_status = 'UNKNOWN' OR  ls_data-txn_status = 'CI' OR  ls_data-txn_status = 'IO' OR ls_data-txn_status = 'LK' OR
           ls_data-txn_status = 'TXWRHD' OR ls_data-txn_status = '70008' OR ls_data-txn_status = '70009' OR
           ls_data-txn_status = 'ENTL_ERR' OR ls_data-txn_status = 'U' OR  ls_data-txn_status = 'TXSIP' OR
           ls_data-txn_status = 'TXSETT' OR  ls_data-txn_status = 'TXPDST' OR ls_data-txn_status = 'TXTRHOLD' OR ls_data-txn_status = 'N'.
          " lv_utr = ls_data-reference_no.
          DATA(lv_status) =  ls_data-od_status_desc.
          l_donothing = 'X'.
        ELSE.
          l_errors = 'X'.
        ENDIF.

      ENDIF.


      IF lv_utr IS INITIAL.
        IF lv_status IS NOT INITIAL AND l_donothing = 'X'.
          MODIFY ENTITIES OF zi_bank_stat_head IN LOCAL MODE
              ENTITY zi_bank_stat_head
                 UPDATE FROM VALUE #( FOR key IN keys
                                      ( Accountingdoc         = key-Accountingdoc
                                        Fiscalyear            = key-Fiscalyear
                                        Companycode           = key-Companycode
                                     "   utr             = lv_utr
                                        appr1comment          = lv_status
                                      "  %control-utr    = if_abap_behv=>mk-on
                                        %control-Appr1comment = if_abap_behv=>mk-on
                                      ) )
                 FAILED failed
                 REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
            ENTITY zi_bank_stat_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT DATA(heads).


          result = VALUE #( FOR head IN heads
                            ( %tky   = head-%tky
                              %param = head ) ).
        ELSEIF l_errors = 'X'.
          MODIFY ENTITIES OF zi_bank_stat_head IN LOCAL MODE
             ENTITY zi_bank_stat_head
                UPDATE FROM VALUE #( FOR key IN keys
                                     ( Accountingdoc         = key-Accountingdoc
                                       Fiscalyear            = key-Fiscalyear
                                       Companycode           = key-Companycode
                                       status                = 'Failed'
                                    "   utr             = lv_utr
                                       appr1comment          = lv_status
                                       Message               = ls_errors-message
                                     "  %control-utr    = if_abap_behv=>mk-on
                                       %control-Appr1comment = if_abap_behv=>mk-on
                                       %control-Status       = if_abap_behv=>mk-on
                                       %control-Message      = if_abap_behv=>mk-on
                                     ) )
                FAILED failed
                REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
            ENTITY zi_bank_stat_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT heads.


          result = VALUE #( FOR head IN heads
                            ( %tky   = head-%tky
                              %param = head ) ).
        ENDIF.
      ELSE.
        "accepted UTR NO received
        DATA : lv_assingment TYPE char18.
        DATA(lv_len1) = strlen( lv_utr ).
*        IF lv_len1 <= 18.
*          lv_assingment = lv_utr.
*        ELSE.
*          lv_len1 = lv_len1 - 19 .
*          lv_assingment = lv_utr+lv_len1(18).
*        ENDIF.
        IF lv_len1 GE 16.
           lv_assingment = lv_utr+3(13).
        ENDIF.

        MODIFY ENTITIES OF zi_bank_stat_head IN LOCAL MODE
            ENTITY zi_bank_stat_head
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( Accountingdoc         = key-Accountingdoc
                                      Fiscalyear            = key-Fiscalyear
                                      Companycode           = key-Companycode
                                      status                = 'UTR Generated' "For Successful UTR Generation
                                      utr                   = lv_utr
                                      appr1comment          = lv_status1
                                      %control-status       = if_abap_behv=>mk-on
                                      %control-utr          = if_abap_behv=>mk-on
                                      %control-Appr1comment = if_abap_behv=>mk-on
                                    ) )
               FAILED failed
               REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
          ENTITY zi_bank_stat_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " acc doc entry Assignement refernce  DocumentItemText update
        DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
              lv_cid TYPE abp_behv_cid.

        APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).
* GL Item Control
        DATA lt_glitem LIKE <je>-%param-_glitems.
        DATA ls_glitem LIKE LINE OF lt_glitem.
        DATA ls_glitem_control LIKE ls_glitem-%control.
        ls_glitem_control-glaccountlineitem = if_abap_behv=>mk-on.
        ls_glitem_control-documentitemtext = if_abap_behv=>mk-on.
        ls_glitem_control-assignmentreference = if_abap_behv=>mk-on.

        SELECT SINGLE ReferenceDocumentItem
        FROM I_JournalEntryItem
        WHERE CompanyCode = @l_comp AND FiscalYear = @l_fiscyear AND AccountingDocument = @l_accdoc AND
        Ledger = '0L' AND Supplier IS INITIAL AND HouseBank IS NOT INITIAL
        INTO @DATA(ls_gl_item) .

*    "CHANGE BO
        <je>-companycode = l_comp.
        <je>-fiscalyear  = l_fiscyear.
        <je>-accountingdocument = l_accdoc.
        <je>-%param = VALUE #(
        _glitems = VALUE #( ( glaccountlineitem   = ls_gl_item
                              documentitemtext    = lv_utr
                              assignmentreference = lv_assingment
                              %control            = ls_glitem_control ) ) ).

        MODIFY ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE change FROM lt_je
         FAILED DATA(ls_failed_deep)
         REPORTED DATA(ls_reported_deep)
         MAPPED DATA(ls_mapped_deep).
        CLEAR: lt_je[].
      ENDIF.

    ENDIF.
    CLEAR: l_errors,l_donothing,ls_errors.
  ENDMETHOD.

  METHOD approve2.
    DATA lv_xtring TYPE string.
    DATA: content(1024).
    DATA: body        TYPE string,
          l_mail      TYPE cl_bcs_mail_message=>ty_address,
          lt_notiflog TYPE TABLE OF zdt_pay_notif.

    READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
      ENTITY ZI_bank_stat_head
      ALL FIELDS
      WITH CORRESPONDING #( keys )
        RESULT DATA(header)
        FAILED DATA(header_failed).

    "Approver - ZP First Level
    SELECT a1~Supplier,a~AccountingDocument AS Accountingdoc,a~FiscalYear AS Fiscalyear,a~CompanyCode AS Companycode,
    d~PaymentRunID AS paymentrunid,a~PostingDate AS postingdate,f~SupplierName AS suppliername,
    SUM( a~AmountInCompanyCodeCurrency ) AS AmountInCompanyCodeCurrency,a~CompanyCodeCurrency,d~PayeeBankKey,
    CASE WHEN c~accountingdoc IS NOT INITIAL THEN 'X' ELSE 'Y' END AS accdoc,c~status,z~type,e~BankName,e~BankAccountNumber as BankNumber
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
                                                         AND z~type = 'A')
    WHERE ( a~AccountingDocumentType = 'ZP' ) AND ( d~PayeeBankKey <> '')
    GROUP BY a1~Supplier,a~AccountingDocument,a~FiscalYear,a~CompanyCode,d~PaymentRunID,a~PostingDate,f~SupplierName,
    a~CompanyCodeCurrency,d~PayeeBankKey,c~accountingdoc,c~status,z~type,e~BankName,e~BankAccountNumber
    INTO TABLE @DATA(lt_notif).
    IF sy-subrc EQ 0.
      DELETE lt_notif WHERE accdoc = 'X'. "Delete the documents carried forward for processing
*      DATA(l_count) = REDUCE #( INIT s TYPE int8 FOR wa IN lt_notif WHERE ( type = '' ) NEXT s = s + 1 ).
*      IF l_count EQ 0. "Delete All
*        DELETE lt_notif WHERE accountingdoc IS NOT INITIAL.
*      ENDIF.
*      DELETE lt_notif WHERE type = 'A'.
      SORT lt_notif BY supplier accountingdoc fiscalyear companycode.
      DELETE ADJACENT DUPLICATES FROM lt_notif COMPARING supplier accountingdoc fiscalyear companycode.
    ENDIF.

    "Approver - KZ Second Level
    SELECT a1~Supplier,a~AccountingDocument AS Accountingdoc,a~FiscalYear AS Fiscalyear,a~CompanyCode AS Companycode,
    d~PaymentRunID AS paymentrunid,a~PostingDate AS postingdate,f~SupplierName AS suppliername,
    SUM( a~AmountInCompanyCodeCurrency ) AS AmountInCompanyCodeCurrency,a~CompanyCodeCurrency,d~PayeeBankKey,
    CASE WHEN c~accountingdoc IS NOT INITIAL THEN 'X' ELSE 'Y' END AS accdoc,c~status,z~type,e~BankName,e~BankAccountNumber as BankNumber
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
                                                         AND z~type = 'A')
    WHERE ( a~AccountingDocumentType = 'KZ' )
    GROUP BY a1~Supplier,a~AccountingDocument,a~FiscalYear,a~CompanyCode,d~PaymentRunID,a~PostingDate,f~SupplierName,
    a~CompanyCodeCurrency,d~PayeeBankKey,c~accountingdoc,c~status,z~type,e~BankName,e~BankAccountNumber
    INTO TABLE @DATA(lt_notif1).
    IF sy-subrc = 0.
      DELETE lt_notif1 WHERE status <> 'In Approval'.
      DELETE lt_notif1 WHERE accdoc = 'Y'.
*      l_count = REDUCE #( INIT s TYPE int8 FOR wa1 IN lt_notif1 WHERE ( type = '' ) NEXT s = s + 1 ).
*      IF l_count EQ 0. "Delete All
*        DELETE lt_notif1 WHERE accountingdoc IS NOT INITIAL.
*      ENDIF.
*      DELETE lt_notif1 WHERE type = 'A'.
      SORT lt_notif1 BY supplier accountingdoc fiscalyear companycode.
      DELETE ADJACENT DUPLICATES FROM lt_notif1 COMPARING supplier accountingdoc fiscalyear companycode.
    ENDIF.

    IF lt_notif1[] IS NOT INITIAL.
      lt_notif[] = CORRESPONDING #( BASE ( lt_notif[] ) lt_notif1[] ).
      DATA(l_count) = REDUCE #( INIT s TYPE int8 FOR wa IN lt_notif WHERE ( type = '' ) NEXT s = s + 1 ).
      IF l_count EQ 0. "Delete All
        DELETE lt_notif WHERE accountingdoc IS NOT INITIAL.
      ENDIF.
    ELSE.
      l_count = REDUCE #( INIT s TYPE int8 FOR wa IN lt_notif WHERE ( type = '' ) NEXT s = s + 1 ).
      IF l_count EQ 0. "Delete All
        DELETE lt_notif WHERE accountingdoc IS NOT INITIAL.
      ENDIF.
    ENDIF.

    IF lt_notif[] IS NOT INITIAL.
      body = '<html><body>Dear All,<br>Below are the Payments Pending for Approval.Please login to the below URL & Approve.<br>'.
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
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td></tr></table>'.
      body = body && '</body><br>Best Regards,<br>Dhunseri Poly Films Private Limited<br>'
                  && 'NOTE : This is a system generated mail, please do not reply.<br></html>'.
      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
          lo_mail->set_sender( 'no-reply@aspetindia.com' ).

          SELECT b~EmailAddress FROM ztmg_appr_matrix AS a
          INNER JOIN I_BusPartEmailAddressTP_3 AS b
          ON ( b~BusinessPartner = right( a~userid,10 ) )
          WHERE a~apprlevel   = '1' AND a~final <> 'X'
          ORDER BY b~EmailAddress
          INTO TABLE @DATA(lt_mail).
          IF sy-subrc EQ 0.
            DELETE ADJACENT DUPLICATES FROM lt_mail COMPARING EmailAddress.
          ENDIF.

          SELECT b~EmailAddress FROM ztmg_appr_matrix AS a
          INNER JOIN I_BusPartEmailAddressTP_3 AS b
          ON ( b~BusinessPartner = right( a~userid,10 ) )
          WHERE a~apprlevel   = '1' AND a~final = 'X'
          ORDER BY b~EmailAddress
          INTO TABLE @DATA(lt_mail_cc).
          IF sy-subrc EQ 0.
            DELETE ADJACENT DUPLICATES FROM lt_mail_cc COMPARING EmailAddress.
          ENDIF.

          IF lt_mail[] IS NOT INITIAL.
            LOOP AT lt_mail INTO DATA(ls_mail) WHERE ( EmailAddress CS 'harish' or EmailAddress CS 'suraj' ).
              l_mail = ls_mail-EmailAddress.
              lo_mail->add_recipient( l_mail ).
            ENDLOOP.

            "CC
            LOOP AT lt_mail_cc INTO DATA(ls_mail_cc).
              l_mail = ls_mail_cc-EmailAddress.
              lo_mail->add_recipient( iv_address = l_mail iv_copy = cl_bcs_mail_message=>cc ).
            ENDLOOP.

            CLEAR content.
            content = 'Payments || Pending for Approval'.
            lo_mail->set_subject( content ).
            lo_mail->set_main(
                cl_bcs_mail_textpart=>create_instance(
                    iv_content      = body
                    iv_content_type = 'text/html' ) ).

            " TODO: variable is assigned but never used (ABAP cleaner)
            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
            lt_notiflog[] = VALUE #( FOR wa IN lt_notif ( accountingdoc = wa-accountingdoc
                                                          fiscalyear    = wa-fiscalyear companycode = wa-companycode type = 'A' senton = sy-datum
                                                          sentat        = sy-uzeit      sentby      = sy-uname ) ).
            MODIFY zdt_pay_notif FROM TABLE @lt_notiflog[].
            IF sy-subrc EQ 0.
              reported-zi_bank_stat_head = VALUE #( ( %msg = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-information
                                                    text     = 'Mail has been Sent'
                                                    ) ) ).
            ENDIF.
          ENDIF.
        CATCH cx_bcs_mail INTO DATA(lx_mail). " TODO: variable is assigned but never used (ABAP cleaner)
          " handle exceptions here
      ENDTRY.
      " TODO: remove needless CLEAR (ABAP cleaner)
    ENDIF.

    CLEAR: body,lt_status[],lx_mail,lo_mail,lt_notif[],lt_notif1[].
    READ ENTITIES OF ZI_bank_stat_head  IN LOCAL MODE
     ENTITY ZI_bank_stat_head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(header1).

    result = VALUE #( FOR ls_header IN header1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

  ENDMETHOD.

  METHOD approve3.
    DATA lv_xtring TYPE string.
    DATA: content(1024).
    DATA: body        TYPE string,
          l_mail      TYPE cl_bcs_mail_message=>ty_address,
          lt_notiflog TYPE TABLE OF zdt_pay_notif.

    READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
     ENTITY ZI_bank_stat_head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

    "=====================================================================
    "Bank Authorized Signatory
    SELECT a1~Supplier,a~AccountingDocument AS Accountingdoc,a~FiscalYear AS Fiscalyear,a~CompanyCode AS Companycode,
    d~PaymentRunID AS paymentrunid,a~PostingDate AS postingdate,f~SupplierName AS suppliername,
    SUM( a~AmountInCompanyCodeCurrency ) AS AmountInCompanyCodeCurrency,a~CompanyCodeCurrency,d~PayeeBankKey,
    CASE WHEN c~accountingdoc IS NOT INITIAL THEN 'X' ELSE 'Y' END AS accdoc,c~status,z~type,e~BankName,e~BankAccountNumber as BankNumber
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
                                                         AND z~type = 'B')
    WHERE ( a~AccountingDocumentType = 'KZ' OR a~AccountingDocumentType = 'ZP' ) AND (  c~status = 'Sent to Bank' )
    AND ( c~PayeeBankKey <> '')
    GROUP BY a1~Supplier,a~AccountingDocument,a~FiscalYear,a~CompanyCode,d~PaymentRunID,a~PostingDate,f~SupplierName,
    a~CompanyCodeCurrency,d~PayeeBankKey,c~accountingdoc,c~status,z~type,e~BankName,e~BankAccountNumber
    INTO TABLE @DATA(lt_notif).
    IF sy-subrc EQ 0.
      DATA(l_count) = REDUCE #( INIT s TYPE int8 FOR wa IN lt_notif WHERE ( type = '' ) NEXT s = s + 1 ).
      IF l_count EQ 0. "Delete All
        DELETE lt_notif WHERE accountingdoc IS NOT INITIAL.
      ENDIF.
*      DELETE lt_notif WHERE type = 'B'.
      SORT lt_notif BY supplier accountingdoc fiscalyear companycode.
      DELETE ADJACENT DUPLICATES FROM lt_notif COMPARING supplier accountingdoc fiscalyear companycode.
    ENDIF.


    IF lt_notif[] IS NOT INITIAL.
      body = '<html><body>Dear All,<br>Below are the Payments Pending for Approval at HDFC Bank CIB.Please login & take necessary action.<br>'.
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
      body = body && '<td style="font-weight: bold;background-color: #FA8072"></td></tr></table>'.
      body = body && '</body><br>'.
      body = body && 'You may login to Bank portal using this URL link: https://www.hdfcbank.com/wholesale<br>'.
      body = body && 'You may see status of payments using this SAP URL link: https://my404341.s4hana.cloud.sap/ui#ZFI_PAYMENTSTAT-display<br>'.
      body = body && 'Best Regards,<br>Dhunseri Poly Films Private Limited<br>'
                  && 'NOTE : This is a system generated mail, please do not reply.<br></html>'..
      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
          lo_mail->set_sender( 'no-reply@aspetindia.com' ).

          SELECT a~email FROM ztmgbankauthmail AS a INTO TABLE @DATA(lt_mail).

          SELECT b~EmailAddress FROM ztmg_appr_matrix AS a
          INNER JOIN I_BusPartEmailAddressTP_3 AS b
          ON ( b~BusinessPartner = right( a~userid,10 ) )
          WHERE a~apprlevel   = '1' AND a~final = 'X'
          ORDER BY b~EmailAddress
          INTO TABLE @DATA(lt_mail_cc).
          IF sy-subrc EQ 0.
            DELETE ADJACENT DUPLICATES FROM lt_mail_cc COMPARING EmailAddress.
          ENDIF.

          SELECT b~EmailAddress FROM ztmg_appr_matrix AS a
          INNER JOIN I_BusPartEmailAddressTP_3 AS b
          ON ( b~BusinessPartner = right( a~userid,10 ) )
          WHERE a~apprlevel   = '1' AND a~final <> 'X'
          ORDER BY b~EmailAddress
          INTO TABLE @DATA(lt_mail_app).
          IF sy-subrc EQ 0.
            DELETE ADJACENT DUPLICATES FROM lt_mail_app COMPARING EmailAddress.
          ENDIF.

          IF lt_mail[] IS NOT INITIAL.
            ""Send Mail
            LOOP AT lt_mail INTO DATA(ls_mail).
              l_mail = ls_mail-email.
              lo_mail->add_recipient( l_mail ).
            ENDLOOP.

            ""CC Verifier
            LOOP AT lt_mail_cc INTO DATA(ls_cc).
              l_mail = ls_cc-EmailAddress.
              lo_mail->add_recipient( iv_address = l_mail
                                      iv_copy    = cl_bcs_mail_message=>cc ).
            ENDLOOP.

            ""CC Approver
            LOOP AT lt_mail_app INTO DATA(ls_mail_app) WHERE EmailAddress CS 'harish'.
              l_mail = ls_mail_app-EmailAddress.
              lo_mail->add_recipient( iv_address = l_mail
                                      iv_copy    = cl_bcs_mail_message=>cc ).
            ENDLOOP.



*        lo_mail->add_recipient( iv_address = 'naresh.agarwal@dhunseripolyfilms.com'
*                                iv_copy    = cl_bcs_mail_message=>cc ).
*        lo_mail->add_recipient( iv_address = 'rajesh.poddar@aspetindia.com'
*                                iv_copy    = cl_bcs_mail_message=>cc ).

            CLEAR content.
            content = 'Payments || Pending for Approval at Bank CIB Portal'.
            lo_mail->set_subject( content ).
            lo_mail->set_main(
                cl_bcs_mail_textpart=>create_instance(
                    iv_content      = body
                    iv_content_type = 'text/html' ) ).

            " TODO: variable is assigned but never used (ABAP cleaner)
            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
            lt_notiflog[] = VALUE #( FOR wa IN lt_notif ( accountingdoc = wa-accountingdoc
                                                          fiscalyear    = wa-fiscalyear companycode = wa-companycode type = 'B' senton = sy-datum
                                                          sentat        = sy-uzeit      sentby      = sy-uname ) ).
            MODIFY zdt_pay_notif FROM TABLE @lt_notiflog[].
            IF sy-subrc EQ 0.
              reported-zi_bank_stat_head = VALUE #( ( %msg = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-information
                                                    text     = 'Mail Sent'
                                                    ) ) ).
            ENDIF.
          ENDIF.
        CATCH cx_bcs_mail INTO DATA(lx_mail). " TODO: variable is assigned but never used (ABAP cleaner)
          " handle exceptions here
      ENDTRY.
      " TODO: remove needless CLEAR (ABAP cleaner)
    ENDIF.

    READ ENTITIES OF ZI_bank_stat_head  IN LOCAL MODE
     ENTITY ZI_bank_stat_head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(header1).

    result = VALUE #( FOR ls_header IN header1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD reject1.
      DATA lv_xtring TYPE string.
    DATA: content(1024).
    DATA: body        TYPE string,
          l_mail      TYPE cl_bcs_mail_message=>ty_address,
          lt_notiflog TYPE TABLE OF zdt_pay_notif,
          lt_selopt   TYPE RANGE OF char15,
          l_date      TYPE datum,
          l_fiscalyear TYPE n LENGTH 4.

    "=====================================================================
    READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
     ENTITY ZI_bank_stat_head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

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
            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
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
              reported-zi_bank_stat_head = VALUE #( ( %msg = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-information
                                                    text     = 'Mail Sent'
                                                    ) ) ).
            ENDIF.

          ENDIF.
        CATCH cx_bcs_mail INTO DATA(lx_mail). " TODO: variable is assigned but never used (ABAP cleaner)
          " handle exceptions here
      ENDTRY.

     READ ENTITIES OF ZI_bank_stat_head  IN LOCAL MODE
     ENTITY ZI_bank_stat_head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(header1).

    result = VALUE #( FOR ls_header IN header1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
      " TODO: remove needless CLEAR (ABAP cleaner)
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_BANK_STAT_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_BANK_STAT_HEAD IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_head  TYPE STANDARD TABLE OF zdt_payment_head,
           lt_head1 TYPE STANDARD TABLE OF zdt_payment_head,
           lt_log   TYPE STANDARD TABLE OF zdt_appr_log.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA l_timestamp TYPE timestamp.

    "header table update
    l_timestamp = sy-datum && sy-uzeit.
    CONVERT TIME STAMP l_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    IF update IS NOT INITIAL.
      lt_head = CORRESPONDING #(  update-zi_bank_stat_head ).

      "log table update
      SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel,b~inprocess,b~rejected,b~approved,
      b~appr1comment
      FROM zdt_appr_log AS a
      INNER JOIN @lt_head AS b
      ON ( b~accountingdoc = a~accountingdoc AND b~fiscalyear = a~fiscalyear AND b~companycode = a~companycode )
      INTO TABLE @DATA(lt_apprlog).
      SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
      IF lt_apprlog[] IS NOT INITIAL.
        DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
        lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                          companycode = wa1-companycode apprlevel = ( wa1-apprlevel + 1 )
                          supplier = wa1-supplier actionedby = sy-uname actionedon = lv_date
                          actionedat = lv_time action = 'Status Upd'
                          apprcomment = COND #( WHEN ls_head-status = 'Failed' THEN ls_head-message ELSE wa1-appr1comment  )  ) ).

        IF lt_log[] IS NOT INITIAL.
          MODIFY zdt_appr_log FROM TABLE @lt_log.
        ENDIF.
      ENDIF.

      IF lt_head[] IS NOT INITIAL.
        LOOP AT lt_head ASSIGNING FIELD-SYMBOL(<fs_head>).
          CLEAR: <fs_head>-appr1comment.
        ENDLOOP.
        MODIFY zdt_payment_head FROM TABLE @lt_head.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
