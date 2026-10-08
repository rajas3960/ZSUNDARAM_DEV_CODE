CLASS zcl_po_det DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztbl_fctn_user_details.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PO_DET IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
*                     USING i_buspartemailaddresstp_3 i_buspartmobilephonenumbertp_3 i_businessuservh.
                      USING ZI_CUSTOMER_PHN .
    lt_item = select
                     mandt,
                     businesspartner,
                     emailaddress,
                     completetelephonenumber
*      from  i_businessuservh as a left outer join
*      i_buspartmobilephonenumbertp_3 as b on a.businesspartner = b.businesspartner
*      left outer join i_buspartemailaddresstp_3 as c on a.businesspartner = c.businesspartner;
       from  ZI_CUSTOMER_PHN ;


     return  select *
        from :lt_item;
  endmethod.
ENDCLASS.
