CLASS lhc_ZMM_GATEHEAD_RVI DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zmm_gatehead_rvi RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_gatehead_rvi RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zmm_gatehead_rvi RESULT result.

    METHODS bgr FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~bgr RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~cancel RESULT result.

    METHODS del FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~del RESULT result.

    METHODS gengate FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~gengate RESULT result.

    METHODS genitem FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~genitem RESULT result.

    METHODS getinv FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~getinv RESULT result.

    METHODS inv FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~inv RESULT result.

    METHODS pgi FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~pgi RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~print RESULT result.

    METHODS setout FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~setout RESULT result.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zmm_gatehead_rvi~upd RESULT result.

    METHODS headerdetails1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_gatehead_rvi~headerdetails1.

    METHODS headerdetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmm_gatehead_rvi~headerdetails.

    METHODS itemmodify FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmm_gatehead_rvi~itemmodify.

    METHODS headdet FOR VALIDATE ON SAVE
      IMPORTING keys FOR zmm_gatehead_rvi~headdet.

    METHODS vehiclecheck FOR VALIDATE ON SAVE
      IMPORTING keys FOR zmm_gatehead_rvi~vehiclecheck.

*    METHODS pendingqty FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zmm_gatehead_rvi~pendingqty.

ENDCLASS.

CLASS lhc_ZMM_GATEHEAD_RVI IMPLEMENTATION.

  METHOD get_instance_features.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_header2)
    FAILED FINAL(lt_header2_failed).

*    SELECT SINGLE * FROM zpostgr_matrix
*    WHERE suser = @sy-uname
*    INTO @DATA(ls_post).

    SELECT SINGLE * FROM ZMM_CONFIRM_DB
    WHERE suser = @sy-uname
    INTO @DATA(ls_confirm).
******************************************************************
    result = VALUE #( FOR gs_header1 IN lt_header2
                      ( %tky                            = gs_header1-%tky
                       %assoc-_item1                    = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )

                       %assoc-_item                    = COND #( WHEN gs_header1-status = 'Exited'
                                                                OR ( gs_header1-Movementtype = 'INWARD' and gs_header1-materialprocess = 'RGP' )
                                                                  OR gs_header1-status = 'Cancelled & Exited'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )


                       %action-bgr  = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND gs_header1-movementtype <> 'OUTWARD'
                                            AND  gs_header1-materialprocess <> 'RGP' AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited'

                                            AND (  gs_header1-grstatus = 'Error' OR gs_header1-grstatus = '' OR gs_header1-grstatus = 'GR Partially Posted' )
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
                       %action-genitem  = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL
*                                            AND  gs_header1-materialprocess <> 'RGP'
                                            AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited'
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
*just deleting purpose i can commented
*                       %delete  = COND #( WHEN gs_header1-gatepassno IS  INITIAL
*                                                                  THEN if_abap_behv=>fc-o-enabled
*                                                                  ELSE if_abap_behv=>fc-o-disabled )

                       %action-gengate  = COND #( WHEN gs_header1-gatepassno IS  INITIAL AND gs_header1-status = 'Under Process'
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )
                       %action-del = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND gs_header1-movementtype <> 'INWARD'
                                            AND  gs_header1-materialprocess <> 'RGP' AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited' AND gs_header1-deliverydocument IS INITIAL
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
                      %action-upd = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND gs_header1-movementtype <> 'INWARD'
                                            AND  gs_header1-materialprocess <> 'RGP' AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited' AND gs_header1-deliverydocument IS NOT INITIAL
                                            AND  gs_header1-textupdated IS INITIAL  "ls_post-suser IS NOT INITIAL AND
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
                       %action-pgi = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND gs_header1-movementtype <> 'INWARD'
                                            AND  gs_header1-materialprocess <> 'RGP' AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited' AND gs_header1-textupdated IS NOT INITIAL
                                             AND gs_header1-pgistat IS INITIAL  "AND ls_post-suser IS NOT INITIAL
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
                       %action-inv = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND gs_header1-movementtype <> 'INWARD'
                                            AND  gs_header1-materialprocess <> 'RGP' AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited' AND gs_header1-pgistat IS NOT INITIAL
                                             AND  gs_header1-crtinv IS  INITIAL " AND ls_post-suser IS NOT INITIAL
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
                      %action-getinv = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND gs_header1-movementtype <> 'INWARD'
                                            AND  gs_header1-materialprocess <> 'RGP' AND gs_header1-status <> 'Cancelled'
                                            AND  gs_header1-status <> 'Cancelled & Exited' AND gs_header1-pgistat IS NOT INITIAL
                                            AND  gs_header1-crtinv = 'X' AND gs_header1-taxinvoice = ' ' " AND ls_post-suser IS NOT INITIAL
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled  )
                       %action-cancel = COND #( WHEN gs_header1-gatepassno IS NOT INITIAL AND  gs_header1-status = 'Gatepass Created'
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )
                       %action-setout =    COND #( WHEN gs_header1-gatepassno IS  INITIAL OR gs_header1-status = 'Exited'
                                                    OR  gs_header1-status = 'Cancelled & Exited'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )
                       %action-print =    COND #( WHEN gs_header1-gatepassno IS  INITIAL OR gs_header1-status = 'Cancelled'
                                                                  THEN if_abap_behv=>fc-o-disabled
                                                                  ELSE if_abap_behv=>fc-o-enabled )
                       %field-invoicedate =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                       %field-invoiceno =  COND #( WHEN gs_header1-gatepassno IS  INITIAL AND gs_header1-materialprocess <> 'STORES'
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                       %field-lrrrdate =  COND #( WHEN  gs_header1-status <> 'Exited' OR  gs_header1-status <> 'Cancelled & Exited'
                                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                                      ELSE if_abap_behv=>fc-f-read_only )
                     %field-lrrrno =  COND #( WHEN  gs_header1-status <> 'Exited' OR  gs_header1-status <> 'Cancelled & Exited'
                                                                      THEN if_abap_behv=>fc-f-unrestricted
                                                                      ELSE if_abap_behv=>fc-f-read_only )

                    %field-supplierdesc =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                    AND ( ( gs_header1-movementtype = 'INWARD' AND gs_header1-materialprocess <> 'STORES' )
                                                   OR ( gs_header1-movementtype = 'OUTWARD' AND  gs_header1-materialprocess = 'RGP' ) )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-supplierno =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                   AND (  ( gs_header1-movementtype = 'INWARD' AND gs_header1-materialprocess <> 'STORES' )
                                                   OR ( gs_header1-movementtype = 'OUTWARD' AND  gs_header1-materialprocess = 'RGP' ) )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE
                                                                  if_abap_behv=>fc-f-read_only )
                    %field-customerdesc =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                              AND ( ( gs_header1-movementtype = 'OUTWARD' AND gs_header1-materialprocess <> 'RGP' )
                                               )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-customerno =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                        AND ( ( gs_header1-movementtype = 'OUTWARD'  AND gs_header1-materialprocess <> 'RGP' )
                       )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )

                    %field-vehicleno =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
*this code added by SAR TechTeam by 10-11-2025-------
                    %field-Entrydate = cond #( WHEN gs_header1-Entrydate is INITIAL
                                                                  thEN if_abap_behv=>fc-f-unrestricted
                                                                  elSE if_abap_behv=>fc-f-read_only )
                    %field-Entrytime = cond #( WHEN gs_header1-Entrytime is INITIAL
                                                                  thEN if_abap_behv=>fc-f-unrestricted
                                                                  elSE if_abap_behv=>fc-f-read_only )
                    %field-Exitdate = cond #( WHEN gs_header1-Exitdate is INITIAL
                                                                  thEN if_abap_behv=>fc-f-unrestricted
                                                                  elSE if_abap_behv=>fc-f-read_only )
                    %field-Exittime = cond #( WHEN gs_header1-Exittime is INITIAL
                                                                  thEN if_abap_behv=>fc-f-unrestricted
                                                                  elSE if_abap_behv=>fc-f-read_only )
                    %field-drivername = cond #( WHEN gs_header1-drivername is INITIAL
                                                                  thEN if_abap_behv=>fc-f-unrestricted
                                                                  elSE if_abap_behv=>fc-f-read_only )
*this code added by SAR TechTeam by 10-11-2025-------

                    %field-tpno =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-waybillno =  COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-packingwt =  COND #( WHEN (  gs_header1-status <> 'Exited' OR  gs_header1-status <> 'Cancelled & Exited' )
                                                        AND gs_header1-movementtype = 'OUTWARD'
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                     %field-challanwt =  COND #( WHEN gs_header1-gatepassno IS  INITIAL AND gs_header1-movementtype = 'INWARD'
                                                    AND  gs_header1-materialprocess <> 'STORES'
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-remarks =  COND #( WHEN gs_header1-status <> 'Exited' OR  gs_header1-status <> 'Cancelled & Exited'
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )

                    %field-invoicevalue =  COND #( WHEN gs_header1-gatepassno IS  INITIAL AND gs_header1-materialprocess <> 'STORES'
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-challanno = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  AND ( gs_header1-movementtype = 'INWARD'
                                                                  AND gs_header1-materialprocess = 'RGP' )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-source = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  AND  gs_header1-movementtype = 'OUTWARD'

                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-destination = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  AND  gs_header1-movementtype = 'OUTWARD'

                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-challandate = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  AND (  gs_header1-movementtype = 'INWARD'
                                                                  AND gs_header1-materialprocess = 'RGP' )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-challanunit = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  AND (  gs_header1-movementtype = 'INWARD'
                                                                  AND gs_header1-materialprocess = 'RGP' )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                    %field-challanvalue  = COND #( WHEN gs_header1-gatepassno IS  INITIAL
                                                                  AND (  gs_header1-movementtype = 'INWARD'
                                                                  AND gs_header1-materialprocess = 'RGP' )
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                                                                  ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD bgr.
**************************************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header2)
    enTITY zmm_gatehead_rvi by \_Item1
    alL FIELDS WITH corrESPONDING #( keys )
    result DATA(item)
    FAILED DATA(lt_header2_failed).
**************************************************************************************

*    READ ENTITY zmm_gatehead_rvi
*         BY  \_item1
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED DATA(item_failed).
**************************************************************************************
    LOOP AT lt_header2 ASSIGNING FIELD-SYMBOL(<fs_head>).
*      DELETE item WHERE fconfirm IS INITIAL.
*      IF item IS INITIAL.
*
*        DATA(lv_msg2) = |No Confirmed Items Available|.
*        APPEND VALUE #( %tky = <fs_head>-%tky )
*                             TO failed-zi_gatehead.
*
*        APPEND VALUE #( %tky           = <fs_head>-%tky
*                        %state_area    = 'Validate_Header'
*                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                text     = lv_msg2 )   )
*       TO reported-zi_gatehead.
*      else.
*      loop at item ASSIGNING FIELD-SYMBOL(<fs_itemx>).
*      if <fs_itemx> is ASSIGNED.
*       if <fs_itemx>-Qtyactual is INITIAL.
*       DATA(lv_msg5) = |GR is not allowed with 0.000 Weighment Quantity|.
*        APPEND VALUE #( %tky = <fs_head>-%tky )
*                             TO failed-zi_gatehead.
*
*        APPEND VALUE #( %tky           = <fs_head>-%tky
*                        %state_area    = 'Validate_Header'
*                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                text     = lv_msg5 )   )
*       TO reported-zi_gatehead.
*       endif.
*      endif.
*      endloop.
*
*      ENDIF.
**      endloop.
*
*      DELETE item WHERE gr IS NOT INITIAL.
*
*      IF item IS INITIAL.
*
*        DATA(lv_msg1) = |GR of All Items Already Done|.
*        APPEND VALUE #( %tky = <fs_head>-%tky )
*                             TO failed-zi_gatehead.
*
*        APPEND VALUE #( %tky           = <fs_head>-%tky
*                        %state_area    = 'Validate_Header'
*                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                text     = lv_msg1 )   )
*       TO reported-zi_gatehead.
*      ELSE.
*        DATA: lv_p TYPE p.
*        DATA(ltitem) = item[].
*        SORT ltitem BY purchaseorder .
*        DELETE ADJACENT DUPLICATES FROM ltitem COMPARING purchaseorder.
*        DATA(ls_item) =  ltitem[ 1 ] .
*        LOOP AT ltitem ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE purchaseorder = ls_item-purchaseorder.
*          IF <fs_item> IS ASSIGNED.
*            lv_p += 1.
*            DATA(ltitem1) = item[].
*            DELETE ltitem1 WHERE purchaseorder <> <fs_item>-purchaseorder.
*            DATA(lv_cid) = |CID_{ lv_p }|.
*            DATA(lv_cid_item) = |CID_ITEM_{ lv_p }|.
*
*            SELECT SINGLE plant
*            FROM i_purchaseorderitemapi01
*            WHERE purchaseorder = @<fs_item>-purchaseorder
*            AND purchaseorderitem = @<fs_item>-gateitem
*            INTO @DATA(lv_plant).
*
*            SELECT SINGLE producttype FROM i_product
*             WHERE product = @<fs_item>-material
*             INTO @DATA(lv_mattype).
*
*            SELECT SINGLE purchaseordertype
*            FROM i_purchaseorderapi01
*            WHERE purchaseorder = @<fs_item>-purchaseorder
*            INTO @DATA(lv_potype).
*
*            IF lv_potype  = 'ZDOM' AND lv_mattype = 'ZROH'.
*
*              MODIFY ENTITIES OF i_materialdocumenttp
*              ENTITY materialdocument
*              CREATE FROM VALUE #( ( %cid                                = lv_cid
*                                     goodsmovementcode                   = '01'
*                                     postingdate                         = sy-datum
*                                     documentdate                        = cl_abap_context_info=>get_system_date( )
*                                     materialdocumentheadertext          = 'Gatepass No:' && <fs_head>-gatepassno
*                                     %control-goodsmovementcode          = cl_abap_behv=>flag_changed
*                                     %control-postingdate                = cl_abap_behv=>flag_changed
*                                     %control-documentdate               = cl_abap_behv=>flag_changed
*                                     %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
*                                 ) )
*              ENTITY materialdocument
*              CREATE BY  \_materialdocumentitem
*              FROM VALUE #(
*                                   (
*                                     %cid_ref                            = lv_cid
*                                     %target                             = VALUE #( FOR ls_gr_2 IN ltitem1
*                                                      ( %cid                             = ls_gr_2-purchaseorder && ls_gr_2-gateitem && lv_cid_item
*                                                        plant                            = lv_plant
*                                                        material                         = ls_gr_2-material
*                                                        goodsmovementtype                = '101'
*                                                        storagelocation                  = ls_gr_2-storagelocation
*                                                        quantityinentryunit              = ls_gr_2-qtybought
*                                                        entryunit                        = ls_gr_2-uom
*                                                        batch                            = ls_gr_2-purchaseorder
*                                                        goodsmovementrefdoctype          = 'B'
*                                                        purchaseorder                    = ls_gr_2-purchaseorder
*                                                        purchaseorderitem                = ls_gr_2-gateitem
*                                                        manufacturedate                  = sy-datum
*                                                        yy1_qtyindelnote_mmi             = ls_gr_2-qtyactual
*                                                        yy1_qtyindelnote_mmiu            = ls_gr_2-uom
*                                                        %control-plant                   = cl_abap_behv=>flag_changed
*                                                        %control-material                = cl_abap_behv=>flag_changed
*                                                        %control-goodsmovementtype       = cl_abap_behv=>flag_changed
*                                                        %control-storagelocation         = cl_abap_behv=>flag_changed
*                                                        %control-quantityinentryunit     = cl_abap_behv=>flag_changed
*                                                        %control-entryunit               = cl_abap_behv=>flag_changed
*                                                        %control-batch                   = cl_abap_behv=>flag_changed
*                                                        %control-goodsmovementrefdoctype = cl_abap_behv=>flag_changed
*                                                        %control-purchaseorder           = cl_abap_behv=>flag_changed
*                                                        %control-purchaseorderitem       = cl_abap_behv=>flag_changed
*                                                        %control-manufacturedate         = cl_abap_behv=>flag_changed
*                                                        %control-yy1_qtyindelnote_mmi    = cl_abap_behv=>flag_changed
*                                                        %control-yy1_qtyindelnote_mmiu   = cl_abap_behv=>flag_changed
*
*                                                      )
*                                                      )
*                                   ) )
*
*              MAPPED DATA(mapped_101)
*              FAILED DATA(failed_101)
*              REPORTED DATA(reported_101).
*              IF reported_101-materialdocument IS NOT INITIAL.
*                APPEND VALUE #(
*                %tky                        = <fs_head>-%tky
*                %state_area                 = 'Validate_Head'
*                %msg                        = new_message_with_text(
*                severity = if_abap_behv_message=>severity-error
*                text     = 'Error in Confirmation of 101'
*                )
*                ) TO reported-zi_gatehead.
*
*                APPEND VALUE #(
*                %tky = <fs_head>-%tky
*                ) TO failed-zi_gatehead.
*
*              ELSE.
*                WAIT UP TO 2 SECONDS.
*                LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item1>) WHERE purchaseorder = <fs_item>-purchaseorder.
*                  IF <fs_item1> IS ASSIGNED.
*                    MODIFY ENTITIES OF zi_gatehead IN LOCAL MODE
*                          ENTITY zi_gateitem
*                          UPDATE
*                          FIELDS (  gr  )
*                          WITH VALUE #( ( %tky          = <fs_item1>-%tky
*                                           gr = 'X'
*                                           "%control-gr   = if_abap_behv=>mk-on
*                                          ) ).
*                  ENDIF.
*                ENDLOOP.
*              ENDIF.
*            ELSE.
*
*              MODIFY ENTITIES OF i_materialdocumenttp
*              ENTITY materialdocument
*              CREATE FROM VALUE #( ( %cid                                = lv_cid
*                                     goodsmovementcode                   = '01'
*                                     postingdate                         = sy-datum
*                                     documentdate                        = cl_abap_context_info=>get_system_date( )
*                                     materialdocumentheadertext          = 'Gatepass No:' && <fs_head>-gatepassno
*                                     %control-goodsmovementcode          = cl_abap_behv=>flag_changed
*                                     %control-postingdate                = cl_abap_behv=>flag_changed
*                                     %control-documentdate               = cl_abap_behv=>flag_changed
*                                     %control-materialdocumentheadertext = cl_abap_behv=>flag_changed
*                                 ) )
*              ENTITY materialdocument
*              CREATE BY \_materialdocumentitem
*              FROM VALUE #(
*                                   (
*                                     %cid_ref                            = lv_cid
*                                     %target                             = VALUE #( FOR ls_gr_2 IN ltitem1
*                                                      ( %cid                             = ls_gr_2-purchaseorder && ls_gr_2-gateitem && lv_cid_item
*                                                        plant                            = lv_plant
*                                                        material                         = ls_gr_2-material
*                                                        goodsmovementtype                = '101'
*                                                        storagelocation                  = ls_gr_2-storagelocation
*                                                        quantityinentryunit              = ls_gr_2-qtybought
*                                                        entryunit                        = ls_gr_2-uom
*                                                        goodsmovementrefdoctype          = 'B'
*                                                        purchaseorder                    = ls_gr_2-purchaseorder
*                                                        purchaseorderitem                = ls_gr_2-gateitem
*                                                        manufacturedate                  = sy-datum
*                                                         yy1_qtyindelnote_mmi             = ls_gr_2-qtyactual
*                                                        yy1_qtyindelnote_mmiu            = ls_gr_2-uom
*                                                        %control-plant                   = cl_abap_behv=>flag_changed
*                                                        %control-material                = cl_abap_behv=>flag_changed
*                                                        %control-goodsmovementtype       = cl_abap_behv=>flag_changed
*                                                        %control-storagelocation         = cl_abap_behv=>flag_changed
*                                                        %control-quantityinentryunit     = cl_abap_behv=>flag_changed
*                                                        %control-entryunit               = cl_abap_behv=>flag_changed
*                                                        %control-goodsmovementrefdoctype = cl_abap_behv=>flag_changed
*                                                        %control-purchaseorder              = cl_abap_behv=>flag_changed
*                                                        %control-purchaseorderitem          = cl_abap_behv=>flag_changed
*                                                        %control-manufacturedate          = cl_abap_behv=>flag_changed
*                                                        %control-yy1_qtyindelnote_mmi    = cl_abap_behv=>flag_changed
*                                                        %control-yy1_qtyindelnote_mmiu   = cl_abap_behv=>flag_changed
*
*                                                      )
*                                                      )
*                                   ) )
*
*              MAPPED DATA(mapped1)
*              FAILED DATA(failed1)
*              REPORTED DATA(reported1).
*              IF reported1-materialdocument IS NOT INITIAL.
*                APPEND VALUE #(
*                %tky                        = <fs_head>-%tky
*                %state_area                 = 'Validate_Head'
*                %msg                        = new_message_with_text(
*                severity = if_abap_behv_message=>severity-error
*                text     = 'Error in Confirmation of 101'
*                )
*                ) TO reported-zi_gatehead.
*
*                APPEND VALUE #(
*                %tky = <fs_head>-%tky
*                ) TO failed-zi_gatehead.
*
*              ELSE.
*                WAIT UP TO 2 SECONDS.
*                LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item2>) WHERE purchaseorder = <fs_item>-purchaseorder.
*                  IF <fs_item2> IS ASSIGNED.
*                    MODIFY ENTITIES OF zi_gatehead IN LOCAL MODE
*                          ENTITY zi_gateitem
*                          UPDATE
*                          FIELDS (  gr  )
*                          WITH VALUE #( ( %tky          = <fs_item2>-%tky
*                                           gr = 'X'
*                                         "  %control-gr   = if_abap_behv=>mk-on
*                                          ) ).
*                  ENDIF.
*                ENDLOOP.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*
*        ENDLOOP.
*      ENDIF.
*      IF <fs_head>-bgr IS INITIAL.
      <fs_head>-bgr = 'X'.
      <fs_head>-grstatus = 'GR Under Progress'.
      <fs_head>-tprint = ' '.
*      ELSE.
*        <fs_head>-bgr = ' '.
*      ENDIF.
**************************************************************************************
      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                         ENTITY zmm_gatehead_rvi
                         UPDATE
                         FIELDS (  bgr grstatus tprint )
                         WITH VALUE #( ( %tky          = <fs_head>-%tky
                                          bgr = <fs_head>-bgr
                                          grstatus = <fs_head>-grstatus
                                          tprint = <fs_head>-tprint
                                         " %control-bgr   = if_abap_behv=>mk-on
                                         ) ).
    ENDLOOP.
**************************************************************************************
    " Fill the response table
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY  zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).
**************************************************************************************
    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
**************************************************************************************

  ENDMETHOD.

  METHOD cancel.
**************************************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(header_failed).
**************************************************************************************
    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_gate>).
      IF <fs_gate> IS ASSIGNED.
        <fs_gate>-tprint = ' '.
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
               ENTITY zmm_gatehead_rvi
               UPDATE
               FIELDS ( tprint status   )
               WITH VALUE #( ( %tky          = <fs_gate>-%tky
                                status        = 'Cancelled'
                                tprint   = <fs_gate>-tprint

                               ) ).
      ENDIF.
    ENDLOOP.
**************************************************************************************
    " Fill the response table
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY  zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).
**************************************************************************************
    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
**************************************************************************************
  ENDMETHOD.

  METHOD del.
**********************************************************************
    DATA lv_json TYPE string.
    DATA lv_str  TYPE string.
    DATA lv_val  TYPE string.
    DATA lv_ext  TYPE string.
    DATA lv_gid  TYPE string.

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         ENTITY zmm_gatehead_rvi BY \_Item1
         all fieldS WITH CORRESPONDING #( keys )
         RESULT DATA(item)
         FAILED DATA(lt_header_failed).

*    READ ENTITY zi_gatehead
*        BY  \_item1
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(item)
*        " TODO: variable is assigned but never used (ABAP cleaner)
*        FAILED DATA(item_failed).

    DATA(ls_hdr) = lt_header[ 1 ].
    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
        LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).
          IF <fs_item> IS ASSIGNED.
            IF <fs_item>-qtyactual = 0 .
              APPEND VALUE #( %tky        = <fs_head>-%tky
                         %state_area = 'Validate_Head'
                         %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = 'Please Check Weighment of all items' ) )
                TO reported-zmm_gatehead_rvi.

              APPEND VALUE #( %tky = <fs_head>-%tky )
                     TO failed-zmm_gatehead_rvi.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    lv_json = '{'.
    lv_json = |{ lv_json }"ActualGoodsMovementDate": null ,|.
    lv_json = |{ lv_json }"BillOfLading":"",|.
    lv_json = |{ lv_json }"DeliveryBlockReason":"",|.
    lv_json = |{ lv_json }"DeliveryDate": null ,|.
    lv_json = |{ lv_json }"DeliveryDocumentBySupplier":"",|.
    lv_json = |{ lv_json }"DeliveryPriority":"",|.
    lv_json = |{ lv_json }"DeliveryTime": null ,|.
    lv_json = |{ lv_json }"GoodsIssueTime": null ,|.
    lv_json = |{ lv_json }"HeaderGrossWeight":"0.000",|.
    lv_json = |{ lv_json }"HeaderNetWeight":"0.000",|.
    lv_json = |{ lv_json }"HeaderVolume":"0.000",|.
    lv_json = |{ lv_json }"HeaderVolumeUnit":"",|.
    lv_json = |{ lv_json }"HeaderWeightUnit":"",|.
    lv_json = |{ lv_json }"IncotermsClassification":"",|.
    lv_json = |{ lv_json }"IncotermsTransferLocation":"",|.
    lv_json = |{ lv_json }"LoadingDate": null,|.
    lv_json = |{ lv_json }"LoadingTime": null,|.
    lv_json = |{ lv_json }"MeansOfTransport":"",|.
    lv_json = |{ lv_json }"MeansOfTransportType":"",|.
    lv_json = |{ lv_json }"PickingDate": null,|.
    lv_json = |{ lv_json }"PickingTime": null ,|.
    lv_json = |{ lv_json }"PlannedGoodsIssueDate": null,|.
    lv_json = |{ lv_json }"ProposedDeliveryRoute":"",|.
    lv_json = |{ lv_json }"ShippingPoint":"1000",|.
    lv_json = |{ lv_json }"TransportationPlanningDate":null,|.
    lv_json = |{ lv_json }"TransportationPlanningTime":null,|.
    lv_json = |{ lv_json }"UnloadingPointName":"",|.
    lv_json = |{ lv_json }"to_DeliveryDocumentItem":\{|.
    "   lv_json = |{ lv_json }"Yy1Gatepassdlh":"{ ls_hdr-gatepassno }"|.
    lv_json = |{ lv_json }"results": [\{|.
    LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item1>).
      IF sy-tabix <> 1.
        lv_json = lv_json  && '} , {' .
      ENDIF.
      lv_json = |{ lv_json }"ReferenceSDDocument":"{ <fs_item1>-salesorder }",|.
      lv_json = |{ lv_json }"ReferenceSDDocumentItem":"{ <fs_item1>-gateitem }"   |.

    ENDLOOP.
    lv_json = |{ lv_json } \}]\}\}|.

    TRY.
        FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCOMM_OTBDLV'
                                    service_id    = 'ZCOMM_OTBDELIVERY_REST' ).
        FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        FINAL(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_gid = ls_hdr-gatepassno.
        lo_request->set_header_field( i_name  = 'Yy1GatepassDlh'
                                      i_value = lv_gid ).
        lo_request->set_text( lv_json ).
        FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.
    IF ls_result IS NOT INITIAL.
      SPLIT ls_result AT '"DeliveryDocument"' INTO TABLE FINAL(lt_delivery).

      FINAL(ls_rs1) = VALUE #( lt_delivery[ 2 ] OPTIONAL ).

      SPLIT ls_rs1 AT '"' INTO TABLE FINAL(lt_delivery1).

      DATA(ls_rs2) = VALUE #( lt_delivery1[ 2 ] OPTIONAL ).

      IF ls_rs2 IS INITIAL.
        APPEND VALUE #( %tky        = ls_hdr-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = 'Error in Delivery Creation' ) )
               TO reported-zmm_gatehead_rvi.

        APPEND VALUE #( %tky = ls_hdr-%tky )
               TO failed-zmm_gatehead_rvi.
      ELSE.

        DATA : lv_del TYPE vbeln.
        lv_del = ls_rs2.
        lv_del = |{ lv_del ALPHA = IN }|.

        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
               ENTITY zmm_gatehead_rvi
               UPDATE
               FIELDS (
               deliverydocument  )
               WITH VALUE #( FOR key IN keys
                             ( %tky           = ls_hdr-%tky
                               deliverydocument  = lv_del
                               tprint = ' '  ) ).

        SELECT * FROM i_deliverydocumentitem
        WHERE   deliverydocument =  @lv_del
        INTO TABLE @DATA(lt_dell).
        IF sy-subrc = 0.

          LOOP AT lt_dell ASSIGNING FIELD-SYMBOL(<fs_dell>).
            IF <fs_dell> IS ASSIGNED.
              SELECT SINGLE *
                  FROM ZMM_GATEITEM_VIEW
                  WHERE gatepassno = @ls_hdr-gatepassno
                  AND salesorder = @<fs_dell>-referencesddocument
                  AND gateitem = @<fs_dell>-referencesddocumentitem
                  INTO  @DATA(ls_gateitem).
              IF sy-subrc = 0.
                MODIFY ENTITIES OF i_outbounddeliverytp fORWARDING PRIVILEGED
                     ENTITY outbounddeliveryitem
                     UPDATE
                     FIELDS ( actualdeliveredqtyinorderunit orderquantityunit )
                     WITH VALUE #( ( actualdeliveredqtyinorderunit          = ls_gateitem-qtyactual
                                     %control-actualdeliveredqtyinorderunit = if_abap_behv=>mk-on
                                     orderquantityunit                      = ls_gateitem-uom
                                     %control-orderquantityunit             = if_abap_behv=>mk-on
                                     %tky-outbounddelivery                  = lv_del
                                     %tky-outbounddeliveryitem              = <fs_dell>-deliverydocumentitem ) )
                     FAILED   FINAL(ls_failed_upd)
                     REPORTED FINAL(ls_reported_upd).
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
*

  ENDMETHOD.

  METHOD gengate.
**********************************************************************
    data lv_date type datn.
    data lv_time type timn.

**********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(header_failed).
**********************************************************************
    DATA nr_number      TYPE cl_numberrange_runtime=>nr_number.
    DATA: lv_numb TYPE zdegate.
**********************************************************************
    GET TIME STAMP FIELD Data(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date1) TIME DATA(lv_time1).
**********************************************************************
    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_gate>).
      IF <fs_gate> IS ASSIGNED.
**********************************************************************
        IF <fs_gate>-movementtype = 'INWARD' AND <fs_gate>-materialprocess = 'RGP' AND <fs_gate>-challanno IS INITIAL.
          DATA(lv_msg) = |Please Provide Challan Details|.
          APPEND VALUE #( %tky = <fs_gate>-%tky )
                      TO failed-zmm_gatehead_rvi.

          APPEND VALUE #( %tky           = <fs_gate>-%tky
                          %state_area    = 'Validate_Header'
                          %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = lv_msg )   )
                 TO reported-zmm_gatehead_rvi.
        ENDIF.
**********************************************************************
        <fs_gate>-entrydate = lv_date1.
        <fs_gate>-entrytime = lv_time1.
        <fs_gate>-createdat = lv_time1.
        <fs_gate>-createdon = lv_date1.
        <fs_gate>-status = 'Gatepass Created'.
        <fs_gate>-tprint = ' '.
**********************************************************************
        TRY.
            cl_numberrange_runtime=>number_get( " generating number
                                                EXPORTING nr_range_nr = '01'
                                                          object      = 'ZMM_NRGATE'
                                                IMPORTING number      = nr_number ).
            IF nr_number IS NOT INITIAL.
              lv_numb = nr_number+10(10).
            ENDIF.
          CATCH cx_nr_object_not_found.
          CATCH cx_number_ranges.
        ENDTRY.
**********************************************************************
        TRANSLATE <fs_gate>-vehicleno TO UPPER CASE.
        CONDENSE <fs_gate>-vehicleno NO-GAPS.
**********************************************************************
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                UPDATE
                FIELDS ( tprint createdat createdon status gatepassno vehicleno Entrydate Entrytime  )
                WITH VALUE #( ( %tky          = <fs_gate>-%tky
                                 gatepassno = lv_numb
                                 createdat = <fs_gate>-createdat
                                 createdon = <fs_gate>-createdon
                                 Entrydate = <fs_gate>-entrydate
                                 Entrytime = <fs_gate>-Entrytime
                                 status        = <fs_gate>-status
                                 trasporterno = <fs_gate>-supplierno       "nk
                                 transportername = <fs_gate>-supplierdesc  "nk
                                 tprint   = <fs_gate>-tprint
                                 vehicleno = <fs_gate>-vehicleno
                                ) ).

      ENDIF.
    ENDLOOP.
**********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(HEAD)
          BY \_item1
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED DATA(revfailed).

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item> IS ASSIGNED.
        <fs_item>-gatepassno = lv_numb.
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                    ENTITY item1
                    UPDATE
                    FIELDS (  gatepassno  )
                    WITH VALUE #( ( %tky          = <fs_item>-%tky
                                     gatepassno = lv_numb
                                     %control-gatepassno   = if_abap_behv=>mk-on
                                    ) ).
      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY  zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD genitem.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          ENTITY zmm_gatehead_rvi by \_Item
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_podet1)
          FAILED FINAL(header_failed).
*********************************************************************
    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_gate>).
      IF <fs_gate> IS ASSIGNED.

        <fs_gate>-tprint = ' '.
        <fs_gate>-genitem = 'X'.
*********************************************************************
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                UPDATE
                FIELDS ( tprint genitem )
                WITH VALUE #( ( %tky          = <fs_gate>-%tky
                                 tprint =  <fs_gate>-tprint
                                 genitem = <fs_gate>-genitem
                                  %control-tprint   = if_abap_behv=>mk-on
                                  %control-genitem   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
*********************************************************************
*    READ ENTITY zi_gatehead
*          BY \_item
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT DATA(lt_podet1)
*          " TODO: variable is assigned but never used (ABAP cleaner)
*          FAILED DATA(revfailed).


*********************************************************************
    LOOP AT lt_podet1 ASSIGNING FIELD-SYMBOL(<lfs_podet>).
      SELECT SINGLE * FROM zi_purchasef4
        WHERE purchaseorder = @<lfs_podet>-purchaseorder
        INTO @FINAL(ls_po).
      IF sy-subrc IS INITIAL.
        <lfs_podet>-supplier = ls_po-supplier.
        <lfs_podet>-supliername = ls_po-supplierfullname.

      ENDIF.
*********************************************************************
      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_pohead_rvi
           UPDATE
           FIELDS ( supplier  supliername )
           WITH VALUE #( FOR key IN keys
                         ( %tky               = <lfs_podet>-%tky
                           supliername = <lfs_podet>-supliername
                           supplier = <lfs_podet>-supplier
                            %control-supliername   = if_abap_behv=>mk-on
                            %control-supplier   = if_abap_behv=>mk-on
                            ) ).

    ENDLOOP.
*********************************************************************

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_gatehead_rvi
           ALL FIELDS  WITH CORRESPONDING #( keys )
           RESULT DATA(gt_header)
           ENTITY zmm_gatehead_rvi BY \_Item
           ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(lt_podet)
           enTITY zmm_gatehead_rvi BY \_Item1
           ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(lt_itemdet)
           FAILED DATA(failed05).
*********************************************************************

*    READ ENTITY zi_gatehead
*             BY \_item
*             ALL FIELDS
*             WITH CORRESPONDING #( keys )
*             RESULT DATA(lt_podet)
*             " TODO: variable is assigned but never used (ABAP cleaner)
*             FAILED DATA(revfailed1).
*    READ ENTITY zi_gatehead
*            BY \_item1
*            ALL FIELDS
*            WITH CORRESPONDING #( keys )
*            RESULT DATA(lt_itemdet)
*            " TODO: variable is assigned but never used (ABAP cleaner)
*            FAILED DATA(revfailed2).
*********************************************************************
    DATA(lt_podet01) = lt_podet[].
    SORT lt_podet01 BY purchaseorder salesorder billingreference.
    DELETE ADJACENT DUPLICATES FROM lt_podet01 COMPARING purchaseorder salesorder billingreference.

    DATA(ls_head) = gt_header[ 1 ].
    DATA lv_p TYPE p.
*********************************************************************
    LOOP AT lt_podet01  ASSIGNING FIELD-SYMBOL(<lfs_podet1>).
      IF <lfs_podet1> IS ASSIGNED.
        IF ls_head-movementtype = 'INWARD' AND ls_head-materialprocess = 'MISC'.
* ++ sp on 14.05.25
         <lfs_podet1>-billingreference = |{ <lfs_podet1>-billingreference alpha = IN }|.

          SELECT * FROM  zi_f4_poso_details
          WHERE billingdocument = @<lfs_podet1>-billingreference
          INTO TABLE @DATA(lt_billref).
*********************************************************************

          LOOP AT lt_billref ASSIGNING FIELD-SYMBOL(<fs_billref>).
            IF <fs_billref> IS INITIAL.
              CONTINUE.
            ENDIF.
            lv_p += 1.
            DATA(ls_id2) = VALUE #( lt_itemdet[ billingreference  = <lfs_podet1>-billingreference gateitem = <fs_billref>-billingdocumentitem ]-item OPTIONAL ).

            DATA: lv_item2 TYPE zi_gateitem-item.
            IF ls_id2 IS INITIAL.
              TRY.
                  lv_item2 = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                CATCH cx_uuid_error.
              ENDTRY.
              lv_item2 = lv_p && lv_item2.
            ELSE.
              lv_item2 = ls_id2.
            ENDIF.
*********************************************************************
            MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                     ENTITY zmm_gatehead_rvi
                     CREATE BY \_item1
                     FROM VALUE #( ( id      = ls_head-id
                                     %target = VALUE #( ( %cid                         =  lv_item2
                                                          item                               = lv_item2
                                                          billingreference                      = <fs_billref>-billingdocument
                                                          gateitem                  = <fs_billref>-billingdocumentitem
                                                          material = <fs_billref>-material
                                                          materialdesc = <fs_billref>-billingdocumentitemtext
                                                          uom = <fs_billref>-billingquantityunit
                                                          qty =  <fs_billref>-billingquantity
                                                          avlqty = <fs_billref>-billingquantity
                                                          gatepassno = ls_head-gatepassno
                                                          storagelocation = <fs_billref>-billingquantity
*                                                     maxqty = lv_maxqty
                                                          qtybought = <fs_billref>-billingquantity
                                                          %control-item            = if_abap_behv=>mk-on
                                                          %control-billingreference            = if_abap_behv=>mk-on
                                                          %control-gateitem         = if_abap_behv=>mk-on
                                                          %control-material            = if_abap_behv=>mk-on
                                                          %control-materialdesc         = if_abap_behv=>mk-on
                                                          %control-uom  = if_abap_behv=>mk-on
                                                          %control-qtybought = if_abap_behv=>mk-on
                                                          %control-qty = if_abap_behv=>mk-on
                                                          %control-avlqty = if_abap_behv=>mk-on
*                                                     %control-maxqty = if_abap_behv=>mk-on
                                                          %control-gatepassno = if_abap_behv=>mk-on
                                                          %control-storagelocation = if_abap_behv=>mk-on

                                                      ) ) ) )
                     MAPPED DATA(ls_mappedbill)
                     FAILED DATA(ls_failedbill)
                     REPORTED DATA(ls_reportedbill).
          ENDLOOP.
*********************************************************************
        ELSE.
*********************************************************************
          IF ls_head-movementtype = 'INWARD' and ls_head-Materialprocess ne 'RGP'.
*********************************************************************

            SELECT * FROM i_purchaseorderitemapi01
            WHERE purchaseorder = @<lfs_podet1>-purchaseorder
            INTO TABLE @DATA(lt_item).

**************************************************************************
            data: lv_qtyx1 type menge_d.
**************************************************************************
            IF sy-subrc = 0.
              LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
                lv_p += 1.
                IF <fs_item> IS ASSIGNED.

                  IF ls_head-materialprocess = 'RAW'.
*                    DATA(lv_qtyx) = ls_head-challanwt.
                    lv_qtyx1 = ls_head-challanwt.
                  ENDIF.
*********************************************************************
                  SELECT SINGLE * FROM i_producttext
                  WHERE product = @<fs_item>-material
                  AND language = 'E'
                  INTO @DATA(ls_material).
*********************************************************************
                  DATA(ls_id) = VALUE #( lt_itemdet[  purchaseorder = <lfs_podet1>-purchaseorder gateitem = <fs_item>-purchaseorderitem ]-item OPTIONAL ).

                  DATA: lv_item TYPE zi_gateitem-item.

                  IF ls_id IS INITIAL.
                    TRY.
                        lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                      CATCH cx_uuid_error.
                    ENDTRY.
                    lv_item = lv_p && lv_item.
                  ELSE.
                    lv_item = ls_id.
                  ENDIF.
*********************************************************************
                  SELECT  purchaseorder , purchaseorderitem ,
                  CASE debitcreditcode
                  WHEN 'S'  THEN quantityinbaseunit
                  ELSE quantityinbaseunit * -1 END AS grqty

                  FROM i_purchaseorderhistoryapi01
                  WHERE purchaseorder = @<fs_item>-purchaseorder
                  AND purchaseorderitem = @<fs_item>-purchaseorderitem
                  INTO TABLE @DATA(lt_grn).
*********************************************************************
                  DATA: lv_grqty TYPE i_purchaseorderhistoryapi01-quantityinbaseunit.
                  DATA: lv_maxqty TYPE i_purchaseorderitemapi01-orderquantity.
                  DATA: lvgrqty01 TYPE i_purchaseorderitemapi01-orderquantity.
*********************************************************************
                  LOOP AT lt_grn ASSIGNING FIELD-SYMBOL(<fs_grn>).
                    IF <fs_grn> IS ASSIGNED.
                      lvgrqty01 = lvgrqty01 + <fs_grn>-grqty.
                    ENDIF.
                  ENDLOOP.
*********************************************************************

                  lv_maxqty = <fs_item>-orderquantity +  ( (  <fs_item>-orderquantity * <fs_item>-overdelivtolrtdlmtratioinpct )  / 100 ).

                  lv_grqty = CONV menge_d( lv_maxqty - lvgrqty01 ).
                  IF ls_head-materialprocess <> 'RAW'.
*                    lv_qtyx = lv_grqty.
                    lv_qtyx1 =  lv_grqty .
                  ENDIF.
*********************************************************************
                  CLEAR : lvgrqty01.
                  MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                  ENTITY zmm_gatehead_rvi
                  CREATE BY \_item1
                  FROM VALUE #( ( id      = ls_head-id
                                  %target = VALUE #( ( %cid                         =  lv_item
                                                       item                         = lv_item
                                                       purchaseorder                = <lfs_podet1>-purchaseorder
                                                       gateitem                     = <fs_item>-purchaseorderitem
                                                       material                     = <fs_item>-material
                                                       materialdesc                 = <fs_item>-purchaseorderitemtext
                                                       uom                          = <fs_item>-purchaseorderquantityunit
                                                       qty                          =  <fs_item>-orderquantity
                                                       avlqty                       = lv_grqty
                                                       gatepassno                   = ls_head-gatepassno
                                                       storagelocation              = <fs_item>-storagelocation
                                                       maxqty                       = lv_maxqty
*                                                       qtybought                   = lv_qtyx
                                                       qtybought                    = lv_qtyx1
                                                       %control-item                = if_abap_behv=>mk-on
                                                       %control-purchaseorder       = if_abap_behv=>mk-on
                                                       %control-gateitem            = if_abap_behv=>mk-on
                                                       %control-material            = if_abap_behv=>mk-on
                                                       %control-materialdesc        = if_abap_behv=>mk-on
                                                       %control-uom                 = if_abap_behv=>mk-on
                                                       %control-qtybought           = if_abap_behv=>mk-on
                                                       %control-qty                 = if_abap_behv=>mk-on
                                                       %control-avlqty              = if_abap_behv=>mk-on
                                                       %control-maxqty              = if_abap_behv=>mk-on
                                                       %control-gatepassno          = if_abap_behv=>mk-on
                                                       %control-storagelocation     = if_abap_behv=>mk-on

                                                   ) ) ) )
                  MAPPED DATA(ls_mapped)
                  FAILED DATA(ls_failed)
                  REPORTED DATA(ls_reported).
                ENDIF.
              ENDLOOP.
            ENDIF.
*********************************************************************
          ELSE.
*********************************************************************
****New Changes added by SAR Tech Team--*****************************


           if ls_head-Movementtype = 'OUTWARD' and ls_head-Materialprocess = 'RGP'.
            SELECT * FROM i_purchaseorderitemapi01
            WHERE purchaseorder = @<lfs_podet1>-purchaseorder
            INTO TABLE @DATA(gt_item).
**************************************************************************
            data: gv_qtyx type menge_d.
**************************************************************************
           if sy-subrc = 0.
           LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<gs_item>).
           lv_p += 1.
           IF <gs_item> IS ASSIGNED.
                  IF ls_head-materialprocess = 'RAW'.
                    gv_qtyx = ls_head-challanwt.
                  ENDIF.

                  SELECT SINGLE * FROM i_producttext
                  WHERE product = @<gs_item>-material
                  AND language = 'E'
                  INTO @DATA(gs_material).

                  DATA(gs_id) = VALUE #( lt_itemdet[  purchaseorder = <lfs_podet1>-purchaseorder gateitem = <gs_item>-purchaseorderitem ]-item OPTIONAL ).

                  DATA: gv_item TYPE zi_gateitem-item.

                  IF gs_id IS INITIAL.
                    TRY.
                        gv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                      CATCH cx_uuid_error.
                    ENDTRY.
                    gv_item = lv_p && gv_item.
                  ELSE.
                    gv_item = gs_id.
                  ENDIF.

                  SELECT  purchaseorder , purchaseorderitem , CASE debitcreditcode
                  WHEN 'S'  THEN quantityinbaseunit
                  ELSE quantityinbaseunit * -1 END AS grqty
                  FROM i_purchaseorderhistoryapi01
                  WHERE purchaseorder = @<gs_item>-purchaseorder
                  AND purchaseorderitem = @<gs_item>-purchaseorderitem
                  INTO TABLE @lt_grn.

                  DATA: gv_grqty TYPE i_purchaseorderhistoryapi01-quantityinbaseunit.
                  DATA: gv_maxqty TYPE i_purchaseorderitemapi01-orderquantity.
                  DATA: gvgrqty01 TYPE i_purchaseorderitemapi01-orderquantity.

                  LOOP AT lt_grn ASSIGNING <fs_grn>.
                    IF <fs_grn> IS ASSIGNED.
                      gvgrqty01 = gvgrqty01 + <fs_grn>-grqty.
                    ENDIF.
                  ENDLOOP.

                  gv_maxqty = <gs_item>-orderquantity +  ( (  <gs_item>-orderquantity * <gs_item>-overdelivtolrtdlmtratioinpct )  / 100 ).

                  gv_grqty = CONV menge_d( gv_maxqty - gvgrqty01 ).
                  IF ls_head-materialprocess <> 'RAW'.
                    gv_qtyx =  gv_grqty .
                  ENDIF.

                  CLEAR : gvgrqty01.
                  MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                  ENTITY zmm_gatehead_rvi
                  CREATE BY \_item1
                  FROM VALUE #( ( id      = ls_head-id
                                  %target = VALUE #( ( %cid                     =  gv_item
                                                       item                     = gv_item
                                                       purchaseorder            = <lfs_podet1>-purchaseorder
                                                       gateitem                 = <gs_item>-purchaseorderitem
                                                       material                 = <gs_item>-material
                                                       materialdesc             = <gs_item>-purchaseorderitemtext
                                                       uom                      = <gs_item>-purchaseorderquantityunit
                                                       qty                      =  <gs_item>-orderquantity
                                                       avlqty                   = gv_grqty
                                                       gatepassno               = ls_head-gatepassno
                                                       storagelocation          = <gs_item>-storagelocation
                                                       maxqty                   = gv_maxqty
*                                                       qtybought = lv_qtyx
                                                       qtybought                = gv_qtyx
                                                       %control-item            = if_abap_behv=>mk-on
                                                       %control-purchaseorder   = if_abap_behv=>mk-on
                                                       %control-gateitem        = if_abap_behv=>mk-on
                                                       %control-material        = if_abap_behv=>mk-on
                                                       %control-materialdesc    = if_abap_behv=>mk-on
                                                       %control-uom             = if_abap_behv=>mk-on
                                                       %control-qtybought       = if_abap_behv=>mk-on
                                                       %control-qty             = if_abap_behv=>mk-on
                                                       %control-avlqty          = if_abap_behv=>mk-on
                                                       %control-maxqty          = if_abap_behv=>mk-on
                                                       %control-gatepassno      = if_abap_behv=>mk-on
                                                       %control-storagelocation = if_abap_behv=>mk-on

                                                   ) ) ) )
                  MAPPED DATA(gs_mapped)
                  FAILED DATA(gs_failed)
                  REPORTED DATA(gs_reported).

           endif.
           endloop.
           endif.

           else.


*********************************************************************
            DATA : lv_so TYPE vbeln.
            lv_so = |{ <lfs_podet1>-salesorder ALPHA = IN }|.
*********************************************************************
            SELECT * FROM i_salesdocumentitem
            WHERE salesdocument = @lv_so
            INTO TABLE @DATA(lt_item01).
*********************************************************************
            IF sy-subrc = 0.
              LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_item01>).
                lv_p += 1.
                IF <fs_item01> IS ASSIGNED.
*********************************************************************
                  SELECT SINGLE * FROM i_producttext
                    WHERE product = @<fs_item01>-material
                    AND language = 'E'
                    INTO @DATA(ls_material01).
*********************************************************************
                  SELECT SINGLE * FROM zv_del_qty
                  WHERE referencesddocument = @<fs_item01>-salesdocument
                  AND referencesddocumentitem = @<fs_item01>-salesdocumentitem
                  INTO @DATA(ls_del).
*********************************************************************
                  DATA : lv_qty TYPE zi_gateitem-qty.
                  DATA : lv_qty1 TYPE zi_gateitem-qty.
                  lv_qty = <fs_item01>-orderquantity + ( (  <fs_item01>-overdelivtolrtdlmtratioinpct * <fs_item01>-orderquantity ) / 100 ) - ls_del-delqty .
                  lv_qty1 = <fs_item01>-orderquantity + ( (  <fs_item01>-overdelivtolrtdlmtratioinpct * <fs_item01>-orderquantity ) / 100 )  .
*********************************************************************
                  DATA: lv_item01 TYPE zi_gateitem-item.
                  DATA(ls_id1) = VALUE #( lt_itemdet[ salesorder = <lfs_podet1>-salesorder gateitem = <fs_item01>-salesdocumentitem ]-item OPTIONAL ).
                  IF ls_id1 IS INITIAL.
                    TRY.
                        lv_item01 = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                      CATCH cx_uuid_error.
                    ENDTRY.
                    lv_item01 = lv_p && lv_item01.
                  ELSE.
                    lv_item01 = ls_id1.
                  ENDIF.
*********************************************************************
                  MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                  ENTITY zmm_gatehead_rvi
                  CREATE BY \_item1
                  FROM VALUE #( ( id      = ls_head-id
                                  %target = VALUE #( ( %cid                         = lv_item01
                                                       item                         = lv_item01
                                                       salesorder                   = <fs_item01>-salesdocument
                                                       gateitem                     = <fs_item01>-salesdocumentitem
                                                       material                     = <fs_item01>-material
                                                       materialdesc                 = ls_material01-productname
                                                       uom                          = <fs_item01>-orderquantityunit
                                                       qty                          =  <fs_item01>-orderquantity
                                                       avlqty                       = lv_qty
                                                       maxqty                       = lv_qty1
                                                       gatepassno                   = ls_head-gatepassno
                                                       %control-item                = if_abap_behv=>mk-on
                                                       %control-salesorder          = if_abap_behv=>mk-on
                                                       %control-gateitem            = if_abap_behv=>mk-on
                                                       %control-material            = if_abap_behv=>mk-on
                                                       %control-materialdesc        = if_abap_behv=>mk-on
                                                       %control-uom                 = if_abap_behv=>mk-on
                                                       %control-qty                 = if_abap_behv=>mk-on
                                                       %control-gatepassno          = if_abap_behv=>mk-on
                                                       %control-maxqty              = if_abap_behv=>mk-on
                                                       %control-avlqty              = if_abap_behv=>mk-on
                                                   ) ) ) )
                  MAPPED DATA(ls_mapped01)
                  FAILED DATA(ls_failed01)
                  REPORTED DATA(ls_reported01).
                  CLEAR : ls_del.

*          SELECT * FROM i_salesdocumentitem
*          WHERE salesdocument = @<lfs_podet1>-salesorder
*          INTO TABLE @DATA(lt_item01).
*          IF sy-subrc = 0.
*            LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_item01>).
*              lv_p += 1.
*              IF <fs_item01> IS ASSIGNED.
*                SELECT SINGLE * FROM i_producttext
*                  WHERE product = @<fs_item01>-material
*                  AND language = 'E'
*                  INTO @DATA(ls_material01).
*
*                SELECT SINGLE * FROM zv_del_qty
*                WHERE referencesddocument = @<fs_item01>-salesdocument
*                AND referencesddocumentitem = @<fs_item01>-salesdocumentitem
*                INTO @DATA(ls_del).
*                DATA : lv_qty TYPE zi_gateitem-qty.
*
*                lv_qty = <fs_item01>-orderquantity + ( (  <fs_item01>-overdelivtolrtdlmtratioinpct * <fs_item01>-orderquantity ) / 100 ) - ls_del-delqty .
*                DATA: lv_item01 TYPE zi_gateitem-item.
*                DATA(ls_id1) = VALUE #( lt_itemdet[ salesorder = <lfs_podet1>-salesorder gateitem = <fs_item01>-salesdocumentitem ]-item OPTIONAL ).
*                IF ls_id1 IS INITIAL.
*                  TRY.
*                      lv_item01 = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*                    CATCH cx_uuid_error.
*                  ENDTRY.
*                  lv_item01 = lv_p && lv_item01.
*                ELSE.
*                  lv_item01 = ls_id1.
*                ENDIF.
*
*                MODIFY ENTITIES OF zi_gatehead IN LOCAL MODE
*                ENTITY zi_gatehead
*                CREATE BY \_item1
*                FROM VALUE #( ( id      = ls_head-id
*                                %target = VALUE #( ( %cid                               = lv_item01
*                                                     item                               = lv_item01
*                                                     salesorder                         = <fs_item01>-salesdocument
*                                                     gateitem                     = <fs_item01>-salesdocumentitem
*                                                     material = <fs_item01>-material
*                                                     materialdesc = ls_material01-productname
*                                                     uom = <fs_item01>-orderquantityunit
*                                                     qty =  lv_qty
*                                                     gatepassno = ls_head-gatepassno
*                                                     %control-item            = if_abap_behv=>mk-on
*                                                     %control-salesorder            = if_abap_behv=>mk-on
*                                                     %control-gateitem          = if_abap_behv=>mk-on
*                                                     %control-material            = if_abap_behv=>mk-on
*                                                     %control-materialdesc         = if_abap_behv=>mk-on
*                                                     %control-uom  = if_abap_behv=>mk-on
*                                                     %control-qty = if_abap_behv=>mk-on
*                                                     %control-gatepassno = if_abap_behv=>mk-on
*                                                 ) ) ) )
*                MAPPED DATA(ls_mapped01)
*                FAILED DATA(ls_failed01)
*                REPORTED DATA(ls_reported01).
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.

          endif. "sar Tech team

        ENDIF.
      ENDIF.
    ENDLOOP.
*********************************************************************
****---New Logic Added by SAR Tech team------************************

        if ls_head-Movementtype = 'INWARD' AND ls_head-materialprocess = 'RGP'.
*********************************************************************
                select single * from zmm_po_head_db with PRIVILEGED ACCESS
                where id = @ls_head-Id
                into @data(wa_pohead).

                select * from zmm_gateitem_db with prIVILEGED ACCESS
                where id = @ls_head-Id
                into table @DATA(wa_gatepoitem).

            if ls_head-Id is not INITIAL.
*********************************************************************

                select single * from zmm_gatehead_db WITH PRIVILEGED ACCESS
                where gatepassno = @ls_head-challanno
                into @data(gs_gatehead).

                select single * from zmm_po_head_db with privileged access
                where id = @gs_gatehead-Id
                into @data(gs_pohead).

                select * from zmm_gateitem_db with prIVILEGED ACCESS
                where id = @gs_gatehead-Id
                into table @DATA(lt_gatepoitem).
*********************************************************************
                if sy-subrc = 0 AND wa_pohead IS INITIAL.
                  CLEAR:ls_id, lv_item.
                  ls_id = VALUE #( lt_itemdet[  purchaseorder = <lfs_podet1>-purchaseorder gateitem = <fs_item>-purchaseorderitem ]-item OPTIONAL ).

*                  DATA: lv_item TYPE zi_gateitem-item.
                  IF ls_id IS INITIAL.
                    TRY.
                        lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                      CATCH cx_uuid_error.
                    ENDTRY.
                    lv_item = lv_item.
                  ELSE.
                    lv_item = ls_id.
                  ENDIF.

*********************************************************************
                MODIFY ENTITIES OF zmm_gatehead_rvi iN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                creATE BY \_Item
                from VALUE #( ( Id = ls_head-Id
                                %target = value #( ( %cid = lv_item
                                            item = lv_item
                                            Purchaseorder = gs_pohead-purchaseorder
                                            Supplier = gs_pohead-supplier
                                            Supliername = gs_pohead-supliername
                                            supplyplant = gs_pohead-supplyingplant
                                            billingreference = gs_pohead-billingreference
                                            eway = gs_pohead-eway
                                            invoiceno = gs_pohead-invoiceno
                                            invoicedate = gs_pohead-invoicedate
                                            Salesorder = gs_pohead-salesorder
                                            %control-item = if_abap_behv=>mk-on
                                            %control-Purchaseorder = if_abap_behv=>mk-on
                                            %control-Supplier = if_abap_behv=>mk-on
                                            %control-Supliername = if_abap_behv=>mk-on
                                            %control-supplyplant = if_abap_behv=>mk-on
                                            %control-billingreference = if_abap_behv=>mk-on
                                            %control-eway = if_abap_behv=>mk-on
                                            %control-invoiceno = if_abap_behv=>mk-on
                                            %control-invoicedate = if_abap_behv=>mk-on
                                            %control-Salesorder = if_abap_behv=>mk-on
                                            ) )    ) )
                MAPPED DATA(get_pohead)
                FAILED DATA(get_failed)
                REPORTED DATA(get_reported).
                endif.

                if lt_gatepoitem is not inITIAL and wa_gatepoitem is iNITIAL.
                clear lv_p.
                    loop at lt_gatepoitem asSIGNING FIELD-SYMBOL(<ls_gatepoitem>).
                        lv_p += 1.
                        if <ls_gatepoitem> is aSSIGNED.

                        ls_id = VALUE #( lt_itemdet[  purchaseorder = <lfs_podet1>-purchaseorder gateitem = <fs_item>-purchaseorderitem ]-item OPTIONAL ).

                          IF ls_id IS INITIAL.
                            TRY.
                                lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                              CATCH cx_uuid_error.
                            ENDTRY.
                            lv_item = lv_item.
                            ELSE.
                            lv_item = ls_id.
                            ENDIF.
**********************************************************************
                    MODIFY ENTITIES OF zmm_gatehead_rvi in LOCAL MODE
                    ENTITY zmm_gatehead_rvi
                    CREATE BY \_Item1
                    FROM VALUE #( ( Id =  ls_head-Id
                                    %target = VALUE #( ( %cid = lv_item
                                            item = lv_item
                                            Purchaseorder = <ls_gatepoitem>-purchaseorder
                                            gateitem = <ls_gatepoitem>-gateitem
                                            gatepassno = <ls_gatepoitem>-gatepassno
                                            gateitemapi = <ls_gatepoitem>-gateitemapi
                                            material = <ls_gatepoitem>-material
                                            materialdesc = <ls_gatepoitem>-materialdesc
                                            uom = <ls_gatepoitem>-uom
                                            wuom = <ls_gatepoitem>-wuom
                                            qty = <ls_gatepoitem>-qty
                                            maxqty = <ls_gatepoitem>-maxqty
                                            avlqty = <ls_gatepoitem>-avlqty
                                            qtybought = <ls_gatepoitem>-qtybought
                                            grossqty = <ls_gatepoitem>-grossqty
                                            tareqty = <ls_gatepoitem>-tareqty
                                            qtyactual = <ls_gatepoitem>-qtyactual
                                            storagelocation = <ls_gatepoitem>-storagelocation
                                            tconfirm = <ls_gatepoitem>-tconfirm
                                            tgr = <ls_gatepoitem>-tgr
                                            fconfirm = <ls_gatepoitem>-fconfirm
                                            gr = <ls_gatepoitem>-gr
                                            salesorder = <ls_gatepoitem>-salesorder
                                            billingreference = <ls_gatepoitem>-billingreference
                                            bgross = <ls_gatepoitem>-bgross
                                            bnet = <ls_gatepoitem>-bnet
                                            weighbentrydate = <ls_gatepoitem>-weighbentrydate
                                            weighbentrytime = <ls_gatepoitem>-weighbentrytime
                                            weighbexitdate = <ls_gatepoitem>-weighbexitdate
                                            weighbexittime = <ls_gatepoitem>-weighbexittime
                                            postinglog = <ls_gatepoitem>-postinglog
                                            sconfirm = <ls_gatepoitem>-sconfirm
                                            ssconfirm = <ls_gatepoitem>-ssconfirm
                                            pendqty = <ls_gatepoitem>-pendqty
                                            %control-item = if_abap_behv=>mk-on
                                            %control-Purchaseorder = if_abap_behv=>mk-on
                                            %control-gateitem = if_abap_behv=>mk-on
                                            %control-gatepassno = if_abap_behv=>mk-on
                                            %control-gateitemapi = if_abap_behv=>mk-on
                                            %control-Material = if_abap_behv=>mk-on
                                            %control-Materialdesc = if_abap_behv=>mk-on
                                            %control-uom = if_abap_behv=>mk-on
                                            %control-wuom = if_abap_behv=>mk-on
                                            %control-qty = if_abap_behv=>mk-on
                                            %control-maxqty = if_abap_behv=>mk-on
                                            %control-avlqty = if_abap_behv=>mk-on
                                            %control-Qtybought = if_abap_behv=>mk-on
                                            %control-grossqty = if_abap_behv=>mk-on
                                            %control-tareqty = if_abap_behv=>mk-on
                                            %control-Qtyactual = if_abap_behv=>mk-on
                                            %control-storagelocation = if_abap_behv=>mk-on
                                            %control-tconfirm = if_abap_behv=>mk-on
                                            %control-tgr = if_abap_behv=>mk-on
                                            %control-fconfirm = if_abap_behv=>mk-on
                                            %control-gr = if_abap_behv=>mk-on
                                            %control-salesorder = if_abap_behv=>mk-on
                                            %control-billingreference = if_abap_behv=>mk-on
                                            %control-bgross = if_abap_behv=>mk-on
                                            %control-bnet = if_abap_behv=>mk-on
                                            %control-weighbentrydate = if_abap_behv=>mk-on
                                            %control-weighbentrytime = if_abap_behv=>mk-on
                                            %control-weighbexitdate = if_abap_behv=>mk-on
                                            %control-weighbexittime = if_abap_behv=>mk-on
                                            %control-postinglog = if_abap_behv=>mk-on
                                            %control-sconfirm = if_abap_behv=>mk-on
                                            %control-ssconfirm = if_abap_behv=>mk-on
                                            %control-pendqty = if_abap_behv=>mk-on
                                            ) ) ) )
                           MAPPED DATA(ls_gateitem)
                           FAILED DATA(ls_gatefailed)
                           REPORTED DATA(ls_gatereported).

                        endif.
                    ENDLOOP.
                endif.

            endif.

        ENDIF.

    " Fill the response table
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY  zmm_gatehead_rvi
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1)
         ENTITY zmm_gatehead_rvi by \_Item
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(poheader_1)
         ENTITY zmm_gatehead_rvi by \_Item1
         alL FIELDS WITH corRESPONDING #( keys )
         reSULT data(poitem_1)
         faILED data(po_failed).


    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

*********************************************************************
  ENDMETHOD.

  METHOD getinv.
*********************************************************************
    DATA lv_datetime TYPE c LENGTH 15.
    DATA lv_str      TYPE string.
    DATA lv_json     TYPE string.

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_header_failed).

    DATA(ls_hdr) = lt_header[ 1 ].
    SELECT SINGLE *
    FROM i_billingdocumentitem
    WHERE referencesddocument = @ls_hdr-deliverydocument
    INTO @DATA(ls_bill).

    IF ls_bill IS NOT INITIAL AND ls_hdr-taxinvoice IS INITIAL.
      ls_hdr-taxinvoice = ls_bill-billingdocument.

      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                UPDATE
                FIELDS (
                taxinvoice tprint )
                WITH VALUE #( FOR key IN keys
                              ( %tky           = ls_hdr-%tky
                                taxinvoice      = ls_hdr-taxinvoice
                                tprint = ' ' ) ).

    ENDIF.
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
            ENTITY zmm_gatehead_rvi
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD inv.
*********************************************************************
    DATA lv_datetime TYPE c LENGTH 15.
    DATA lv_str      TYPE string.
    DATA lv_json     TYPE string.


    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_header_failed).

    DATA(ls_hdr) = lt_header[ 1 ].

    MODIFY ENTITIES OF i_billingdocumenttp foRWARDING PRIVILEGED
    ENTITY billingdocument
    EXECUTE createfromsddocument AUTO FILL CID
                    WITH VALUE #(
                                ( %param = VALUE #( _reference = VALUE #( (
                                  sddocument = ls_hdr-deliverydocument
                                %control = VALUE #( sddocument = if_abap_behv=>mk-on ) )
                                ( sddocument = ls_hdr-deliverydocument
                                %control = VALUE #( sddocument = if_abap_behv=>mk-on ) ) )
                                %control = VALUE #( _reference = if_abap_behv=>mk-on ) ) ) )

                                RESULT DATA(lt_result_modify)
                                FAILED DATA(ls_failed_modify)
                                REPORTED DATA(ls_reported_modify).

    IF lt_result_modify IS NOT INITIAL.

      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                 ENTITY zmm_gatehead_rvi
                 UPDATE
                 FIELDS (
                 crtinv tprint )
                 WITH VALUE #( FOR key IN keys
                               ( %tky           = ls_hdr-%tky
                                 crtinv       = 'X'
                                 tprint = ' ' ) ).

    ENDIF.

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
            ENTITY zmm_gatehead_rvi
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).


  ENDMETHOD.

  METHOD pgi.
*********************************************************************
    DATA lv_datetime TYPE c LENGTH 15.
    DATA lv_str      TYPE string.
    DATA lv_json     TYPE string.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_header_failed).

    DATA(ls_hdr) = lt_header[ 1 ].

    TRY.
        FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCOMMSYS_PGI_REST'
                                    service_id    = 'ZOS_PGI_REST' ).
        FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        FINAL(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).

        lv_str = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                                      i_value = lv_str ).
        "  lo_request->set_text( lv_json ).
        FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO FINAL(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

*    SPLIT ls_result AT '"picked Status"' INTO TABLE FINAL(lt_delivery).
*    FINAL(ls_rs1) = VALUE #( lt_delivery[ 2 ] OPTIONAL ).
*
*    SPLIT ls_rs1 AT '"' INTO TABLE FINAL(lt_delivery1).
*    DATA(ls_rs2) = VALUE #( lt_delivery1[ 2 ] OPTIONAL ).
*    " DATA(ls_rs2) = VALUE #( lt_delivery1[ 1 ] OPTIONAL ).
*
*    SPLIT ls_result AT '"pgi status:"' INTO TABLE FINAL(lt_delivery2).
*    FINAL(ls_rs3) = VALUE #( lt_delivery2[ 2 ] OPTIONAL ).
*
*    SPLIT ls_rs3 AT '"' INTO TABLE FINAL(lt_delivery3).
*    DATA(ls_rs4) = VALUE #( lt_delivery3[ 1 ] OPTIONAL ).

    IF ls_result <> 'Success'.
*    IF ls_rs2 = 'X' AND ls_rs4 = ''.

      APPEND VALUE #( %tky        = ls_hdr-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = 'Error while Delivery Picking & PGI.' ) )
             TO reported-zmm_gatehead_rvi.

      APPEND VALUE #( %tky = ls_hdr-%tky )
             TO failed-zmm_gatehead_rvi.
    ELSE.
      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
             ENTITY zmm_gatehead_rvi
             UPDATE
             FIELDS (
             pgistat tprint )
             WITH VALUE #( FOR key IN keys
                           ( %tky           = ls_hdr-%tky
                             tprint       = ' '
                             pgistat = 'X' ) ).
    ENDIF.
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).

  ENDMETHOD.

  METHOD print.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          FAILED FINAL(header_failed).

******************************************************************
    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_gate>).
      IF <fs_gate> IS ASSIGNED.

        <fs_gate>-tprint = 'X'.

        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                UPDATE
                FIELDS ( tprint )
                WITH VALUE #( ( %tky          = <fs_gate>-%tky
                                 tprint =  <fs_gate>-tprint
                                  %control-tprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY  zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD setout.
**********************************************************************
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
**********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          ENTITY zmm_gatehead_rvi BY \_Item1
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(item)
          FAILED FINAL(header_failed).
**********************************************************************
*    READ ENTITIES OF zi_gatehead IN LOCAL MODE
*         ENTITY item1
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(item_failed).

*    READ ENTITY zmm_gatehead_rvi
*         BY \_item1
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED DATA(revfailed).
**********************************************************************
    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
**********************************************************************
***This Code Added by SAR Tech Team by 10-11-2-2025*****
    GET TIME STAMP FIELD Data(ts).
    CONVERT TIME STAMP ts TIME ZONE 'INDIA' INTO DATE DATA(lv_date1) TIME DATA(lv_time1).
**********************************************************************
    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_gate>).
      IF <fs_gate> IS ASSIGNED.

*        IF <fs_gate>-movementtype = 'OUTWARD' AND <fs_gate>-materialprocess = 'RGP' AND <fs_gate>-challanno IS INITIAL. "old
        IF <fs_gate>-movementtype = 'INWARD' AND <fs_gate>-materialprocess = 'RGP' AND <fs_gate>-challanno IS INITIAL.   " new one change by SAR tech team by 20-11-2025
          DATA(lv_msg2) = |Please Create Challan Before Exit|.
          APPEND VALUE #( %tky = <fs_gate>-%tky )
                      TO failed-zmm_gatehead_rvi.

          APPEND VALUE #( %tky           = <fs_gate>-%tky
                          %state_area    = 'Validate_Header'
                          %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = lv_msg2 )   )
                 TO reported-zmm_gatehead_rvi.

        ENDIF.
**********************************************************************
        IF <fs_gate>-movementtype = 'INWARD' AND <fs_gate>-materialprocess <> 'RGP'.
          LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).
            IF <fs_item> IS ASSIGNED.
              IF <fs_item>-qtyactual IS INITIAL.
                DATA(lv_msg3) = |Set Out Is Only Allowed After Weighment|.
*              APPEND VALUE #( %tky = <fs_gate>-%tky )
*                          TO failed-zi_gatehead.

                APPEND VALUE #( %tky           = <fs_gate>-%tky
                                %state_area    = 'Validate_Header'
                                %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = lv_msg3 )   )
                       TO reported-zmm_gatehead_rvi.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
**********************************************************************
**nk
**        SELECT SINGLE deliverydocument
**        FROM i_deliverydocument
**        WHERE yy1_gatepass_dlh = @<fs_gate>-gatepassno
**        INTO @DATA(lv_del).
**
**        SELECT SINGLE billingdocument
**        FROM i_billingdocumentitem
**        WHERE referencesddocument = @lv_del
**        INTO @DATA(lv_inv).
**nk

*        IF lv_inv IS INITIAL AND <fs_gate>-movementtype = 'OUTWARD' AND <fs_gate>-materialprocess <> 'RGP'.
*          DATA(lv_msg) = |Invoice not created against Gatepass|.
*          APPEND VALUE #( %tky = <fs_gate>-%tky )
*                      TO failed-zi_gatehead.
*
*          APPEND VALUE #( %tky           = <fs_gate>-%tky
*                          %state_area    = 'Validate_Header'
*                          %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                  text     = lv_msg )   )
*                 TO reported-zi_gatehead.
*        ELSE.
*nk        <fs_gate>-taxinvoice = lv_inv.
**********************************************************************
        <fs_gate>-exitdate = lv_date1.
        <fs_gate>-exittime = lv_time1.

        IF <fs_gate>-status = 'Cancelled'.
          <fs_gate>-status = 'Cancelled & Exited'.
        ELSE.
          <fs_gate>-status = 'Exited'.
        ENDIF.
        <fs_gate>-tprint = ' '.
**********************************************************************
*nk        <fs_gate>-deliverydocument = lv_del.
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                UPDATE
                FIELDS ( deliverydocument taxinvoice tprint status Exitdate Exittime )
                WITH VALUE #( ( %tky          = <fs_gate>-%tky
                                 status        = <fs_gate>-status
                                 tprint = <fs_gate>-tprint
                                 taxinvoice = <fs_gate>-taxinvoice
                                 Exitdate = <fs_gate>-Exitdate
                                 Exittime = <fs_gate>-Exittime
                                 deliverydocument = <fs_gate>-deliverydocument
                                ) ).

*        ENDIF.
      ENDIF.
    ENDLOOP.
**********************************************************************
    " Fill the response table
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
         ENTITY  zmm_gatehead_rvi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
**********************************************************************

  ENDMETHOD.

  METHOD upd.
*********************************************************************
    DATA lv_json TYPE string.
    DATA lv_val TYPE string.
    DATA lv_str  TYPE string.

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
        ENTITY zmm_gatehead_rvi
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header)
        " TODO: variable is assigned but never used (ABAP cleaner)
        FAILED DATA(lt_header_failed).

    DATA(ls_hdr) = lt_header[ 1 ].


    lv_json = '{'.
    lv_json = |{ lv_json }"TextElement": "JGVN" ,|.
    lv_json = |{ lv_json }"Language":"EN",|.
    lv_json = |{ lv_json }"TextElementText":"{ ls_hdr-vehicleno }"|.
    lv_json = |{ lv_json } \}|.
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCS_DEL_TEXT'
                                    service_id    = 'ZOS_DELTEXT_REST' ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_val = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                              i_value = lv_val ).
        lo_request->set_text( lv_json ).
        DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error). " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO DATA(web_http_client_error). " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

    FREE: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    CLEAR: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    lv_json = '{'.
    lv_json = |{ lv_json }"TextElement": "Z001" ,|.
    lv_json = |{ lv_json }"Language":"EN",|.
    lv_json = |{ lv_json }"TextElementText":"{ ls_hdr-transportername }"|.
    lv_json = |{ lv_json } \}|.
    TRY.
        lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCS_DEL_TEXT'
                                    service_id    = 'ZOS_DELTEXT_REST' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_request = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_val = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                              i_value = lv_val ).
        lo_request->set_text( lv_json ).
        ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.


    FREE: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    CLEAR: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    lv_json = '{'.
    lv_json = |{ lv_json }"TextElement": "Z002" ,|.
    lv_json = |{ lv_json }"Language":"EN",|.
    lv_json = |{ lv_json }"TextElementText":"{ ls_hdr-transportergst }"|.
    lv_json = |{ lv_json } \}|.
    TRY.
        lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCS_DEL_TEXT'
                                    service_id    = 'ZOS_DELTEXT_REST' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_request = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_val = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                              i_value = lv_val ).
        lo_request->set_text( lv_json ).
        ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

    FREE: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    CLEAR: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    DATA: lv_lrdate TYPE c LENGTH 10.
    lv_lrdate =  |{ ls_hdr-lrrrdate+6(2) }.{ ls_hdr-lrrrdate+4(2) }.{ ls_hdr-lrrrdate+0(4) }|.
    lv_json = '{'.
    lv_json = |{ lv_json }"TextElement": "Z004" ,|.
    lv_json = |{ lv_json }"Language":"EN",|.
    lv_json = |{ lv_json }"TextElementText":"{ lv_lrdate }"|.
    lv_json = |{ lv_json } \}|.
    TRY.
        lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCS_DEL_TEXT'
                                    service_id    = 'ZOS_DELTEXT_REST' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_request = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_val = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                              i_value = lv_val ).
        lo_request->set_text( lv_json ).
        ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

    FREE: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    CLEAR: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    lv_json = '{'.
    lv_json = |{ lv_json }"TextElement": "Z003" ,|.
    lv_json = |{ lv_json }"Language":"EN",|.
    lv_json = |{ lv_json }"TextElementText":"{ ls_hdr-lrrrno }"|.
    lv_json = |{ lv_json } \}|.
    TRY.
        lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCS_DEL_TEXT'
                                    service_id    = 'ZOS_DELTEXT_REST' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_request = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_val = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                              i_value = lv_val ).
        lo_request->set_text( lv_json ).
        ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

    FREE: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    CLEAR: lo_destination, lo_http_client, lo_request,ls_result ,lv_json, http_dest_provider_error, web_http_client_error, lv_str.
    lv_json = '{'.
    lv_json = |{ lv_json }"TextElement": "Z008" ,|.
    lv_json = |{ lv_json }"Language":"EN",|.
    lv_json = |{ lv_json }"TextElementText":"001"|.
    lv_json = |{ lv_json } \}|.
    TRY.
        lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario = 'ZCS_DEL_TEXT'
                                    service_id    = 'ZOS_DELTEXT_REST' ).
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_request = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |application/json| ).
        lv_val = ls_hdr-deliverydocument.
        lo_request->set_header_field( i_name  = 'DeliveryDocument'
                              i_value = lv_val ).
        lo_request->set_text( lv_json ).
        ls_result = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            out->write( ls_result ).
        lo_http_client->close( ).
        CLEAR lv_json.
      CATCH cx_http_dest_provider_error INTO http_dest_provider_error. " TODO: variable is assigned but never used (ABAP cleaner)
      CATCH cx_web_http_client_error INTO web_http_client_error. " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.


    MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
              ENTITY zmm_gatehead_rvi
              UPDATE
              FIELDS (
              textupdated tprint )
              WITH VALUE #( FOR key IN keys
                            ( %tky           = ls_hdr-%tky
                              textupdated       = 'X'
                              tprint = ' ' ) ).

    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).


  ENDMETHOD.

  METHOD headerdetails1.
*************************************************************************
    DATA: lv_bp   TYPE i_businessuserbasic-businesspartner,     "" ++ 09.06.25
          ls_user TYPE i_businessuserbasic.                         ""++ 09.06.25

*************************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS  WITH CORRESPONDING #( keys )
          RESULT DATA(gt_header)
          FAILED DATA(failed).
*************************************************************************

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
        <fs_head>-status = 'Draft'.
        <fs_head>-tprint = ' '.

        <fs_head>-createdby = sy-uname.


        lv_bp = sy-uname.
*        select single * FROM I_BusinessUserBasic
*        where BusinessPartner = @lv_bp
*        into @ls_user.

        SELECT SINGLE personfullname FROM i_businessuserbasic wiTH PRIVILEGED ACCESS
        WHERE userid = @<fs_head>-createdby
        INTO @DATA(lv_user).
*************************************************************************
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_gatehead_rvi
           UPDATE
           FIELDS ( status  tprint createdby createdbyname )
           WITH VALUE #( FOR key IN keys
                         ( %tky               = <fs_head>-%tky
                           status = <fs_head>-status
                           tprint = <fs_head>-tprint
                           createdby = sy-uname
*                           createdbyname = ls_user-PersonFullName  // -- 26.06.25
                           createdbyname = lv_user
                           %control-status   = if_abap_behv=>mk-on
                           %control-tprint = if_abap_behv=>mk-on
                           %control-createdby   = if_abap_behv=>mk-on
                           %control-createdbyname   = if_abap_behv=>mk-on
                            ) ).
      ENDIF.
    ENDLOOP.
*************************************************************************
  ENDMETHOD.

  METHOD headerdetails.

*************************************************************************
    DATA: lv_bp   TYPE i_businessuserbasic-businesspartner,      "" ++ 09.06.25
          ls_user TYPE i_businessuserbasic.                    "" ++ 09.06.25
*************************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_gatehead_rvi
           ALL FIELDS  WITH CORRESPONDING #( keys )
           RESULT DATA(gt_header)
           FAILED DATA(failed).
*************************************************************************

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
        IF <fs_head>-gatepassno IS INITIAL.
          <fs_head>-status = 'Under Process'.
        ELSE.
          <fs_head>-status = 'Gatepass Created'.
        ENDIF.

        <fs_head>-tprint = ' '.
        <fs_head>-createdby = sy-uname.

        lv_bp = sy-uname.                     "" ++ 09.06.25
*        select single * FROM I_BusinessUserBasic
*        where BusinessPartner = @lv_bp
*        into @ls_user.
        SELECT SINGLE personfullname FROM i_businessuserbasic wiTH PRIVILEGED ACCESS
        WHERE userid = @<fs_head>-createdby
        INTO @DATA(lv_user).

*************************************************************************
        TRANSLATE <fs_head>-vehicleno TO UPPER CASE.
        CONDENSE <fs_head>-vehicleno NO-GAPS.
*************************************************************************
        MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_gatehead_rvi
           UPDATE
           FIELDS ( status tprint vehicleno createdby createdbyname )
           WITH VALUE #( FOR key IN keys
                         ( %tky   = <fs_head>-%tky
                           status = <fs_head>-status
                           tprint = <fs_head>-tprint
                           vehicleno = <fs_head>-vehicleno
                           createdby = sy-uname
*                           createdbyname = ls_user-PersonFullName
                           createdbyname = lv_user
                           %control-status   = if_abap_behv=>mk-on
                           %control-tprint   = if_abap_behv=>mk-on
                           %control-vehicleno   = if_abap_behv=>mk-on
                           %control-createdby   = if_abap_behv=>mk-on
                           %control-createdbyname   = if_abap_behv=>mk-on
                            ) ).

      ENDIF.
    ENDLOOP.
*************************************************************************
  ENDMETHOD.

  METHOD itemmodify.
**************************************************************************************
    READ ENTITIES OF zmm_gatehead_rvi iN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(gt_head)
    enTITY zmm_gatehead_rvi BY \_item1
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item)
           " TODO: variable is assigned but never used (ABAP cleaner)
    FAILED DATA(revfailed).

**************************************************************************************
    DATA : lv_item TYPE zdt_gate_item-gateitemapi.

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      IF <lfs_item> IS ASSIGNED.
        lv_item = lv_item + 10.

        MODIFY ENTITIES OF zmm_gatehead_rvi   IN LOCAL MODE
             ENTITY item1
             UPDATE
             FIELDS ( gateitemapi )
             WITH VALUE #( FOR key IN keys
                           ( %tky               = <lfs_item>-%tky
                             gateitemapi = lv_item
                              %control-gateitemapi   = if_abap_behv=>mk-on
                              ) ).
      ENDIF.
    ENDLOOP.
**************************************************************************************
  ENDMETHOD.

  METHOD headdet.
  ENDMETHOD.

  METHOD vehiclecheck.
*************************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_gatehead_rvi
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(lt_header_failed).
*************************************************************************
    DATA(ls_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*************************************************************************
*** ---- User Validation logic -----*******************************
    if ls_head-Companycode is not inITIAL.

    TRY.
        DATA(lv_user) = cl_abap_context_info=>get_user_business_partner_id(  ).
      CATCH cx_abap_context_info_error.
        DATA(ls_x1) = 1.
    ENDTRY.

    DATA(lv_cbuser) = 'CB' && lv_user.

    SELECT SINGLE * FROM zmm_gate_user_rvi with PRIVILEGED ACCESS
    WHERE userid = @lv_cbuser
    AND ccode = @ls_head-companycode
    INTO @DATA(ls_userval).

    if ls_userval-Userid is iNITIAL.
    DATA(lv_msgs) = |This User"{ ls_head-createdbyname }"Cannot Be Create GatePass|.
        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msgs ) )
               TO reported-zmm_gatehead_rvi.

        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zmm_gatehead_rvi.
    endif.

    endif.

*************************************************************************
    IF ls_head-movementtype = 'OUTWARD'.
      IF ls_head-transportergst IS INITIAL.
        DATA(lv_msg) = |Transporter GSTIN is a mandatory field for Outbound Gatepass.|.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
               TO reported-zmm_gatehead_rvi.

        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zmm_gatehead_rvi.
      ENDIF.
    ENDIF.
*************************************************************************

    IF ls_head-movementtype = 'INWARD' AND ls_head-materialprocess = 'RAW'.
      IF ls_head-challanwt IS INITIAL.
        DATA(lv_msgx) = |Challan Weight is mandatory Field|.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msgx ) )

               TO reported-zmm_gatehead_rvi.
        APPEND VALUE #( %tky = ls_head-%tky )
                TO failed-zmm_gatehead_rvi.
      ENDIF.
    ENDIF.
*************************************************************************
**this new logic added by SAR Tech team---
    IF ls_head-movementtype = 'INWARD' AND ls_head-materialprocess = 'RGP'.
      IF ls_head-challanno IS INITIAL.
        DATA(gv_msgx) = |Challan No & Date is mandatory Field|.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = gv_msgx ) )

               TO reported-zmm_gatehead_rvi.
        APPEND VALUE #( %tky = ls_head-%tky )
                TO failed-zmm_gatehead_rvi.
      ENDIF.
    ENDIF.
**************************************************************************

    IF ls_head-vehicleno IS NOT INITIAL.
      DATA: lv_veh TYPE c leNGTH 10.
      lv_veh = ls_head-vehicleno.
      CONDENSE lv_veh NO-GAPS.
      TRANSLATE lv_veh TO UPPER CASE.
*************************************************************************
*      IF ls_head-gatepassno IS INITIAL.
*        SELECT SINGLE vehicleno , gatepassno
*        FROM zi_gatehead
*        WHERE vehicleno = @lv_veh
*        AND gatepassno IS NOT INITIAL
*        AND exitdate IS INITIAL
*        INTO @DATA(lv_vehno).
*        IF sy-subrc = 0.
*          DATA(lv_msg2) = |Vehicle already Exist in the Plant|.
*          APPEND VALUE #( %tky = ls_head-%tky )
*                 TO failed-zi_gatehead.
*
*          APPEND VALUE #( %tky        = ls_head-%tky
*                          %state_area = 'Validate_Head'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg2 ) )
*
*                 TO reported-zi_gatehead.
*        ENDIF.
*      ENDIF.
*************************************************************************
      IF  ls_head-vehicleno CA '!@#$%^&*()_,./<>?\|-=+'.
*        DATA(lv_msg) = |Vehicle No. cannot Contain Special Charater|.
        lv_msg = |Vehicle No. cannot Contain Special Charater|.
        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zmm_gatehead_rvi.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-zmm_gatehead_rvi.
      ENDIF.
*************************************************************************
      IF  strlen( ls_head-vehicleno ) GT 10.
        lv_msg = |Vehicle No. cannot be more than 10 Characters|.
        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zmm_gatehead_rvi.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-zmm_gatehead_rvi.
      ENDIF.
*************************************************************************
    ELSE.
      DATA(lv_msg1) = |Vehicle No. is Required Field|.
      APPEND VALUE #( %tky = ls_head-%tky )
             TO failed-zmm_gatehead_rvi.

      APPEND VALUE #( %tky        = ls_head-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )

             TO reported-zmm_gatehead_rvi.
    ENDIF.
*************************************************************************
  ENDMETHOD.

*  METHOD pendingqty.
*  ENDMETHOD.

ENDCLASS.

CLASS lhc_item1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item1 RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR item1 RESULT result.

    METHODS confirm FOR MODIFY
      IMPORTING keys FOR ACTION item1~confirm RESULT result.

    METHODS confirms FOR MODIFY
      IMPORTING keys FOR ACTION item1~confirms RESULT result.

    METHODS qtyupdate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item1~qtyupdate.

    METHODS itemmodify2 FOR DETERMINE ON SAVE
      IMPORTING keys FOR item1~itemmodify2.

    METHODS qtychk FOR VALIDATE ON SAVE
      IMPORTING keys FOR item1~qtychk.
    METHODS qtystatus FOR MODIFY
      IMPORTING keys FOR ACTION item1~qtystatus RESULT result.

ENDCLASS.

CLASS lhc_item1 IMPLEMENTATION.

  METHOD get_instance_features.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_header2)
    ENTITY zmm_gatehead_rvi BY \_Item1
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    FAILED FINAL(lt_header2_failed).
******************************************************************
*    READ ENTITIES OF zi_gatehead IN LOCAL MODE
*           ENTITY zi_gateitem
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT DATA(item)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED DATA(item_failed).
******************************************************************
   SELECT SINGLE * FROM ZMM_CONFIRM_DB
   WHERE suser = @sy-uname
   INTO @DATA(ls_confirm).

    SELECT SINGLE * FROM zpostgr_matrix
  WHERE suser = @sy-uname
  INTO @DATA(ls_post).
******************************************************************
    LOOP AT lt_header2 ASSIGNING FIELD-SYMBOL(<fs_head>).
      result = VALUE #( FOR gs_item IN item
                  ( %tky                            = gs_item-%tky

                  %action-confirm  = COND #( WHEN gs_item-ssconfirm IS NOT INITIAL   AND gs_item-fconfirm IS INITIAL
                                             AND <fs_head>-movementtype = 'INWARD' AND  <fs_head>-materialprocess <> 'RAW'
                                             AND ls_confirm-suser IS NOT INITIAL
                                              THEN if_abap_behv=>fc-o-enabled
                                                ELSE if_abap_behv=>fc-o-disabled )
                   %action-confirms  = COND #( WHEN gs_item-ssconfirm IS  INITIAL  AND <fs_head>-movementtype = 'INWARD'
                                                AND  <fs_head>-materialprocess <> 'RAW' AND ls_post-suser IS NOT INITIAL
                                              THEN if_abap_behv=>fc-o-enabled
                                                ELSE if_abap_behv=>fc-o-disabled )
*                  %action-gr  = COND #( WHEN gs_item-fconfirm IS NOT INITIAL AND gs_item-gr IS INITIAL AND  <fs_head>-movementtype = 'INWARD'
*                                                              THEN if_abap_behv=>fc-o-enabled
*                                                              ELSE if_abap_behv=>fc-o-disabled )
                 %field-qtybought = COND #( WHEN <fs_head>-materialprocess = 'RAW' AND  <fs_head>-movementtype = 'INWARD'
                                                              THEN if_abap_behv=>fc-f-read_only
*                                            WHEN gs_item-qtyboughtsts = 'X'
*                                                              THEN if_abap_behv=>fc-f-read_only
                                                              ELSE if_abap_behv=>fc-f-unrestricted )

*                 %action-QtyStatus = cond #( when gs_item-qtyboughtsts is INITIAL
*                                            THEN if_abap_behv=>fc-o-enabled
*                                            ELSE if_abap_behv=>fc-o-disabled )

                 %field-tareqty = COND #( WHEN gs_item-tareqty is not INITIAL
                                                              THEN if_abap_behv=>fc-f-read_only
                                                              ELSE if_abap_behv=>fc-f-unrestricted )
                 %field-grossqty = COND #( WHEN gs_item-grossqty is not INITIAL
                                                              THEN if_abap_behv=>fc-f-read_only
                                                              ELSE if_abap_behv=>fc-f-unrestricted )
                  %field-storagelocation = COND #( WHEN gs_item-gr IS INITIAL AND  <fs_head>-movementtype = 'INWARD'
                                                              THEN if_abap_behv=>fc-f-unrestricted
                                                              ELSE if_abap_behv=>fc-f-read_only )



                  %delete = COND #( WHEN gs_item-gr IS INITIAL AND  gs_item-fconfirm IS INITIAL
                                                              THEN if_abap_behv=>fc-o-enabled
                                                              ELSE if_abap_behv=>fc-o-disabled )
                                                              ) ).
    ENDLOOP.
******************************************************************
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD confirm.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_header2)

    ENTITY zmm_gatehead_rvi by \_Item1
    alL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    FAILED FINAL(lt_header2_failed).

*    READ ENTITIES OF zi_gatehead IN LOCAL MODE
*            ENTITY zi_gateitem
*            ALL FIELDS
*            WITH CORRESPONDING #( keys )
*            RESULT DATA(item)
*            " TODO: variable is assigned but never used (ABAP cleaner)
*            FAILED DATA(item_failed).

    LOOP AT lt_header2 ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
        LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).
          IF <fs_item> IS ASSIGNED.
            IF <fs_item>-storagelocation IS NOT INITIAL.
*********************************************************************
              SELECT SINGLE * FROM ZMM_CONFIRM_DB
              WHERE suser = @sy-uname
              AND sloc = @<fs_item>-storagelocation
              INTO @DATA(ls_cnf).
              IF sy-subrc <> 0.
                DATA(lv_msgx) = |You are not authorized to Confirm for S. Loc { <fs_item>-storagelocation }|.
                APPEND VALUE #( %tky        = <fs_item>-%tky
                                %state_area = 'Validate_Head'
                                %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     = lv_msgx ) )
                       TO reported-item1.
                APPEND VALUE #( %tky = <fs_item>-%tky )
                                TO failed-item1.
*********************************************************************
              ELSE.

                <fs_item>-fconfirm = 'X'.
                MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                            ENTITY item1
                            UPDATE
                            FIELDS (  fconfirm  )
                            WITH VALUE #( ( %tky          = <fs_item>-%tky
                                             fconfirm = <fs_item>-fconfirm
                                             %control-fconfirm  = if_abap_behv=>mk-on
                                            ) ).
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
        ENTITY item1
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(item1)
        FAILED DATA(item_failed1).

    DATA : lv_gateitem TYPE zdt_gate_item-gateitemapi.

    LOOP AT item1 ASSIGNING FIELD-SYMBOL(<fs_item1>) WHERE fconfirm = 'X'.
      IF <fs_item1> IS ASSIGNED.
        lv_gateitem = lv_gateitem + 10.
        <fs_item1>-gateitemapi = lv_gateitem.
      ENDIF.
    ENDLOOP.
*********************************************************************
  ENDMETHOD.

  METHOD confirms.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header2)
    ENTITY zmm_gatehead_rvi BY \_Item1
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(item)
    FAILED DATA(lt_header2_failed).
******************************************************************
*    READ ENTITIES OF zi_gatehead IN LOCAL MODE
*            ENTITY zi_gateitem
*            ALL FIELDS
*            WITH CORRESPONDING #( keys )
*            RESULT DATA(item)
*            " TODO: variable is assigned but never used (ABAP cleaner)
*            FAILED DATA(item_failed).

    LOOP AT lt_header2 ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
        LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).
          IF <fs_item> IS ASSIGNED.
            IF <fs_item>-storagelocation IS INITIAL.
              DATA(lv_msgx) = |Storage Location is mandatory Field|.

              APPEND VALUE #( %tky        = <fs_item>-%tky
                              %state_area = 'Validate_Head'
                              %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = lv_msgx ) )
                     TO reported-item1.
              APPEND VALUE #( %tky = <fs_item>-%tky )
                       TO failed-item1.

            ELSE.

              <fs_item>-ssconfirm = 'X'.
******************************************************************
              MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
                          ENTITY item1
                          UPDATE
                          FIELDS (  ssconfirm  )
                          WITH VALUE #( ( %tky          = <fs_item>-%tky
                                           ssconfirm = <fs_item>-ssconfirm
                                           %control-ssconfirm  = if_abap_behv=>mk-on
                                          ) ).
******************************************************************
              SELECT SINGLE * FROM ZMM_CONFIRM_DB
                WHERE sloc = @<fs_item>-storagelocation
                INTO @DATA(ls_cnf).
******************************************************************
              DATA lv_xtring TYPE string.
              TRY.
                  "Initialize Template Store Client
                  DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
                   iv_name                  = 'YY1_CS_ADOBE'
                   iv_service_instance_name = 'YY1_OS_ADOBE_REST'
                  ).
                  DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZGATE_PRINT_HEAD_CE' ) .

                  TRY.
                      lo_store->get_schema_by_name( iv_form_name = 'GATEFORM' ).
                      "   out->write( 'Schema found in form' ).
                    CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                      "  out->write( 'No schema in form found' ).
                      IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
                        "Upload service definition
*                        lo_store->set_schema(
*                          iv_form_name = 'GATEFORM'
*                          is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                        ).
                      ELSE.

                      ENDIF.
******************************************************************
                  ENDTRY.
                  DATA(lt_keys)     = lo_fdp_util->get_keys( ).
                  lt_keys[ name = 'ID' ]-value = <fs_head>-id.

                  TRY.
                      DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
                      "out->write( 'Service data retrieved' ).
                    CATCH cx_fp_fdp_error INTO DATA(lo_exception).
                  ENDTRY.
                  DATA(ls_template) = lo_store->get_template_by_name(
                 iv_get_binary    = abap_true
                 iv_form_name     = 'GATEFORM'
                 iv_template_name = 'GATEFORM'
                                                   ).
******************************************************************
                  "out->write( 'Form Template retrieved' ).

*                  cl_fp_ads_util=>render_4_pq(
*                    EXPORTING
*                      iv_locale       = 'en_US'
*                      iv_pq_name      = 'YYGATEFROM' "'PRINT_QUEUE'
*                      iv_xml_data     = lv_xml
*                      iv_xdp_layout   = ls_template-xdp_template
*                      is_options      = VALUE #(
*                        trace_level = 4 "Use 0 in production environment
*                  )
*                    IMPORTING
*                      ev_trace_string = DATA(lv_trace)
*                      ev_pdl          = DATA(lv_pdf)
*                  ).
******************************************************************
                  cl_fp_ads_util=>render_pdf(
                    EXPORTING
                      iv_locale       = 'en_US'
                      "iv_pq_name      = 'PSLITTER' "'PRINT_QUEUE'
                      iv_xml_data     = lv_xml
                      iv_xdp_layout   = ls_template-xdp_template
                      is_options      = VALUE #(
                        trace_level = 4 "Use 0 in production environment
                  )
                    IMPORTING
                      ev_trace_string = DATA(lv_trace00)
                      ev_pdf          = DATA(lv_pdf00)
                  ).
******************************************************************
                  " out->write( 'Output was sent to print queue' ).
                  DATA : lv_email TYPE zde_email.
                  lv_email = ls_cnf-mail.

****************************************************************
TRY.

    "-----------------------------------------------------------
    " Sender & Recipient (must be STRING in Public Cloud)
    "-----------------------------------------------------------
    DATA lv_sender    TYPE c LENGTH 512.
    DATA lv_recipient TYPE c LENGTH 512.

    lv_sender    = 'tharmaraj.seenikkalai@sarindiadigital.com'.
    lv_recipient = lv_email.   "Your recipient email

    "Validate sender
    IF lv_sender IS INITIAL.
      RAISE EXCEPTION TYPE cx_bcs_mail
        EXPORTING textid = cx_bcs_mail=>invalid_sender.
    ENDIF.

    "Validate recipient
    IF lv_recipient IS INITIAL.
      RAISE EXCEPTION TYPE cx_bcs_mail
        EXPORTING textid = cx_bcs_mail=>invalid_recipient.
    ENDIF.

    "Validate PDF content
    IF lv_pdf00 IS INITIAL.
      RAISE EXCEPTION TYPE cx_bcs_mail
        EXPORTING textid = cx_bcs_mail=>attachment_invalid.
    ENDIF.

    "-----------------------------------------------------------
    " Prepare HTML Body
    "-----------------------------------------------------------
                      DATA : iv_content      TYPE string .
                      iv_content = |<p>Dear Sir / Madam,</p><p></p><p>Please confirm the supply of the materials.</p><p></p><p>Thanking you,</p><p>Bengal Energy Limited</p>|.
    "-----------------------------------------------------------
    " Create mail object
    "-----------------------------------------------------------
    DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).

    lo_mail->set_sender( lv_sender ).
    lo_mail->add_recipient( lv_recipient ).
    lo_mail->set_subject( 'Gatepass Confirmation' ).

    "-----------------------------------------------------------
    " Add HTML body
    "-----------------------------------------------------------
    lo_mail->set_main(
        cl_bcs_mail_textpart=>create_instance(
            iv_content      = iv_content
            iv_content_type = 'text/html'
        )
    ).

    "-----------------------------------------------------------
    " Add PDF attachment
    "-----------------------------------------------------------
    lo_mail->add_attachment(
        cl_bcs_mail_binarypart=>create_instance(
            iv_content      = lv_pdf00
            iv_content_type = 'application/pdf'
            iv_filename     = 'gatepass.pdf'
        )
    ).

    "-----------------------------------------------------------
    " Send Email & Capture Status
    "-----------------------------------------------------------
    lo_mail->send(
        IMPORTING et_status = DATA(lt_status)
    ).

    "Log status (important)
    LOOP AT lt_status ASSIGNING FIELD-SYMBOL(<fs_status>).
IF <fs_status>-status <> 'S'.
  RAISE EXCEPTION TYPE cx_bcs_mail
    EXPORTING textid = cx_bcs_mail=>send_error.
ENDIF.
    ENDLOOP.

  CATCH cx_bcs_mail INTO DATA(lx_mail).

ENDTRY.

*                  TRY.
*                      DATA : iv_content      TYPE string .
*                      iv_content = |<p>Dear Sir / Madam,</p><p></p><p>Please confirm the supply of the materials.</p><p></p><p>Thanking you,</p><p>Bengal Energy Limited</p>|.
*                      DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
*                      lo_mail->set_sender( 'no-reply@bengalenergy.in' ).  "old one
**                      lo_mail->set_sender( 'tharmaraj.seenikkalai@sarindiadigital.com' ).
*                      lo_mail->add_recipient( lv_email ).
*
*                      lo_mail->set_subject( 'Gatepass Confirmation' ).
*                      lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
*                        iv_content      =  iv_content
*                        iv_content_type = 'text/html' ) ).
*
*                      lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
*                        iv_content      = lv_pdf00
*                        iv_content_type = 'application/pdf'
*                        iv_filename     = 'gatepass.pdf'
*                      ) ).
*
*                      lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
*
*                    CATCH cx_bcs_mail INTO DATA(lx_mail).
*                      "handle exceptions here
*                  ENDTRY.

                CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
                  " out->write( 'Exception occurred.' ).
              ENDTRY.
              "out->write( 'Finished processing.' ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
        ENTITY item1
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(item1)
        " TODO: variable is assigned but never used (ABAP cleaner)
        FAILED DATA(item_failed1).
******************************************************************
    DATA : lv_gateitem TYPE zdt_gate_item-gateitemapi.

    LOOP AT item1 ASSIGNING FIELD-SYMBOL(<fs_item1>) WHERE fconfirm = 'X'.
      IF <fs_item1> IS ASSIGNED.
        lv_gateitem = lv_gateitem + 10.
        <fs_item1>-gateitemapi = lv_gateitem.

      ENDIF.
    ENDLOOP.

******************************************************************
  ENDMETHOD.

  METHOD qtyupdate.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi in LOCAL MODE
    ENTITY zmm_gatehead_rvi
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_gatehead)
    enTITY zmm_gatehead_rvi BY \_item1
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_item)
         FAILED DATA(revfailed).

    DATA : lv_qty TYPE zdt_gate_item-qtyactual.
    data : lv_penqty type zmm_gateitem_db-pendqty.
    data : lv_penqty1 type zmm_gateitem_db-pendqty.

    data(ls_gatehead) = lt_gatehead[ 1 ].
******************************************************************
    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      IF <lfs_item> IS ASSIGNED.
        lv_qty = <lfs_item>-grossqty - <lfs_item>-tareqty.

        if ls_gatehead-Movementtype = 'INWARD' and ls_gatehead-Materialprocess = 'RGP'.
        lv_penqty = <lfs_item>-Qty - <lfs_item>-Qtybought.
        endif.

        MODIFY ENTITIES OF zmm_gatehead_rvi   IN LOCAL MODE
             ENTITY item1
             UPDATE
             FIELDS ( qtyactual pendqty )
             WITH VALUE #( FOR key IN keys
                           ( %tky               = <lfs_item>-%tky
                             qtyactual = lv_qty
                             pendqty = lv_penqty
                              %control-qtyactual   = if_abap_behv=>mk-on
                              %control-pendqty = if_abap_behv=>mk-on
                              ) ).
        CLEAR : lv_qty,lv_penqty.
      ENDIF.
    ENDLOOP.
******************************************************************
        if ls_gatehead-Movementtype = 'INWARD' and ls_gatehead-Materialprocess = 'RGP'.
            loop at lt_item into data(wa_item).
              lv_penqty1 = lv_penqty1 + wa_item-pendqty.
            endloop.

            if lv_penqty1 is not iNITIAL.
                MODIFY ENTITIES OF zmm_gatehead_rvi iN LOCAL MODE
                ENTITY zmm_gatehead_rvi
                UPDATE
                FIELDS ( pendqty )
                WITH VALUE #( ( %tky = ls_gatehead-%tky
                                pendqty = lv_penqty1
                                %control-pendqty = if_abap_behv=>mk-on ) ).
            endif.
        endif.

  ENDMETHOD.

  METHOD itemmodify2.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi in LOCAL MODE
    enTITY zmm_gatehead_rvi BY \_item1
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item)
   FAILED DATA(revfailed).
******************************************************************
    DATA : lv_item TYPE zdt_gate_item-gateitemapi.
    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      IF <lfs_item> IS ASSIGNED.
        lv_item = lv_item + 10.
        MODIFY ENTITIES OF zmm_gatehead_rvi   IN LOCAL MODE
             ENTITY item1
             UPDATE
             FIELDS ( gateitemapi )
             WITH VALUE #( FOR key IN keys
                           ( %tky               = <lfs_item>-%tky
                             gateitemapi = lv_item
                              %control-gateitemapi   = if_abap_behv=>mk-on
                              ) ).
      ENDIF.
    ENDLOOP.
******************************************************************
  ENDMETHOD.

  METHOD qtychk.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
          ENTITY zmm_gatehead_rvi
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          ENTITY zmm_gatehead_rvi BY \_Item1
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(item)
          FAILED FINAL(header_failed).
******************************************************************
*    READ ENTITIES OF zi_gatehead IN LOCAL MODE
*             ENTITY zi_gateitem
*             ALL FIELDS
*             WITH CORRESPONDING #( keys )
*             RESULT DATA(item)
*             " TODO: variable is assigned but never used (ABAP cleaner)
*             FAILED DATA(item_failed).
******************************************************************
    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
*        IF <fs_head>-movementtype = 'INWARD'.
        LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).
          IF <fs_item> IS ASSIGNED.
            IF <fs_item>-qtybought > <fs_item>-avlqty.
              DATA(lv_msg) = |Bought/Sold Qty. Must Be Less/Equal to Avl. Qty|.
              APPEND VALUE #( %tky = <fs_head>-%tky )
                          TO failed-zmm_gatehead_rvi.

              APPEND VALUE #( %tky           = <fs_head>-%tky
                              %state_area    = 'Validate_Header'
                              %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )   )
                     TO reported-zmm_gatehead_rvi.
            ENDIF.
            """"Validation for over delivery tolerance in the gate pass, based on percentage or unlimited. 20.06.25
            " Over-Delivery Tolerance Validation


            """Validation for over delivery tolerance in the gate pass, based on percentage or unlimited.20.06.25

          ENDIF.
        ENDLOOP.
*        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD QtyStatus.
****************************************************************************
*       READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
*       ENTITY zmm_gatehead_rvi
*       ALL FIELDS WITH CORRESPONDING #( keys )
*       RESULT DATA(head)
*       ENTITY zmm_gatehead_rvi BY \_Item1
*       ALL FIELDS WITH CORRESPONDING #( KEYS )
*       RESULT DATA(GITEM)
*       FAILED DATA(GT_FAILED).
*
*****************************************************************************
*    LOOP AT GITEM ASSIGNING FIELD-SYMBOL(<lfs_item>).
*      IF <lfs_item> IS ASSIGNED.
*
*              APPEND VALUE #( %tky = <lfs_item>-%tky
*                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-warning
*                                                            text = 'Do You Want Non-Editable field in Sold/RecQty' )
*                             ) TO reported-item1.
*
*
*        MODIFY ENTITIES OF zmm_gatehead_rvi   IN LOCAL MODE
*             ENTITY item1
*             UPDATE
*             FIELDS ( qtyboughtsts )
*             WITH VALUE #( FOR key IN keys
*                           ( %tky               = <lfs_item>-%tky
*                             qtyboughtsts = 'X'
*                              %control-qtyboughtsts   = if_abap_behv=>mk-on
*                              ) ).
*
*
*      ENDIF.
*    ENDLOOP.
*
*           READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
*           ENTITY zmm_gatehead_rvi
*           ALL FIELDS WITH CORRESPONDING #( keys )
*           RESULT DATA(outhead)
*           ENTITY zmm_gatehead_rvi by \_Item1
*           ALL FIELDS WITH CORRESPONDING #( keys )
*           RESULT DATA(outitem).
*
*
**          data(fs_head) = outhead[ 1 ].
**

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZMM_POHEAD_RVI DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zmm_pohead_rvi RESULT result.

    METHODS itemdetails2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_pohead_rvi~itemdetails2.

    METHODS podetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_pohead_rvi~podetails.

    METHODS sodetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zmm_pohead_rvi~sodetails.

    METHODS itemmodify1 FOR DETERMINE ON SAVE
      IMPORTING keys FOR zmm_pohead_rvi~itemmodify1.

    METHODS itemdet FOR VALIDATE ON SAVE
      IMPORTING keys FOR zmm_pohead_rvi~itemdet.

ENDCLASS.

CLASS lhc_ZMM_POHEAD_RVI IMPLEMENTATION.

  METHOD get_instance_features.
******************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
    ENTITY zmm_gatehead_rvi ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT FINAL(lt_header2)
     ENTITY zmm_gatehead_rvi BY \_Item
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT FINAL(lt_po)
     FAILED FINAL(lt_header2_failed).
******************************************************************
    DATA(ls_head) = VALUE #( lt_header2[ 1 ] OPTIONAL ).

*    READ ENTITIES OF zi_gatehead IN LOCAL MODE
*    ENTITY zi_po_details ALL FIELDS
*   WITH CORRESPONDING #( keys )
*   RESULT FINAL(lt_po)
*   FAILED FINAL(lt_po_failed).

    result = VALUE #( FOR gs_po IN lt_po
                      ( %tky                            = gs_po-%tky
                       %field-purchaseorder                    = COND #( WHEN gs_po-supplier IS  NOT INITIAL AND gs_po-purchaseorder IS NOT INITIAL
                                                                  THEN if_abap_behv=>fc-f-read_only
                                                                  ELSE if_abap_behv=>fc-f-unrestricted )
                       %field-salesorder    = COND #( WHEN gs_po-supplier IS  NOT INITIAL
                                                                  THEN if_abap_behv=>fc-f-read_only
                                                                  ELSE if_abap_behv=>fc-f-unrestricted )
                       %field-supplyplant    = COND #( WHEN ls_head-materialprocess = 'STO' AND ls_head-movementtype = 'INWARD'
                                                                  THEN if_abap_behv=>fc-f-unrestricted
                                                                  ELSE if_abap_behv=>fc-f-read_only )
                                                                   ) ).

  ENDMETHOD.

  METHOD itemdetails2.
  ENDMETHOD.

  METHOD podetails.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
            ENTITY zmm_gatehead_rvi
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(header_1)

            ENTITY zmm_gatehead_rvi by \_Item
            alL FIELDS WITH corrESPONDING #( keys )
            RESULT DATA(lt_podet1)
            FAILED DATA(revfailed).

    DATA(ls_hdr) = VALUE #( header_1[ 1 ] OPTIONAL ).


    LOOP AT lt_podet1 ASSIGNING FIELD-SYMBOL(<lfs_podet>).

      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_pohead_rvi
           UPDATE
           FIELDS ( supplier  supliername )
           WITH VALUE #( FOR key IN keys
                         ( %tky               = <lfs_podet>-%tky
*                           supliername = <lfs_podet>-supliername
*                           supplier = <lfs_podet>-supplier
                            supliername = ls_hdr-supplierdesc
                            supplier = ls_hdr-supplierno
                            %control-supliername   = if_abap_behv=>mk-on
                            %control-supplier   = if_abap_behv=>mk-on
                            ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD sodetails.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi iN LOCAL MODE
    enTITY zmm_gatehead_rvi BY \_item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_podet1)
    FAILED DATA(revfailed).

*********************************************************************
    LOOP AT lt_podet1 ASSIGNING FIELD-SYMBOL(<lfs_podet>).

      SELECT SINGLE * FROM zi_salesorderf4
       WHERE salesdocument = @<lfs_podet>-salesorder
       INTO @FINAL(ls_so).
*********************************************************************
      IF sy-subrc IS INITIAL.
        <lfs_podet>-supplier = ls_so-customer.
        <lfs_podet>-supliername = ls_so-customername.
      ENDIF.
*********************************************************************
      " Fetch supplying plant for STO 04/07/25
      SELECT SINGLE supplyingplant
      FROM i_purchaseorderapi01
       WHERE purchaseorder = @<lfs_podet>-salesorder " Assuming sales order is linked to purchase order
       INTO @DATA(supplying_plant).

      " Update the PO/SO details with the fetched supplying plant
      IF sy-subrc IS INITIAL.
        <lfs_podet>-supplyplant = supplying_plant. " New field in lt_podet1 for supplying plant
      ENDIF.
*********************************************************************
      "" till this added on 04.07.25
      MODIFY ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
           ENTITY zmm_pohead_rvi
           UPDATE
           FIELDS ( supplier  supliername )
           WITH VALUE #( FOR key IN keys
                         ( %tky               = <lfs_podet>-%tky
                           supliername = <lfs_podet>-supliername
                           supplier = <lfs_podet>-supplier
                           supplyplant = <lfs_podet>-supplyplant " Update with supplying plant 04.07.25
                            %control-supliername   = if_abap_behv=>mk-on
                            %control-supplier   = if_abap_behv=>mk-on
                            %control-supplyplant = if_abap_behv=>mk-on " Control for supplying plant 04.07.25
                            ) ).
    ENDLOOP.
*********************************************************************
  ENDMETHOD.

  METHOD itemmodify1.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi iN LOCAL MODE
    ENTITY zmm_gatehead_rvi BY \_item1
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item)
    FAILED DATA(revfailed).
*********************************************************************
    DATA : lv_item TYPE zdt_gate_item-gateitemapi.
    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).
      IF <lfs_item> IS ASSIGNED.
        lv_item = lv_item + 10.
*********************************************************************
        MODIFY ENTITIES OF zmm_gatehead_rvi   IN LOCAL MODE
             ENTITY item1
             UPDATE
             FIELDS ( gateitemapi )
             WITH VALUE #( FOR key IN keys
                           ( %tky               = <lfs_item>-%tky
                             gateitemapi = lv_item
                              %control-gateitemapi   = if_abap_behv=>mk-on

                              ) ).
      ENDIF.
    ENDLOOP.
*********************************************************************
  ENDMETHOD.

  METHOD itemdet.
*********************************************************************
    READ ENTITIES OF zmm_gatehead_rvi IN LOCAL MODE
            ENTITY zmm_gatehead_rvi
            ALL FIELDS  WITH CORRESPONDING #( keys )
            RESULT DATA(gt_header)
            ENTITY zmm_gatehead_rvi BY \_Item
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_podet)
            FAILED DATA(failed1).

*********************************************************************
    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

      IF lt_podet IS NOT INITIAL.
        DATA(lt_podet1) = lt_podet[].
        DATA : lv_count TYPE i.

        lv_count = lines( lt_podet ).

        IF <lfs_header>-movementtype = 'INWARD'.
          "Checking Duplicate PO

          SORT lt_podet1 BY purchaseorder .
          DELETE ADJACENT DUPLICATES FROM lt_podet1 COMPARING purchaseorder.

          DATA : lv_count1 TYPE i.
          lv_count1 = lines( lt_podet1 ).
*********************************************************************
          IF lv_count <> lv_count1.
            DATA(lv_msg) = |Duplicate PO Exists|.
            APPEND VALUE #( %tky = <lfs_header>-%tky )
                        TO failed-zmm_gatehead_rvi.

            APPEND VALUE #( %tky           = <lfs_header>-%tky
                            %state_area    = 'Validate_Header'
                            %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg )   )
                   TO reported-zmm_gatehead_rvi.
*********************************************************************
          ELSE.

            "Checking Different Supplier
            SORT lt_podet1 BY supplier .
            DELETE ADJACENT DUPLICATES FROM lt_podet1 COMPARING supplier.
            DATA : lv_count2 TYPE i.
            lv_count2 = lines( lt_podet1 ).
            IF lv_count2 <> 1.
              DATA(lv_msg1) = |Supplier Must Be Same In All PO|.
              APPEND VALUE #( %tky = <lfs_header>-%tky )
                          TO failed-zmm_gatehead_rvi.

              APPEND VALUE #( %tky           = <lfs_header>-%tky
                              %state_area    = 'Validate_Header'
                              %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg1 )   )
                     TO reported-zmm_gatehead_rvi.
            ENDIF.

          ENDIF.
*********************************************************************
        ELSE.

          SORT lt_podet1 BY salesorder .
          DELETE ADJACENT DUPLICATES FROM lt_podet1 COMPARING salesorder.
          DATA : lv_count3 TYPE i.
          lv_count3 = lines( lt_podet1 ).
          IF lv_count <> lv_count3.
            DATA(lv_msg2) = |Duplicate SalesOrder Exists|.
            APPEND VALUE #( %tky = <lfs_header>-%tky )
                        TO failed-zmm_gatehead_rvi.

            APPEND VALUE #( %tky           = <lfs_header>-%tky
                            %state_area    = 'Validate_Header'
                            %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = lv_msg2 )   )
                   TO reported-zmm_gatehead_rvi.
*********************************************************************
          ELSE.

            SORT lt_podet1 BY supplier .
            DELETE ADJACENT DUPLICATES FROM lt_podet1 COMPARING supplier.
            DATA : lv_count4 TYPE i.
            lv_count4 = lines( lt_podet1 ).
            IF lv_count4 <> 1.
              DATA(lv_msg3) = |Customer Must Be Same In All SO|.
              APPEND VALUE #( %tky = <lfs_header>-%tky )
                          TO failed-zmm_gatehead_rvi.

              APPEND VALUE #( %tky           = <lfs_header>-%tky
                              %state_area    = 'Validate_Header'
                              %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg3 )   )
                     TO reported-zmm_gatehead_rvi.
            ENDIF.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZMM_GATEHEAD_RVI DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZMM_GATEHEAD_RVI IMPLEMENTATION.

  METHOD save_modified.
    IF update-zmm_gatehead_rvi IS NOT INITIAL.

      DATA(lt_head) = update-zmm_gatehead_rvi
      .
      IF lt_head[ 1 ]-tprint = 'X'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'YY1_CS_ADOBE'
             iv_service_instance_name = 'YY1_OS_ADS_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZGATE_PRINT_HEAD_CE' ) .

            SELECT SINGLE * FROM zdt_printqueue
           WHERE cbuser = @sy-uname
*             AND configdeprecationcode IS INITIAL
            INTO @DATA(ls_queue).

            IF sy-subrc IS NOT INITIAL.
              ls_queue-printque = 'ADOBE_DEFAULT'.
            ENDIF.

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'GATEFORM' ).
                "   out->write( 'Schema found in form' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "  out->write( 'No schema in form found' ).
                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
                  "Upload service definition
*                  lo_store->set_schema(
*                    iv_form_name = 'GATEFORM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
                ELSE.

                ENDIF.
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
                "out->write( 'Service data retrieved' ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY..

            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'GATEFORM'
              iv_template_name = 'GATEFORM'
            ).

            cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                       "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                                 iv_xml_data     = lv_xml
                                                 iv_xdp_layout   = ls_template-xdp_template
                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                       IMPORTING
                                       " TODO: variable is assigned but never used (ABAP cleaner)
                                                 ev_trace_string = DATA(lv_trace)
                                                 ev_pdf          = DATA(lv_pdf) ).


            DATA: lv_name TYPE c LENGTH 120.
            lv_name = |Gatepass Print { lt_head[ 1 ]-gatepassno }|.

            DATA(lv_gno) = VALUE #( lt_head[ 1 ]-id OPTIONAL ).

            SELECT SINGLE * FROM zmm_gatehead_db
              WHERE id =  @lv_gno INTO @DATA(ls_files).
            IF sy-subrc IS INITIAL.
              ls_files-attachment = lv_pdf.
              ls_files-mimetype   = 'application/pdf'.
              ls_files-filename   = lv_name.
              MODIFY zmm_gatehead_db FROM @ls_files.
            ELSE.
*
              CLEAR ls_files.
              ls_files-id = lv_gno.
              ls_files-attachment = lv_pdf.
              ls_files-mimetype = 'application/pdf'.
              ls_files-filename = lv_name.

*        ENDIF.
              MODIFY zmm_gatehead_db FROM @ls_files.
            ENDIF.






            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = CONV zde_print_queue( ls_queue-printque )
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_name
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
            " out->write( 'Exception occurred.' ).
        ENDTRY.
        "out->write( 'Finished processing.' ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
