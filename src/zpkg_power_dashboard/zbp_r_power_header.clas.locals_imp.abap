CLASS lhc_zr_power_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_power_header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zr_power_header RESULT result.

    METHODS consistency FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~consistency RESULT result.

    METHODS postcons FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~postcons RESULT result.

    METHODS postgen FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~postgen RESULT result.

    METHODS headerdetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zr_power_header~headerdetails.

    METHODS power FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~power RESULT result.

    METHODS headeronmod FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_power_header~headeronmod.

    METHODS postcnf FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~postcnf RESULT result.

    METHODS getcons FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~getcons RESULT result.

    METHODS transfer FOR MODIFY
      IMPORTING keys FOR ACTION zr_power_header~transfer RESULT result.

ENDCLASS.


CLASS lhc_zr_power_header IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_failed).

    result = VALUE #( FOR gs_header IN gt_header
                      ( %tky                = gs_header-%tky

                        %update             = COND #( WHEN gs_header-consistency = ''
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %assoc-_cons        = COND #( WHEN gs_header-consistency = ''
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %assoc-_mat         = if_abap_behv=>fc-o-disabled

                        %assoc-_pow         = if_abap_behv=>fc-o-disabled

                        %action-getcons     = COND #( WHEN gs_header-status = 'Created'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %action-consistency = COND #( WHEN gs_header-status = 'Cons. Fetched'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %action-postcnf     = COND #( WHEN gs_header-status = 'Checked'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %action-postgen     = COND #( WHEN gs_header-status = 'Confirmed'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %action-postcons    = COND #( WHEN gs_header-status = 'GR Posted'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %action-transfer       = COND #( WHEN gs_header-status = 'GI Posted'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %action-power       = COND #( WHEN gs_header-status = 'Transferred'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled ) ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD consistency.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_powergenerated TYPE zr_billet_hdr-billetquantity.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_powerconsumed  TYPE zr_billet_hdr-heatquantity.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS  WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zr_power_header
         BY \_pow
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    READ ENTITY zr_power_header
         BY \_mat
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_261) FAILED FINAL(ft_261).

    READ ENTITY zr_power_header
         BY \_cons
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_531) FAILED FINAL(ft_531).

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

      " Header checks
      IF <fs_head>-postingdate > lv_date.
        APPEND VALUE #(
            %tky                 = <fs_head>-%tky
            %state_area          = 'Validate_Header'
            %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text     = 'Posting Date greater than current Date' )
            %element-consistency = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      ENDIF.

      " 101 checks
      IF lines( gt_101 ) = 0.
        APPEND VALUE #( %tky             = <fs_head>-%tky
                        %state_area      = 'Validate_Header'
                        %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = 'No Power Generation Lines present' )
                        %element-postgen = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      ELSE.

        LOOP AT gt_101 INTO FINAL(gs_101).
          IF gs_101-powergenerated IS INITIAL.
            APPEND VALUE #( %tky             = <fs_head>-%tky
                            %state_area      = 'Validate_Header'
                            %msg             = new_message_with_text(
                                                   severity = if_abap_behv_message=>severity-error
                                                   text     = |No Power Generated provided in Line { sy-tabix }| )
                            %element-postgen = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          ENDIF.

          IF gs_101-storagelocation IS INITIAL.

            APPEND VALUE #(
                %tky             = <fs_head>-%tky
                %state_area      = 'Validate_Header'
                %msg             = new_message_with_text(
                                       severity = if_abap_behv_message=>severity-error
                                       text     = |Provide a valid storage location in Billet Line { sy-tabix }| )
                %element-postgen = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          ENDIF.

        ENDLOOP.
      ENDIF.

      " 261 checks
      IF lines( gt_261 ) = 0.
        APPEND VALUE #(
            %tky              = <fs_head>-%tky
            %state_area       = 'Validate_Header'
            %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                       text     = 'No Consumption Lines present, check BOM' )
            %element-postcons = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      ELSE.

        LOOP AT gt_261 INTO FINAL(gs_261).
          IF gs_261-storagelocation IS INITIAL.

            APPEND VALUE #(
                %tky              = <fs_head>-%tky
                %state_area       = 'Validate_Header'
                %msg              = new_message_with_text(
                                        severity = if_abap_behv_message=>severity-error
                                        text     = |Provide a valid storage location in Cons. Line { sy-tabix }| )
                %element-postcons = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          ENDIF.

          IF gs_261-quantity IS INITIAL.
            APPEND VALUE #( %tky              = <fs_head>-%tky
                            %state_area       = 'Validate_Header'
                            %msg              = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-error
                                                    text     = |Provide a quantity in Cons. Line { sy-tabix }| )
                            %element-postcons = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          ENDIF.
        ENDLOOP.
      ENDIF.

      " 531 checks
      DATA(lt_531) = gt_531.
      DELETE lt_531 WHERE consumption = 0.

      IF lines( lt_531 ) = 0.
        APPEND VALUE #(
            %tky              = <fs_head>-%tky
            %state_area       = 'Validate_Header'
            %msg              = new_message_with_text(
                                    severity = if_abap_behv_message=>severity-error
                                    text     = |Add lines in the Power Consumption Section| )
            %element-postcons = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      ELSE.

        LOOP AT gt_531 INTO FINAL(gs_531).
          IF gs_531-consumption IS INITIAL.
            APPEND VALUE #( %tky              = <fs_head>-%tky
                            %state_area       = 'Validate_Header'
                            %msg              = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-error
                                                    text     = |Consumption can not be blank in Line { sy-tabix }| )
                            %element-postcons = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          ENDIF.

          if gs_531-Plant+0(1) <> <fs_head>-Plant+0(1).
            APPEND VALUE #( %tky              = <fs_head>-%tky
                            %state_area       = 'Validate_Header'
                            %msg              = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-error
                                                   text     = |Plant Mismatch| )
                            %element-postcons = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          endif.

          IF gs_531-storagelocation IS INITIAL.
            APPEND VALUE #( %tky              = <fs_head>-%tky
                            %state_area       = 'Validate_Header'
                            %msg              = new_message_with_text(
                                                    severity = if_abap_behv_message=>severity-error
                                                    text     = |Storage Location can not be blank in Line { sy-tabix }| )
                            %element-postcons = if_abap_behv=>mk-on )
                   TO reported-zr_power_header.

            APPEND VALUE #( %tky = <fs_head>-%tky )
                   TO failed-zr_power_header.
          ENDIF.
        ENDLOOP.
      ENDIF.

      DATA(lt_101_heat) = gt_101.
      SORT lt_101_heat BY turbine.
      DELETE lt_101_heat WHERE powergenerated = 0.
      DELETE ADJACENT DUPLICATES FROM lt_101_heat COMPARING turbine.
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(lv_heat101) = lines( lt_101_heat ).

      DATA(lt_261_heat) = gt_261.
      DELETE lt_261_heat WHERE quantity = 0.
      SORT lt_261_heat BY turbine.
      DELETE ADJACENT DUPLICATES FROM lt_261_heat COMPARING turbine.
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(lv_heat261) = lines( lt_261_heat ).

      DATA(lt_531_heat) = gt_531.
      DELETE lt_531_heat WHERE consumption = 0.
      SORT lt_531_heat BY plant.
      DELETE ADJACENT DUPLICATES FROM lt_531_heat COMPARING plant.
      " TODO: variable is assigned but never used (ABAP cleaner)
      FINAL(lv_heat531) = lines( lt_531_heat ).

      " power consumption Balancing
      lv_powergenerated = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                    FOR gs_101_t IN gt_101
                                                    NEXT lv_quantity = lv_quantity + gs_101_t-powergenerated ).

      lv_powerconsumed = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                    FOR gs_531_t IN gt_531
                                                    NEXT lv_quantity = lv_quantity + gs_531_t-consumption ).


      IF lv_powergenerated <> lv_powerconsumed.
        APPEND VALUE #(
            %tky             = <fs_head>-%tky
            %state_area      = 'Validate_Header'
            %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = |Power Generated must be equal to Power Consumed| )
            %element-postcons = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      ENDIF.
      data(ls_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).
      loop at gt_261 ASSIGNING FIELD-SYMBOL(<fs_261CHK>).
      if <fs_261CHK> is NOT ASSIGNED.
      CONTINUE.
      endif.
      SELECT SINGLE * from ZV261STOCK
      where Product = @<fs_261chk>-Material
      and StorageLocation = @<fs_261chk>-Storagelocation
      and Plant = @ls_header-Plant
      and InventoryStockType = '01'
      INTO @data(ls_stock).
      if <fs_261chk>-Quantity > ls_stock-MatlWrhsStkQtyInMatlBaseUnit.
       APPEND VALUE #(
            %tky             = <fs_head>-%tky
            %state_area      = 'Validate_Header'
            %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text     = |Stock deficit| )
            %element-postcons = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      endif.
      ENDLOOP.
      IF failed-zr_power_header IS INITIAL.

        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_header
               UPDATE
               FIELDS ( status consistency )
               WITH VALUE #( FOR key IN keys
                             ( %tky                 = <fs_head>-%tky
                               status               = 'Checked'
                               consistency          = 'X'
                               %control-status      = if_abap_behv=>mk-on
                               %control-consistency = if_abap_behv=>mk-on ) ).

      ENDIF.

      READ ENTITIES OF zr_power_header IN LOCAL MODE
           ENTITY zr_power_header
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_result).

      result = VALUE #( FOR ls_header_result IN header_result
                        ( %tky   = ls_header_result-%tky
                          %param = ls_header_result ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD postcons.
    DATA lv_item     TYPE zr_billet_261-item.
    DATA lv_status   TYPE zr_billet_hdr-status.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_progress TYPE zr_billet_hdr-progress.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zr_power_header
         BY \_pow
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    READ ENTITY zr_power_header
         BY \_mat
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_261) FAILED FINAL(ft_261).

    READ ENTITY zr_power_header
         BY \_cons
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_531) FAILED FINAL(ft_531).

    TRY.
        lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
    ENDTRY.

    DATA(lt_531) = gt_531.
    DELETE lt_531 WHERE consumption = 0.
    FINAL(lv_lines531) = lines( lt_531 ).

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

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
                                                 ( %cid                         = gs_261_t-turbine
                                                   plant                        = <fs_head>-plant
                                                   material                     = gs_261_t-material
                                                   goodsmovementtype            = '261'
                                                   storagelocation              = gs_261_t-storagelocation
                                                   quantityinentryunit          = gs_261_t-quantity
                                                   entryunit                    = gs_261_t-uom
                                                   manufacturingorder           = <fs_head>-productionorder
                                                   materialdocumentitemtext          = <fs_head>-referenceid

                                                   %control-plant               = cl_abap_behv=>flag_changed
                                                   %control-material            = cl_abap_behv=>flag_changed
                                                   %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                   %control-storagelocation     = cl_abap_behv=>flag_changed
                                                   %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                   %control-entryunit           = cl_abap_behv=>flag_changed
                                                   %control-materialdocumentitemtext           = cl_abap_behv=>flag_changed
                                                   %control-manufacturingorder  = cl_abap_behv=>flag_changed ) ) ) )

             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(mapped_261)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(failed_261)
             REPORTED FINAL(reported_261).

      IF reported_261-materialdocument IS NOT INITIAL.
        APPEND VALUE #( %tky              = <fs_head>-%tky
                        %state_area       = 'Validate_Head'
                        %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = 'Error in Consumed Materials' )
                        %element-postcons = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.

      ELSE.

        IF lv_lines531 > 0.
          lv_status   = 'GI Posted'.
          lv_progress = 80.
        ELSE.
          lv_progress = 100.
          lv_status   = 'Completed'.
        ENDIF.

        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_header
               UPDATE
               FIELDS ( postcons status )
               WITH VALUE #( ( %tky     = <fs_head>-%tky
                               status   = lv_status
*                               progress = lv_progress
                               postcons = 'X' ) ).

      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

  METHOD postgen.
    DATA lv_item TYPE zr_billet_101-item.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS  WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zr_power_header
         BY \_pow
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
                                                   material                          = gs_101-material
                                                   goodsmovementtype                 = '101'
                                                   storagelocation                   = gs_101-storagelocation
                                                   quantityinentryunit               = gs_101-powergenerated
                                                   entryunit                         = gs_101-uom
                                                   manufacturingorder                = <fs_head>-productionorder
                                                   goodsmovementrefdoctype           = 'F'
                                                   materialdocumentitemtext          = <fs_head>-referenceid

                                                   %control-plant                    = cl_abap_behv=>flag_changed
                                                   %control-material                 = cl_abap_behv=>flag_changed
                                                   %control-goodsmovementtype        = cl_abap_behv=>flag_changed
                                                   %control-storagelocation          = cl_abap_behv=>flag_changed
                                                   %control-quantityinentryunit      = cl_abap_behv=>flag_changed
                                                   %control-entryunit                = cl_abap_behv=>flag_changed
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
                                                                  text     = 'Error in Power Generation' )
                        %element-postgen = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.

      ELSE.

        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_header
               UPDATE
               FIELDS ( postgen status )
               WITH VALUE #( ( %tky    = <fs_head>-%tky
                               status  = 'GR Posted'
                               postgen = 'X' ) ).

      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

  METHOD headerdetails.
    DATA lv_referencelike TYPE zr_billet_hdr-referenceid.
    DATA lv_no            TYPE zde_no                    VALUE 1.
    DATA lv_reference     TYPE zr_billet_hdr-referenceid.
    DATA lv_item          TYPE zr_billet_531-item.
    DATA lv_count         TYPE zde_no                    VALUE 1.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
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
        lv_referencelike = |%{ lv_date+2(2) }{ lv_date+4(2) }%|.
      ENDIF.

      SELECT * FROM zr_power_header
        WHERE referenceid LIKE @lv_referencelike
        INTO TABLE @DATA(lt_zr_power_hdr).
      IF sy-subrc = 0.
        SORT lt_zr_power_hdr BY referenceid DESCENDING.
        FINAL(ls_zr_power_hdr) = VALUE #( lt_zr_power_hdr[ 1 ] OPTIONAL ).
        lv_no = ls_zr_power_hdr-referenceid+4(6) + 1.
      ENDIF.
      lv_reference = lv_date+2(2) && lv_date+4(2) && lv_no.
      MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
             ENTITY zr_power_header
             UPDATE
             FIELDS ( status referenceid activity )
             WITH VALUE #( FOR key IN keys
                           ( %tky                 = <fs_head>-%tky
                             status               = <fs_head>-status
                             referenceid          = lv_reference
                             activity             = <fs_head>-activity
                             %control-status      = if_abap_behv=>mk-on
                             %control-referenceid = if_abap_behv=>mk-on
                             %control-activity    = if_abap_behv=>mk-on ) ).
    ENDLOOP.

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head01>).
      IF <fs_head01> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      SELECT SINGLE *
      FROM i_manufacturingorder
      WHERE manufacturingorder = @<fs_head01>-productionorder
      INTO @DATA(ls_manforder).

      " Power Generation
      TRY.
          lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
      ENDTRY.

      DO <fs_head01>-noofturbine TIMES.
        lv_count += 1.
        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_header
               CREATE BY \_pow
               FROM VALUE #( ( id      = <fs_head01>-id
                               %target = VALUE #( ( %cid                         = lv_count && lv_item
                                                    item                         = lv_count && lv_item
                                                    material                     = <fs_head01>-material
                                                    materialdescription          = <fs_head01>-materialdesc
                                                    uom                          = ls_manforder-productionunit
                                                    storagelocation              = ls_manforder-storagelocation
                                                    movementtype                 = '101'
                                                    plant                        = ls_manforder-productionplant

                                                    %control-item                = if_abap_behv=>mk-on
                                                    %control-material            = if_abap_behv=>mk-on
                                                    %control-plant               = if_abap_behv=>mk-on
                                                    %control-materialdescription = if_abap_behv=>mk-on
                                                    %control-uom                 = if_abap_behv=>mk-on
                                                    %control-movementtype        = if_abap_behv=>mk-on
                                                    %control-storagelocation     = if_abap_behv=>mk-on  ) ) ) )
               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(ls_mapped_pow)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(ls_failed_pow)
               " TODO: variable is assigned but never used (ABAP cleaner)
               REPORTED FINAL(ls_reported_pow).

      ENDDO.

    ENDLOOP.
  ENDMETHOD.

  METHOD power.
    DATA lv_item            TYPE zr_billet_261-item.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_billet_quantity TYPE zr_billet_hdr-billetquantity.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    DATA lv_byp_quantity    TYPE zr_billet_hdr-byproductquantity.

*    DATA lv_heat_quantity    TYPE zr_billet_hdr-heatquantity.
*    DATA lv_balance_quantity TYPE zr_billet_hdr-balancequantity.
*    DATA lv_yield            TYPE zr_billet_hdr-yieldpercentage.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zr_power_header
         BY \_pow
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    READ ENTITY zr_power_header
         BY \_mat
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_261) FAILED FINAL(ft_261).

    READ ENTITY zr_power_header
         BY \_cons
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_531) FAILED FINAL(ft_531).

    TRY.
        lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
    ENDTRY.

    DATA(lt_531) = gt_531.
    DELETE lt_531 WHERE consumption = 0.
    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(lv_lines531) = lines( lt_531 ).

    " power consumption Balancing
    lv_billet_quantity = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                  FOR gs_101_y IN gt_101
                                                  NEXT lv_quantity = lv_quantity + gs_101_y-powergenerated ).

    lv_byp_quantity = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                  FOR gs_531_y IN gt_531
                                                  NEXT lv_quantity = lv_quantity + gs_531_y-consumption ).

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

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
             FROM VALUE #(
                 ( %cid_ref = lv_item
                   %target  = VALUE #( FOR gs_261_t IN gt_531
                                       ( %cid                         = gs_261_t-material && gs_261_t-productionorderno
                                         plant                        = gs_261_t-plant
                                         material                     = gs_261_t-material
                                         goodsmovementtype            = '261'
                                         quantityinentryunit          = gs_261_t-consumption
                                         entryunit                    = gs_261_t-uom
                                         manufacturingorder           = gs_261_t-productionorderno
                                         materialdocumentitemtext = <fs_head>-referenceid
                                         storagelocation = gs_261_t-storagelocation

                                         %control-plant               = cl_abap_behv=>flag_changed
                                         %control-material            = cl_abap_behv=>flag_changed
                                         %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                         %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                         %control-entryunit           = cl_abap_behv=>flag_changed
                                         %control-storagelocation           = cl_abap_behv=>flag_changed
                                         %control-materialdocumentitemtext               = cl_abap_behv=>flag_changed
                                         %control-manufacturingorder  = cl_abap_behv=>flag_changed ) ) ) )

             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(mapped_261)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(failed_261)
             REPORTED FINAL(reported_261).

      IF reported_261-materialdocument IS NOT INITIAL.
        APPEND VALUE #( %tky              = <fs_head>-%tky
                        %state_area       = 'Validate_Head'
                        %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                   text     = 'Error in Power Consumption' )
                        %element-postcons = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.

      ELSE.

        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_header
               UPDATE
               FIELDS ( postcons status )
               WITH VALUE #( ( %tky   = <fs_head>-%tky
                               status = 'Completed'
*                               progress = 100
                               power  = 'X' ) ).

      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

  METHOD headeronmod.
    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS  WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT DATA(gt_header) FAILED FINAL(failed).

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      SELECT SINGLE manufacturingorder,
                    productionplant,
                    material
        FROM i_manufacturingorder
        WHERE manufacturingorder = @<fs_head>-productionorder
        INTO @FINAL(ls_i_manufacturingorder).

      SELECT SINGLE product,
                    productname
        FROM i_producttext
        WHERE product = @ls_i_manufacturingorder-material
        INTO @FINAL(ls_product).

      <fs_head>-status = 'Draft'.

      MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
             ENTITY zr_power_header
             UPDATE
             FIELDS ( status activity plant material materialdesc )
             WITH VALUE #( FOR key IN keys
                           ( %tky                  = <fs_head>-%tky
                             status                = <fs_head>-status
                             activity              = <fs_head>-activity
                             plant                 = ls_i_manufacturingorder-productionplant
                             material              = ls_i_manufacturingorder-material
                             materialdesc          = ls_product-productname

                             %control-material     = if_abap_behv=>mk-on
                             %control-status       = if_abap_behv=>mk-on
                             %control-plant        = if_abap_behv=>mk-on
                             %control-materialdesc = if_abap_behv=>mk-on
                             %control-activity     = if_abap_behv=>mk-on ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD postcnf.
    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zr_power_header
         BY \_pow
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

      DATA(ls_cost) = |{ <fs_head>-productionorder ALPHA = IN }|.
      SELECT SINGLE manufacturingorder,
                    manufacturingorderoperation
        FROM i_manufacturingorderoperation
        WHERE manufacturingorder = @ls_cost   "<fs_head>-productionorder
        INTO @FINAL(ls_i_manufacturingorderop).

      FINAL(lv_gr_quantity) = REDUCE menge_d( INIT lv_quantity TYPE menge_d
                                                          FOR gs_101 IN gt_101
                                                          NEXT lv_quantity = lv_quantity + gs_101-powergenerated ).

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

*      MODIFY ENTITIES OF i_productionordconfirmationtp
*             ENTITY productionorderconfirmation
*             CREATE FROM VALUE #( ( %cid                        = <fs_head>-productionorder
*                                    orderid                     = <fs_head>-productionorder
*                                    orderoperation              = ls_i_manufacturingorderop-manufacturingorderoperation
*                                    sequence                    = '000000'
*                                    confirmationyieldquantity   = lv_gr_quantity
*                                    confirmationunitsapcode     = lv_unit
*                                    confirmationtext            = <fs_head>-referenceid
*                                    postingdate                 = <fs_head>-postingdate
*                                    confirmedexecutionstartdate = <fs_head>-postingdate
*                                    confirmedsetupenddate       = <fs_head>-postingdate
*
*                                    opconfirmedworkquantity1    = ( lv_gr_quantity *
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty1 /
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )
*
*                                    opconfirmedworkquantity2    =  ( lv_gr_quantity *
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty2 /
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )
*
*                                    opconfirmedworkquantity3    = ( lv_gr_quantity *
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty3 /
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )
*
*                                    opconfirmedworkquantity4    = ( lv_gr_quantity *
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty4 /
*                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )
*
*                                    opconfirmedworkquantity5    = <fs_head>-activity ) )
*             " TODO: variable is assigned but never used (ABAP cleaner)
*             MAPPED FINAL(mapped_conf)
*             " TODO: variable is assigned but never used (ABAP cleaner)
*             FAILED FINAL(failed_conf)
*             REPORTED FINAL(reported_conf).


      MODIFY ENTITIES OF i_productionordconfirmationtp
             ENTITY productionorderconfirmation
             CREATE FROM VALUE #( FOR gs_101_t IN gt_101
                                  ( %cid                        =  gs_101_t-item
                                    orderid                     =  <fs_head>-Productionorder
                                    orderoperation              = ls_i_manufacturingorderop-manufacturingorderoperation
                                    sequence                    = '000000'
                                    confirmationyieldquantity   = gs_101_t-powergenerated
                                    confirmationunitsapcode     = gs_101_t-uom
                                    confirmationtext            = <fs_head>-referenceid
                                    postingdate                 = <fs_head>-postingdate
                                    confirmedexecutionstartdate = <fs_head>-postingdate
                                    confirmedsetupenddate       = <fs_head>-postingdate
                                    workcenter                  = gs_101_t-turbine

                                    opconfirmedworkquantity1    = ( gs_101_t-powergenerated *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty1 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity2    =  ( gs_101_t-powergenerated *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty2 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity3    = ( gs_101_t-powergenerated *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty3 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity4    = ( gs_101_t-powergenerated *
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-workcenterstandardworkqty4 /
                                    lt_routing[ manufacturingorder = <fs_head>-productionorder ]-operationreferencequantity )

                                    opconfirmedworkquantity5    = <fs_head>-activity  * ( gs_101_t-powergenerated / lv_gr_quantity ) ) )
             " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED FINAL(mapped_conf)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(failed_conf)
             REPORTED FINAL(reported_conf).

      IF reported_conf-productionorderconfirmation IS NOT INITIAL.
        APPEND VALUE #( %tky             = <fs_head>-%tky
                        %state_area      = 'Validate_Head'
                        %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = 'Error in Post Confirmation' )
                        %element-postgen = if_abap_behv=>mk-on )
               TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head>-%tky )
               TO failed-zr_power_header.
      ELSE.

        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_header
               UPDATE
               FIELDS ( status postcnf )
               WITH VALUE #( FOR key IN keys
                             ( %tky             = <fs_head>-%tky
                               status           = 'Confirmed'
                               postcnf          = 'X'
                               %control-status  = if_abap_behv=>mk-on
                               %control-postcnf = if_abap_behv=>mk-on
                                ) ).
      ENDIF.
      CLEAR ls_cost.
    ENDLOOP.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

  METHOD getcons.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_item  TYPE zr_billet_531-item.
    DATA lv_count TYPE zde_no VALUE 1.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS  WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(ls_failed).

    READ ENTITY zr_power_header
         BY \_pow
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    TRY.
        GET TIME STAMP FIELD FINAL(lv_utctimestamp).
        " TODO: variable is assigned but never used (ABAP cleaner)
        CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE FINAL(lv_date) TIME FINAL(lv_time).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head01>).
      IF <fs_head01> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      IF <fs_head01>-%is_draft = 01.
        APPEND VALUE #( %tky             = <fs_head01>-%tky
                  %state_area      = 'Validate_Head'
                  %msg             = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text     = 'Disable the Draft Mode' )
                  %element-getcons = if_abap_behv=>mk-on )
         TO reported-zr_power_header.

        APPEND VALUE #( %tky = <fs_head01>-%tky )
               TO failed-zr_power_header.

      ELSE.

        SELECT SINGLE * FROM i_manufacturingorder
          WHERE manufacturingorder = @<fs_head01>-productionorder
          INTO @FINAL(ls_mnford).

        SELECT * FROM i_billofmaterialitemtp_3
          WHERE billofmaterial        = @ls_mnford-billofmaterial
            AND billofmaterialvariant = '01'
          INTO TABLE @FINAL(lt_bom).

        " TODO: variable is assigned but never used (ABAP cleaner)
        FINAL(lt_531) = lt_bom.
        DATA(lt_261) = lt_bom.
        DELETE lt_261 WHERE billofmaterialvariant <> '01'.
        DELETE lt_261 WHERE billofmaterialitemquantity < 0.

        " Consumption
        TRY.
            lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
        ENDTRY.

        DATA(gt_101_t) = gt_101.
        SORT gt_101_t BY turbine.
        DELETE ADJACENT DUPLICATES FROM gt_101_t COMPARING turbine.

        " TODO: variable is assigned but never used (ABAP cleaner)
        FINAL(lv_line) = lines( gt_101_t ).

        FINAL(ls_101) = VALUE #( gt_101[ turbine = '' ] OPTIONAL ).
        IF ls_101 IS INITIAL.

          FINAL(ls_261) = VALUE #( lt_261[ 1 ] OPTIONAL ).
          LOOP AT gt_101_t INTO FINAL(gs_101).
            lv_count += 1.

*          FINAL(ls_zvbilletheatf4_1) = VALUE #( lt_zvbilletheatf4_1[ heatnumber = gs_101-heatnumber ] OPTIONAL ).
            " TODO: variable is assigned but never used (ABAP cleaner)
            SELECT SINGLE * FROM i_product WHERE product = @ls_261-billofmaterialcomponent INTO @FINAL(ls_prod_261).
            MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
                   ENTITY zr_power_header
                   CREATE BY \_mat
                   FROM VALUE #( ( id      = <fs_head01>-id
                                   %target = VALUE #( ( %cid                         = <fs_head01>-referenceid && lv_count
                                                        item                         = <fs_head01>-referenceid && lv_count
                                                        referenceid                  = <fs_head01>-referenceid
                                                        turbine                      = gs_101-turbine
                                                        description                  = gs_101-description
                                                        material                     = ls_261-billofmaterialcomponent
                                                        materialdescription          = ls_261-componentdescription
                                                        uom                          = ls_261-billofmaterialitemunit
                                                        storagelocation              = gs_101-storagelocation

                                                        %control-item                = if_abap_behv=>mk-on
                                                        %control-referenceid         = if_abap_behv=>mk-on
                                                        %control-turbine             = if_abap_behv=>mk-on
                                                        %control-description         = if_abap_behv=>mk-on
                                                        %control-material            = if_abap_behv=>mk-on
                                                        %control-materialdescription = if_abap_behv=>mk-on
                                                        %control-uom                 = if_abap_behv=>mk-on
                                                        %control-storagelocation     = if_abap_behv=>mk-on ) ) ) )
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   MAPPED FINAL(ls_mapped_261)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED FINAL(ls_failed_261)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   REPORTED FINAL(ls_reported_261).
          ENDLOOP.

          MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
                 ENTITY zr_power_header
                 UPDATE
                 FIELDS ( getcons status )
                 WITH VALUE #( ( %tky    = <fs_head01>-%tky
                                 status  = 'Cons. Fetched'
*                               progress = 45
*                               noofheats = lv_line
                                 getcons = 'X' ) ).
        ELSE.

          APPEND VALUE #( %tky                 = <fs_head01>-%tky
                          %state_area          = 'Validate_Head'
                          %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                        text     = 'Consumed power cannot be determined' )
                          %element-consistency = if_abap_behv=>mk-on )
                 TO reported-zr_power_header.

          APPEND VALUE #( %tky = <fs_head01>-%tky )
                 TO failed-zr_power_header.

        ENDIF.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).
  ENDMETHOD.

  METHOD transfer.

    DATA lv_item     TYPE zr_billet_261-item.
    DATA lv_status   TYPE zr_billet_hdr-status.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_progress TYPE zr_billet_hdr-progress.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_header) FAILED FINAL(ft_header).

    READ ENTITY zr_power_header
         BY \_pow
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_101) FAILED FINAL(ft_101).

    READ ENTITY zr_power_header
         BY \_mat
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_261) FAILED FINAL(ft_261).

    READ ENTITY zr_power_header
         BY \_cons
         ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(gt_531) FAILED FINAL(ft_531).

    TRY.
        lv_item = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
      CATCH cx_uuid_error.
    ENDTRY.

    DATA(lt_531) = gt_531.
    DELETE lt_531 WHERE consumption = 0.
    FINAL(lv_lines531) = lines( lt_531 ).

    DATA(gs_101) = VALUE #( gt_101[ 1 ] OPTIONAL ).
    IF gs_101 IS NOT INITIAL.
      LOOP AT gt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
        IF <fs_head> IS NOT ASSIGNED.
          CONTINUE.
        ENDIF.

        MODIFY ENTITIES OF i_materialdocumenttp
               ENTITY materialdocument
               CREATE FROM VALUE #( ( %cid                                = lv_item
                                      goodsmovementcode                   = '04'
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
                               %target  = VALUE #( FOR gs_261_t IN gt_531
                                                   ( %cid                         = gs_261_t-material && gs_261_t-productionorderno
                                                     plant                        = <fs_head>-plant
                                                     issuingorreceivingplant      = gs_261_t-plant
                                                     material                     = gs_261_t-material
                                                     issgorrcvgmaterial           = gs_261_t-material
                                                     goodsmovementtype            = '301'
                                                     storagelocation              = gs_101-storagelocation
                                                     issuingorreceivingstorageloc = gs_261_t-storagelocation
                                                     quantityinentryunit          = gs_261_t-consumption
                                                     entryunit                    = gs_261_t-uom
                                                     materialdocumentitemtext     = <fs_head>-referenceid

                                                     %control-plant               = cl_abap_behv=>flag_changed
                                                     %control-material            = cl_abap_behv=>flag_changed
                                                     %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                                     %control-storagelocation     = cl_abap_behv=>flag_changed
                                                     %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                                     %control-entryunit           = cl_abap_behv=>flag_changed
                                                     %control-materialdocumentitemtext = cl_abap_behv=>flag_changed
                                                     %control-issuingorreceivingplant = cl_abap_behv=>flag_changed
                                                     %control-issgorrcvgmaterial = cl_abap_behv=>flag_changed
                                                     %control-issuingorreceivingstorageloc = cl_abap_behv=>flag_changed
                                                     ) ) ) )

               " TODO: variable is assigned but never used (ABAP cleaner)
               MAPPED FINAL(mapped_261)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(failed_261)
               REPORTED FINAL(reported_261).

        IF reported_261-materialdocument IS NOT INITIAL.
          APPEND VALUE #( %tky              = <fs_head>-%tky
                          %state_area       = 'Validate_Head'
                          %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                     text     = 'Error in Consumed Materials' )
                          %element-postcons = if_abap_behv=>mk-on )
                 TO reported-zr_power_header.

          APPEND VALUE #( %tky = <fs_head>-%tky )
                 TO failed-zr_power_header.

        ELSE.

          lv_status   = 'Transferred'.
          lv_progress = 90.
          MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
                 ENTITY zr_power_header
                 UPDATE
                 FIELDS ( transfer status )
                 WITH VALUE #( ( %tky     = <fs_head>-%tky
                                 status   = lv_status
                                 transfer = 'X' ) ).

        ENDIF.
      ENDLOOP.
    ENDIF.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_result).

    result = VALUE #( FOR ls_header_result IN header_result
                      ( %tky   = ls_header_result-%tky
                        %param = ls_header_result ) ).

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zr_power_generation DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_power_generation RESULT result.
    METHODS turbinemet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_power_generation~turbinemet.

ENDCLASS.


CLASS lhc_zr_power_generation IMPLEMENTATION.
  METHOD get_instance_features.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_failed).

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_generation
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_gen)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_fgen).

    DATA(ls_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR gs_header IN gt_gen
                      ( %tky                = gs_header-%tky

                        %update             = COND #( WHEN ls_header-consistency = ''
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )
                       ) ).

  ENDMETHOD.

  METHOD turbinemet.
    "ZV_TURNBINE_F4
    READ ENTITIES OF zr_power_header IN LOCAL MODE
       ENTITY zr_power_generation
       ALL FIELDS  WITH CORRESPONDING #( keys )
       RESULT FINAL(gt_power)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(ls_power).

    LOOP AT gt_power ASSIGNING FIELD-SYMBOL(<gfs_power>).
      SELECT SINGLE * FROM zv_turnbine_f4 WHERE turbine = @<gfs_power>-turbine INTO @DATA(ls_turbine).
      MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
             ENTITY zr_power_generation
             UPDATE
             FIELDS ( description )
             WITH VALUE #( ( %tky    = <gfs_power>-%tky
                             description  = ls_turbine-description
                            ) ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zr_consumed_mat DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_consumed_mat RESULT result.

ENDCLASS.


CLASS lhc_zr_consumed_mat IMPLEMENTATION.
  METHOD get_instance_features.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_failed).

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_consumed_mat
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_gen)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_fgen).

    DATA(ls_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR gs_header IN gt_gen
                      ( %tky                = gs_header-%tky

                        %update             = COND #( WHEN ls_header-consistency = ''
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )
                       ) ).

  ENDMETHOD.
ENDCLASS.


CLASS lhc_zr_power_cons DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zr_power_cons RESULT result.
    METHODS prodordmet FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zr_power_cons~prodordmet.

ENDCLASS.


CLASS lhc_zr_power_cons IMPLEMENTATION.
  METHOD get_instance_features.

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_header
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_failed).

    READ ENTITIES OF zr_power_header IN LOCAL MODE
         ENTITY zr_power_cons
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_gen)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(gt_fgen).

    DATA(ls_header) = VALUE #( gt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR gs_header IN gt_gen
                      ( %tky                = gs_header-%tky

                        %update             = COND #( WHEN ls_header-consistency = ''
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                        %delete             = COND #( WHEN ls_header-consistency = ''
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )
                       ) ).

  ENDMETHOD.
  METHOD prodordmet.

    READ ENTITY zr_power_header
         BY \_pow
         ALL FIELDS  WITH CORRESPONDING #( keys )
         RESULT FINAL(gt_headergen)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(ls_failed).

    READ ENTITIES OF zr_power_header IN LOCAL MODE
       ENTITY zr_power_cons
       ALL FIELDS  WITH CORRESPONDING #( keys )
       RESULT FINAL(gt_powercons)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(ls_powercons).

    DATA(ls_headergen) =  VALUE #( gt_headergen[ 1 ] OPTIONAL ).
    IF ls_headergen IS NOT INITIAL.
      LOOP AT gt_powercons ASSIGNING FIELD-SYMBOL(<gfs_powercons>).

        SELECT SINGLE manufacturingorder,
                      productionplant,
                      storagelocation
         FROM i_manufacturingorder
         WHERE manufacturingorder = @<gfs_powercons>-productionorderno
         INTO @DATA(ls_i_manufacturingorder).

        MODIFY ENTITIES OF zr_power_header IN LOCAL MODE
               ENTITY zr_power_cons
               UPDATE
               FIELDS ( plant material materialdescription uom )
               WITH VALUE #( ( %tky    = <gfs_powercons>-%tky
                               plant  = ls_i_manufacturingorder-productionplant
                               material  = ls_headergen-material
                               materialdescription  = ls_headergen-materialdescription
                               uom  = ls_headergen-uom
                              ) ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
