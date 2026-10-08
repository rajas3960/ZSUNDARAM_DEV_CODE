CLASS zcl_po_email DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_email.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PO_EMAIL IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                       USING zi_customer_email.
    lt_item = select
                     mandt,
                     businesspartner,
                     emailaddress
      from  zi_customer_email;

     RETURN  select *
        from :lt_item;
  ENDMETHOD.
ENDCLASS.
