 CLASS lsc_zi_quality_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.

   PROTECTED SECTION.

     METHODS save_modified REDEFINITION.

 ENDCLASS.

 CLASS lsc_zi_quality_hdr IMPLEMENTATION.

   METHOD save_modified.

     TYPES: BEGIN OF ty_schema_body,
              xsd_schema  TYPE xstring,
              schema_name TYPE c LENGTH 30,
              note        TYPE c LENGTH 280,
            END OF ty_schema_body.

     " TODO: variable is assigned but never used (ABAP cleaner)
     DATA lv_xdp      TYPE ty_schema_body.
     DATA lv_json     TYPE string.
     " DATA lv_doc_name TYPE char120.

     IF update-head IS NOT INITIAL.

       DATA(lt_head) = update-head.
       TRY.
           " Initialize Template Store Client
           DATA(lo_store) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_CS_ADOBE'
                                                           iv_service_instance_name = 'YY1_OS_ADS_REST' ).
           DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_QLTYPRINT'
                                                                 iv_root_node          = 'ZI_QAL_PRINT' ).

           TRY.
               lo_store->get_schema_by_name( iv_form_name = 'QCFORM' ).
               "   out->write( 'Schema found in form' ).
             CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
               "  out->write( 'No schema in form found' ).
               IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403.
                 " Upload service definition
                 lo_store->set_schema( iv_form_name = 'QCFORM'
                                       is_data      = VALUE #( note        = ''
                                                               schema_name = 'schema'
                                                               xsd_schema  = lo_fdp_util->get_xsd( ) ) ).
               ELSE.
*              "   out->write( lo_tmpl_error->get_longtext( ) ).
               ENDIF.
           ENDTRY.

           " TODO: variable is assigned but never used (ABAP cleaner)
           lv_xdp = VALUE #( note        = ''
                             schema_name = 'schema'
                             xsd_schema  = lo_fdp_util->get_xsd( ) ).
           " Get initial select keys for service
           DATA(lt_keys) = lo_fdp_util->get_keys( ).
           lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.

           TRY.
               DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
               " out->write( 'Service data retrieved' ).
             CATCH cx_fp_fdp_error INTO DATA(lo_exception). " TODO: variable is assigned but never used (ABAP cleaner)
           ENDTRY.

           DATA(ls_template) = lo_store->get_template_by_name( iv_get_binary    = abap_true
                                                               iv_form_name     = 'QCFORM'
                                                               iv_template_name = 'QCFORM' ).
           " out->write( 'Form Template retrieved' ).

           cl_fp_ads_util=>render_pdf( EXPORTING iv_locale       = 'en_US'
                                       "  iv_pq_name      = CONV zde_pqname( ls_queue-printque )"'YYRESV' "'PRINT_QUEUE'
                                                 iv_xml_data     = lv_xml
                                                 iv_xdp_layout   = ls_template-xdp_template
                                                 is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                       IMPORTING
                                       " TODO: variable is assigned but never used (ABAP cleaner)
                                                 ev_trace_string = DATA(lv_trace)
                                                 ev_pdf          = DATA(lv_pdf) ).
           " out->write( 'Output was generated' ).

           DATA lv_doc_name TYPE char120.
           lv_doc_name = |QUALITY|.
           DATA(lv_quality) = VALUE #( lt_head[ 1 ]-id OPTIONAL ).

*         SELECT SINGLE * FROM zdt_quality
*           WHERE id = @<lfs_head>-Id
*           INTO @DATA(ls_res).
*         IF sy-subrc IS INITIAL.
*           ls_res-attachment = lv_pdf.
*           ls_res-mimetype   = 'application/pdf'.
*           ls_res-filename   = lv_doc_name.
*           MODIFY zdt_quality FROM @ls_res.
*         ENDIF.

           SELECT SINGLE * FROM zdt_quality
                 WHERE id = @lv_quality INTO @DATA(ls_res).
           IF sy-subrc IS INITIAL.
             ls_res-attachment = lv_pdf.
             ls_res-mimetype   = 'application/pdf'.
             ls_res-filename   = lv_doc_name.
             MODIFY zdt_quality FROM @ls_res.
           ELSE.
*
             CLEAR ls_res.
             ls_res-id = lv_quality.
             ls_res-attachment = lv_pdf.
             ls_res-mimetype   = 'application/pdf'.
             ls_res-filename   = lv_doc_name.

*        ENDIF.
             MODIFY zdt_quality FROM @ls_res.
           ENDIF.

*            cl_print_queue_utils=>create_queue_item_by_data(
*              iv_qname            = 'YYADOBE2'
*              iv_print_data       = lv_pdf
*              iv_name_of_main_doc = lv_doc_name
*              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
*            ).

         CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
           " out->write( 'Exception occurred.' ).
       ENDTRY.
     ENDIF.
   ENDMETHOD.

 ENDCLASS.

 CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS get_instance_features FOR INSTANCE FEATURES
       IMPORTING keys REQUEST requested_features FOR head RESULT result.

     METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
       IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

     METHODS action FOR DETERMINE ON SAVE
       IMPORTING keys FOR head~action  .

     METHODS headerdetails FOR DETERMINE ON MODIFY
       IMPORTING keys FOR head~headerdetails.

     METHODS inspecplan FOR DETERMINE ON MODIFY
       IMPORTING keys FOR head~inspecplan.

     METHODS resultchar FOR VALIDATE ON SAVE
       IMPORTING keys FOR head~resultchar.

     METHODS print FOR MODIFY
       IMPORTING keys FOR ACTION head~print RESULT result.

     METHODS id FOR VALIDATE ON SAVE
       IMPORTING keys FOR head~id.

     METHODS delete FOR MODIFY
       IMPORTING keys FOR ACTION head~delete RESULT result.

 ENDCLASS.

 CLASS lhc_head IMPLEMENTATION.

   METHOD get_instance_features.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

     READ TABLE header INTO DATA(ls_head) INDEX 1.
     SELECT SINGLE * FROM zdt_quality WHERE id = @ls_head-id INTO @DATA(ls_hdr).

     result = VALUE #( FOR gs_header1 IN header
                       (
                       %tky              = gs_header1-%tky


                       %update           = COND #(

                                                   WHEN ls_hdr-billingdoc IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-disabled

                                                   ELSE if_abap_behv=>fc-o-enabled
                       )
                       %field-remarks    = if_abap_behv=>fc-o-enabled

                       %action-print     = COND #( WHEN ls_hdr-tdelete IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-disabled

                                                   ELSE if_abap_behv=>fc-o-enabled
                     )
                       %action-delete   = COND #(  WHEN ls_hdr-tdelete IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-disabled

                                                   ELSE if_abap_behv=>fc-o-enabled
                     )
                       %field-textbox    = COND #(

                                                   WHEN ls_hdr-qc_cert_no IS NOT INITIAL
                                                   THEN if_abap_behv=>fc-o-disabled

                                                   ELSE if_abap_behv=>fc-o-enabled
                     )
                     ) ).

*        SELECT SINGLE * FROM zdt_quality_dr WHERE id = @ls_head-id INTO @DATA(ls_hdr1).

   ENDMETHOD.

   METHOD get_instance_authorizations.
   ENDMETHOD.

   METHOD action.

     DATA: lv_item TYPE zi_quality_itm-item.
     DATA: lv_inspecplan TYPE zi_quality_hdr-inspecplan.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_header)
     FAILED DATA(lt_header_failed).

     DATA(ls_header) = lt_header[ 1 ].

     ls_header-billingdoc = |{ ls_header-billingdoc ALPHA = IN } |.

     "lv_inspecplan = |0| && ls_header-inspecplan.

     SELECT *
         FROM zi_inspectionplan02
         WHERE inspectionplan = @ls_header-inspecplan
         AND inspectionplangroup = @ls_header-inspecplangroup
         AND material = @ls_header-material
         INTO TABLE @DATA(lt_inspeccharc02).
     IF sy-subrc = 0.
       SORT lt_inspeccharc02 BY material plant inspectionplangroup inspectionplan.
     ENDIF.

     DATA(ls_inspeccharc02) = VALUE #( lt_inspeccharc02[ 1 ] OPTIONAL ).
     SELECT *
         FROM zi_inspectionplan01
         WHERE inspectionplan = @ls_inspeccharc02-inspectionplan
         AND inspectionplangroup = @ls_inspeccharc02-inspectionplangroup
         AND material = @ls_inspeccharc02-material
         INTO TABLE @DATA(lt_inspeccharc).

     SELECT DISTINCT a~billingdocument , b~batch , b~actualdeliveryquantity , b~deliveryquantityunit
     FROM i_billingdocumentitem AS a LEFT OUTER JOIN i_deliverydocumentitem AS b
     ON b~deliverydocument = a~referencesddocument
     WHERE billingdocument = @ls_header-billingdoc
     INTO TABLE @DATA(lt_billingitem).



     SORT lt_inspeccharc ASCENDING BY boocharacteristic.
     LOOP AT lt_billingitem ASSIGNING FIELD-SYMBOL(<lfs_billing>).
       LOOP AT lt_inspeccharc ASSIGNING FIELD-SYMBOL(<lfs_inspeccharc>).

         IF ls_header-material = '150000011'.
           <lfs_billing>-batch = ''.
           <lfs_billing>-actualdeliveryquantity = ''.
           <lfs_billing>-deliveryquantityunit = ''.
         ELSE.
         ENDIF.

         TRY.
             lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
           CATCH cx_uuid_error.
         ENDTRY.

         MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
         ENTITY head
         CREATE BY \_item
         FROM VALUE #( ( id      = ls_header-id
                         %target = VALUE #( ( %cid                      = lv_item
                                              item                      = lv_item
                                              batch = <lfs_billing>-batch
                                              quantity = <lfs_billing>-actualdeliveryquantity
                                              charname                  = <lfs_inspeccharc>-inspectionspecification
                                              chardesc                  = <lfs_inspeccharc>-inspectionspecificationtext
                                              maxlimit                  = <lfs_inspeccharc>-inspspecupperlimit
                                              minlimit                  = <lfs_inspeccharc>-inspspeclowerlimit
                                              uom                       = <lfs_inspeccharc>-inspectionspecificationunit
                                              uomname                   = <lfs_inspeccharc>-unitofmeasurename
                                              test_method_text          = <lfs_inspeccharc>-inspspecinformationfield1
                                              test_range                = <lfs_inspeccharc>-inspspecinformationfield3
                                              results                   = <lfs_inspeccharc>-inspspecinformationfield2

                                              %control-item             = if_abap_behv=>mk-on
                                              %control-charname         = if_abap_behv=>mk-on
                                              %control-chardesc         = if_abap_behv=>mk-on
                                               %control-batch         = if_abap_behv=>mk-on
                                                %control-quantity        = if_abap_behv=>mk-on
                                              %control-maxlimit         = if_abap_behv=>mk-on
                                              %control-minlimit         = if_abap_behv=>mk-on
                                              %control-uom              = if_abap_behv=>mk-on
                                              %control-uomname          = if_abap_behv=>mk-on
                                              %control-test_method_text = if_abap_behv=>mk-on
                                              %control-test_range       = if_abap_behv=>mk-on
                                              %control-results          = if_abap_behv=>mk-on

                                          ) ) ) )
         MAPPED DATA(ls_mapped)
         FAILED DATA(ls_failed)
         REPORTED DATA(ls_reported).

       ENDLOOP.
     ENDLOOP.
     DATA lv_qc1 TYPE numc4.
     DATA lv_qc2 TYPE char1.
     IF sy-datum+4(2) = '01'.
       lv_qc2 = 'A'.
     ELSEIF sy-datum+4(2) = '02'.
       lv_qc2 = 'B'.
     ELSEIF sy-datum+4(2) = '03'.
       lv_qc2 = 'C'.
     ELSEIF sy-datum+4(2) = '04'.
       lv_qc2 = 'D'.
     ELSEIF sy-datum+4(2) = '05'.
       lv_qc2 = 'E'.
     ELSEIF sy-datum+4(2) = '06'.
       lv_qc2 = 'F'.
     ELSEIF sy-datum+4(2) = '07'.
       lv_qc2 = 'G'.
     ELSEIF sy-datum+4(2) = '08'.
       lv_qc2 = 'H'.
     ELSEIF sy-datum+4(2) = '09'.
       lv_qc2 = 'I'.
     ELSEIF sy-datum+4(2) = '10'.
       lv_qc2 = 'J'.
     ELSEIF sy-datum+4(2) = '11'.
       lv_qc2 = 'K'.
     ELSEIF sy-datum+4(2) = '12'.
       lv_qc2 = 'L'.


     ENDIF.
     DATA lv_qcno1 TYPE zi_quality_hdr-qc_cert_no.
     TYPES: BEGIN OF ty_qcno,
              qc_cert_no TYPE zi_quality_hdr-qc_cert_no,
              num        TYPE numc4,
            END OF ty_qcno.
     DATA: lt_qcno TYPE STANDARD TABLE OF  ty_qcno.
     SELECT  qc_cert_no
     FROM zi_quality_hdr
     WHERE qc_cert_no IS NOT INITIAL
     INTO TABLE @DATA(lv_qc).
     IF lv_qc IS NOT INITIAL.
       lt_qcno = VALUE #( FOR lsqcno IN lv_qc ( qc_cert_no = lsqcno
                                                num        = lsqcno+15(4) ) ).
       SORT lt_qcno BY num DESCENDING.

       lv_qc1 = lt_qcno[ 1 ]-num.
       lv_qc1 = lv_qc1 + 1.
       lv_qc1 = |{  lv_qc1 ALPHA = IN }|.
       lv_qcno1 = 'SSPL/QA/' && sy-datum+2(2) && '/' && lv_qc2 && '/' && lv_qc1.
     ELSE.
       lv_qcno1 = 'SSPL/QA/' && sy-datum+2(2) && '/' && lv_qc2 && '/' && '0001'.
     ENDIF.

     MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
           ENTITY head
           UPDATE
               FIELDS ( qc_cert_no )
               WITH VALUE #(
                              ( %tky                = ls_header-%tky
                                qc_cert_no          = lv_qcno1
                                %control-qc_cert_no = if_abap_behv=>mk-on
                              ) ).
   ENDMETHOD.

   METHOD headerdetails.


     DATA : lv_batch_10 TYPE char10 .
     DATA : gv_space TYPE char1 VALUE ' '.
     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_header)
     FAILED DATA(lt_header_failed).


     LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

       <lfs_header>-billingdoc = |{ <lfs_header>-billingdoc ALPHA = IN } |.

       SELECT SINGLE plant FROM i_billingdocumentitem
       WHERE billingdocument =  @<lfs_header>-billingdoc
       INTO @DATA(lv_plant).
       <lfs_header>-plant = lv_plant.
       SELECT SINGLE *
       FROM zcds_quality_hdr( p_matnr = @<lfs_header>-material , p_billingdoc = @<lfs_header>-billingdoc )
       INTO @DATA(ls_billingdoc).
       IF sy-subrc  = 0.
         <lfs_header>-vehicleno = ls_billingdoc-vehicleno.
         <lfs_header>-deliveryitem = ls_billingdoc-deliverydocumentitem.
         <lfs_header>-invdate = ls_billingdoc-billingdocumentdate.
         <lfs_header>-billingitem = ls_billingdoc-billingdocumentitem.
         <lfs_header>-vehicleno = ls_billingdoc-vehicleno.

         IF <lfs_header>-material IS INITIAL.
           <lfs_header>-material = ls_billingdoc-material.
           <lfs_header>-prod_name = ls_billingdoc-productdescription.
           <lfs_header>-prod_group = ls_billingdoc-productgroup.
         ELSE.

           SELECT SINGLE productdescription FROM i_productdescription
           WHERE product = @<lfs_header>-material
           INTO @<lfs_header>-prod_name.
           SELECT SINGLE productgroup FROM i_product
          WHERE product = @<lfs_header>-material
          INTO @<lfs_header>-prod_group.

         ENDIF.


         <lfs_header>-batch = ls_billingdoc-batch.
         <lfs_header>-customer = ls_billingdoc-customername.
         IF  <lfs_header>-prod_group = 'ZFFRPTMT' OR <lfs_header>-prod_group = 'ZFFRBPMT'.
           <lfs_header>-filmtype = 'MET FILM'.
         ELSE.
           <lfs_header>-filmtype = 'BOPET FILM'.
         ENDIF.
         <lfs_header>-pono = ls_billingdoc-pono.
*         <lfs_header>-grade = ls_billingdoc-grade.

         <lfs_header>-salesord = ls_billingdoc-salesdocument.
         <lfs_header>-salesitem = ls_billingdoc-salesdocumentitem.
       ENDIF.

       SELECT SINGLE * FROM zcds_value_new
       WHERE invno = @<lfs_header>-billingdoc AND material = @<lfs_header>-material
       INTO @DATA(ls_value_new).
       IF sy-subrc EQ 0.
         <lfs_header>-invdate = ls_value_new-invdate.
         <lfs_header>-pono = ls_value_new-po.
         <lfs_header>-material = ls_value_new-material.
         <lfs_header>-prod_name = ls_value_new-materialname.
         <lfs_header>-quantity = ls_value_new-quantity.
         SHIFT <lfs_header>-quantity LEFT DELETING LEADING space.
         SELECT SINGLE * FROM i_customer  WHERE customer = @ls_value_new-customername
         INTO @DATA(ls_customername).
         IF sy-subrc EQ 0.
           <lfs_header>-customer = ls_customername-customerfullname.
         ENDIF.
       ENDIF.

       MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
           ENTITY head
           UPDATE
               FIELDS ( deliveryitem deliveryno invdate prod_group prod_name
                        thickness width quantity batch grade plant vehicleno
                        customer treatment coatside filmtype pono salesord salesitem remarks )
               WITH VALUE #(
                              ( %tky                  = <lfs_header>-%tky
                                deliveryitem          = <lfs_header>-deliveryitem
                                deliveryno            = <lfs_header>-deliveryno
                                invdate               = <lfs_header>-invdate
                                vehicleno               = <lfs_header>-vehicleno
                                prod_group            = <lfs_header>-prod_group
                                prod_name             = <lfs_header>-prod_name
                                thickness             = <lfs_header>-thickness
                                width                 = <lfs_header>-width
                                quantity              = <lfs_header>-quantity
                                batch                 = <lfs_header>-batch
                                grade                 = <lfs_header>-grade
                                customer              = <lfs_header>-customer
                                treatment             = <lfs_header>-treatment
                                coatside              = <lfs_header>-coatside
                                filmtype              = <lfs_header>-filmtype
                                pono                  = <lfs_header>-pono
                                plant                 = <lfs_header>-plant
                                salesord              = <lfs_header>-salesord
                                salesitem             = <lfs_header>-salesitem
                                remarks               = <lfs_header>-remarks

                                %control-deliveryitem = if_abap_behv=>mk-on
                                %control-deliveryno   = if_abap_behv=>mk-on
                                %control-invdate      = if_abap_behv=>mk-on
                                %control-vehicleno    = if_abap_behv=>mk-on
                                %control-prod_group   = if_abap_behv=>mk-on
                                %control-prod_name    = if_abap_behv=>mk-on
                                %control-thickness    = if_abap_behv=>mk-on
                                %control-width        = if_abap_behv=>mk-on
                                %control-quantity     = if_abap_behv=>mk-on
                                %control-batch        = if_abap_behv=>mk-on
                                %control-grade        = if_abap_behv=>mk-on
                                %control-customer     = if_abap_behv=>mk-on
                                %control-treatment    = if_abap_behv=>mk-on
                                %control-coatside     = if_abap_behv=>mk-on
                                %control-filmtype     = if_abap_behv=>mk-on
                                %control-pono         = if_abap_behv=>mk-on
                                %control-plant        = if_abap_behv=>mk-on
                                %control-salesord     = if_abap_behv=>mk-on
                                %control-salesitem    = if_abap_behv=>mk-on
                                %control-remarks      = if_abap_behv=>mk-on

                              ) ).
     ENDLOOP.


   ENDMETHOD.

   METHOD inspecplan.

     DATA: lv_inspecplan TYPE zi_quality_hdr-inspecplan.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_header)
     FAILED DATA(lt_header_failed).

     LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

       lv_inspecplan = |0| && <lfs_header>-inspecplan.
       SELECT SINGLE *
        FROM zi_inspectionplan02
       WHERE material = @<lfs_header>-material
       AND   plant = @<lfs_header>-plant
       AND tgroup = @<lfs_header>-tgroup
       INTO @DATA(ls_inspecplan).

       <lfs_header>-inspecplangroup = ls_inspecplan-inspectionplangroup.
       <lfs_header>-inspecplan = ls_inspecplan-inspectionplan.

       MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
           ENTITY head
           UPDATE
               FIELDS ( inspecplan inspecplangroup )
               WITH VALUE #(
                              ( %tky            = <lfs_header>-%tky
                                inspecplan      = <lfs_header>-inspecplan
                                inspecplangroup = <lfs_header>-inspecplangroup
                              ) ).

     ENDLOOP.

   ENDMETHOD.

   METHOD resultchar.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_header)
     FAILED DATA(lt_header_failed).

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY item
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_item)
     FAILED DATA(lt_item_failed).

     LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

       LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).

         IF <lfs_item>-maxlimit = 0.
           IF <lfs_item>-results < <lfs_item>-minlimit.

             APPEND VALUE #(
             %tky                = <lfs_header>-%tky
             %state_area         = 'Validate_Head'
             %msg                = new_message_with_text(
             severity = if_abap_behv_message=>severity-error
             text     = 'Min Limit is greater than Results'
             )
             %element-inspecplan = if_abap_behv=>mk-on
             ) TO reported-head.

             APPEND VALUE #(
             %tky = <lfs_header>-%tky
             ) TO failed-head.

           ENDIF.
         ENDIF.

         IF <lfs_item>-minlimit = 0.
           IF <lfs_item>-results > <lfs_item>-maxlimit.

             APPEND VALUE #(
             %tky                = <lfs_header>-%tky
             %state_area         = 'Validate_Head'
             %msg                = new_message_with_text(
             severity = if_abap_behv_message=>severity-error
             text     = 'Max Limit is less than Results'
             )
             %element-inspecplan = if_abap_behv=>mk-on
             ) TO reported-head.

             APPEND VALUE #(
             %tky = <lfs_header>-%tky
             ) TO failed-head.

           ENDIF.
         ENDIF.

         IF <lfs_item>-minlimit <> 0 AND <lfs_item>-maxlimit <> 0.
           IF <lfs_item>-results > <lfs_item>-maxlimit AND <lfs_item>-results < <lfs_item>-minlimit.

             APPEND VALUE #(
             %tky                = <lfs_header>-%tky
             %state_area         = 'Validate_Head'
             %msg                = new_message_with_text(
             severity = if_abap_behv_message=>severity-error
             text     = 'Result not within valid range'
             )
             %element-inspecplan = if_abap_behv=>mk-on
             ) TO reported-head.

             APPEND VALUE #(
             %tky = <lfs_header>-%tky
             ) TO failed-head.


           ENDIF.
         ENDIF.
       ENDLOOP.
     ENDLOOP.

   ENDMETHOD.

   METHOD print.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
       RESULT DATA(header)
       FAILED DATA(header_failed).

     LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
       <lfs_head>-tprint = 'X'.
       MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( tprint )
         WITH VALUE #(
                        ( %tky   = <lfs_head>-%tky
                          tprint = <lfs_head>-tprint
                        ) ).
     ENDLOOP.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(header1).

     result = VALUE #( FOR ls_header IN header1
                       ( %tky   = ls_header-%tky
                         %param = ls_header ) ).





   ENDMETHOD.

   METHOD id.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_header)
     FAILED DATA(lt_header_failed).

     LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).
       SELECT SINGLE *
       FROM zi_quality_hdr
       WHERE billingdoc = @<lfs_header>-billingdoc
       AND material = @<lfs_header>-material
       AND qc_cert_no IS NOT INITIAL AND tdelete <> 'X'
       INTO  @DATA(ls_qc1).
       IF ls_qc1 IS NOT INITIAL.
         DATA(lv_msg) = 'QC number:' &&  ls_qc1-qc_cert_no && ' already exists for this combination.'.
         APPEND VALUE #(
             %tky        = <lfs_header>-%tky
             %state_area = 'Validate_Head'
             %msg        = new_message_with_text(
             severity = if_abap_behv_message=>severity-error
             text     = lv_msg
             )
         ) TO reported-head.

         APPEND VALUE #(
         %tky = <lfs_header>-%tky
         ) TO failed-head.
         RETURN.
       ENDIF.
     ENDLOOP.

   ENDMETHOD.

*   METHOD fetchdata.
*     "Changes Added by DV : 29.08.2024
*     DATA : lv_batch_10 TYPE char10 .
*     DATA : gv_space TYPE char1 VALUE ' '.
*
*     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
*     ENTITY head
*     ALL FIELDS
*     WITH CORRESPONDING #( keys )
*     RESULT DATA(lt_header)
*     FAILED DATA(lt_header_failed).
*
*
*     LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).
*
*       SELECT MAX( batch )  FROM i_billingdocumentitem
*          WHERE product =  @<lfs_header>-material
*          AND billingdocument = @<lfs_header>-billingdoc
*       "   and BillingDocumentItem = @ls_billingdoc-BillingDocumentItem
*          INTO @lv_batch_10.
*       IF sy-subrc = 0 .
*         IF lv_batch_10 IS NOT INITIAL.
**         shift lv_batch_10 RIGHT DELETING TRAILING gv_space.
*
*           IF <lfs_header>-treatment IS INITIAL.
*             SELECT SINGLE c~charcvaluedescription
*           FROM zi_stock_batch_value AS b
*           LEFT OUTER JOIN i_clfncharcvalue AS d ON d~charcinternalid = '0000000829' AND d~charcvalue = b~cval
*           LEFT OUTER JOIN i_clfncharcvaluedesc AS c ON c~charcinternalid =  '0000000829'
*           AND c~charcvaluepositionnumber = d~charcvaluepositionnumber
*           WHERE b~valbatch =  @lv_batch_10 AND b~cinid  = '0000000829' " 829
*             INTO @DATA(lv_treatment).
*             IF sy-subrc = 0.
*               <lfs_header>-treatment     = lv_treatment.
*             ENDIF.
*
**             SELECT SINGLE CharValDesc FROM zi_stock_batch_value_v1
**             WHERE ValMat = @<lfs_header>-material
**             AND ValBatch =  @lv_batch_10
**             AND CInId = '0000000829'
**             INTO @DATA(lv_treatment).
**             IF sy-subrc = 0.
**               <lfs_header>-treatment     = lv_treatment.
**             ENDIF.
*           ENDIF.
*
*           IF <lfs_header>-coatside IS INITIAL.
*
*             SELECT SINGLE c~charcvaluedescription
*             FROM  zi_stock_batch_value AS b
*             LEFT OUTER JOIN i_clfncharcvalue AS d ON d~charcinternalid = '0000000828' AND d~charcvalue = b~cval
*             LEFT OUTER JOIN i_clfncharcvaluedesc AS c ON c~charcinternalid =  '0000000828'
*             AND c~charcvaluepositionnumber = d~charcvaluepositionnumber
*             WHERE b~valbatch =  @lv_batch_10 AND b~cinid  = '0000000828' " 828
*              INTO @DATA(lv_coating).
*             IF sy-subrc = 0.
*               <lfs_header>-coatside = lv_coating.
*             ENDIF.
**             SELECT SINGLE CharValDesc FROM zi_stock_batch_value_v1
**             WHERE ValMat = @<lfs_header>-material
**             AND ValBatch =  @lv_batch_10
**             AND CInId = '0000000828'
**             INTO @DATA(lv_coating).
**             IF sy-subrc = 0.
**               <lfs_header>-coatside = lv_coating.
**             ENDIF.
*           ENDIF.
*
*           IF <lfs_header>-chem_metal IS INITIAL.
*             SELECT SINGLE c~charcvaluedescription
*          FROM zi_stock_batch_value AS b
*          LEFT OUTER JOIN i_clfncharcvalue AS d ON d~charcinternalid = '0000000850' AND d~charcvalue = b~cval
*          LEFT OUTER JOIN i_clfncharcvaluedesc AS c ON c~charcinternalid =  '0000000850'
*          AND c~charcvaluepositionnumber = d~charcvaluepositionnumber
*          WHERE b~valbatch =  @lv_batch_10 AND b~cinid  = '0000000850'
*            INTO @DATA(lv_metal).
*             IF sy-subrc = 0.
*               <lfs_header>-chem_metal = lv_metal.
*             ENDIF.
*
**             SELECT SINGLE CharValDesc FROM zi_stock_batch_value_v1
**             WHERE ValMat = @<lfs_header>-material
**             AND ValBatch =  @lv_batch_10
**             AND CInId = '0000000850'
**             INTO @DATA(lv_metal).
**             IF sy-subrc = 0.
**               <lfs_header>-chem_metal = lv_metal.
**             ENDIF.
*           ENDIF.
*         ENDIF.
*       ENDIF.
*
*       MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
*           ENTITY head
*           UPDATE
*               FIELDS ( treatment coatside chem_metal )
*               WITH VALUE #(
*                              ( %tky       = <lfs_header>-%tky
*                                treatment  = <lfs_header>-treatment
*                                coatside   = <lfs_header>-coatside
*                                chem_metal = <lfs_header>-chem_metal
*                              ) ).
*
*     ENDLOOP.
*     "Changes Added by DV : 29.08.2024
*   ENDMETHOD.

   METHOD delete.
     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
  ENTITY head
  ALL FIELDS
  WITH CORRESPONDING #( keys )
    RESULT DATA(header)
    FAILED DATA(header_failed).

     DATA(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).

     LOOP AT header ASSIGNING FIELD-SYMBOL(<lfs_head>).
       <lfs_head>-tdelete = 'X'.
       MODIFY ENTITIES OF zi_quality_hdr IN LOCAL MODE
         ENTITY head
         UPDATE
         FIELDS ( tdelete )
         WITH VALUE #(
                        ( %tky   = <lfs_head>-%tky
                          tdelete = <lfs_head>-tdelete
                        ) ).
     ENDLOOP.

     "DELETE FROM zdt_quality WHERE id = @ls_head-id.

     READ ENTITIES OF zi_quality_hdr IN LOCAL MODE
     ENTITY head
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(header1).

     result = VALUE #( FOR ls_header IN header1
                       ( %tky   = ls_header-%tky
                         %param = ls_header ) ).
   ENDMETHOD.

 ENDCLASS.
