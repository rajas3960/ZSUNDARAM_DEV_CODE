CLASS lhc_zpo_i_pogst DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zpo_i_pogst RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zpo_i_pogst RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zpo_i_pogst RESULT result.

    METHODS pogst_post FOR MODIFY
      IMPORTING keys FOR ACTION zpo_i_pogst~pogst_post RESULT result.

ENDCLASS.

CLASS lhc_zpo_i_pogst IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD pogst_post.
**********************************************************************
    DATA lv_json          TYPE string.
    DATA clientcd        TYPE string.
    DATA: clientgstin  TYPE string,
          mappingcd    TYPE string,
          templatecd   TYPE string,
          uploadtype   TYPE string,
          periodtype   TYPE string,
          invoicedate  TYPE string,
          SModule       type string,
          PModule       type string,
          invoicevalue TYPE string,
          taxablevalue TYPE string,
          taxrate      TYPE string,
          igstamt      TYPE string,
          cgstamt      TYPE string,
          sgstamt      TYPE string,
          cessamt      TYPE string,
          Invoicetype      TYPE string,
          self_gstin        TYPE string,
          SupplyType      TYPE string.
**********************************************************************
    DATA: invoicevalue_n TYPE n LENGTH 13,
          taxablevalue_n TYPE n LENGTH 11,
          taxrate_n      TYPE n LENGTH 2,
          igstamt_n      TYPE n LENGTH 11,
          cgstamt_n      TYPE n LENGTH 11,
          sgstamt_n      TYPE n LENGTH 11,
          cessamt_n      TYPE n LENGTH 11.

    DATA lv_diffgstn    TYPE string.
    DATA: gt_status TYPE TABLE OF ZPO_GSTSTATUS_DB,
          gs_status TYPE ZPO_GSTSTATUS_DB.
**********************************************************************

    READ ENTITIES OF zpo_i_pogst IN LOCAL MODE
    ENTITY zpo_i_pogst
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_head)
    FAILED DATA(lt_failed).

    DATA(ls_head) = VALUE #( lt_head[ 1 ] OPTIONAL ).
    IF ls_head-DocumentDate IS NOT INITIAL.
      invoicedate = |{ ls_head-DocumentDate+6(2) }-{ ls_head-DocumentDate+4(2) }-{ ls_head-DocumentDate(4) }|.
    ENDIF.

    IF ls_head-invoicevalue IS NOT INITIAL.
      invoicevalue_n = ls_head-invoicevalue.
      invoicevalue = |{ invoicevalue_n ALPHA = OUT }|.
      CONDENSE invoicevalue.
    ENDIF.
    IF ls_head-taxablevalue IS NOT INITIAL.
      taxablevalue_n = ls_head-taxablevalue.
      taxablevalue = |{ taxablevalue_n ALPHA = OUT }|.
      CONDENSE taxablevalue.
    ENDIF.

    if ls_head-CgstType is not inITIAL.
    taxrate_n = ( ls_head-CgstRate * 2 ).
*    taxrate = |{ taxrate_n ALPHA = OUT }|.
    taxrate = taxrate_n.
    endif.
    if ls_head-IgstType is not inITIAL.
    taxrate_n = ls_head-IgstRate.
*    taxrate = |{ taxrate_n ALPHA = OUT }|.
    taxrate = taxrate_n.
    endif.

    igstamt_n = ls_head-IgstAmt.
    igstamt = |{ igstamt_n ALPHA = OUT }|.
    CONDENSE igstamt.

    cgstamt_n = ls_head-CgstAmt.
    cgstamt = |{ cgstamt_n ALPHA = OUT }|.
    CONDENSE cgstamt.

    sgstamt_n = ls_head-SgstAmt.
    sgstamt = |{ sgstamt_n ALPHA = OUT }|.
    CONDENSE sgstamt.

*        clientgstin = ls_head-selfgstin.
*        clientcd = ls_head-clientid.
    if ls_head-CompanyCode = '1000'.
    clientgstin = '20AAMCS4941D1ZM'.
    clientcd = 'AAMCS4941D'.
    self_gstin = '20AAMCS4941D1ZM'.
    elseif ls_head-CompanyCode = '2000'.
    clientgstin = '20AACCC3707F1ZE'.
    clientcd = 'AACCC3707F'.
    self_gstin = '20AACCC3707F1ZE'.
    elseif ls_head-CompanyCode = '3000'.
    clientgstin = '20AACCN8200C1ZB'.
    clientcd = 'AACCN8200C'.
    self_gstin = '20AACCN8200C1ZB'.
    elsEIF ls_head-CompanyCode = '4000'.
    clientgstin = '20AABCJ6505H2Z1'.
    clientcd = 'AABCJ6505H'.
    self_gstin = '20AABCJ6505H2Z1'.
    endif.

    IF ls_head-AccountingDocument IS NOT INITIAL.

*      CONCATENATE
*    '{'
*        '"trans_type_code": "B2B",'
*        '"fp": "72017",'
*        '"ack_sr_no": "1",'
*        '"self_gstin": "20AACCC3707F1ZE",'
*        '"system_cd": "",'
*        '"branch_cd": "",'
*        '"vertical_cd": "",'
*        '"result_flag": "A",'
*        '"cp_gstin": "07CQZCD1111I4Z7",'
*        '"cp_gstin_name": "Kamath Foods Pvt. Ltd.",'
*        '"invoice_type": "R",'
*        '"invoice_no": "INVUPLB2B-/002",'
*        '"invoice_dt": "15-07-2017",'
*        '"invoice_val": "100000",'
*        '"taxable_val": "100000",'
*        '"items_serial_no": "1",'
*        '"rate_of_tax": "5",'
*        '"igst_amnt": "5000",'
*        '"cgst_amnt": "",'
*        '"sgst_amnt": "",'
*        '"cess_amnt": "100",'
*        '"pos": "25",'
*        '"rchrg": "N",'
*        '"eligibility_of_itc": "no",'
*        '"tot_tax_avlbl_itc_igst": "0",'
*        '"tot_tax_avlbl_itc_cgst": "",'
*        '"tot_tax_avlbl_itc_sgst": "",'
*        '"total_tax_itc_cess": "0",'
*        '"gstn_of_supplier": "",'
*        '"orignal_invoice_no": "",'
*        '"orignal_invoice_dt": "",'
*        '"supply_type": "",'
*        '"is_pur_frm_sez": "",'
*        '"sez_gstin": "",'
*        '"exp_suppliername": "",'
*        '"port_code": "",'
*        '"bill_entry_exprt_no": "",'
*        '"bill_entry_exprt_dt": "",'
*        '"bill_entry_exprt_val": "",'
*        '"or_bill_entry_exprt_no": "",'
*        '"or_bill_entry_exprt_dt": "",'
*        '"dtls_imprt_srvc_no": "",'
*        '"dtls_imprt_srvc_dt": "",'
*        '"dtls_imprt_srvc_val": "",'
*        '"dtls_imprt_srvc_txblval": "",'
*        '"or_dtls_imprt_srvc_no": "",'
*        '"or_dtls_imprt_srvc_dt": "",'
*        '"type_of_note": "",'
*        '"db_cr_issue_reason": "",'
*        '"is_pre_gst_regime": "",'
*        '"dbt_crdt_note_no": "",'
*        '"dbt_crdt_note_dt": "",'
*        '"dbt_crdt_note_val": "",'
*        '"diff_value": "",'
*        '"diff_igst_amnt": "",'
*        '"diff_cgst_amnt": "",'
*        '"diff_sgst_amnt": "",'
*        '"diff_cess_amnt": "",'
*        '"or_dbt_crdt_note_no": "",'
*        '"or_dbt_crdt_note_dt": ""'
*    '}'
*
*                  INTO lv_json.

*//this direct value passing to JSON
      if ls_head-TransType = 'B2B'.
        invoicetype = 'R'.
        supplytype = ''.
        CONDENSE invoicetype.
        CONDENSE supplytype.

      elseif ls_head-TransType = 'B2BUR'.
        invoicetype = ''.
        supplytype = 'INTRA'.
        CONDENSE invoicetype.
        CONDENSE supplytype.
      ENDIF.
      CONCATENATE

    '{'
        '"trans_type_code": "' ls_head-TransType '",'
        '"fp": "' ls_head-Fiscalperiod '",'
        '"ack_sr_no": "1",'
*        '"self_gstin": "' ls_head-Selfgstin '",'
        '"self_gstin": "' self_gstin '",'
        '"system_cd": "",'
        '"branch_cd": "",'
        '"vertical_cd": "",'
        '"result_flag": "' ls_head-Resultflag '",'
        '"cp_gstin": "' ls_head-SupGSTIN '",'
        '"cp_gstin_name": "' ls_head-BPSupplierFullName '",'
        '"invoice_type": "' invoicetype '",'
        '"invoice_no": "' ls_head-AccountingDocument '",'
        '"invoice_dt": "' invoicedate '",'
        '"invoice_val": "' invoicevalue '",'
        '"taxable_val": "' taxablevalue '",'
        '"items_serial_no": "' ls_head-LedgerGLLineItem '",'
        '"rate_of_tax": "' taxrate '",'
        '"igst_amnt": "' igstamt '",'
        '"cgst_amnt": "' cgstamt '",'
        '"sgst_amnt": "' sgstamt '",'
        '"cess_amnt": "",'
        '"pos": "25",'
        '"rchrg": "N",'
        '"eligibility_of_itc": "no",'
        '"tot_tax_avlbl_itc_igst": "0",'
        '"tot_tax_avlbl_itc_cgst": "",'
        '"tot_tax_avlbl_itc_sgst": "",'
        '"total_tax_itc_cess": "0",'
        '"gstn_of_supplier": "",'
        '"orignal_invoice_no": "",'
        '"orignal_invoice_dt": "",'
        '"supply_type": "' supplytype '",'
        '"is_pur_frm_sez": "",'
        '"sez_gstin": "",'
        '"exp_suppliername": "",'
        '"port_code": "",'
        '"bill_entry_exprt_no": "",'
        '"bill_entry_exprt_dt": "",'
        '"bill_entry_exprt_val": "",'
        '"or_bill_entry_exprt_no": "",'
        '"or_bill_entry_exprt_dt": "",'
        '"dtls_imprt_srvc_no": "",'
        '"dtls_imprt_srvc_dt": "",'
        '"dtls_imprt_srvc_val": "",'
        '"dtls_imprt_srvc_txblval": "",'
        '"or_dtls_imprt_srvc_no": "",'
        '"or_dtls_imprt_srvc_dt": "",'
        '"type_of_note": "",'
        '"db_cr_issue_reason": "",'
        '"is_pre_gst_regime": "",'
        '"dbt_crdt_note_no": "",'
        '"dbt_crdt_note_dt": "",'
        '"dbt_crdt_note_val": "",'
        '"diff_value": "",'
        '"diff_igst_amnt": "",'
        '"diff_cgst_amnt": "",'
        '"diff_sgst_amnt": "",'
        '"diff_cess_amnt": "",'
        '"or_dbt_crdt_note_no": "",'
        '"or_dbt_crdt_note_dt": ""'
    '}'

                  INTO lv_json.
*///

      IF clientgstin IS NOT INITIAL AND clientcd IS NOT INITIAL.


        mappingcd = 'MFHSPDTN0000004'.
        templatecd = 'PurchaseInvoiceData807'.
        uploadtype = 'json'.
*        pmodule = 'purchaseInvUpld'.   "salesInvUpld
*        smodule = 'salesInvUpld'.   "salesInvUpld
        periodtype = ls_head-Fiscalperiod.

        TRY.
            FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                        comm_scenario = 'ZCOMM_POGST_INTE'
                                        service_id    = 'ZPOGST_INTE_REST' ).
            FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
            FINAL(lo_request) = lo_http_client->get_http_request( ).
            lo_request->set_content_type( content_type = |application/json| ).

            "Client CD
            lo_request->set_header_field( i_name  = 'ClientCode'
                                        i_value = clientcd ).
            "Mapping CD
            lo_request->set_header_field( i_name  = 'MappingCD'
                                        i_value = mappingcd ).
            "Template CD
            lo_request->set_header_field( i_name  = 'TemplateCD'
                                        i_value = templatecd ).
            "Client GSTIN
            lo_request->set_header_field( i_name  = 'GSTIN'
                                          i_value = clientgstin ).
            "Upload Type
            lo_request->set_header_field( i_name  = 'UpType'
                                          i_value = uploadtype ).
            "Period
            lo_request->set_header_field( i_name  = 'Period'
                                          i_value = periodtype ).

            lo_request->set_text( lv_json ).
            FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
            lo_http_client->close( ).
            CLEAR lv_json.
          CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
          CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

      ENDIF.
    ENDIF.
*********************************************************
*            data(ls_result) = '{"Status":202,"ackNo":"25930232123"}'.

    IF ls_result IS NOT INITIAL.
      SPLIT ls_result AT '"Status":' INTO DATA(lv_text) DATA(lv_text1).
      SPLIT lv_text1 AT ',"ac' INTO DATA(finalstatus) DATA(lv_text2).
      SPLIT ls_result AT '"ackNo":"' INTO DATA(lv_text3) DATA(lv_text4).
      SPLIT lv_text4 AT '"}' INTO DATA(ackno) DATA(lv_text5).
      CONDENSE finalstatus.
      CONDENSE ackno.
    ENDIF.
*********************************************************
    IF ackno IS NOT INITIAL.
**********************************************************************
      GET TIME STAMP FIELD DATA(ts).
      CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).

      TRY.
          DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
        CATCH cx_abap_context_info_error.
          DATA(ls_x1) = 1.
      ENDTRY.
      DATA(lv_cbuser) = 'CB' && lv_user.

      select single UserID,PersonFullName from I_BUSINESSUSERBASIC with PRIVILEGED ACCESS
      where UserID = @lv_cbuser

      into @data(name).
**********************************************************************
      gs_status-fiscalyear = ls_head-fiscalyear.
      gs_status-companycode = ls_head-CompanyCode.
      gs_status-accountingdocument = ls_head-accountingdocument.
      gs_status-sourceledger = ls_head-sourceledger.
      gs_status-LedgerGLLineItem = ls_head-LedgerGLLineItem.

      gs_status-statuscode = finalstatus.
      gs_status-ackno = ackno.
      gs_status-createdby = lv_cbuser.
      gs_status-createdat = lv_time.
      gs_status-createdname = name-PersonFullName.


      APPEND gs_status TO gt_status.
      zbp_po_i_pogst=>lt_status = gt_status.
**********************************************************************
      data(msg) = |Posting Success "Ack"{ ackno }|.
      APPEND VALUE #( %tky = ls_head-%tky
                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                text = msg ) )
                TO reported-zpo_i_pogst.
    ELSE.

      APPEND VALUE #( %tky = ls_head-%tky
                %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                text = 'GST Not Posted ' ) )
                TO reported-zpo_i_pogst.
    ENDIF.

**********************************************************************

    result = VALUE #( FOR head IN lt_head
                      ( %tky   = head-%tky
                        %param = head ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zpo_i_pogst DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zpo_i_pogst IMPLEMENTATION.

  METHOD save_modified.

  if zbp_po_i_pogst=>lt_status is not INITIAL.
    MODIFY ZPO_GSTSTATUS_DB from table @zbp_po_i_pogst=>lt_status.
  endif.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
