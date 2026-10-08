CLASS zcl_res_sort DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort FOR TABLE FUNCTION zr_resv_sort.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RES_SORT IMPLEMENTATION.


  METHOD sort BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING zv_serv_item .
    lt_item = select
     mandt,
     reservation,
     reservationitem,
     Product,
     productdescription,
     entryunit,
     resvnitmrequiredqtyinentryunit,
     goodsrecipientname,
     reservationitemtext
     from  zv_serv_item ;
     RETURN  select *
        from :lt_item;
  ENDMETHOD.
ENDCLASS.
