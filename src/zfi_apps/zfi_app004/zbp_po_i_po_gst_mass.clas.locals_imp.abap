CLASS lhc_zpo_i_po_gst_mass DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zpo_i_po_gst_mass RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zpo_i_po_gst_mass RESULT result.
    METHODS daterange FOR MODIFY
      keys FOR ACTION zpo_i_po_gst_mass~daterange RESULT result.

    METHODS getpost FOR MODIFY
      keys FOR ACTION zpo_i_po_gst_mass~getpost RESULT result.

ENDCLASS.

CLASS lhc_zpo_i_po_gst_mass IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD DateRange.

   READ ENTITIES OF zpo_i_po_gst_mass IN LOCAL MODE
    ENTITY zpo_i_po_gst_mass
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_mass).

  LOOP AT lt_mass ASSIGNING FIELD-SYMBOL(<ls_mass>).

    MODIFY ENTITIES OF zpo_i_po_gst_mass IN LOCAL MODE
      ENTITY zpo_i_po_gst_mass
      UPDATE FIELDS ( fromdate todate )
      WITH VALUE #(
        ( %tky    = <ls_mass>-%tky
          fromdate = keys[ 1 ]-%param-FromDate
          todate   = keys[ 1 ]-%param-ToDate )
      ).

    APPEND VALUE #(
      %tky = <ls_mass>-%tky
      %param = <ls_mass>
    ) TO result.

  ENDLOOP.

  ENDMETHOD.

  METHOD GetPost.
  ENDMETHOD.

ENDCLASS.
