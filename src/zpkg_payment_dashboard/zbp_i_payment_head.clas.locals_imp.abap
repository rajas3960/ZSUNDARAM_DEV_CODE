CLASS lhc_zi_payment_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_payment_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_payment_head RESULT result.

    METHODS approve1 FOR MODIFY
      IMPORTING keys FOR ACTION zi_payment_head~approve1 RESULT result.

*    METHODS approve2 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~approve2 RESULT result.
*
*    METHODS approve3 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~approve3 RESULT result.

    METHODS reject1 FOR MODIFY
      IMPORTING keys FOR ACTION zi_payment_head~reject1 RESULT result.

*    METHODS Reject2 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~Reject2 RESULT result.
*
*    METHODS Reject3 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~Reject3 RESULT result.

ENDCLASS.

CLASS lhc_zi_payment_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD approve1.
    DATA lv_json_post TYPE string VALUE ''.
    TYPES: BEGIN OF ty_type,
             login_id               TYPE string,
             input_gcif             TYPE string,
             transfer_type_desc     TYPE string,
             bene_bank              TYPE string,
             input_debit_amount     TYPE string,
             input_value_date       TYPE string,
             transaction_type       TYPE string,
             input_debit_org_acc_no TYPE string,
             input_business_prod    TYPE string,
             bene_id                TYPE string,
             bene_acc_name          TYPE string,
             bene_acc_no            TYPE string,
             bene_type              TYPE string,
             bene_branch            TYPE string,
             bene_idn_code          TYPE string,
             payment_ref_no         TYPE string,
             bene_narration         TYPE string,
           END OF ty_type.
    DATA ls_paysend TYPE ty_type.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA l_timestamp TYPE timestamp.


    l_timestamp = sy-datum && sy-uzeit.
    CONVERT TIME STAMP l_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-companycode OPTIONAL ).
    DATA l_apprlevel TYPE zdt_payment_head-apprlevel.
    SELECT SINGLE a~accountingdoccreatedbyuser,a~accountingdocumenttype,b~personfullname FROM i_journalentry AS a
    INNER JOIN i_businessuserbasic AS b ON ( b~userid = a~accountingdoccreatedbyuser )
    WHERE a~accountingdocument = @l_accdoc AND a~fiscalyear = @l_fiscyear AND a~companycode = @l_comp
    INTO ( @DATA(l_cr),@DATA(l_doc),@DATA(l_benename) ).
    IF sy-subrc EQ 0 AND ( l_cr <> sy-uname ).
      SELECT SINGLE * FROM zi_payment_head
        WHERE accountingdoc = @l_accdoc
          AND fiscalyear    = @l_fiscyear AND companycode = @l_comp
        INTO @DATA(l_head).
      IF sy-subrc = 0.
        l_apprlevel = 1.
        SELECT SINGLE userid FROM ztmg_appr_matrix
          WHERE companycode = @l_comp AND apprlevel = '1'
            AND userid      = @sy-uname
          " TODO: variable is assigned but never used (ABAP cleaner)
          INTO @DATA(l_user).
        IF sy-subrc = 0 AND l_head-appr1 IS INITIAL.
          IF l_doc EQ 'ZP'.
            SELECT SINGLE payeecityname FROM i_paymentproposalpayment
              WHERE paymentdocument   = @l_accdoc
                AND payingcompanycode = @l_comp AND financialaccounttype = 'K'
              INTO @DATA(l_payeecity).
            IF sy-subrc = 0.
              IF l_payeecity IS INITIAL.
                ls_paysend-bene_branch = 'India' .
              ELSE.
                ls_paysend-bene_branch = l_payeecity.
              ENDIF.
            ELSE.
              ls_paysend-bene_branch = 'India' .
            ENDIF.
            "REPLACE ALL OCCURRENCES OF  '*() <>^`&; *() <>^`&;`";|&>\# --' IN l_head-suppliername WITH ' '.
            REPLACE ALL OCCURRENCES OF  '-' IN l_head-suppliername WITH ' '.
            REPLACE ALL OCCURRENCES OF  '&' IN l_head-suppliername WITH ' '.
            REPLACE ALL OCCURRENCES OF  '*' IN l_head-suppliername WITH ' '.
            REPLACE ALL OCCURRENCES OF  '\' IN l_head-suppliername WITH ' '.
            REPLACE ALL OCCURRENCES OF  '|' IN l_head-suppliername WITH ' '.
            REPLACE ALL OCCURRENCES OF  '/' IN l_head-suppliername WITH ' '.
            ls_paysend-bene_acc_name      = l_head-suppliername.

            IF sy-sysid = 'PZJ'.
              ls_paysend-input_gcif = 'CBXMGRT4'.
              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
            ELSEIF sy-sysid = 'A1S'.
              ls_paysend-input_gcif = 'CBXMGRT4'.
              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
            ELSEIF sy-sysid = 'AYR'.
              ls_paysend-input_gcif = 'DHUNSERIPCX'.
              ls_paysend-login_id = 'APIUSER'.
            ENDIF.
*            ls_paysend-transfer_type_desc = COND #( WHEN l_head-paymentmethod = 'I'    THEN 'IMPS'
*                                                    WHEN l_head-paymentmethod = 'N'    THEN 'NEFT'
*                                                    WHEN l_head-paymentmethod = 'R'    THEN 'RTGS'
*                                                    WHEN l_head-payeebankkey CS 'HDFC' THEN 'INTRA BANK TRANSFER' ).
*            l_head-amountincompanycodecurrency = round( val = l_head-amountincompanycodecurrency dec = 2 ).
            ls_paysend-input_debit_amount = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
                                            THEN l_head-amountincompanycodecurrency * ( -1 )
                                            ELSE l_head-amountincompanycodecurrency ).
            ls_paysend-input_value_date   = |{ lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) }|.
            ls_paysend-transaction_type   = 'SINGLE'.
            ls_paysend-input_debit_amount = condense( val  = ls_paysend-input_debit_amount
                                                      from = ` `
                                                      to   = `` ).
            IF ( sy-sysid = 'PZJ' OR sy-sysid = 'A1S' ).
              ls_paysend-transfer_type_desc     = 'IMPS'.
              ls_paysend-input_debit_org_acc_no = '00500340000261'.
              ls_paysend-bene_acc_no            = '00040350004239'.
              ls_paysend-bene_idn_code          = 'CITI0000001'.
            ELSEIF ( sy-sysid = 'AYR' ).
              DATA(l_amt) = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
                                    THEN l_head-amountincompanycodecurrency * ( -1 )
                                    ELSE l_head-amountincompanycodecurrency ).
              IF l_head-payeebankkey CS 'HDFC'.
                ls_paysend-transfer_type_desc = 'Intra Bank Transfer'.
              ELSE.
                IF l_amt > 200000.
                  ls_paysend-transfer_type_desc = 'RTGS'.
                ELSE.
                  ls_paysend-transfer_type_desc = 'NEFT'.
                ENDIF.
              ENDIF.
              ls_paysend-input_debit_org_acc_no = l_head-bankaccountnumber.
              REPLACE ALL OCCURRENCES OF '''' IN ls_paysend-input_debit_org_acc_no WITH ''.
              ls_paysend-bene_acc_no            = l_head-payeebankaccount.
              REPLACE ALL OCCURRENCES OF '''' IN l_head-payeebankaccount WITH ''.
              ls_paysend-bene_idn_code          = l_head-payeebankkey.
            ENDIF.
            ls_paysend-input_business_prod = 'VENDBUS01'.
            ls_paysend-bene_type           = 'ADHOC'.
            ls_paysend-payment_ref_no      = l_accdoc && l_fiscyear && l_comp.
            ls_paysend-bene_narration      = l_benename.

            lv_json_post = /ui2/cl_json=>serialize( data = ls_paysend ).

            TRY.
                DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                  comm_scenario = 'ZFI_SC_PAYSEND'
                  service_id    = 'ZFI_PAYSEND_REST' ).
                DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
                DATA(lo_request) = lo_http_client->get_http_request( ).
                lo_request->set_content_type( content_type = |application/json| ).
                lo_request->set_text( lv_json_post ).
                DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
                lo_http_client->close( ).

                CLEAR lv_json_post.
                IF ls_result CS 'Accepted'.
                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                         ENTITY zi_payment_head
                         UPDATE FROM VALUE #( FOR key IN keys
                                              ( accountingdoc          = key-accountingdoc
                                                fiscalyear             = key-fiscalyear
                                                companycode            = key-companycode
                                                appr1                  = 'X' " Booked
                                                inprocess              = ''
                                                approved               = 'X'
                                                apprlevel              = l_apprlevel
                                                status                 = 'Sent to Bank'
                                                appr2comment           = ls_result
                                                senton                 = lv_date
                                                sentat                 = lv_time
                                                sentby                 = sy-uname
                                                %control-accountingdoc = if_abap_behv=>mk-on
                                                %control-fiscalyear    = if_abap_behv=>mk-on
                                                %control-companycode   = if_abap_behv=>mk-on
                                                %control-status        = if_abap_behv=>mk-on
                                                %control-appr1         = if_abap_behv=>mk-on
                                                %control-inprocess     = if_abap_behv=>mk-on
                                                %control-approved      = if_abap_behv=>mk-on
                                                %control-apprlevel     = if_abap_behv=>mk-on
                                                %control-appr2comment  = if_abap_behv=>mk-on
                                                %control-senton        = if_abap_behv=>mk-on
                                                %control-sentat        = if_abap_behv=>mk-on
                                                %control-sentby        = if_abap_behv=>mk-on ) )
                         FAILED failed
                         REPORTED reported.
                ELSE.
                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                         ENTITY zi_payment_head
                         UPDATE FROM VALUE #( FOR key IN keys
                                              ( accountingdoc          = key-accountingdoc
                                                fiscalyear             = key-fiscalyear
                                                companycode            = key-companycode
                                                appr1                  = 'X' " Booked
                                                inprocess              = ''
                                                rejected               = 'X'
                                                apprlevel              = l_apprlevel
                                                status                 = 'Failed'
                                                appr2comment           = ls_result
                                                senton                 = lv_date
                                                sentat                 = lv_time
                                                sentby                 = sy-uname
                                                %control-accountingdoc = if_abap_behv=>mk-on
                                                %control-fiscalyear    = if_abap_behv=>mk-on
                                                %control-companycode   = if_abap_behv=>mk-on
                                                %control-status        = if_abap_behv=>mk-on
                                                %control-appr1         = if_abap_behv=>mk-on
                                                %control-inprocess     = if_abap_behv=>mk-on
                                                %control-rejected      = if_abap_behv=>mk-on
                                                %control-apprlevel     = if_abap_behv=>mk-on
                                                %control-appr2comment  = if_abap_behv=>mk-on
                                                %control-senton        = if_abap_behv=>mk-on
                                                %control-sentat        = if_abap_behv=>mk-on
                                                %control-sentby        = if_abap_behv=>mk-on ) )
                         FAILED failed
                         REPORTED reported.
                ENDIF.

                " Read changed data for action result
                READ ENTITIES OF zi_payment_head IN LOCAL MODE
                     ENTITY zi_payment_head
                     ALL FIELDS WITH
                     CORRESPONDING #( keys )
                     RESULT DATA(heads).

                result = VALUE #( FOR head IN heads
                                  ( %tky   = head-%tky
                                    %param = head ) ).

              CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
              CATCH cx_web_http_client_error INTO DATA(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
            ENDTRY.

            INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = 'Approved' ) )
                   INTO TABLE reported-zi_payment_head.
          ELSEIF l_doc EQ 'KZ'. "2 Level approval

            SELECT SINGLE payeecityname FROM i_paymentproposalpayment
            WHERE paymentdocument   = @l_accdoc
            AND payingcompanycode = @l_comp AND financialaccounttype = 'K'
              INTO @l_payeecity.
            IF sy-subrc = 0.
              IF l_payeecity IS INITIAL.
                ls_paysend-bene_branch = 'India' .
              ELSE.
                ls_paysend-bene_branch = l_payeecity.
              ENDIF.
            ELSE.
              ls_paysend-bene_branch = 'India' .
            ENDIF.
            REPLACE ALL OCCURRENCES OF  '*() <>^`&; *() <>^`&;`";|&>\# --' IN l_head-suppliername WITH ' '.
            ls_paysend-bene_acc_name      = l_head-suppliername.
*            IF sy-sysid = 'YYQ'.
            IF sy-sysid = 'PZJ'.
              ls_paysend-input_gcif = 'CBXMGRT4'.
              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
*            ELSEIF sy-sysid = 'X6V'.
            ELSEIF sy-sysid = 'A1S'.
              ls_paysend-input_gcif = 'CBXMGRT4'.
              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
*            ELSEIF sy-sysid = 'XDA'.
            ELSEIF sy-sysid = 'AYR'.
              ls_paysend-input_gcif = 'DHUNSERIPCX'.
              ls_paysend-login_id = 'APIUSER'.
            ENDIF.
*          l_head-amountincompanycodecurrency = round( val = l_head-amountincompanycodecurrency dec = 2 ).
            ls_paysend-input_debit_amount = COND #( WHEN l_head-amountincompanycodecurrency LT 0
                                                THEN l_head-amountincompanycodecurrency * ( -1 )
                                                ELSE l_head-amountincompanycodecurrency ).
            ls_paysend-input_value_date   = |{ lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) }|.
            ls_paysend-transaction_type   = 'SINGLE'.
            ls_paysend-input_debit_amount = condense( val  = ls_paysend-input_debit_amount
                                                      from = ` `
                                                      to   = `` ).
*            IF ( sy-sysid = 'YYQ' OR sy-sysid = 'X6V' ).
            IF ( sy-sysid = 'PZJ' OR sy-sysid = 'A1S' ).
              ls_paysend-transfer_type_desc     = 'IMPS'.
              ls_paysend-input_debit_org_acc_no = '00500340000261'.
              ls_paysend-bene_acc_no            = '00040350004239'.
              ls_paysend-bene_idn_code          = 'CITI0000001'.
            ELSEIF ( sy-sysid = 'AYR' ).
              l_amt = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
                                        THEN l_head-amountincompanycodecurrency * ( -1 )
                                        ELSE l_head-amountincompanycodecurrency ).
              IF l_head-payeebankkey CS 'HDFC'.
                ls_paysend-transfer_type_desc = 'Intra Bank Transfer'.
              ELSE.
                IF l_amt > 200000.
                  ls_paysend-transfer_type_desc = 'RTGS'.
                ELSE.
                  ls_paysend-transfer_type_desc = 'NEFT'.
                ENDIF.
              ENDIF.
              ls_paysend-input_debit_org_acc_no = l_head-bankaccountnumber.
              REPLACE ALL OCCURRENCES OF '''' IN ls_paysend-input_debit_org_acc_no WITH ''.
              ls_paysend-bene_acc_no            = l_head-payeebankaccount.
              REPLACE ALL OCCURRENCES OF '''' IN l_head-payeebankaccount WITH ''.
              ls_paysend-bene_idn_code          = l_head-payeebankkey.
            ENDIF.

            SELECT SINGLE name FROM zi_appr_log WHERE accountingdoc = @l_accdoc AND fiscalyear = @l_fiscyear
            AND companycode = @l_comp AND apprlevel = 1 INTO @l_benename.
            IF sy-subrc EQ 0.
              ls_paysend-bene_narration = l_benename.
            ELSE.
              ls_paysend-bene_narration = 'Finance User'.
            ENDIF.
            ls_paysend-input_business_prod = 'VENDBUS01'.
            ls_paysend-bene_type           = 'ADHOC'.
            ls_paysend-payment_ref_no      = l_accdoc && l_fiscyear && l_comp.

            lv_json_post = /ui2/cl_json=>serialize( data = ls_paysend ).

            TRY.
                lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                  comm_scenario = 'ZFI_SC_PAYSEND'
                  service_id    = 'ZFI_PAYSEND_REST' ).
                lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
                lo_request = lo_http_client->get_http_request( ).
                lo_request->set_content_type( content_type = |application/json| ).
                lo_request->set_text( lv_json_post ).
                ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
                lo_http_client->close( ).

                CLEAR lv_json_post.
                IF ls_result CS 'Accepted'.
                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                         ENTITY zi_payment_head
                         UPDATE FROM VALUE #( FOR key IN keys
                                              ( accountingdoc          = key-accountingdoc
                                                fiscalyear             = key-fiscalyear
                                                companycode            = key-companycode
                                                appr1                  = 'X' " Booked
                                                inprocess              = ''
                                                approved               = 'X'
                                                apprlevel              = l_apprlevel
                                                status                 = 'Sent to Bank'
                                                appr2comment           = ls_result
                                                senton                 = lv_date
                                                sentat                 = lv_time
                                                sentby                 = sy-uname
                                                %control-accountingdoc = if_abap_behv=>mk-on
                                                %control-fiscalyear    = if_abap_behv=>mk-on
                                                %control-companycode   = if_abap_behv=>mk-on
                                                %control-status        = if_abap_behv=>mk-on
                                                %control-appr1         = if_abap_behv=>mk-on
                                                %control-inprocess     = if_abap_behv=>mk-on
                                                %control-approved      = if_abap_behv=>mk-on
                                                %control-apprlevel     = if_abap_behv=>mk-on
                                                %control-appr2comment  = if_abap_behv=>mk-on
                                                %control-senton        = if_abap_behv=>mk-on
                                                %control-sentat        = if_abap_behv=>mk-on
                                                %control-sentby        = if_abap_behv=>mk-on ) )
                         FAILED failed
                         REPORTED reported.
                ELSE.
                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                         ENTITY zi_payment_head
                         UPDATE FROM VALUE #( FOR key IN keys
                                              ( accountingdoc          = key-accountingdoc
                                                fiscalyear             = key-fiscalyear
                                                companycode            = key-companycode
                                                appr1                  = 'X' " Booked
                                                inprocess              = ''
                                                rejected               = 'X'
                                                apprlevel              = l_apprlevel
                                                status                 = 'Failed'
                                                appr2comment           = ls_result
                                                senton                 = lv_date
                                                sentat                 = lv_time
                                                sentby                 = sy-uname
                                                %control-accountingdoc = if_abap_behv=>mk-on
                                                %control-fiscalyear    = if_abap_behv=>mk-on
                                                %control-companycode   = if_abap_behv=>mk-on
                                                %control-status        = if_abap_behv=>mk-on
                                                %control-appr1         = if_abap_behv=>mk-on
                                                %control-inprocess     = if_abap_behv=>mk-on
                                                %control-rejected      = if_abap_behv=>mk-on
                                                %control-apprlevel     = if_abap_behv=>mk-on
                                                %control-appr2comment  = if_abap_behv=>mk-on
                                                %control-senton        = if_abap_behv=>mk-on
                                                %control-sentat        = if_abap_behv=>mk-on
                                                %control-sentby        = if_abap_behv=>mk-on ) )
                         FAILED failed
                         REPORTED reported.
                ENDIF.

                " Read changed data for action result
                READ ENTITIES OF zi_payment_head IN LOCAL MODE
                     ENTITY zi_payment_head
                     ALL FIELDS WITH
                     CORRESPONDING #( keys )
                     RESULT heads.

                result = VALUE #( FOR head IN heads
                                  ( %tky   = head-%tky
                                    %param = head ) ).

              CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
              CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
            ENDTRY.

            INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                          text     = 'Approved' ) )
                   INTO TABLE reported-zi_payment_head.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSEIF (  l_cr = sy-uname ).
      READ ENTITIES OF zi_payment_head IN LOCAL MODE
        ENTITY zi_payment_head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT heads.

      result = VALUE #( FOR head IN heads
                        ( %tky   = head-%tky
                          %param = head ) ).
      INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                    text     = 'Approver cannot be same as verifier' ) )
             INTO TABLE reported-zi_payment_head.
    ENDIF.


****    l_timestamp = sy-datum && sy-uzeit.
****    CONVERT TIME STAMP l_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
****    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-Accountingdoc OPTIONAL ).
****    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-Fiscalyear OPTIONAL ).
****    DATA(l_comp) = VALUE #(  keys[ 1 ]-Companycode OPTIONAL ).
****    DATA l_apprlevel TYPE zdt_payment_head-apprlevel.
****    SELECT SINGLE a~AccountingDocCreatedByUser,a~AccountingDocumentType,b~PersonFullName FROM I_JournalEntry AS a
****    INNER JOIN I_BusinessUserBasic AS b ON ( b~UserID = a~AccountingDocCreatedByUser )
****    WHERE a~AccountingDocument = @l_accdoc AND a~FiscalYear = @l_fiscyear AND a~CompanyCode = @l_comp
****    INTO ( @DATA(l_cr),@DATA(l_doc),@DATA(l_benename) ).
****    IF sy-subrc EQ 0 AND ( l_cr <> sy-uname ).
****      SELECT SINGLE * FROM zi_payment_head
****        WHERE accountingdoc = @l_accdoc
****          AND fiscalyear    = @l_fiscyear AND companycode = @l_comp
****        INTO @DATA(l_head).
****      IF sy-subrc = 0.
****        l_apprlevel = 1.
****        SELECT SINGLE userid FROM ztmg_appr_matrix
****          WHERE companycode = @l_comp AND apprlevel = '1'
****            AND userid      = @sy-uname
****          " TODO: variable is assigned but never used (ABAP cleaner)
****          INTO @DATA(l_user).
****        IF sy-subrc = 0 AND l_head-Appr1 IS INITIAL.
****          IF l_doc EQ 'ZP'.
****            SELECT SINGLE PayeeCityName FROM I_PaymentProposalPayment
****              WHERE PaymentDocument   = @l_accdoc
****                AND PayingCompanyCode = @l_comp AND FinancialAccountType = 'K'
****              INTO @DATA(l_payeecity).
****            IF sy-subrc = 0.
****              IF l_payeecity IS INITIAL.
****                ls_paysend-bene_branch = 'India' .
****              ELSE.
****                ls_paysend-bene_branch = l_payeecity.
****              ENDIF.
****            ELSE.
****              ls_paysend-bene_branch = 'India' .
****            ENDIF.
****            "REPLACE ALL OCCURRENCES OF  '*() <>^`&; *() <>^`&;`";|&>\# --' IN l_head-suppliername WITH ' '.
****            REPLACE ALL OCCURRENCES OF  '-' IN l_head-suppliername WITH ' '.
****            REPLACE ALL OCCURRENCES OF  '&' IN l_head-suppliername WITH ' '.
****            REPLACE ALL OCCURRENCES OF  '*' IN l_head-suppliername WITH ' '.
****            REPLACE ALL OCCURRENCES OF  '\' IN l_head-suppliername WITH ' '.
****            REPLACE ALL OCCURRENCES OF  '|' IN l_head-suppliername WITH ' '.
****            REPLACE ALL OCCURRENCES OF  '/' IN l_head-suppliername WITH ' '.
****            ls_paysend-bene_acc_name      = l_head-suppliername.
****
****            IF sy-sysid = 'PZJ'.
****              ls_paysend-input_gcif = 'CBXMGRT4'.
****              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
****            ELSEIF sy-sysid = 'A1S'.
****              ls_paysend-input_gcif = 'CBXMGRT4'.
****              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
****            ELSEIF sy-sysid = 'AYR'.
****              ls_paysend-input_gcif = 'DHUNSERIPCX'.
****              ls_paysend-login_id = 'APIUSER'.
****            ENDIF.
*****            ls_paysend-transfer_type_desc = COND #( WHEN l_head-paymentmethod = 'I'    THEN 'IMPS'
*****                                                    WHEN l_head-paymentmethod = 'N'    THEN 'NEFT'
*****                                                    WHEN l_head-paymentmethod = 'R'    THEN 'RTGS'
*****                                                    WHEN l_head-payeebankkey CS 'HDFC' THEN 'INTRA BANK TRANSFER' ).
*****            l_head-amountincompanycodecurrency = round( val = l_head-amountincompanycodecurrency dec = 2 ).
****            ls_paysend-input_debit_amount = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
****                                            THEN l_head-amountincompanycodecurrency * ( -1 )
****                                            ELSE l_head-amountincompanycodecurrency ).
****            ls_paysend-input_value_date   = |{ lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) }|.
****            ls_paysend-transaction_type   = 'SINGLE'.
****            ls_paysend-input_debit_amount = condense( val  = ls_paysend-input_debit_amount
****                                                      from = ` `
****                                                      to   = `` ).
****            IF ( sy-sysid = 'PZJ' OR sy-sysid = 'A1S' ).
****              ls_paysend-transfer_type_desc     = 'IMPS'.
****              ls_paysend-input_debit_org_acc_no = '00500340000261'.
****              ls_paysend-bene_acc_no            = '00040350004239'.
****              ls_paysend-bene_idn_code          = 'CITI0000001'.
****            ELSEIF ( sy-sysid = 'AYR' ).
****              DATA(l_amt) = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
****                                    THEN l_head-amountincompanycodecurrency * ( -1 )
****                                    ELSE l_head-amountincompanycodecurrency ).
****              IF l_head-payeebankkey CS 'HDFC'.
****                ls_paysend-transfer_type_desc = 'Intra Bank Transfer'.
****              ELSE.
****                IF l_amt > 200000.
****                  ls_paysend-transfer_type_desc = 'RTGS'.
****                ELSE.
****                  ls_paysend-transfer_type_desc = 'NEFT'.
****                ENDIF.
****              ENDIF.
****              ls_paysend-input_debit_org_acc_no = l_head-bankaccountnumber.
****              REPLACE ALL OCCURRENCES OF '''' IN ls_paysend-input_debit_org_acc_no WITH ''.
****              ls_paysend-bene_acc_no            = l_head-payeebankaccount.
****              REPLACE ALL OCCURRENCES OF '''' IN l_head-payeebankaccount WITH ''.
****              ls_paysend-bene_idn_code          = l_head-payeebankkey.
****            ENDIF.
****            ls_paysend-input_business_prod = 'VENDBUS01'.
****            ls_paysend-bene_type           = 'ADHOC'.
****            ls_paysend-payment_ref_no      = l_accdoc && l_fiscyear && l_comp.
****            ls_paysend-bene_narration      = l_benename.
****
****            lv_json_post = /ui2/cl_json=>serialize( data = ls_paysend ).
****
****            TRY.
****                DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
****                  comm_scenario = 'ZFI_SC_PAYSEND'
****                  service_id    = 'ZFI_PAYSEND_REST' ).
****                DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
****                DATA(lo_request) = lo_http_client->get_http_request( ).
****                lo_request->set_content_type( content_type = |application/json| ).
****                lo_request->set_text( lv_json_post ).
****                DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
****                lo_http_client->close( ).
****
****                CLEAR lv_json_post.
****                IF ls_result CS 'Accepted'.
****                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                         ENTITY zi_payment_head
****                         UPDATE FROM VALUE #( FOR key IN keys
****                                              ( Accountingdoc          = key-Accountingdoc
****                                                Fiscalyear             = key-Fiscalyear
****                                                Companycode            = key-Companycode
****                                                Appr1                  = 'X' " Booked
****                                                Inprocess              = ''
****                                                Approved               = 'X'
****                                                apprlevel              = l_apprlevel
****                                                status                 = 'Sent to Bank'
****                                                Appr2comment           = ls_result
****                                                Senton                 = lv_date
****                                                sentat                 = lv_time
****                                                sentby                 = sy-uname
****                                                %control-Accountingdoc = if_abap_behv=>mk-on
****                                                %control-Fiscalyear    = if_abap_behv=>mk-on
****                                                %control-Companycode   = if_abap_behv=>mk-on
****                                                %control-status        = if_abap_behv=>mk-on
****                                                %control-Appr1         = if_abap_behv=>mk-on
****                                                %control-Inprocess     = if_abap_behv=>mk-on
****                                                %control-Approved      = if_abap_behv=>mk-on
****                                                %control-apprlevel     = if_abap_behv=>mk-on
****                                                %control-Appr2comment  = if_abap_behv=>mk-on
****                                                %control-Senton        = if_abap_behv=>mk-on
****                                                %control-sentat        = if_abap_behv=>mk-on
****                                                %control-sentby        = if_abap_behv=>mk-on ) )
****                         FAILED failed
****                         REPORTED reported.
****                ELSE.
****                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                         ENTITY zi_payment_head
****                         UPDATE FROM VALUE #( FOR key IN keys
****                                              ( Accountingdoc          = key-Accountingdoc
****                                                Fiscalyear             = key-Fiscalyear
****                                                Companycode            = key-Companycode
****                                                Appr1                  = 'X' " Booked
****                                                Inprocess              = ''
****                                                Rejected               = 'X'
****                                                apprlevel              = l_apprlevel
****                                                status                 = 'Failed'
****                                                Appr2comment           = ls_result
****                                                Senton                 = lv_date
****                                                sentat                 = lv_time
****                                                sentby                 = sy-uname
****                                                %control-Accountingdoc = if_abap_behv=>mk-on
****                                                %control-Fiscalyear    = if_abap_behv=>mk-on
****                                                %control-Companycode   = if_abap_behv=>mk-on
****                                                %control-status        = if_abap_behv=>mk-on
****                                                %control-Appr1         = if_abap_behv=>mk-on
****                                                %control-Inprocess     = if_abap_behv=>mk-on
****                                                %control-Rejected      = if_abap_behv=>mk-on
****                                                %control-apprlevel     = if_abap_behv=>mk-on
****                                                %control-Appr2comment  = if_abap_behv=>mk-on
****                                                %control-Senton        = if_abap_behv=>mk-on
****                                                %control-sentat        = if_abap_behv=>mk-on
****                                                %control-sentby        = if_abap_behv=>mk-on ) )
****                         FAILED failed
****                         REPORTED reported.
****                ENDIF.
****
****                " Read changed data for action result
****                READ ENTITIES OF zi_payment_head IN LOCAL MODE
****                     ENTITY zi_payment_head
****                     ALL FIELDS WITH
****                     CORRESPONDING #( keys )
****                     RESULT DATA(heads).
****
****                result = VALUE #( FOR head IN heads
****                                  ( %tky   = head-%tky
****                                    %param = head ) ).
****
****              CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
****              CATCH cx_web_http_client_error INTO DATA(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
****            ENDTRY.
****
****            INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
****                                                          text     = 'Approved' ) )
****                   INTO TABLE reported-zi_payment_head.
****          ELSEIF l_doc EQ 'KZ'. "2 Level approval
****            l_apprlevel = 1.
****            SELECT SINGLE userid FROM ztmg_appr_matrix
****            WHERE companycode = @l_comp AND apprlevel = '1'
****            AND userid      = @sy-uname
****            INTO @l_user.
****            IF sy-subrc = 0.
****              MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                     ENTITY zi_payment_head
****                     UPDATE FROM VALUE #( FOR key IN keys
****                                          ( Accountingdoc          = key-Accountingdoc
****                                            Fiscalyear             = key-Fiscalyear
****                                            Companycode            = key-Companycode
****                                            Appr1                  = 'X' " Booked
****                                            Inprocess              = 'X'
****                                            apprlevel              = l_apprlevel
****                                            status                 = 'In Approval'
****                                            %control-Accountingdoc = if_abap_behv=>mk-on
****                                            %control-Fiscalyear    = if_abap_behv=>mk-on
****                                            %control-Companycode   = if_abap_behv=>mk-on
****                                            %control-status        = if_abap_behv=>mk-on
****                                            %control-Appr1         = if_abap_behv=>mk-on
****                                            %control-Inprocess     = if_abap_behv=>mk-on
****                                            %control-apprlevel     = if_abap_behv=>mk-on ) )
****                     FAILED failed
****                     REPORTED reported.
****
****              " Read changed data for action result
****              READ ENTITIES OF zi_payment_head IN LOCAL MODE
****                   ENTITY zi_payment_head
****                   ALL FIELDS WITH
****                   CORRESPONDING #( keys )
****                   RESULT heads.
****
****              result = VALUE #( FOR head IN heads
****                                ( %tky   = head-%tky
****                                  %param = head ) ).
****
****              INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
****                                                            text     = 'Approved' ) )
****                     INTO TABLE reported-zi_payment_head.
****            ENDIF.
****          ENDIF.
****          "Code Here
****        ELSEIF l_head-appr1 = 'X' AND l_head-appr2 <> 'X' AND l_head-appr3 <> 'X'.
****          SELECT SINGLE actionedby FROM zdt_appr_log WHERE accountingdoc = @l_accdoc
****          AND fiscalyear = @l_fiscyear AND companycode = @l_comp AND apprlevel = 1 INTO @DATA(l_level1).
****          IF sy-subrc EQ 0 AND ( l_level1 <> sy-uname ).
****            SELECT SINGLE PayeeCityName FROM I_PaymentProposalPayment
****            WHERE PaymentDocument   = @l_accdoc
****            AND PayingCompanyCode = @l_comp AND FinancialAccountType = 'K'
****              INTO @l_payeecity.
****            IF sy-subrc = 0.
****              IF l_payeecity IS INITIAL.
****                ls_paysend-bene_branch = 'India' .
****              ELSE.
****                ls_paysend-bene_branch = l_payeecity.
****              ENDIF.
****            ELSE.
****              ls_paysend-bene_branch = 'India' .
****            ENDIF.
****            REPLACE ALL OCCURRENCES OF  '*() <>^`&; *() <>^`&;`";|&>\# --' IN l_head-suppliername WITH ' '.
****            ls_paysend-bene_acc_name      = l_head-suppliername.
*****            IF sy-sysid = 'YYQ'.
****            IF sy-sysid = 'PZJ'.
****              ls_paysend-input_gcif = 'CBXMGRT4'.
****              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
*****            ELSEIF sy-sysid = 'X6V'.
****            ELSEIF sy-sysid = 'A1S'.
****              ls_paysend-input_gcif = 'CBXMGRT4'.
****              ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
*****            ELSEIF sy-sysid = 'XDA'.
****            ELSEIF sy-sysid = 'AYR'.
****              ls_paysend-input_gcif = 'DHUNSERIPCX'.
****              ls_paysend-login_id = 'APIUSER'.
****            ENDIF.
*****          l_head-amountincompanycodecurrency = round( val = l_head-amountincompanycodecurrency dec = 2 ).
****            ls_paysend-input_debit_amount = COND #( WHEN l_head-amountincompanycodecurrency LT 0
****                                                THEN l_head-amountincompanycodecurrency * ( -1 )
****                                                ELSE l_head-amountincompanycodecurrency ).
****            ls_paysend-input_value_date   = |{ lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) }|.
****            ls_paysend-transaction_type   = 'SINGLE'.
****            ls_paysend-input_debit_amount = condense( val  = ls_paysend-input_debit_amount
****                                                      from = ` `
****                                                      to   = `` ).
*****            IF ( sy-sysid = 'YYQ' OR sy-sysid = 'X6V' ).
****            IF ( sy-sysid = 'PZJ' OR sy-sysid = 'A1S' ).
****              ls_paysend-transfer_type_desc     = 'IMPS'.
****              ls_paysend-input_debit_org_acc_no = '00500340000261'.
****              ls_paysend-bene_acc_no            = '00040350004239'.
****              ls_paysend-bene_idn_code          = 'CITI0000001'.
****            ELSEIF ( sy-sysid = 'AYR' ).
****              l_amt = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
****                                        THEN l_head-amountincompanycodecurrency * ( -1 )
****                                        ELSE l_head-amountincompanycodecurrency ).
****              IF l_head-payeebankkey CS 'HDFC'.
****                ls_paysend-transfer_type_desc = 'Intra Bank Transfer'.
****              ELSE.
****                IF l_amt > 200000.
****                  ls_paysend-transfer_type_desc = 'RTGS'.
****                ELSE.
****                  ls_paysend-transfer_type_desc = 'NEFT'.
****                ENDIF.
****              ENDIF.
****              ls_paysend-input_debit_org_acc_no = l_head-bankaccountnumber.
****              REPLACE ALL OCCURRENCES OF '''' IN ls_paysend-input_debit_org_acc_no WITH ''.
****              ls_paysend-bene_acc_no            = l_head-payeebankaccount.
****              REPLACE ALL OCCURRENCES OF '''' IN l_head-payeebankaccount WITH ''.
****              ls_paysend-bene_idn_code          = l_head-payeebankkey.
****            ENDIF.
****
****            SELECT SINGLE name FROM zi_appr_log WHERE Accountingdoc = @l_accdoc AND Fiscalyear = @l_fiscyear
****            AND Companycode = @l_comp AND Apprlevel = 1 INTO @l_benename.
****            IF sy-subrc EQ 0.
****              ls_paysend-bene_narration = l_benename.
****            ELSE.
****              ls_paysend-bene_narration = 'Finance User'.
****            ENDIF.
****            ls_paysend-input_business_prod = 'VENDBUS01'.
****            ls_paysend-bene_type           = 'ADHOC'.
****            ls_paysend-payment_ref_no      = l_accdoc && l_fiscyear && l_comp.
****
****            lv_json_post = /ui2/cl_json=>serialize( data = ls_paysend ).
****
****            TRY.
****                lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
****                  comm_scenario = 'ZFI_SC_PAYSEND'
****                  service_id    = 'ZFI_PAYSEND_REST' ).
****                lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
****                lo_request = lo_http_client->get_http_request( ).
****                lo_request->set_content_type( content_type = |application/json| ).
****                lo_request->set_text( lv_json_post ).
****                ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
****                lo_http_client->close( ).
****
****                CLEAR lv_json_post.
****                IF ls_result CS 'Accepted'.
****                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                         ENTITY zi_payment_head
****                         UPDATE FROM VALUE #( FOR key IN keys
****                                              ( Accountingdoc          = key-Accountingdoc
****                                                Fiscalyear             = key-Fiscalyear
****                                                Companycode            = key-Companycode
****                                                Appr1                  = 'X' " Booked
****                                                Inprocess              = ''
****                                                Approved               = 'X'
****                                                apprlevel              = l_apprlevel
****                                                status                 = 'Sent to Bank'
****                                                Appr2comment           = ls_result
****                                                Senton                 = lv_date
****                                                sentat                 = lv_time
****                                                sentby                 = sy-uname
****                                                %control-Accountingdoc = if_abap_behv=>mk-on
****                                                %control-Fiscalyear    = if_abap_behv=>mk-on
****                                                %control-Companycode   = if_abap_behv=>mk-on
****                                                %control-status        = if_abap_behv=>mk-on
****                                                %control-Appr1         = if_abap_behv=>mk-on
****                                                %control-Inprocess     = if_abap_behv=>mk-on
****                                                %control-Approved      = if_abap_behv=>mk-on
****                                                %control-apprlevel     = if_abap_behv=>mk-on
****                                                %control-Appr2comment  = if_abap_behv=>mk-on
****                                                %control-Senton        = if_abap_behv=>mk-on
****                                                %control-sentat        = if_abap_behv=>mk-on
****                                                %control-sentby        = if_abap_behv=>mk-on ) )
****                         FAILED failed
****                         REPORTED reported.
****                ELSE.
****                  MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                         ENTITY zi_payment_head
****                         UPDATE FROM VALUE #( FOR key IN keys
****                                              ( Accountingdoc          = key-Accountingdoc
****                                                Fiscalyear             = key-Fiscalyear
****                                                Companycode            = key-Companycode
****                                                Appr1                  = 'X' " Booked
****                                                Inprocess              = ''
****                                                Rejected               = 'X'
****                                                apprlevel              = l_apprlevel
****                                                status                 = 'Failed'
****                                                Appr2comment           = ls_result
****                                                Senton                 = lv_date
****                                                sentat                 = lv_time
****                                                sentby                 = sy-uname
****                                                %control-Accountingdoc = if_abap_behv=>mk-on
****                                                %control-Fiscalyear    = if_abap_behv=>mk-on
****                                                %control-Companycode   = if_abap_behv=>mk-on
****                                                %control-status        = if_abap_behv=>mk-on
****                                                %control-Appr1         = if_abap_behv=>mk-on
****                                                %control-Inprocess     = if_abap_behv=>mk-on
****                                                %control-Rejected      = if_abap_behv=>mk-on
****                                                %control-apprlevel     = if_abap_behv=>mk-on
****                                                %control-Appr2comment  = if_abap_behv=>mk-on
****                                                %control-Senton        = if_abap_behv=>mk-on
****                                                %control-sentat        = if_abap_behv=>mk-on
****                                                %control-sentby        = if_abap_behv=>mk-on ) )
****                         FAILED failed
****                         REPORTED reported.
****                ENDIF.
****
****                " Read changed data for action result
****                READ ENTITIES OF zi_payment_head IN LOCAL MODE
****                     ENTITY zi_payment_head
****                     ALL FIELDS WITH
****                     CORRESPONDING #( keys )
****                     RESULT heads.
****
****                result = VALUE #( FOR head IN heads
****                                  ( %tky   = head-%tky
****                                    %param = head ) ).
****
****              CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
****              CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
****            ENDTRY.
****
****            INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
****                                                          text     = 'Approved' ) )
****                   INTO TABLE reported-zi_payment_head.
****          ELSEIF ( l_level1 = sy-uname ).
****            READ ENTITIES OF zi_payment_head IN LOCAL MODE
****            ENTITY zi_payment_head
****            ALL FIELDS WITH
****            CORRESPONDING #( keys )
****            RESULT heads.
****
****            result = VALUE #( FOR head IN heads
****                              ( %tky   = head-%tky
****                                %param = head ) ).
****
****            INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
****                                                          text     = 'Approver cannot be same as verifier' ) )
****                 INTO TABLE reported-zi_payment_head.
****          ENDIF.
****        ENDIF.
****      ELSEIF l_head-appr1 = 'X' AND l_head-appr2 <> 'X' AND l_head-appr3 <> 'X'.  "KZ - 2nd Level
****        SELECT SINGLE actionedby FROM zdt_appr_log WHERE accountingdoc = @l_accdoc
****        AND fiscalyear = @l_fiscyear AND companycode = @l_comp AND apprlevel = 1 INTO @l_level1.
****        IF sy-subrc EQ 0 AND ( l_level1 <> sy-uname ).
****          SELECT SINGLE PayeeCityName FROM I_PaymentProposalPayment
****          WHERE PaymentDocument   = @l_accdoc
****                  AND PayingCompanyCode = @l_comp AND FinancialAccountType = 'K'
****                INTO @l_payeecity.
****          IF sy-subrc = 0.
****            ls_paysend-bene_branch = l_payeecity.
****          ELSE.
****            ls_paysend-bene_branch = 'India' .
****          ENDIF.
****          REPLACE ALL OCCURRENCES OF  '*() <>^`&; *() <>^`&;`";|&>\# --' IN l_head-suppliername WITH ' '.
****          ls_paysend-bene_acc_name      = l_head-suppliername.
*****          IF sy-sysid = 'YYQ'.
****          IF sy-sysid = 'PZJ'.
****            ls_paysend-input_gcif = 'CBXMGRT4'.
****            ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
*****          ELSEIF sy-sysid = 'X6V'.
****          ELSEIF sy-sysid = 'A1S'.
****            ls_paysend-input_gcif = 'CBXMGRT4'.
****            ls_paysend-login_id = 'APIUSER@CBXMGRT4'.
*****          ELSEIF sy-sysid = 'XDA'.
****          ELSEIF sy-sysid = 'AYR'.
****            ls_paysend-input_gcif = 'DHUNSERIPCX'.
****            ls_paysend-login_id = 'APIUSER'.
****          ENDIF.
*****        ls_paysend-transfer_type_desc = COND #( WHEN l_head-paymentmethod = 'I'    THEN 'IMPS'
*****                                                WHEN l_head-paymentmethod = 'N'    THEN 'NEFT'
*****                                                WHEN l_head-paymentmethod = 'R'    THEN 'RTGS'
*****                                                WHEN l_head-payeebankkey CS 'HDFC' THEN 'INTRA BANK TRANSFER' ).
****          ls_paysend-input_debit_amount = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
****                                              THEN l_head-amountincompanycodecurrency * ( -1 )
****                                              ELSE l_head-amountincompanycodecurrency ).
****          ls_paysend-input_value_date   = |{ lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) }|.
****          ls_paysend-transaction_type   = 'SINGLE'.
****          ls_paysend-input_debit_amount = condense( val  = ls_paysend-input_debit_amount
****                                                    from = ` `
****                                                    to   = `` ).
*****          IF ( sy-sysid = 'YYQ' OR sy-sysid = 'X6V' ).
****          IF ( sy-sysid = 'PZJ' OR sy-sysid = 'A1S' ).
****            ls_paysend-transfer_type_desc     = 'IMPS'.
****            ls_paysend-input_debit_org_acc_no = '00500340000261'.
****            ls_paysend-bene_acc_no            = '00040350004239'.
****            ls_paysend-bene_idn_code          = 'CITI0000001'.
*****          ELSEIF ( sy-sysid = 'XDA' ).
****          ELSEIF ( sy-sysid = 'AYR' ).
****            l_amt = COND dmbtr( WHEN l_head-amountincompanycodecurrency LT 0
****                                      THEN l_head-amountincompanycodecurrency * ( -1 )
****                                      ELSE l_head-amountincompanycodecurrency ).
****            IF l_head-payeebankkey CS 'HDFC'.
****              ls_paysend-transfer_type_desc = 'Intra Bank Transfer'.
****            ELSE.
****              IF l_amt > 200000.
****                ls_paysend-transfer_type_desc = 'RTGS'.
****              ELSE.
****                ls_paysend-transfer_type_desc = 'NEFT'.
****              ENDIF.
****            ENDIF.
****            ls_paysend-input_debit_org_acc_no = l_head-bankaccountnumber.
****            REPLACE ALL OCCURRENCES OF '''' IN ls_paysend-input_debit_org_acc_no WITH ''.
****            ls_paysend-bene_acc_no            = l_head-payeebankaccount.
****            REPLACE ALL OCCURRENCES OF '''' IN l_head-payeebankaccount WITH ''.
****            ls_paysend-bene_idn_code          = l_head-payeebankkey.
****          ENDIF.
****          ls_paysend-input_business_prod = 'VENDBUS01'.
****          ls_paysend-bene_type           = 'ADHOC'.
****          ls_paysend-payment_ref_no      = l_accdoc && l_fiscyear && l_comp.
****
****          lv_json_post = /ui2/cl_json=>serialize( data = ls_paysend ).
****
****          TRY.
****              lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
****                comm_scenario = 'ZFI_SC_PAYSEND'
****                service_id    = 'ZFI_PAYSEND_REST' ).
****              lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
****              lo_request = lo_http_client->get_http_request( ).
****              lo_request->set_content_type( content_type = |application/json| ).
****              lo_request->set_text( lv_json_post ).
****              ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
****              lo_http_client->close( ).
****
****              CLEAR lv_json_post.
****              IF ls_result CS 'Accepted'.
****                MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                       ENTITY zi_payment_head
****                       UPDATE FROM VALUE #( FOR key IN keys
****                                            ( Accountingdoc          = key-Accountingdoc
****                                              Fiscalyear             = key-Fiscalyear
****                                              Companycode            = key-Companycode
****                                              Appr1                  = 'X' " Booked
****                                              Inprocess              = ''
****                                              Approved               = 'X'
****                                              apprlevel              = l_apprlevel
****                                              status                 = 'Sent to Bank'
****                                              Appr2comment           = ls_result
****                                              Senton                 = lv_date
****                                              sentat                 = lv_time
****                                              sentby                 = sy-uname
****                                              %control-Accountingdoc = if_abap_behv=>mk-on
****                                              %control-Fiscalyear    = if_abap_behv=>mk-on
****                                              %control-Companycode   = if_abap_behv=>mk-on
****                                              %control-status        = if_abap_behv=>mk-on
****                                              %control-Appr1         = if_abap_behv=>mk-on
****                                              %control-Inprocess     = if_abap_behv=>mk-on
****                                              %control-Approved      = if_abap_behv=>mk-on
****                                              %control-apprlevel     = if_abap_behv=>mk-on
****                                              %control-Appr2comment  = if_abap_behv=>mk-on
****                                              %control-Senton        = if_abap_behv=>mk-on
****                                              %control-sentat        = if_abap_behv=>mk-on
****                                              %control-sentby        = if_abap_behv=>mk-on ) )
****                       FAILED failed
****                       REPORTED reported.
****              ELSE.
****                MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
****                       ENTITY zi_payment_head
****                       UPDATE FROM VALUE #( FOR key IN keys
****                                            ( Accountingdoc          = key-Accountingdoc
****                                              Fiscalyear             = key-Fiscalyear
****                                              Companycode            = key-Companycode
****                                              Appr1                  = 'X' " Booked
****                                              Inprocess              = ''
****                                              Rejected               = 'X'
****                                              apprlevel              = l_apprlevel
****                                              status                 = 'Failed'
****                                              Appr2comment           = ls_result
****                                              Senton                 = lv_date
****                                              sentat                 = lv_time
****                                              sentby                 = sy-uname
****                                              %control-Accountingdoc = if_abap_behv=>mk-on
****                                              %control-Fiscalyear    = if_abap_behv=>mk-on
****                                              %control-Companycode   = if_abap_behv=>mk-on
****                                              %control-status        = if_abap_behv=>mk-on
****                                              %control-Appr1         = if_abap_behv=>mk-on
****                                              %control-Inprocess     = if_abap_behv=>mk-on
****                                              %control-Rejected      = if_abap_behv=>mk-on
****                                              %control-apprlevel     = if_abap_behv=>mk-on
****                                              %control-Appr2comment  = if_abap_behv=>mk-on
****                                              %control-Senton        = if_abap_behv=>mk-on
****                                              %control-sentat        = if_abap_behv=>mk-on
****                                              %control-sentby        = if_abap_behv=>mk-on ) )
****                       FAILED failed
****                       REPORTED reported.
****              ENDIF.
****
****              " Read changed data for action result
****              READ ENTITIES OF zi_payment_head IN LOCAL MODE
****                   ENTITY zi_payment_head
****                   ALL FIELDS WITH
****                   CORRESPONDING #( keys )
****                   RESULT heads.
****
****              result = VALUE #( FOR head IN heads
****                                ( %tky   = head-%tky
****                                  %param = head ) ).
****
****            CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
****            CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
****          ENDTRY.
****
****          INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
****                                                        text     = 'Approved' ) )
****                 INTO TABLE reported-zi_payment_head.
*****        l_apprlevel = l_head-apprlevel + 1.
*****        SELECT SINGLE userid FROM ztmg_appr_matrix
*****          WHERE companycode = @l_comp AND apprlevel = '2'
*****            AND userid      = @sy-uname
*****          INTO @l_user.
*****        IF sy-subrc = 0.
*****          MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
*****                 ENTITY zi_payment_head
*****                 UPDATE FROM VALUE #( FOR key IN keys
*****                                      ( Accountingdoc          = key-Accountingdoc
*****                                        Fiscalyear             = key-Fiscalyear
*****                                        Companycode            = key-Companycode
*****                                        Appr2                  = 'X' " Booked
*****                                        Inprocess              = 'X'
*****                                        apprlevel              = l_apprlevel
*****                                        status                 = 'In Approval'
*****                                        %control-Accountingdoc = if_abap_behv=>mk-on
*****                                        %control-Fiscalyear    = if_abap_behv=>mk-on
*****                                        %control-Companycode   = if_abap_behv=>mk-on
*****                                        %control-status        = if_abap_behv=>mk-on
*****                                        %control-Appr2         = if_abap_behv=>mk-on
*****                                        %control-Inprocess     = if_abap_behv=>mk-on
*****                                        %control-apprlevel     = if_abap_behv=>mk-on ) )
*****                 FAILED failed
*****                 REPORTED reported.
*****
*****          " Read changed data for action result
*****          READ ENTITIES OF zi_payment_head IN LOCAL MODE
*****               ENTITY zi_payment_head
*****               ALL FIELDS WITH
*****               CORRESPONDING #( keys )
*****               RESULT heads.
*****
*****          result = VALUE #( FOR head IN heads
*****                            ( %tky   = head-%tky
*****                              %param = head ) ).
*****
*****          INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*****                                                        text     = 'Approved' ) )
*****                 INTO TABLE reported-zi_payment_head.
*****        ENDIF.
****        ELSEIF ( l_level1 = sy-uname ).
****          READ ENTITIES OF zi_payment_head IN LOCAL MODE
****          ENTITY zi_payment_head
****          ALL FIELDS WITH
****          CORRESPONDING #( keys )
****          RESULT heads.
****
****          result = VALUE #( FOR head IN heads
****                            ( %tky   = head-%tky
****                              %param = head ) ).
****
****          INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
****                                                        text     = 'Approver cannot be same as verifier' ) )
****               INTO TABLE reported-zi_payment_head.
****        ENDIF.
****      ELSEIF l_head-appr1 = 'X' AND l_head-appr2 = 'X' AND l_head-appr3 IS INITIAL.
****        l_apprlevel = l_head-apprlevel + 1.
****        SELECT SINGLE userid FROM ztmg_appr_matrix
****          WHERE companycode = @l_comp AND apprlevel = '3'
****            AND userid      = @sy-uname
****          INTO @l_user.
****        IF sy-subrc = 0.
*****        SELECT SINGLE PayeeCityName FROM I_PaymentProposalPayment
*****          WHERE PaymentDocument   = @l_accdoc
*****            AND PayingCompanyCode = @l_comp AND FinancialAccountType = 'K'
*****          INTO @DATA(l_payeecity).
*****        IF sy-subrc = 0.
*****          ls_paysend-bene_branch = l_payeecity.
*****        ELSE.
*****          ls_paysend-bene_branch = 'India' .
*****        ENDIF.
*****        ls_paysend-bene_acc_name      = l_head-suppliername.
*****        ls_paysend-login_id           = 'APIUSER@CBXMGRT4'.
*****        ls_paysend-input_gcif         = 'CBXMGRT4'.
*****        ls_paysend-transfer_type_desc = COND #( WHEN l_head-paymentmethod = 'I'    THEN 'IMPS'
*****                                                WHEN l_head-paymentmethod = 'N'    THEN 'NEFT'
*****                                                WHEN l_head-paymentmethod = 'R'    THEN 'RTGS'
*****                                                WHEN l_head-payeebankkey CS 'HDFC' THEN 'INTRA BANK TRANSFER' ).
*****        ls_paysend-input_debit_amount = l_head-amountincompanycodecurrency.
*****        ls_paysend-input_value_date   = |{ sy-datlo+6(2) }/{ sy-datlo+4(2) }/{ sy-datlo+0(4) }|.
*****        ls_paysend-transaction_type   = 'SINGLE'.
*****        ls_paysend-input_debit_amount = condense( val  = ls_paysend-input_debit_amount
*****                                                  from = ` `
*****                                                  to   = `` ).
*****        IF sy-sysid = 'YYQ'.
*****          ls_paysend-transfer_type_desc     = 'IMPS'.
*****          ls_paysend-input_debit_org_acc_no = '00500340000261'.
*****          ls_paysend-bene_acc_no            = '00040350004239'.
*****          ls_paysend-bene_idn_code          = 'CITI0000001'.
*****        ELSE.
*****          ls_paysend-input_debit_org_acc_no = l_head-bankaccountnumber.
*****          ls_paysend-bene_acc_no            = l_head-payeebankaccount.
*****          ls_paysend-bene_idn_code          = l_head-payeebankkey.
*****        ENDIF.
*****        ls_paysend-input_business_prod = 'VENDBUS01'.
*****        ls_paysend-bene_type           = 'ADHOC'.
*****        ls_paysend-payment_ref_no      = l_accdoc && l_fiscyear && l_comp.
*****
*****        lv_json_post = /ui2/cl_json=>serialize( data = ls_paysend ).
*****
*****        TRY.
*****            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*****              comm_scenario = 'ZFI_SC_PAYSEND'
*****              service_id    = 'ZFI_PAYSEND_REST' ).
*****            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*****            DATA(lo_request) = lo_http_client->get_http_request( ).
*****            lo_request->set_content_type( content_type = |application/json| ).
*****            lo_request->set_text( lv_json_post ).
*****            DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*****            lo_http_client->close( ).
*****
*****            CLEAR lv_json_post.
*****            IF ls_result CS 'Accepted'.
*****              MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
*****                     ENTITY zi_payment_head
*****                     UPDATE FROM VALUE #( FOR key IN keys
*****                                          ( Accountingdoc          = key-Accountingdoc
*****                                            Fiscalyear             = key-Fiscalyear
*****                                            Companycode            = key-Companycode
*****                                            Appr3                  = 'X' " Booked
*****                                            Inprocess              = ''
*****                                            Approved               = 'X'
*****                                            apprlevel              = l_apprlevel
*****                                            status                 = 'Sent to Bank'
*****                                            Appr2comment           = ls_result
*****                                            Senton                 = sy-datum
*****                                            sentat                 = sy-uzeit
*****                                            sentby                 = sy-uname
*****                                            %control-Accountingdoc = if_abap_behv=>mk-on
*****                                            %control-Fiscalyear    = if_abap_behv=>mk-on
*****                                            %control-Companycode   = if_abap_behv=>mk-on
*****                                            %control-status        = if_abap_behv=>mk-on
*****                                            %control-Appr3         = if_abap_behv=>mk-on
*****                                            %control-Inprocess     = if_abap_behv=>mk-on
*****                                            %control-Approved      = if_abap_behv=>mk-on
*****                                            %control-apprlevel     = if_abap_behv=>mk-on
*****                                            %control-Appr2comment  = if_abap_behv=>mk-on
*****                                            %control-Senton        = if_abap_behv=>mk-on
*****                                            %control-sentat        = if_abap_behv=>mk-on
*****                                            %control-sentby        = if_abap_behv=>mk-on ) )
*****                     FAILED failed
*****                     REPORTED reported.
*****            ELSE.
*****              MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
*****                     ENTITY zi_payment_head
*****                     UPDATE FROM VALUE #( FOR key IN keys
*****                                          ( Accountingdoc          = key-Accountingdoc
*****                                            Fiscalyear             = key-Fiscalyear
*****                                            Companycode            = key-Companycode
*****                                            Appr3                  = 'X' " Booked
*****                                            Inprocess              = ''
*****                                            Rejected               = 'X'
*****                                            apprlevel              = l_apprlevel
*****                                            status                 = 'Failed'
*****                                            Appr2comment           = ls_result
*****                                            Senton                 = sy-datum
*****                                            sentat                 = sy-uzeit
*****                                            sentby                 = sy-uname
*****                                            %control-Accountingdoc = if_abap_behv=>mk-on
*****                                            %control-Fiscalyear    = if_abap_behv=>mk-on
*****                                            %control-Companycode   = if_abap_behv=>mk-on
*****                                            %control-status        = if_abap_behv=>mk-on
*****                                            %control-Appr3         = if_abap_behv=>mk-on
*****                                            %control-Inprocess     = if_abap_behv=>mk-on
*****                                            %control-Rejected      = if_abap_behv=>mk-on
*****                                            %control-apprlevel     = if_abap_behv=>mk-on
*****                                            %control-Appr2comment  = if_abap_behv=>mk-on
*****                                            %control-Senton        = if_abap_behv=>mk-on
*****                                            %control-sentat        = if_abap_behv=>mk-on
*****                                            %control-sentby        = if_abap_behv=>mk-on ) )
*****                     FAILED failed
*****                     REPORTED reported.
*****            ENDIF.
*****
*****            " Read changed data for action result
*****            READ ENTITIES OF zi_payment_head IN LOCAL MODE
*****                 ENTITY zi_payment_head
*****                 ALL FIELDS WITH
*****                 CORRESPONDING #( keys )
*****                 RESULT heads.
*****
*****            result = VALUE #( FOR head IN heads
*****                              ( %tky   = head-%tky
*****                                %param = head ) ).
*****
*****          CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
*****          CATCH cx_web_http_client_error INTO DATA(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
*****        ENDTRY.
*****
*****        INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*****                                                      text     = 'Approved' ) )
*****               INTO TABLE reported-zi_payment_head.
****        ENDIF.
****      ENDIF.
****    ELSEIF (  l_cr = sy-uname ).
****      READ ENTITIES OF zi_payment_head IN LOCAL MODE
****        ENTITY zi_payment_head
****        ALL FIELDS WITH
****        CORRESPONDING #( keys )
****        RESULT heads.
****
****      result = VALUE #( FOR head IN heads
****                        ( %tky   = head-%tky
****                          %param = head ) ).
****
****      INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
****                                                    text     = 'Approver cannot be same as verifier' ) )
****             INTO TABLE reported-zi_payment_head.
****    ENDIF.
****  ENDMETHOD.
****
*****  METHOD approve2.
*****  ENDMETHOD.
*****
*****  METHOD approve3.
  ENDMETHOD.

  METHOD reject1.
    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-companycode OPTIONAL ).
    DATA l_apprlevel TYPE zdt_payment_head-apprlevel.
    DATA: lt_jr TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.

*    APPEND INITIAL LINE TO lt_jr ASSIGNING FIELD-SYMBOL(<jr>).
*    "Reversal BO
*    <jr>-companycode = l_comp.
*    <jr>-fiscalyear = l_fiscyear.
*    <jr>-accountingdocument = l_accdoc.
*    <jr>-%param = VALUE #(
*    postingdate    = sy-datlo
*    reversalreason = '01'
*    createdbyuser  = sy-uname ).
*
*    MODIFY ENTITIES OF i_journalentrytp FORWARDING PRIVILEGED
*    ENTITY journalentry
*    EXECUTE reverse FROM lt_jr
*    FAILED DATA(ls_failed)
*    REPORTED DATA(ls_reported)
*    MAPPED DATA(ls_mapped).
*    IF ls_failed-journalentry IS INITIAL.
*
*    ENDIF.
*    SELECT * FROM zdt_payment_head INTO TABLE @DATA(lt_del).
*    IF sy-subrc EQ 0.
*        DELETE zdt_payment_head FROM TABLE @lt_del.
*    ENDIF.
    SELECT SINGLE accountingdoccreatedbyuser FROM i_journalentry WHERE
    accountingdocument = @l_accdoc AND fiscalyear = @l_fiscyear AND companycode = @l_comp INTO @DATA(l_cr).
    IF sy-subrc EQ 0 AND ( l_cr <> sy-uname ).
      SELECT SINGLE * FROM zi_payment_head WHERE accountingdoc = @l_accdoc
      AND fiscalyear = @l_fiscyear AND companycode = @l_comp
      INTO @DATA(l_head).
      IF sy-subrc = 0.
        l_apprlevel = 1.
        SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '1'
        AND userid = @sy-uname INTO @DATA(l_user).
        IF sy-subrc EQ 0.
          MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                 ENTITY zi_payment_head
                    UPDATE FROM VALUE #( FOR key IN keys
                                         ( accountingdoc      = key-accountingdoc
                                           fiscalyear         = key-fiscalyear
                                           companycode        = key-companycode
                                           reject1            = 'X' " Booked
                                           rejected           = 'X'
                                           inprocess          = ''
                                           apprlevel          = l_apprlevel
                                           status             = 'Rejected'
                                           %control-status    = if_abap_behv=>mk-on
                                           %control-reject1   = if_abap_behv=>mk-on
                                           %control-inprocess = if_abap_behv=>mk-on
                                           %control-rejected  = if_abap_behv=>mk-on
                                           %control-apprlevel = if_abap_behv=>mk-on ) )
                    FAILED failed
                    REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_payment_head IN LOCAL MODE
            ENTITY zi_payment_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT DATA(heads).

          result = VALUE #( FOR head IN heads
                            ( %tky     = head-%tky
                              %param   = head
                              %cid_ref = if_abap_behv=>fc-o-disabled ) ).

          INSERT VALUE #(
            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected' )
          ) INTO TABLE reported-zi_payment_head.
        ENDIF.
      ELSEIF l_head-appr1 = 'X' AND l_head-appr2 IS INITIAL AND l_head-appr3 IS INITIAL.
        l_apprlevel = l_head-apprlevel + 1.
        SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '2'
        AND userid = @sy-uname INTO @l_user.
        IF sy-subrc EQ 0.
          MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                 ENTITY zi_payment_head
                    UPDATE FROM VALUE #( FOR key IN keys
                                         ( accountingdoc      = key-accountingdoc
                                           fiscalyear         = key-fiscalyear
                                           companycode        = key-companycode
                                           reject2            = 'X' " Booked
                                           rejected           = 'X'
                                           inprocess          = ''
                                           apprlevel          = l_apprlevel
                                           status             = 'Rejected'
                                           %control-status    = if_abap_behv=>mk-on
                                           %control-reject2   = if_abap_behv=>mk-on
                                           %control-inprocess = if_abap_behv=>mk-on
                                           %control-apprlevel = if_abap_behv=>mk-on
                                           %control-rejected  = if_abap_behv=>mk-on ) )
                    FAILED failed
                    REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_payment_head IN LOCAL MODE
            ENTITY zi_payment_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT heads.

          result = VALUE #( FOR head IN heads
                            ( %tky   = head-%tky
                              %param = head ) ).

          INSERT VALUE #(
            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected' )
          ) INTO TABLE reported-zi_payment_head.
        ENDIF.
      ELSEIF l_head-appr1 = 'X' AND l_head-appr2 = 'X' AND l_head-appr3 IS INITIAL.
        l_apprlevel = l_head-apprlevel + 1.
        SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '3'
        AND userid = @sy-uname INTO @l_user.
        IF sy-subrc EQ 0.
          MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
                 ENTITY zi_payment_head
                    UPDATE FROM VALUE #( FOR key IN keys
                                         ( accountingdoc      = key-accountingdoc
                                           fiscalyear         = key-fiscalyear
                                           companycode        = key-companycode
                                           reject3            = 'X' " Booked
                                           rejected           = 'X'
                                           inprocess          = ''
                                           apprlevel          = l_apprlevel
                                           status             = 'Rejected'
                                           %control-status    = if_abap_behv=>mk-on
                                           %control-reject3   = if_abap_behv=>mk-on
                                           %control-inprocess = if_abap_behv=>mk-on
                                           %control-apprlevel = if_abap_behv=>mk-on
                                           %control-rejected  = if_abap_behv=>mk-on ) )
                    FAILED failed
                    REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_payment_head IN LOCAL MODE
            ENTITY zi_payment_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT heads.

          result = VALUE #( FOR head IN heads
                            ( %tky   = head-%tky
                              %param = head ) ).

          INSERT VALUE #(
            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected' )
          ) INTO TABLE reported-zi_payment_head.
        ENDIF.
      ENDIF.
    ELSEIF (  l_cr = sy-uname ).
      READ ENTITIES OF zi_payment_head IN LOCAL MODE
        ENTITY zi_payment_head
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT heads.

      result = VALUE #( FOR head IN heads
                        ( %tky   = head-%tky
                          %param = head ) ).
      INSERT VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
                                                    text     = 'Approver cannot be same as verifier' ) )
             INTO TABLE reported-zi_payment_head.
    ENDIF.
  ENDMETHOD.

*  METHOD Reject2.
*  ENDMETHOD.
*
*  METHOD Reject3.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_payment_head DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

    METHODS cleanup REDEFINITION.

ENDCLASS.

CLASS lsc_zi_payment_head IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_head TYPE STANDARD TABLE OF zdt_payment_head,
           ls_head TYPE zdt_payment_head,
           lt_log  TYPE STANDARD TABLE OF zdt_appr_log,
           lt_log1 TYPE STANDARD TABLE OF zdt_appr_log.
    DATA: lo_obj TYPE REF TO zcl_payment_save.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA l_timestamp TYPE timestamp.

    l_timestamp = sy-datum && sy-uzeit.
    CONVERT TIME STAMP l_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    CREATE OBJECT lo_obj.
    DATA: lt_jr TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.
    IF update IS NOT INITIAL.
      lt_head = CORRESPONDING #(  update-zi_payment_head ).
      IF lt_head[] IS NOT INITIAL.
        ls_head = VALUE #( lt_head[ 1 ] OPTIONAL ).
*        CALL METHOD lo_obj->save CHANGING head = ls_head.
*        CALL FUNCTION 'ZFM_PAYMENT' EXPORTING head = ls_head.
*         MODIFY zdt_payment_head FROM TABLE @lt_head."zdt_payment_head
      ENDIF.
      SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel,b~inprocess,b~rejected,b~approved
      FROM zdt_appr_log AS a
      INNER JOIN @lt_head AS b
      ON ( b~accountingdoc = a~accountingdoc AND b~fiscalyear = a~fiscalyear AND b~companycode = a~companycode )
      INTO TABLE @DATA(lt_apprlog).
      SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
      IF lt_apprlog[] IS INITIAL. "No previous logs
        lt_log[] = VALUE #( FOR wa IN lt_head ( accountingdoc = wa-accountingdoc fiscalyear = wa-fiscalyear
                          companycode = wa-companycode apprlevel = 1
                          supplier = wa-supplier actionedby = sy-uname actionedon = lv_date
                          actionedat = lv_time action = COND #( WHEN wa-inprocess = 'X' THEN 'Approve'
                                                                 WHEN wa-approved = 'X' THEN 'Approve'
                                                                 WHEN wa-rejected = 'X' THEN 'Reject' ) ) ).
        IF lt_log[] IS NOT INITIAL.
          MODIFY zdt_appr_log FROM TABLE @lt_log.
        ENDIF.

      ELSE.
        lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                          companycode = wa1-companycode apprlevel = ( wa1-apprlevel + 1 )
                          supplier = wa1-supplier actionedby = sy-uname actionedon = lv_date
                          actionedat = lv_time action = COND #( WHEN wa1-inprocess = 'X' THEN 'Approve'
                                                                 WHEN wa1-approved = 'X' THEN 'Approve'
                                                                 WHEN wa1-rejected = 'X' THEN 'Reject' ) ) ).
        DATA(l_level) = VALUE #( lt_apprlog[ 1 ]-apprlevel OPTIONAL ).
        IF l_level <> '1'.
          lt_log1[] = VALUE #( FOR wa2 IN lt_log ( accountingdoc = wa2-accountingdoc fiscalyear = wa2-fiscalyear
                                                   companycode   = wa2-companycode   apprlevel  = ( wa2-apprlevel + 1 )
                                                   supplier      = wa2-supplier      actionedby = sy-uname actionedon = lv_date
                                                   actionedat    = lv_time           action     = 'Int Status'
                                                   apprcomment   = VALUE #( lt_head[ 1 ]-appr2comment OPTIONAL ) ) ).
          lt_log[] = CORRESPONDING #(  BASE (  lt_log[] ) lt_log1[] ).
        ENDIF.
        IF lt_log[] IS NOT INITIAL.
          MODIFY zdt_appr_log FROM TABLE @lt_log.
        ENDIF.
      ENDIF.
      MODIFY zdt_payment_head FROM TABLE @lt_head.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

ENDCLASS.
