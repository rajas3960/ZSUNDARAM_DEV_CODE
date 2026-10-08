CLASS zcl_del_text_01 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  TYPES: begin of ty_text,
         client TYPE sy-mandt,
         BillingDocument TYPE char10,
         Language TYPE char2,
         TextID TYPE char4,
         LongText TYPE char200,
         END OF TY_TEXT.
  TYPES : tt_text TYPE TABLE of ty_text.
  class-data : gt_text TYPE table of ty_text.
  class-data : gs_text TYPE ty_text.
*  INTERFACES if_oo_adt_classrun.
  class-methods get_text
  IMPORTING
  !billingdocument  TYPE char10
  EXPORTING
  gt_text TYPE  tt_text.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEL_TEXT_01 IMPLEMENTATION.


method get_text.

*
   CONSTANTS: c_i TYPE char10 VALUE ''''.
   DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

    lo_factory->query_ca(
      EXPORTING
        is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_SAP_COM_0120' ) ) ) " Custom Communication Scenario
      IMPORTING
        et_com_arrangement = DATA(lt_comm_arrang) ).

    DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = CONV #( 'YY1_SAP_COM_0120' )" Use Custom Communicaiton Scenario, Not standard!
          comm_system_id = lo_comm_arrang->get_comm_system_id( )
          service_id     = CONV #( 'YY1_BILLINGINTEGRATION_REST' )" Outbound Service ID
        ).
      CATCH cx_http_dest_provider_error INTO DATA(lo_error).
        DATA(lv_message) = lo_error->get_longtext( ).
    ENDTRY.

    TRY.
        DATA(eo_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    DATA(eo_request) = eo_client->get_http_request( ).
    eo_request->set_content_type( content_type = |application/json| ).

     data(lv_billdoc) = |{ billingdocument ALPHA = IN }|.
*    data(lv_billdoc) = '9210000012'.
    data(lv_path) = |A_BillingDocument('{ lv_billdoc }')/to_Text|.
*    eo_request->set_uri_path( i_uri_path = 'A_BillingDocument(''9210000012'')/to_Text' ).
    eo_request->set_uri_path( i_uri_path = lv_path ).

    TRY.
        DATA(lo_response) = eo_client->execute( i_method = if_web_http_client=>get ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    DATA(lv_resp_satus) = lo_response->get_status( ).
    DATA(lv_resp_text) = lo_response->get_text( ).

DATA: lv_atom_xml TYPE string,
      lv_abap_xml TYPE string,
      lt_final_xml TYPE TABLE OF string,
      lv_final_xml TYPE string,
      lt_entries TYPE TABLE OF string,
      lv_entry1 TYPE string,
      lv_billing_document TYPE string,
      lv_language TYPE string,
      lv_longtext_id TYPE string,
      lv_longtext TYPE string,
      lv_start_pos TYPE i,                    " Start position for extracting values
      lv_end_pos TYPE i,                      " End position for extracting values
      lv_substr TYPE string,                  " Temp variable for extracted value
      lv_length TYPE i.                       " Length for substring extraction

*input Atom XML as string (Example)
lv_atom_xml = lv_resp_text.

DATA: lt_atom_entries TYPE TABLE OF string.   " Internal table to store dynamic XML entries

* Transform XML using CALL TRANSFORMATION
TRY.
    CALL TRANSFORMATION id
      SOURCE XML lv_atom_xml
      RESULT XML lv_abap_xml.
  CATCH cx_root INTO DATA(lx_error).
ENDTRY.

* Split the XML into entries based on "<entry>" tag
SPLIT lv_atom_xml AT '<entry>' INTO TABLE lt_atom_entries.

* Loop through the entries (dynamic data)
LOOP AT lt_atom_entries INTO DATA(lv_entry).
" Find and extract BillingDocument
  FIND '<d:BillingDocument>' IN lv_entry MATCH OFFSET lv_start_pos.
  IF sy-subrc = 0.
    lv_start_pos = lv_start_pos + 19. " Length of <d:BillingDocument> tag
    FIND '</d:BillingDocument>' IN lv_entry MATCH OFFSET lv_end_pos.
        if sy-subrc = 0.
         lv_length = lv_end_pos - lv_start_pos .
         lv_substr = lv_entry+lv_start_pos(lv_length).
         lv_billing_document = lv_substr.
        gs_text-billingdocument = lv_billing_document .
       ENDIF.
  ENDIF.

  " Find and extract Language
  FIND '<d:Language>' IN lv_entry MATCH OFFSET lv_start_pos.
   IF sy-subrc = 0.
     lv_start_pos = lv_start_pos + 12. " Length of <d:Language> tag
     FIND '</d:Language>' IN lv_entry MATCH OFFSET lv_end_pos.
      if sy-subrc = 0.
    " Extract Language value using SUBSTRING
       lv_length = lv_end_pos - lv_start_pos .
       lv_substr = lv_entry+lv_start_pos(lv_length).
       lv_language = lv_substr.
       gs_text-language = lv_language .
      ENDIF.
   ENDIF.

  " Find and extract LongTextID
  FIND '<d:LongTextID>' IN lv_entry MATCH OFFSET lv_start_pos.
  IF sy-subrc = 0.
     lv_start_pos = lv_start_pos + 14. " Length of <d:LongTextID> tag
      FIND '</d:LongTextID>' IN lv_entry MATCH OFFSET lv_end_pos.
      if sy-subrc = 0.
      " Extract LongTextID value using SUBSTRING
      lv_length = lv_end_pos - lv_start_pos .
      lv_substr = lv_entry+lv_start_pos(lv_length).
      lv_longtext_id = lv_substr.
      gs_text-textid = lv_longtext_id .
      ENDIF.
   ENDIF.

  " Find and extract LongText
  FIND '<d:LongText>' IN lv_entry MATCH OFFSET lv_start_pos.
  IF sy-subrc = 0.
   FIND '</d:LongText>' IN lv_entry MATCH OFFSET lv_end_pos.
      if sy-subrc = 0.
      lv_start_pos = lv_start_pos + 12. " Length of <d:LongText> tag
      " Extract LongText value using SUBSTRING
      lv_length = lv_end_pos - lv_start_pos .
      lv_substr = lv_entry+lv_start_pos(lv_length).
      lv_longtext = lv_substr.
      gs_text-longtext = lv_longtext .
     ENDIF.
  ENDIF.
  if not gs_text is INITIAL.
  gs_text-client = sy-mandt.
  APPEND gs_text to gt_text.
  clear : gs_text.
  endif.
ENDLOOP.
data : gt_text01 TYPE TABLE of zsd_billing_txt.
MOVE-CORRESPONDING gt_text TO gt_text01 .
MODIFY zsd_billing_txt FROM TABLE @gt_text01.
ENDMETHOD.
ENDCLASS.
