CLASS zcl_qlty_item_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data FOR TABLE FUNCTION ztbl_fctn_item.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_QLTY_ITEM_PRINT IMPLEMENTATION.


  METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING zdt_quality_itm.

    lt_item = select * from zdt_quality_itm WHERE client = :client ;



    lt_item1 = SELECT   client ,
                        id,
                        item,
                        billingdoc,
                        billingitem,
                        batch,
                        quantity,
                        charname,
                        chardesc,
                        maxlimit,
                        minlimit,
                        results ,
                        remarks,
                        uom,
                        uomname,
                        test_method_text,
                        test_range
                    from :lt_item ;

      RETURN  select * from :lt_item1 WHERE client = :client
      ORDER BY item;


  ENDMETHOD.
ENDCLASS.
