CLASS lhc_zi_transation_report DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_transation_report RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_transation_report RESULT result.

    METHODS post FOR MODIFY
      IMPORTING keys FOR ACTION zi_transation_report~post RESULT result.

    METHODS postdoc FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_transation_report~postdoc.

ENDCLASS.

CLASS lhc_zi_transation_report IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD post.
  ENDMETHOD.

  METHOD postdoc.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_error_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_error_item RESULT result.

ENDCLASS.

CLASS lhc_zi_error_item IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_transation_report DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_transation_report IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
