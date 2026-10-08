CLASS lhc_zi_tmt_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_tmt_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_tmt_head RESULT result.

    METHODS conscheck FOR MODIFY
      IMPORTING keys FOR ACTION zi_tmt_head~conscheck RESULT result.

    METHODS headerdetails1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_tmt_head~headerdetails1.

    METHODS headerdetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_tmt_head~headerdetails.
    METHODS post101 FOR MODIFY
      IMPORTING keys FOR ACTION zi_tmt_head~post101 RESULT result.

    METHODS post261 FOR MODIFY
      IMPORTING keys FOR ACTION zi_tmt_head~post261 RESULT result.

    METHODS post531 FOR MODIFY
      IMPORTING keys FOR ACTION zi_tmt_head~post531 RESULT result.

    METHODS postcnf FOR MODIFY
      IMPORTING keys FOR ACTION zi_tmt_head~postcnf RESULT result.
    METHODS getcons FOR MODIFY
      IMPORTING keys FOR ACTION zi_tmt_head~getcons RESULT result.

ENDCLASS.

CLASS lhc_zi_tmt_head IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
          ENTITY zi_tmt_head
          ALL FIELDS  WITH CORRESPONDING #( keys )
          RESULT FINAL(gt_header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(gt_failed).

    result = VALUE #( FOR gs_header IN gt_header
                      ( %tky              = gs_header-%tky

                        %update           = COND #( WHEN gs_header-status = 'Created'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                       %delete           = COND #( WHEN gs_header-status = 'Created'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-disabled )

                       %action-getcons = COND #( WHEN gs_header-status = 'Created' AND gs_header-department <> 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )

                        %assoc-_item =  COND #( WHEN gs_header-status = 'Completed' OR gs_header-department <> 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )

                         %assoc-_item1 =  COND #( WHEN gs_header-status = 'Completed' OR gs_header-department <> 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )


                         %assoc-_item2 =  COND #( WHEN gs_header-status = 'Completed' OR gs_header-department <> 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                   THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )

                         %assoc-_item3 =  COND #( WHEN gs_header-status = 'Completed' OR gs_header-department <> 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )

                         %assoc-_item4 =  COND #( WHEN gs_header-status = 'Completed' OR gs_header-department = 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )

                         %assoc-_item5 =  COND #( WHEN gs_header-status = 'Completed' OR gs_header-department = 'ROLLMILL'
                                                      OR gs_header-status = ''
                                                   THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )


                        %action-conscheck = COND #( WHEN gs_header-status = 'Created' AND gs_header-department = 'ROLLMILL'
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )

                        %action-postcnf   = COND #( WHEN ( gs_header-status = 'Checked' AND gs_header-department = 'ROLLMILL' ) OR
                        ( gs_header-status = 'Item Fetched' AND gs_header-department = 'DESPATCH' )
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )

                        %action-post101   = COND #( WHEN gs_header-status = 'Confirmed'
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )

                        %action-post261   = COND #( WHEN gs_header-status = 'GR Posted'
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )

                        %action-post531   = COND #( WHEN gs_header-status = 'GI Posted' AND gs_header-department <> 'DESPATCH'
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled ) ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD conscheck.

    DATA lv_reference     TYPE zi_tmt_head-referenceid.
    DATA lv_item          TYPE zi_tmt_byprod-item.
    DATA lv_count         TYPE zde_no                    VALUE 1.


    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
            ENTITY zi_tmt_head
            ALL FIELDS  WITH CORRESPONDING #( keys )
            " TODO: variable is assigned but never used (ABAP cleaner)
            RESULT DATA(gt_head) FAILED FINAL(failedh).


    READ ENTITY zi_tmt_head
         BY \_item1
         ALL FIELDS  WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT DATA(gt_byprd) FAILED FINAL(failedby).

    READ ENTITY zi_tmt_head
        BY \_item2
        ALL FIELDS  WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT DATA(gt_consumed) FAILED FINAL(failedcn).



    READ ENTITY zi_tmt_head
             BY \_item
             ALL FIELDS WITH CORRESPONDING #( keys )
             " TODO: variable is assigned but never used (ABAP cleaner)
            RESULT DATA(gt_prod) FAILED FINAL(failedpd).


    TRY.
        GET TIME STAMP FIELD FINAL(lv_utctimestamp).
        " TODO: variable is assigned but never used (ABAP cleaner)
        CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    LOOP AT gt_head ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      " Header checks
      IF <fs_head>-postingdate > lv_date.
        APPEND VALUE #(
            %tky               = <fs_head>-%tky
            %state_area        = 'Validate_Header'
            %msg               = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = 'Posting Date greater than current Date' )
            %element-conscheck = if_abap_behv=>mk-on )
               TO reported-zi_tmt_head.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zi_tmt_head.
      ENDIF.

      DATA : lv_post_qty TYPE zi_tmt_prod-weight.
      DATA : lv_cons_qty TYPE zi_tmt_prod-weight.
      DATA : lv_by_qty TYPE zi_tmt_prod-weight.
      DATA : lv_balance_quantity TYPE zi_tmt_prod-weight.


      DATA :   lv_bymat TYPE zi_tmt_prod-weight.

      " Heat Balancing
      lv_post_qty = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                    FOR gs_101_t IN gt_prod
                                                    NEXT lv_quantity = lv_quantity + gs_101_t-weight ).

      lv_cons_qty = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                    FOR gs_261_t IN gt_consumed
                                                    NEXT lv_quantity = lv_quantity + gs_261_t-quantity ).

      lv_by_qty = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                    FOR gs_531_t IN gt_byprd
                                                    NEXT lv_quantity = lv_quantity + gs_531_t-quantity ).

      lv_balance_quantity = lv_post_qty + lv_by_qty -  lv_cons_qty .


      IF lv_balance_quantity <> 0.
        APPEND VALUE #(
            %tky             = <fs_head>-%tky
            %state_area      = 'Validate_Header'
            %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = |Balance Quantity { lv_balance_quantity } must be 0| )
            %element-conscheck = if_abap_behv=>mk-on )
               TO reported-zi_tmt_head.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zi_tmt_head.
      ENDIF.


      CLEAR : lv_item.

      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      lv_bymat =  REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                    FOR gs_prod IN gt_prod
                                                    NEXT lv_quantity = lv_quantity + gs_prod-weight
                                                     ).

      MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
             ENTITY zi_tmt_head
             CREATE BY \_item3
             FROM VALUE #( ( id      = <fs_head>-id
                             %target = VALUE #( ( %cid                 = lv_item
                                                  item                 = lv_item
                                                  referenceid          = <fs_head>-referenceid
                                                  material             = <fs_head>-material
                                                  materialdes = <fs_head>-materialdesc
                                                  quantity = lv_bymat
                                                  uom = <fs_head>-uom
                                                  %control-item        = if_abap_behv=>mk-on
                                                  %control-referenceid = if_abap_behv=>mk-on
                                                  %control-material        = if_abap_behv=>mk-on
                                                  %control-materialdes        = if_abap_behv=>mk-on
                                                  %control-quantity        = if_abap_behv=>mk-on
                                                  %control-uom        = if_abap_behv=>mk-on
                                                   ) ) ) )
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(ls_mapped_htbpp)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(ls_failed_htbpp)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(ls_reported_htbpp).

      CLEAR : lv_bymat.

      DATA(gt_byprod01) =  gt_byprd[].
      SORT gt_byprod01 ASCENDING BY material.
      DELETE ADJACENT DUPLICATES FROM gt_byprod01 COMPARING material.


      " By-Product Metal Balancing
      LOOP AT gt_byprod01 ASSIGNING FIELD-SYMBOL(<fs_byprd>).
        IF <fs_byprd> IS ASSIGNED.
          CLEAR : lv_item.

          TRY.
              lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.

          lv_bymat =  REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                        FOR gs_byprd IN gt_byprd WHERE ( material = <fs_byprd>-material )
                                                        NEXT lv_quantity = lv_quantity + gs_byprd-quantity
                                                         ).
          lv_bymat = lv_bymat .
          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 CREATE BY \_item3
                 FROM VALUE #( ( id      = <fs_head>-id
                                 %target = VALUE #( ( %cid                 = lv_item
                                                      item                 = lv_item
                                                      referenceid          = <fs_head>-referenceid
                                                      material             = <fs_byprd>-material
                                                      materialdes = <fs_byprd>-materialdes
                                                      quantity = lv_bymat
                                                      uom = <fs_byprd>-uom
                                                      %control-item        = if_abap_behv=>mk-on
                                                      %control-referenceid = if_abap_behv=>mk-on
                                                      %control-material        = if_abap_behv=>mk-on
                                                      %control-materialdes        = if_abap_behv=>mk-on
                                                      %control-quantity        = if_abap_behv=>mk-on
                                                      %control-uom        = if_abap_behv=>mk-on
                                                       ) ) ) )
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 MAPPED FINAL(ls_mapped_htb)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(ls_failed_htb)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 REPORTED FINAL(ls_reported_htb).

          CLEAR : lv_bymat.
        ENDIF.
      ENDLOOP.



      DATA(gt_con01) =  gt_consumed[].
      SORT gt_con01 ASCENDING BY material.
      DELETE ADJACENT DUPLICATES FROM gt_con01 COMPARING material.

      " Consumed Metal Balancing
      LOOP AT gt_con01 ASSIGNING FIELD-SYMBOL(<fs_con>).
        IF <fs_con> IS ASSIGNED.
          CLEAR : lv_item.

          lv_count += 1.
          TRY.
              lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.

          lv_bymat =  REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                        FOR gs_consumed IN gt_consumed WHERE ( material = <fs_con>-material )
                                                        NEXT lv_quantity = lv_quantity + gs_consumed-quantity
                                                         ).
          lv_bymat = lv_bymat * -1.
          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 CREATE BY \_item3
                 FROM VALUE #( ( id      = <fs_head>-id
                                 %target = VALUE #( ( %cid                 =  lv_count && lv_item
                                                      item                 = lv_count && lv_item
                                                      referenceid          = <fs_head>-referenceid
                                                      material             = <fs_con>-material
                                                      materialdes = <fs_con>-materialdes
                                                      quantity = lv_bymat
                                                      uom = <fs_con>-uom
                                                      %control-item        = if_abap_behv=>mk-on
                                                      %control-referenceid = if_abap_behv=>mk-on
                                                      %control-material        = if_abap_behv=>mk-on
                                                      %control-materialdes        = if_abap_behv=>mk-on
                                                      %control-quantity        = if_abap_behv=>mk-on
                                                      %control-uom        = if_abap_behv=>mk-on
                                                       ) ) ) )
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 MAPPED FINAL(ls_mapped_htb01)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(ls_failed_htb01)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 REPORTED FINAL(ls_reported_htb01).

          CLEAR : lv_bymat.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
             ENTITY zi_tmt_head
             UPDATE
             FIELDS ( conscheck status progress )
             WITH VALUE #( ( %tky     = <fs_head>-%tky
                             status   = 'Checked'
                             progress = 40
                             conscheck  = 'X' ) ).
        ENDIF.
      ENDLOOP.



    ENDLOOP.

    " Fill the response table
    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY  zi_tmt_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.


  METHOD headerdetails1.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
            ENTITY zi_tmt_head
            ALL FIELDS  WITH CORRESPONDING #( keys )
            " TODO: variable is assigned but never used (ABAP cleaner)
            RESULT DATA(gt_header) FAILED FINAL(failed).

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.

     select SINGLE * FROM ZVDEPTF4
        where ManufacturingOrder = @<fs_head>-Productionorder
        into @data(ls_dept).

        <fs_head>-status = 'Draft'.
        <fs_head>-plant = '2008'.

        SELECT SINGLE * FROM i_productionorderitemtp
          WHERE productionorder = @<fs_head>-productionorder
          INTO @FINAL(ls_prdord).

        SELECT SINGLE * FROM i_producttext
          WHERE product  = @ls_prdord-product
            AND language = 'E'
          INTO @FINAL(ls_prodtext).

        SELECT SINGLE * FROM i_product
          WHERE product = @ls_prdord-product
          INTO @FINAL(ls_prod).

        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
               ENTITY zi_tmt_head
               UPDATE
               FIELDS ( status material materialdesc avlquantity uom  plant progress department )
               WITH VALUE #( FOR key IN keys
                             ( %tky                   = <fs_head>-%tky
                               status                 = <fs_head>-status
                               material               = ls_prdord-product
                               materialdesc           = ls_prodtext-productname
                               avlquantity          = ls_prdord-openyieldquantity
                               uom                    = ls_prod-baseunit
                               plant                  = <fs_head>-plant
                               progress = 10
                               department = ls_dept-department
                               %control-status        = if_abap_behv=>mk-on
                               %control-department        = if_abap_behv=>mk-on
                               %control-material      = if_abap_behv=>mk-on
                               %control-materialdesc  = if_abap_behv=>mk-on
                               %control-avlquantity = if_abap_behv=>mk-on
                               %control-uom           = if_abap_behv=>mk-on
                               %control-plant         = if_abap_behv=>mk-on
                               %control-progress         = if_abap_behv=>mk-on  ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD headerdetails.
    DATA lv_referencelike TYPE zi_tmt_head-referenceid.
    DATA lv_no            TYPE zde_no                    VALUE 1.
    DATA lv_reference     TYPE zi_tmt_head-referenceid.
    DATA lv_item          TYPE zi_tmt_byprod-item.
    DATA lv_count         TYPE zde_no                    VALUE 1.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
            ENTITY zi_tmt_head
            ALL FIELDS  WITH CORRESPONDING #( keys )
            " TODO: variable is assigned but never used (ABAP cleaner)
            RESULT DATA(gt_header) FAILED FINAL(failed).

    TRY.
        GET TIME STAMP FIELD FINAL(lv_utctimestamp).
        " TODO: variable is assigned but never used (ABAP cleaner)
        CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS ASSIGNED.
        <fs_head>-status = 'Created'.
        <fs_head>-plant = '2008'.

        select SINGLE * FROM ZVDEPTF4
        where ManufacturingOrder = @<fs_head>-Productionorder
        into @data(ls_dept).

        lv_referencelike = |%{ lv_date+2(2) }{ lv_date+4(2) }%|.

        SELECT * FROM zi_tmt_head
     WHERE referenceid LIKE @lv_referencelike
     INTO TABLE @DATA(lt_zi_tmt_head).
        IF sy-subrc = 0.
          SORT lt_zi_tmt_head BY referenceid DESCENDING.
          FINAL(ls_zi_tmt_head) = VALUE #( lt_zi_tmt_head[ 1 ] OPTIONAL ).
          lv_no = ls_zi_tmt_head-referenceid+4(6) + 1.
        ENDIF.
        lv_reference = lv_date+2(2) && lv_date+4(2) && lv_no.


        SELECT SINGLE * FROM i_productionorderitemtp
          WHERE productionorder = @<fs_head>-productionorder
          INTO @FINAL(ls_prdord).

        SELECT SINGLE * FROM i_producttext
          WHERE product  = @ls_prdord-product
            AND language = 'E'
          INTO @FINAL(ls_prodtext).

        SELECT SINGLE * FROM i_product
          WHERE product = @ls_prdord-product
          INTO @FINAL(ls_prod).

        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
               ENTITY zi_tmt_head
               UPDATE
               FIELDS ( referenceid status material materialdesc avlquantity uom  plant progress department )
               WITH VALUE #( FOR key IN keys
                             ( %tky                   = <fs_head>-%tky
                               referenceid = lv_reference
                               status                 = <fs_head>-status
                               material               = ls_prdord-product
                               materialdesc           = ls_prodtext-productname
                               avlquantity          = ls_prdord-openyieldquantity
                               uom                    = ls_prod-baseunit
                               progress = 25
                               plant                  = <fs_head>-plant
                               department = ls_dept-department
                               %control-status        = if_abap_behv=>mk-on
                               %control-department        = if_abap_behv=>mk-on
                                %control-referenceid        = if_abap_behv=>mk-on
                               %control-material      = if_abap_behv=>mk-on
                               %control-materialdesc  = if_abap_behv=>mk-on
                               %control-avlquantity = if_abap_behv=>mk-on
                               %control-uom           = if_abap_behv=>mk-on
                               %control-plant         = if_abap_behv=>mk-on
                               %control-progress         = if_abap_behv=>mk-on  ) ).
      ENDIF.
    ENDLOOP.

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head01>).
      IF <fs_head01> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM i_manufacturingorder
        WHERE manufacturingorder = @<fs_head01>-productionorder
        INTO @FINAL(ls_mnford).

      SELECT * FROM i_billofmaterialitemtp_3
        WHERE billofmaterial = @ls_mnford-billofmaterial
          AND billofmaterial = @ls_mnford-billofmaterial
        INTO TABLE @DATA(lt_bom).

      DATA(lt_531) = lt_bom.

      DELETE lt_531 WHERE billofmaterialitemquantity > 0.


      FINAL(ls_531) = VALUE #( lt_531[ 1 ] OPTIONAL ).

      IF   <fs_head01>-department = 'ROLLMILL'.
        DATA(lt_261) = lt_bom.
        DELETE lt_261 WHERE billofmaterialitemquantity < 0.
        DELETE lt_261 WHERE billofmaterialvariant <> '01'.
        TRY.
            lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
        ENDTRY.
        SELECT SINGLE * FROM i_product WHERE product = @ls_531-billofmaterialcomponent INTO @FINAL(ls_prod_531).
        SELECT SINGLE * FROM i_productstoragelocationbasic WHERE product = @ls_531-billofmaterialcomponent AND plant = @<fs_head01>-plant
        INTO @FINAL(ls_sloc).
        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
               ENTITY zi_tmt_head
               CREATE BY \_item1
               FROM VALUE #( ( id      = <fs_head01>-id
                               %target = VALUE #( ( %cid                         = lv_item
                                                    item                         = lv_item
                                                    referenceid                  = <fs_head01>-referenceid
                                                    material                     = ls_531-billofmaterialcomponent
                                                    materialdes          = ls_531-componentdescription
                                                    uom                          = ls_prod_531-baseunit
                                                    storageloc                        = ls_sloc-storagelocation

                                                    %control-item                = if_abap_behv=>mk-on
                                                    %control-referenceid         = if_abap_behv=>mk-on
                                                    %control-material            = if_abap_behv=>mk-on
                                                    %control-storageloc               = if_abap_behv=>mk-on
                                                    %control-materialdes = if_abap_behv=>mk-on
                                                    %control-uom                 = if_abap_behv=>mk-on ) ) ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(ls_mapped_531)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(ls_failed_531)
               " TODO: variable is assigned but never used (ABAP cleaner)
               REPORTED FINAL(ls_reported_531).


        LOOP AT lt_261 ASSIGNING FIELD-SYMBOL(<fs_261>).
          IF <fs_261> IS ASSIGNED.
            DO <fs_head01>-noofbatch TIMES.
              TRY.
                  lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
                CATCH cx_uuid_error.
              ENDTRY.
              lv_count += 1.
              SELECT SINGLE * FROM i_product WHERE product = @<fs_261>-billofmaterialcomponent INTO @FINAL(ls_prod_261).
              SELECT SINGLE * FROM i_productstoragelocationbasic WHERE product = @<fs_261>-billofmaterialcomponent AND plant = @<fs_head01>-plant
              INTO @FINAL(ls_sloc1).
              MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                     ENTITY zi_tmt_head
                     CREATE BY \_item2
                     FROM VALUE #( ( id      = <fs_head01>-id
                                     %target = VALUE #( ( %cid                         =   lv_count && lv_item
                                                          item                         = lv_count && lv_item
                                                          referenceid                  = <fs_head01>-referenceid
                                                          material                     = <fs_261>-billofmaterialcomponent
                                                          materialdes          = <fs_261>-componentdescription
                                                          uom                          = ls_prod_261-baseunit
                                                          storageloc                        = ls_sloc1-storagelocation

                                                          %control-item                = if_abap_behv=>mk-on
                                                          %control-referenceid         = if_abap_behv=>mk-on
                                                          %control-material            = if_abap_behv=>mk-on
                                                          %control-storageloc               = if_abap_behv=>mk-on
                                                          %control-materialdes = if_abap_behv=>mk-on
                                                          %control-uom                 = if_abap_behv=>mk-on ) ) ) )
                     " TODO: variable is assigned but never used (ABAP cleaner)
                     MAPPED FINAL(ls_mapped_261)
                     " TODO: variable is assigned but never used (ABAP cleaner)
                     FAILED FINAL(ls_failed_261)
                     " TODO: variable is assigned but never used (ABAP cleaner)
                     REPORTED FINAL(ls_reported_261).
            ENDDO.
          ENDIF.
        ENDLOOP.
      ELSE.
        CLEAR : lv_count.
        DO <fs_head01>-noofbatch TIMES.
          TRY.
              lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
          ENDTRY.
          lv_count += 1.
          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 CREATE BY \_item4
                 FROM VALUE #( ( id      = <fs_head01>-id
                                 %target = VALUE #( ( %cid                         =   lv_count && lv_item
                                                      item                         = lv_count && lv_item
                                                      referenceid                  = <fs_head01>-referenceid
                                                      uom                          = <fs_head01>-uom
                                                      %control-uom                 = if_abap_behv=>mk-on ) ) ) )
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 MAPPED FINAL(ls_bund)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(ls_bundf)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 REPORTED FINAL(ls_bundr).
        ENDDO.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD post101.

    DATA lv_item TYPE zr_billet_101-item.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS  WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    IF ls_head-department = 'ROLLMILL'.

      READ ENTITY zi_tmt_head
           BY \_item
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_101) FAILED FINAL(ft_101).

      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
        IF <fs_head> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

        " ==101 Movement
        MODIFY ENTITIES OF i_materialdocumenttp PRIVILEGED
               ENTITY materialdocument
               CREATE FROM VALUE #( ( %cid                                = lv_item
                                      goodsmovementcode                   = '02'
                                      postingdate                         = <fs_head>-postingdate
                                      documentdate                        = cl_abap_context_info=>get_system_date( )
                                      materialdocumentheadertext          = <fs_head>-referenceid
                                      %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                      %control-postingdate                = cl_abap_behv=>flag_changed
                                      %control-documentdate               = cl_abap_behv=>flag_changed
                                      %control-materialdocumentheadertext = cl_abap_behv=>flag_changed ) )
               ENTITY materialdocument
               CREATE BY \_materialdocumentitem
               FROM VALUE #( ( %cid_ref = lv_item
                               %target  = VALUE #( FOR gs_101 IN gt_101
                                                   ( %cid                              = gs_101-item
                                                     plant                             = <fs_head>-plant
                                                     material                          = <fs_head>-material
                                                     goodsmovementtype                 = '101'
                                                     storagelocation                   = gs_101-storagelocation
                                                     quantityinentryunit               = gs_101-weight
                                                     entryunit                         = gs_101-uom
                                                     manufacturingorder                = <fs_head>-productionorder
                                                     manufacturedate                   = <fs_head>-postingdate
                                                     batch                             = gs_101-batchno
                                                     goodsmovementrefdoctype           = 'F'
                                                     materialdocumentitemtext          = |{ gs_101-batchno }|

                                                     %control-plant                    = cl_abap_behv=>flag_changed
                                                     %control-material                 = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementtype        = cl_abap_behv=>flag_changed
                                                     %control-storagelocation          = cl_abap_behv=>flag_changed
                                                     %control-quantityinentryunit      = cl_abap_behv=>flag_changed
                                                     %control-entryunit                = cl_abap_behv=>flag_changed
                                                     %control-manufacturingorder       = cl_abap_behv=>flag_changed
                                                     %control-batch                    = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementrefdoctype  = cl_abap_behv=>flag_changed
                                                     %control-materialdocumentitemtext = cl_abap_behv=>flag_changed
                                                     %control-manufacturedate          = cl_abap_behv=>flag_changed ) ) ) )

               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_101)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_101)
               REPORTED FINAL(reported_101).

        IF reported_101-materialdocument IS NOT INITIAL.
          APPEND VALUE #( %tky             = <fs_head>-%tky
                          %state_area      = 'Validate_Head'
                          %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Error in Billet Production' )
                          %element-post101 = if_abap_behv=>mk-on )
                 TO reported-zi_tmt_head.

          APPEND VALUE #( %tky = <fs_head>-%tky )
                 TO failed-zi_tmt_head.

        ELSE.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 UPDATE
                 FIELDS ( post101 status progress )
                 WITH VALUE #( ( %tky     = <fs_head>-%tky
                                 status   = 'GR Posted'
                                 progress = 70
                                 post101  = 'X' ) ).

        ENDIF.
      ENDLOOP.

    ELSE.


      READ ENTITY zi_tmt_head
           BY \_item4
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_1011) FAILED FINAL(ft_1011).

      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head1>).
        IF <fs_head1> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

        " ==101 Movement
        MODIFY ENTITIES OF i_materialdocumenttp PRIVILEGED
               ENTITY materialdocument
               CREATE FROM VALUE #( ( %cid                                = lv_item
                                      goodsmovementcode                   = '02'
                                      postingdate                         = <fs_head1>-postingdate
                                      documentdate                        = cl_abap_context_info=>get_system_date( )
                                      materialdocumentheadertext          = <fs_head1>-referenceid
                                      %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                      %control-postingdate                = cl_abap_behv=>flag_changed
                                      %control-documentdate               = cl_abap_behv=>flag_changed
                                      %control-materialdocumentheadertext = cl_abap_behv=>flag_changed ) )
               ENTITY materialdocument
               CREATE BY \_materialdocumentitem
               FROM VALUE #( ( %cid_ref = lv_item
                               %target  = VALUE #( FOR gs_1011 IN gt_1011
                                                   ( %cid                              = gs_1011-item
                                                     plant                             = <fs_head1>-plant
                                                     material                          = <fs_head1>-material
                                                     goodsmovementtype                 = '101'
                                                     storagelocation                   = gs_1011-storagelocation
                                                     quantityinentryunit               = gs_1011-weight
                                                     entryunit                         = gs_1011-uom
                                                     manufacturingorder                = <fs_head1>-productionorder
                                                     manufacturedate                   = <fs_head1>-postingdate
                                                     batch                             = gs_1011-bbatchno
                                                     goodsmovementrefdoctype           = 'F'
                                                     materialdocumentitemtext          = |{ gs_1011-bbatchno }|

                                                     %control-plant                    = cl_abap_behv=>flag_changed
                                                     %control-material                 = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementtype        = cl_abap_behv=>flag_changed
                                                     %control-storagelocation          = cl_abap_behv=>flag_changed
                                                     %control-quantityinentryunit      = cl_abap_behv=>flag_changed
                                                     %control-entryunit                = cl_abap_behv=>flag_changed
                                                     %control-manufacturingorder       = cl_abap_behv=>flag_changed
                                                     %control-batch                    = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementrefdoctype  = cl_abap_behv=>flag_changed
                                                     %control-materialdocumentitemtext = cl_abap_behv=>flag_changed
                                                     %control-manufacturedate          = cl_abap_behv=>flag_changed ) ) ) )

               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_1011)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_1011)
               REPORTED FINAL(reported_1011).

        IF reported_1011-materialdocument IS NOT INITIAL.
          APPEND VALUE #( %tky             = <fs_head1>-%tky
                          %state_area      = 'Validate_Head'
                          %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Error in Bundle Production' )
                          %element-post101 = if_abap_behv=>mk-on )
                 TO reported-zi_tmt_head.

          APPEND VALUE #( %tky = <fs_head>-%tky )
                 TO failed-zi_tmt_head.

        ELSE.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 UPDATE
                 FIELDS ( post101 status progress )
                 WITH VALUE #( ( %tky     = <fs_head1>-%tky
                                 status   = 'GR Posted'
                                 progress = 70
                                 post101  = 'X' ) ).

        ENDIF.
      ENDLOOP.


    ENDIF.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).

  ENDMETHOD.

  METHOD post261.

    DATA lv_item     TYPE zr_billet_261-item.
    DATA lv_status   TYPE zr_billet_hdr-status.
    DATA lv_progress TYPE zr_billet_hdr-progress.

    DATA : lv_count TYPE i VALUE 5.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    IF ls_head-department = 'ROLLMILL'.
      READ ENTITY zi_tmt_head
           BY \_item1
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_101) FAILED FINAL(ft_101).

      READ ENTITY zi_tmt_head
           BY \_item2
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_261) FAILED FINAL(ft_261).

      READ ENTITY zi_tmt_head
           BY \_item3
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_531) FAILED FINAL(ft_531).

      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      DATA(lt_531) = gt_531.
      DELETE lt_531 WHERE quantity = 0.
      FINAL(lv_lines531) = lines( lt_531 ).

      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
        IF <fs_head> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.
        lv_count += 1.
        MODIFY ENTITIES OF i_materialdocumenttp
               ENTITY materialdocument
               CREATE FROM VALUE #( ( %cid                                = lv_item
                                      goodsmovementcode                   = '03'
                                      postingdate                         = <fs_head>-postingdate
                                      documentdate                        = cl_abap_context_info=>get_system_date( )
                                      materialdocumentheadertext          = <fs_head>-referenceid
                                      %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                      %control-postingdate                = cl_abap_behv=>flag_changed
                                      %control-documentdate               = cl_abap_behv=>flag_changed
                                      %control-materialdocumentheadertext = cl_abap_behv=>flag_changed ) )
               ENTITY materialdocument
               CREATE BY \_materialdocumentitem
               FROM VALUE #( ( %cid_ref = lv_item
                               %target  = VALUE #( FOR gs_261_t IN gt_261
                                                   ( %cid                         =  gs_261_t-Item
                                                     plant                        = <fs_head>-plant
                                                     material                     = gs_261_t-material
                                                     goodsmovementtype            = '261'
                                                     storagelocation              = gs_261_t-storageloc
                                                     quantityinentryunit          = gs_261_t-quantity
                                                     entryunit                    = gs_261_t-uom
                                                     batch                        = gs_261_t-batchno
                                                     manufacturingorder           = <fs_head>-productionorder

                                                     %control-plant               = cl_abap_behv=>flag_changed
                                                     %control-material            = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                     %control-storagelocation     = cl_abap_behv=>flag_changed
                                                     %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                     %control-entryunit           = cl_abap_behv=>flag_changed
                                                     %control-batch               = cl_abap_behv=>flag_changed
                                                     %control-manufacturingorder  = cl_abap_behv=>flag_changed ) ) ) )

               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_261)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_261)
               REPORTED FINAL(reported_261).

        IF reported_261-materialdocument IS NOT INITIAL.
          APPEND VALUE #( %tky             = <fs_head>-%tky
                          %state_area      = 'Validate_Head'
                          %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Error in Consumption' )
                          %element-post261 = if_abap_behv=>mk-on )
                 TO reported-zi_tmt_head.

          APPEND VALUE #( %tky = <fs_head>-%tky )
                 TO failed-zi_tmt_head.

        ELSE.

          IF lv_lines531 > 0.
            lv_status   = 'GI Posted'.
            lv_progress = 85.
          ELSE.
            lv_progress = 100.
            lv_status   = 'Completed'.
          ENDIF.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 UPDATE
                 FIELDS ( post261 status progress )
                 WITH VALUE #( ( %tky     = <fs_head>-%tky
                                 status   = lv_status
                                 progress = lv_progress
                                 post261  = 'X' ) ).

        ENDIF.
      ENDLOOP.

    ELSE.

      READ ENTITY zi_tmt_head
        BY \_item4
        ALL FIELDS WITH CORRESPONDING #( keys )
        " TODO: variable is assigned but never used (ABAP cleaner)
        RESULT FINAL(gt_1011) FAILED FINAL(ft_1011).

      READ ENTITY zi_tmt_head
           BY \_item5
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_2611) FAILED FINAL(ft_2611).

*    READ ENTITY zi_tmt_head
*         BY \_item3
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         RESULT FINAL(gt_531) FAILED FINAL(ft_531).

      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

*    DATA(lt_531) = gt_5311.
*    DELETE lt_531 WHERE quantity = 0.
*    FINAL(lv_lines531) = lines( lt_531 ).

      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head1>).
        IF <fs_head1> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.
        lv_count += 1.
        MODIFY ENTITIES OF i_materialdocumenttp
               ENTITY materialdocument
               CREATE FROM VALUE #( ( %cid                                = lv_item
                                      goodsmovementcode                   = '03'
                                      postingdate                         = <fs_head1>-postingdate
                                      documentdate                        = cl_abap_context_info=>get_system_date( )
                                      materialdocumentheadertext          = <fs_head1>-referenceid
                                      %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                      %control-postingdate                = cl_abap_behv=>flag_changed
                                      %control-documentdate               = cl_abap_behv=>flag_changed
                                      %control-materialdocumentheadertext = cl_abap_behv=>flag_changed ) )
               ENTITY materialdocument
               CREATE BY \_materialdocumentitem
               FROM VALUE #( ( %cid_ref = lv_item
                               %target  = VALUE #( FOR gs_261_t1 IN gt_2611
                                                   ( %cid                         = gs_261_t1-Item
                                                     plant                        = <fs_head1>-plant
                                                     material                     = gs_261_t1-material
                                                     goodsmovementtype            = '261'
                                                     storagelocation              = gs_261_t1-storageloc
                                                     quantityinentryunit          = gs_261_t1-quantity
                                                     entryunit                    = gs_261_t1-uom
                                                     batch                        = gs_261_t1-batchno
                                                     manufacturingorder           = <fs_head1>-productionorder

                                                     %control-plant               = cl_abap_behv=>flag_changed
                                                     %control-material            = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                     %control-storagelocation     = cl_abap_behv=>flag_changed
                                                     %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                     %control-entryunit           = cl_abap_behv=>flag_changed
                                                     %control-batch               = cl_abap_behv=>flag_changed
                                                     %control-manufacturingorder  = cl_abap_behv=>flag_changed ) ) ) )

               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_2611)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_2611)
               REPORTED FINAL(reported_2611).

        IF reported_2611-materialdocument IS NOT INITIAL.
          APPEND VALUE #( %tky             = <fs_head1>-%tky
                          %state_area      = 'Validate_Head'
                          %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Error in Consumption' )
                          %element-post261 = if_abap_behv=>mk-on )
                 TO reported-zi_tmt_head.

          APPEND VALUE #( %tky = <fs_head1>-%tky )
                 TO failed-zi_tmt_head.

        ELSE.


          lv_progress = 100.
          lv_status   = 'Completed'.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 UPDATE
                 FIELDS ( post261 status progress )
                 WITH VALUE #( ( %tky     = <fs_head1>-%tky
                                 status   = lv_status
                                 progress = lv_progress
                                 post261  = 'X' ) ).

        ENDIF.
      ENDLOOP.

    ENDIF.
    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).

  ENDMETHOD.

  METHOD post531.

    DATA lv_item TYPE zr_billet_261-item.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS  WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zi_tmt_head
         BY \_item
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    READ ENTITY zi_tmt_head
         BY \_item1
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_531) FAILED FINAL(ft_531).

    TRY.
        lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
    ENDTRY.

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      TRY.
          GET TIME STAMP FIELD FINAL(lv_utctimestamp).
          " TODO: variable is assigned but never used (ABAP cleaner)
          CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      MODIFY ENTITIES OF i_materialdocumenttp
             ENTITY materialdocument
             CREATE FROM VALUE #( ( %cid                                = lv_item
                                    goodsmovementcode                   = '05'
                                    postingdate                         = <fs_head>-postingdate
                                    documentdate                        = cl_abap_context_info=>get_system_date( )
                                    materialdocumentheadertext          = <fs_head>-referenceid
                                    %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                                    %control-postingdate                = cl_abap_behv=>flag_changed
                                    %control-documentdate               = cl_abap_behv=>flag_changed
                                    %control-materialdocumentheadertext = cl_abap_behv=>flag_changed ) )
             ENTITY materialdocument
             CREATE BY \_materialdocumentitem
             FROM VALUE #( ( %cid_ref = lv_item
                             %target  = VALUE #( FOR ls_531 IN gt_531 WHERE ( quantity > 0 )
                                                 ( %cid                         = ls_531-material && ls_531-quantity
                                                   plant                        = <fs_head>-plant
                                                   material                     = ls_531-material
                                                   goodsmovementtype            = '531'
                                                   storagelocation              = ls_531-storageloc
                                                   quantityinentryunit          = ls_531-quantity
                                                   entryunit                    = ls_531-uom
                                                   manufacturingorder           = <fs_head>-productionorder

                                                   %control-plant               = cl_abap_behv=>flag_changed
                                                   %control-material            = cl_abap_behv=>flag_changed
                                                   %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                   %control-storagelocation     = cl_abap_behv=>flag_changed
                                                   %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                   %control-entryunit           = cl_abap_behv=>flag_changed
                                                   %control-manufacturingorder  = cl_abap_behv=>flag_changed ) ) ) )

             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(mapped_531)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(failed_531)
             REPORTED FINAL(reported_531).
      IF reported_531-materialdocument IS NOT INITIAL.
        APPEND VALUE #( %tky             = <fs_head>-%tky
                        %state_area      = 'Validate_Head'
                        %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = 'Error in By-Product' )
                        %element-post261 = if_abap_behv=>mk-on )
               TO reported-zi_tmt_head.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zi_tmt_head.

      ELSE.

        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
               ENTITY zi_tmt_head
               UPDATE
               FIELDS ( post531 status progress )
               WITH VALUE #( ( %tky     = <fs_head>-%tky
                               status   = 'Completed'
                               progress = 100
                               post531  = 'X' ) ).

      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).

  ENDMETHOD.

  METHOD postcnf.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).
    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    IF ls_head-department = 'ROLLMILL'.

      READ ENTITY zi_tmt_head
           BY \_item
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_101) FAILED FINAL(ft_101).

      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
        IF <fs_head> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

        TRY.
            GET TIME STAMP FIELD FINAL(lv_utctimestamp).
            " TODO: variable is assigned but never used (ABAP cleaner)
            CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        SELECT SINGLE manufacturingorder,
                      manufacturingorderoperation
          FROM i_manufacturingorderoperation
          WHERE manufacturingorder = @<fs_head>-productionorder
          INTO @FINAL(ls_i_manufacturingorderop).

        FINAL(lv_gr_quantity) = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                            FOR gs_101 IN gt_101
                                                            NEXT lv_quantity = lv_quantity + gs_101-weight ).

        FINAL(lv_unit) = VALUE #( gt_101[ 1 ]-uom OPTIONAL ).

           SELECT a~manufacturingorder,
             b~workcenterstandardworkqty1,
             b~workcenterstandardworkqty2,
             b~workcenterstandardworkqty3,
             b~workcenterstandardworkqty4,
             b~workcenterstandardworkqty5,
             b~operationreferencequantity
        FROM i_manufacturingorder AS a
        INNER JOIN i_manufacturingorderoperation AS b ON b~billofoperationsgroup = a~billofoperationsgroup
                                 AND b~billofoperationsvariant = a~billofoperationsvariant
                                 AND b~manufacturingorder = a~manufacturingorder
        WHERE a~manufacturingorder = @<fs_head>-productionorder
        INTO TABLE @DATA(lt_routing).
      IF sy-subrc = 0.
        SORT lt_routing BY manufacturingorder.
      ENDIF.

        MODIFY ENTITIES OF i_productionordconfirmationtp
               ENTITY productionorderconfirmation
               CREATE FROM VALUE #( ( %cid                        = <fs_head>-productionorder
                                      orderid                     = <fs_head>-productionorder
                                      orderoperation              = ls_i_manufacturingorderop-manufacturingorderoperation
                                      sequence                    = '000000'
                                      confirmationyieldquantity   = lv_gr_quantity
                                      confirmationunitsapcode     = lv_unit
                                      confirmationtext            = <fs_head>-referenceid
                                      postingdate                 = <fs_head>-postingdate
                                      confirmedexecutionstartdate = <fs_head>-postingdate
                                      confirmedsetupenddate       = <fs_head>-postingdate
                                       opconfirmedworkquantity1    = ( <fs_head>-Avlquantity *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty1 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity2    = <fs_head>-activity

                                    opconfirmedworkquantity3    = ( <fs_head>-Avlquantity *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty3 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity4    = ( <fs_head>-Avlquantity *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty4 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity5    = ( <fs_head>-Avlquantity *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty5 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity ) ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_conf)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_conf)
               REPORTED FINAL(reported_conf).
        IF reported_conf-productionorderconfirmation IS NOT INITIAL.
          APPEND VALUE #( %tky             = <fs_head>-%tky
                          %state_area      = 'Validate_Head'
                          %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Error in Billet Confirmation' )
                          %element-post101 = if_abap_behv=>mk-on )
                 TO reported-zi_tmt_head.

          APPEND VALUE #( %tky = <fs_head>-%tky )
                 TO failed-zi_tmt_head.
        ELSE.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 UPDATE
                 FIELDS ( status postcnf progress )
                 WITH VALUE #( FOR key IN keys
                               ( %tky               = <fs_head>-%tky
                                 status             = 'Confirmed'
                                 progress           = 55
                                 postcnf            = 'X'
                                 %control-status    = if_abap_behv=>mk-on
                                 %control-postcnf = if_abap_behv=>mk-on
                                 %control-progress  = if_abap_behv=>mk-on ) ).
        ENDIF.
      ENDLOOP.

    ELSE.

      READ ENTITY zi_tmt_head
           BY \_item4
           ALL FIELDS WITH CORRESPONDING #( keys )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT FINAL(gt_1011) FAILED FINAL(ft_1011).

      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head1>).
        IF <fs_head1> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

        TRY.
            GET TIME STAMP FIELD FINAL(lv_utctimestamp1).
            " TODO: variable is assigned but never used (ABAP cleaner)
            CONVERT TIME STAMP lv_utctimestamp1 TIME ZONE 'INDIA' INTO DATE FINAL(lv_date1) TIME FINAL(lv_time1).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        SELECT SINGLE manufacturingorder,
                      manufacturingorderoperation
          FROM i_manufacturingorderoperation
          WHERE manufacturingorder = @<fs_head1>-productionorder
          INTO @FINAL(ls_i_manufacturingorderop1).

        FINAL(lv_gr_quantity1) = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                            FOR gs_1011 IN gt_1011
                                                            NEXT lv_quantity = lv_quantity + gs_1011-noofpcs ).

        FINAL(lv_unit1) = VALUE #( gt_1011[ 1 ]-uom OPTIONAL ).

        MODIFY ENTITIES OF i_productionordconfirmationtp
               ENTITY productionorderconfirmation
               CREATE FROM VALUE #( ( %cid                        = <fs_head1>-productionorder
                                      orderid                     = <fs_head1>-productionorder
                                      orderoperation              = ls_i_manufacturingorderop1-manufacturingorderoperation
                                      sequence                    = '000000'
                                      confirmationyieldquantity   = lv_gr_quantity1
                                      confirmationunitsapcode     = lv_unit1
                                      confirmationtext            = <fs_head1>-referenceid
                                      postingdate                 = <fs_head1>-postingdate
                                      confirmedexecutionstartdate = <fs_head1>-postingdate
                                      confirmedsetupenddate       = <fs_head1>-postingdate ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_conf1)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_conf1)
               REPORTED FINAL(reported_conf1).
        IF reported_conf-productionorderconfirmation IS NOT INITIAL.
          APPEND VALUE #( %tky             = <fs_head>-%tky
                          %state_area      = 'Validate_Head'
                          %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                    text     = 'Error in Bundle Confirmation' )
                          %element-post101 = if_abap_behv=>mk-on )
                 TO reported-zi_tmt_head.

          APPEND VALUE #( %tky = <fs_head1>-%tky )
                 TO failed-zi_tmt_head.
        ELSE.

          MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                 ENTITY zi_tmt_head
                 UPDATE
                 FIELDS ( status postcnf progress )
                 WITH VALUE #( FOR key IN keys
                               ( %tky               = <fs_head1>-%tky
                                 status             = 'Confirmed'
                                 progress           = 55
                                 postcnf            = 'X'
                                 %control-status    = if_abap_behv=>mk-on
                                 %control-postcnf = if_abap_behv=>mk-on
                                 %control-progress  = if_abap_behv=>mk-on ) ).
        ENDIF.
      ENDLOOP.

    ENDIF.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
         ENTITY zi_tmt_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

  METHOD getcons.

    DATA :lv_count TYPE i.
    DATA : lv_item TYPE zi_cons_bundle-item.
    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
            ENTITY zi_tmt_head
            ALL FIELDS WITH CORRESPONDING #( keys )
            " TODO: variable is assigned but never used (ABAP cleaner)
            RESULT DATA(gt_header) FAILED DATA(ft_header).

    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    READ ENTITY zi_tmt_head
         BY \_item4
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.
      LOOP AT gt_101 ASSIGNING FIELD-SYMBOL(<fs_101>).
        IF <fs_101> IS ASSIGNED.

          IF <fs_101>-tbatchno IS INITIAL.
            " Bundle Generation TMT batch no Validation
            APPEND VALUE #(
                %tky               = <fs_head>-%tky
                %state_area        = 'Validate_Header'
                %msg               = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text     = 'TMT Batch no is Madatory field' )
                %element-conscheck = if_abap_behv=>mk-on )
                   TO reported-zi_tmt_head.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zi_tmt_head.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head01>).
      IF <fs_head01> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      IF <fs_head01>-%is_draft = 01.
        APPEND VALUE #( %tky             = <fs_head>-%tky
                  %state_area      = 'Validate_Head'
                  %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text     = 'Disable the Draft Mode' )
                  %element-post101 = if_abap_behv=>mk-on )
         TO reported-zi_tmt_head.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zi_tmt_head.
      ELSE.
        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                    ENTITY zi_tmt_head
                    UPDATE
                    FIELDS ( status  progress )
                    WITH VALUE #( FOR key IN keys
                                  ( %tky               = <fs_head>-%tky
                                    status             = 'Item Fetched'
                                    progress           = 30
                                    postcnf            = 'X'
                                    %control-status    = if_abap_behv=>mk-on
                                    %control-postcnf = if_abap_behv=>mk-on
                                    %control-progress  = if_abap_behv=>mk-on ) ).

        SELECT SINGLE * FROM i_manufacturingorder
          WHERE manufacturingorder = @<fs_head01>-productionorder
          INTO @FINAL(ls_mnford).

        SELECT * FROM i_billofmaterialitemtp_3
          WHERE billofmaterial = @ls_mnford-billofmaterial
            AND billofmaterialitemquantity > 0
            AND  billofmaterialvariant = '02'
          INTO TABLE @DATA(lt_bom).

        DATA(lt_101) = gt_101[].
        SORT lt_101 ASCENDING BY tbatchno.
        DELETE ADJACENT DUPLICATES FROM lt_101 COMPARING tbatchno.

        DATA(ls_261) = lt_bom[ 1 ].


        CLEAR : lv_count.

        LOOP AT lt_101 ASSIGNING FIELD-SYMBOL(<fs_2611>).
          IF <fs_2611> IS ASSIGNED.

            TRY.
                lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
              CATCH cx_uuid_error.
            ENDTRY.
            lv_count += 1.
            SELECT SINGLE * FROM i_product WHERE product = @ls_261-billofmaterialcomponent INTO @FINAL(ls_prod_2611).
            SELECT SINGLE * FROM i_productstoragelocationbasic WHERE product = @ls_261-billofmaterialcomponent AND plant = @<fs_head01>-plant
            INTO @FINAL(ls_sloc11).
            MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
                   ENTITY zi_tmt_head
                   CREATE BY \_item5
                   FROM VALUE #( ( id      = <fs_head01>-id
                                   %target = VALUE #( ( %cid                         =   lv_count && lv_item
                                                        item                         = lv_count && lv_item
                                                        referenceid                  = <fs_head01>-referenceid
                                                        material                     = ls_261-billofmaterialcomponent
                                                        materialdes          = ls_261-componentdescription
                                                        batchno     = <fs_2611>-tbatchno
                                                        uom                          = ls_prod_2611-baseunit
                                                        storageloc                        = ls_sloc11-storagelocation
                                                        %control-item                = if_abap_behv=>mk-on
                                                        %control-referenceid         = if_abap_behv=>mk-on
                                                        %control-material            = if_abap_behv=>mk-on
                                                        %control-storageloc               = if_abap_behv=>mk-on
                                                        %control-materialdes = if_abap_behv=>mk-on
                                                        %control-batchno = if_abap_behv=>mk-on
                                                        %control-uom                 = if_abap_behv=>mk-on ) ) ) )
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   MAPPED FINAL(ls_mapped_2611)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED FINAL(ls_failed_2611)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   REPORTED FINAL(ls_reported_2611).

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
           ENTITY zi_tmt_head
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bundle_gen DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bundle_gen RESULT result.
*    METHODS bundlegen FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zi_bundle_gen~bundlegen.

    METHODS bundlesave FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_bundle_gen~bundlesave.

ENDCLASS.

CLASS lhc_zi_bundle_gen IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

*  METHOD bundlegen.
*
*    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
*            ENTITY zi_tmt_head
*            ALL FIELDS  WITH CORRESPONDING #( keys )
*            " TODO: variable is assigned but never used (ABAP cleaner)
*            RESULT DATA(gt_header) FAILED FINAL(failed).
*
*    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
*    ENTITY zi_bundle_gen
*    ALL FIELDS  WITH CORRESPONDING #( keys )
*    " TODO: variable is assigned but never used (ABAP cleaner)
*    RESULT DATA(gt_bund) FAILED FINAL(failedp).
*
*
*    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).
*    LOOP AT gt_bund ASSIGNING FIELD-SYMBOL(<fs_bund>).
*      IF <fs_bund> IS ASSIGNED.
*
*
*
*        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
*               ENTITY zi_bundle_gen
*               UPDATE
*               FIELDS ( uom )
*               WITH VALUE #( FOR key IN keys
*                             ( %tky                   = <fs_bund>-%tky
*                               uom                    = ls_head-uom
*                               %control-uom           = if_abap_behv=>mk-on ) ).
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD bundlesave.
    DATA lv_referencelike TYPE zi_tmt_head-referenceid.
    DATA lv_reference TYPE zi_tmt_head-referenceid.

    DATA : lv_count TYPE i  VALUE 1.
    DATA : lv_no TYPE numc5.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
              ENTITY zi_tmt_head
              ALL FIELDS  WITH CORRESPONDING #( keys )
              " TODO: variable is assigned but never used (ABAP cleaner)
              RESULT DATA(gt_header) FAILED FINAL(failed).

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
    ENTITY zi_bundle_gen
    ALL FIELDS  WITH CORRESPONDING #( keys )
    " TODO: variable is assigned but never used (ABAP cleaner)
    RESULT DATA(gt_bund) FAILED FINAL(failedp).


    TRY.
        GET TIME STAMP FIELD FINAL(lv_utctimestamp).
        " TODO: variable is assigned but never used (ABAP cleaner)
        CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
      CATCH cx_abap_context_info_error.
    ENDTRY.
    lv_referencelike = |%B{ lv_date+2(2) }{ lv_date+4(2) }%|.
    SELECT * FROM zi_bundle_gen
     WHERE bbatchno LIKE @lv_referencelike
     INTO TABLE @DATA(lt_zi_bundle_gen).
    IF sy-subrc = 0.
      SORT lt_zi_bundle_gen BY bbatchno DESCENDING.
      FINAL(ls_zi_bundle_gen) = VALUE #( lt_zi_bundle_gen[ 1 ] OPTIONAL ).
      lv_no = ls_zi_bundle_gen-bbatchno+5(5) + 1.
    ENDIF.


    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).
    LOOP AT gt_bund ASSIGNING FIELD-SYMBOL(<fs_bund>).
      IF <fs_bund> IS ASSIGNED.
        lv_reference = 'B' && lv_date+2(2) && lv_date+4(2) && lv_no.
        lv_no += 1.
        IF lv_count < 10.
          <fs_bund>-bbatchno = lv_reference.
        ELSE.
          <fs_bund>-bbatchno = lv_reference.
        ENDIF.
        lv_count += 1.

        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
               ENTITY zi_bundle_gen
               UPDATE
               FIELDS ( uom bbatchno )
               WITH VALUE #( FOR key IN keys
                             ( %tky                   = <fs_bund>-%tky
                               uom                    = ls_head-uom
                               bbatchno = <fs_bund>-bbatchno
                               %control-uom           = if_abap_behv=>mk-on
                               %control-bbatchno           = if_abap_behv=>mk-on ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_consumed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_consumed RESULT result.




ENDCLASS.

CLASS lhc_zi_consumed IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.



ENDCLASS.

CLASS lhc_zi_cons_bundle DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_cons_bundle RESULT result.

ENDCLASS.

CLASS lhc_zi_cons_bundle IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_metal_bal DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_metal_bal RESULT result.

ENDCLASS.

CLASS lhc_zi_metal_bal IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_tmt_byprod DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_tmt_byprod RESULT result.

ENDCLASS.

CLASS lhc_zi_tmt_byprod IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_tmt_prod DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_tmt_prod RESULT result.
    METHODS proddetails1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_tmt_prod~proddetails1.

    METHODS proddetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_tmt_prod~proddetails.

ENDCLASS.

CLASS lhc_zi_tmt_prod IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD proddetails1.


    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
              ENTITY zi_tmt_head
              ALL FIELDS  WITH CORRESPONDING #( keys )
              " TODO: variable is assigned but never used (ABAP cleaner)
              RESULT DATA(gt_header) FAILED FINAL(failed).

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
    ENTITY zi_tmt_prod
    ALL FIELDS  WITH CORRESPONDING #( keys )
    " TODO: variable is assigned but never used (ABAP cleaner)
    RESULT DATA(gt_post) FAILED FINAL(failedp).

    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).
    LOOP AT gt_post ASSIGNING FIELD-SYMBOL(<fs_post>).
      IF <fs_post> IS ASSIGNED.

        SELECT SINGLE * FROM i_productstoragelocationbasic WHERE product = @ls_head-material
        AND plant = @ls_head-plant INTO @DATA(ls_sloc).
        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
            ENTITY zi_tmt_prod
            UPDATE
            FIELDS (  uom storagelocation )
            WITH VALUE #( FOR key IN keys
                          ( %tky                   = <fs_post>-%tky
                            uom                    = ls_head-uom
                            storagelocation     = ls_sloc-storagelocation
                            %control-storagelocation        = if_abap_behv=>mk-on
                            %control-uom           = if_abap_behv=>mk-on  ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD proddetails.

    DATA lv_referencelike TYPE zi_tmt_head-referenceid.
    DATA lv_reference TYPE zi_tmt_head-referenceid.

    DATA : lv_count TYPE i  VALUE 1.
    DATA : lv_no TYPE numc5.
    DATA : lv_pre1 TYPE char1.
    DATA : lv_pre2 TYPE char1.
    DATA : lv_pre3 TYPE char1.

    DATA:  lv_batchlike  TYPE char10.
    DATA: lv_num TYPE zde_no.

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
              ENTITY zi_tmt_head
              ALL FIELDS  WITH CORRESPONDING #( keys )
              " TODO: variable is assigned but never used (ABAP cleaner)
              RESULT DATA(gt_header) FAILED FINAL(failed).

    READ ENTITIES OF zi_tmt_head IN LOCAL MODE
    ENTITY zi_tmt_prod
    ALL FIELDS  WITH CORRESPONDING #( keys )
    " TODO: variable is assigned but never used (ABAP cleaner)
    RESULT DATA(gt_post) FAILED FINAL(failedp).


    TRY.
        GET TIME STAMP FIELD FINAL(lv_utctimestamp).
        " TODO: variable is assigned but never used (ABAP cleaner)
        CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
      CATCH cx_abap_context_info_error.
    ENDTRY.
    lv_referencelike = |%T{ lv_date+2(2) }{ lv_date+4(2) }%|.
    lv_referencelike = |%T{ lv_date+2(2) }{ lv_date+4(2) }%|.
    SELECT * FROM zi_tmt_prod
     WHERE batchno LIKE @lv_referencelike
     INTO TABLE @DATA(lt_zi_bundle_gen).
    IF sy-subrc = 0.
      SORT lt_zi_bundle_gen BY batchno DESCENDING.
      FINAL(ls_zi_bundle_gen) = VALUE #( lt_zi_bundle_gen[ 1 ] OPTIONAL ).
      lv_no = ls_zi_bundle_gen-batchno+5(5) + 1.
    ENDIF.

    DATA(ls_head) = VALUE #( gt_header[ 1 ] OPTIONAL ).
    LOOP AT gt_post ASSIGNING FIELD-SYMBOL(<fs_post>).
      IF <fs_post> IS ASSIGNED.

**--this code added SAR TECH team---05-12-2025----
**********************************************************************
    data(ls_batchno) = |TMT{ <fs_post>-Tsection }MM|.

**--this code added SAR TECH team---05-12-2025----
**********************************************************************

        lv_reference = 'T' && lv_date+2(2) && lv_date+4(2) && lv_no.
        lv_no += 1.
        <fs_post>-batchno = lv_reference.
        lv_count += 1.

        MODIFY ENTITIES OF zi_tmt_head IN LOCAL MODE
          ENTITY zi_tmt_prod
          UPDATE
          FIELDS (  batchno )
          WITH VALUE #( FOR key IN keys
                        ( %tky                   = <fs_post>-%tky
*                          batchno                    = <fs_post>-batchno       "this one old code
                          batchno                    = ls_batchno               "this new code added by SAR TECH team
                          %control-batchno        = if_abap_behv=>mk-on  ) ).

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
