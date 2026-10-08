CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZREGISTEREDOFFICEDET'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'RegisteredOfficeDet' table = 'ZDT_REGOFFICE' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_REGISTEREDOFFICEDET_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR RegisteredOfficeAll
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RegisteredOfficeAll~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR RegisteredOfficeAll
        RESULT result,
      EDIT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RegisteredOfficeAll~edit.
ENDCLASS.

CLASS LHC_ZI_REGISTEREDOFFICEDET_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    result = VALUE #( FOR key in keys (
               %TKY = key-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_RegisteredOfficeDet = edit_flag
               %FIELD-TransportRequestID = transport_feature
               %ACTION-SelectCustomizingTransptReq = COND #( WHEN key-%IS_DRAFT = if_abap_behv=>mk-off
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE selecttransport_flag ) ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeAll
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeAll
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_REGISTEREDOFFICEDET' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD EDIT.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_RegisteredOfficeDet_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-RegisteredOfficeAll = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_REGISTEREDOFFICEDET_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_REGISTEREDOFFICEDET_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    DATA(transport_from_singleton) = VALUE #( update-RegisteredOfficeAll[ 1 ]-TransportRequestID OPTIONAL ).
    IF transport_from_singleton IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = transport_from_singleton
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_REGISTEREDOFFICEDET DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR RegisteredOfficeDet~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR RegisteredOfficeDet
        RESULT result,
      DEPRECATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RegisteredOfficeDet~Deprecate
        RESULT result,
      INVALIDATE FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RegisteredOfficeDet~Invalidate
        RESULT result,
      COPYREGISTEREDOFFICEDET FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RegisteredOfficeDet~CopyRegisteredOfficeDet,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR RegisteredOfficeDet
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR RegisteredOfficeDet
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_REGISTEREDOFFICEALL FOR RegisteredOfficeAll~ValidateTransportRequest
          KEYS_REGISTEREDOFFICEDET FOR RegisteredOfficeDet~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_REGISTEREDOFFICEDET IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(RegisteredOfficeDet).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZDT_REGOFFICE' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE REF TO if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT RegisteredOfficeDet ASSIGNING FIELD-SYMBOL(<RegisteredOfficeDet>).
      element_checks = VALUE #(
        ( element = 'ConfigDeprecationCode' check = table->field( 'CONFIGDEPRECATIONCODE' )->get_value_check( ia_value = <RegisteredOfficeDet>-ConfigDeprecationCode  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <RegisteredOfficeDet>-%TKY
                        %STATE_AREA = |RegisteredOfficeDet_{ element_check-element }| ) INTO TABLE reported-RegisteredOfficeDet.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <RegisteredOfficeDet>-%TKY ) INTO TABLE failed-RegisteredOfficeDet.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <RegisteredOfficeDet>-%TKY
                          %STATE_AREA = |RegisteredOfficeDet_{ element_check-element }|
                          %PATH-RegisteredOfficeAll-SingletonID = 1
                          %PATH-RegisteredOfficeAll-%IS_DRAFT = <RegisteredOfficeDet>-%IS_DRAFT
                          %msg = mbc_cp_api=>message( )->get_behv_msg_from_value_check( <msg> ) ) INTO TABLE reported-RegisteredOfficeDet ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
  ENDMETHOD.
  METHOD DEPRECATE.
    MODIFY ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'W'
                         ConfigDeprecationCode_Critlty = 2 ) ).
    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(RegisteredOfficeDet).
    result = VALUE #( FOR row IN RegisteredOfficeDet
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-RegisteredOfficeDet = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Deprecate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_deprecated( )
                                                   %PATH-RegisteredOfficeAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-RegisteredOfficeAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD INVALIDATE.
    MODIFY ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      UPDATE
        FIELDS ( ConfigDeprecationCode ConfigDeprecationCode_Critlty )
        WITH VALUE #( FOR key IN keys
                       ( %TKY            = key-%TKY
                         ConfigDeprecationCode            = 'E'
                         ConfigDeprecationCode_Critlty = 1 ) ).
    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(RegisteredOfficeDet).
    result = VALUE #( FOR row IN RegisteredOfficeDet
                        ( %TKY   = row-%TKY
                          %PARAM  = row ) ).
    reported-RegisteredOfficeDet = VALUE #( FOR key IN keys ( %CID = key-%CID_REF
                                                   %TKY = key-%TKY
                                                   %ACTION-Invalidate = if_abap_behv=>mk-on
                                                   %ELEMENT-ConfigDeprecationCode = if_abap_behv=>mk-on
                                                   %msg = mbc_cp_api=>message( )->get_item_invalidated( )
                                                   %PATH-RegisteredOfficeAll-%IS_DRAFT = key-%IS_DRAFT
                                                   %PATH-RegisteredOfficeAll-SingletonID = 1
          ) ).
  ENDMETHOD.
  METHOD COPYREGISTEREDOFFICEDET.
    DATA new_RegisteredOfficeDet TYPE TABLE FOR CREATE ZI_RegisteredOfficeDet_S\_RegisteredOfficeDet.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-RegisteredOfficeDet = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_RegisteredOfficeDet)
        FAILED DATA(read_failed).

    IF ref_RegisteredOfficeDet IS NOT INITIAL.
      ASSIGN ref_RegisteredOfficeDet[ 1 ] TO FIELD-SYMBOL(<ref_RegisteredOfficeDet>).
      DATA(key) = keys[ KEY draft %TKY = <ref_RegisteredOfficeDet>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_RegisteredOfficeDet>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_RegisteredOfficeDet>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_RegisteredOfficeDet> EXCEPT
          SingletonID
          ConfigDeprecationCode
          Id
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_RegisteredOfficeDet ASSIGNING FIELD-SYMBOL(<new_RegisteredOfficeDet>).

      MODIFY ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
        ENTITY RegisteredOfficeAll CREATE BY \_RegisteredOfficeDet
        FIELDS (
                 CompanyCode
                 RegOffice
                 Email
                 Contact
                 Website
                 Cin
               ) WITH new_RegisteredOfficeDet
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-RegisteredOfficeDet = mapped_create-RegisteredOfficeDet.
    ENDIF.

    INSERT LINES OF read_failed-RegisteredOfficeDet INTO TABLE failed-RegisteredOfficeDet.

    IF failed-RegisteredOfficeDet IS INITIAL.
      reported-RegisteredOfficeDet = VALUE #( FOR created IN mapped-RegisteredOfficeDet (
                                                 %CID = created-%CID
                                                 %ACTION-CopyRegisteredOfficeDet = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-RegisteredOfficeAll-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-RegisteredOfficeAll-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_REGISTEREDOFFICEDET' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-Deprecate = is_authorized.
    result-%ACTION-Invalidate = is_authorized.
    result-%ACTION-CopyRegisteredOfficeDet = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys )
      RESULT DATA(RegisteredOfficeDet).
    DATA keys_act LIKE keys.
    LOOP AT keys INTO DATA(key) USING KEY draft WHERE %is_draft = if_abap_behv=>mk-on.
      key-%is_draft = if_abap_behv=>mk-off.
      INSERT key INTO TABLE keys_act.
    ENDLOOP.
    READ ENTITIES OF ZI_RegisteredOfficeDet_S IN LOCAL MODE
      ENTITY RegisteredOfficeDet
      FIELDS ( ConfigDeprecationCode ) WITH CORRESPONDING #( keys_act )
      RESULT DATA(RegisteredOfficeDet_act).
    LOOP AT keys INTO key.
      DATA(delete) = if_abap_behv=>fc-o-disabled.
      DATA(deprecate) = if_abap_behv=>fc-o-disabled.
      DATA(invalidate) = if_abap_behv=>fc-o-disabled.
      DATA(copy) = if_abap_behv=>fc-o-disabled.
      IF key-%IS_DRAFT = if_abap_behv=>mk-on.
        copy = if_abap_behv=>fc-o-enabled.
        READ TABLE RegisteredOfficeDet WITH KEY draft COMPONENTS %TKY = key-%TKY ASSIGNING FIELD-SYMBOL(<RegisteredOfficeDet>).
        IF <RegisteredOfficeDet>-ConfigDeprecationCode = ''.
          deprecate = if_abap_behv=>fc-o-enabled.
          invalidate = if_abap_behv=>fc-o-enabled.
        ELSEIF <RegisteredOfficeDet>-ConfigDeprecationCode = 'W'.
          invalidate = if_abap_behv=>fc-o-enabled.
        ENDIF.
        IF NOT line_exists( RegisteredOfficeDet_act[ KEY entity COMPONENTS %KEY = key-%KEY ] ).
          delete = if_abap_behv=>fc-o-enabled.
        ENDIF.
      ENDIF.
      INSERT VALUE #( %TKY = key-%TKY
                      %DELETE = delete
                      %ACTION-CopyRegisteredOfficeDet = copy
                      %ACTION-deprecate = deprecate
                      %ACTION-invalidate = invalidate ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    CHECK keys_RegisteredOfficeDet IS NOT INITIAL.
    DATA change TYPE REQUEST FOR CHANGE ZI_RegisteredOfficeDet_S.
    READ ENTITY IN LOCAL MODE ZI_RegisteredOfficeDet_S
    FIELDS ( TransportRequestID ) WITH CORRESPONDING #( keys_RegisteredOfficeAll )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZDT_REGOFFICE' keys = REF #( keys_RegisteredOfficeDet ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
