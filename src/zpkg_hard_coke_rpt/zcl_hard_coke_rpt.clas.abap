CLASS zcl_hard_coke_rpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ZTBL_FCTN_HARDCOKE.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HARD_COKE_RPT IMPLEMENTATION.


  METHOD get_data BY DATABASE FUNCTION
                       FOR HDB
                       LANGUAGE SQLSCRIPT
                       OPTIONS READ-ONLY
                       USING zcds_hard_coke_rpt i_materialdocumentitemtp I_INSPPLANMATLASSGMTVERSTP_2 I_INSPPLANOPCHARCVERSION_2.

  lt_item = SELECT * FROM zcds_hard_coke_rpt;

  lt_item_2 = SELECT a.materialdocument, a.materialdocumentitem, a.materialdocumentyear, d.inspectionspecification,
              CAST( d.INSPSPECUPPERLIMIT as DEC( 13, 3 ) ) as INSPSPECUPPERLIMIT
              from :lt_item as a
              INNER JOIN I_INSPPLANMATLASSGMTVERSTP_2 as c ON a.material = c.material and a.plant = c.plant
              INNER JOIN I_INSPPLANOPCHARCVERSION_2 as d ON d.inspectionplangroup = c.inspectionplangroup and c.inspectionplan = d.inspectionplan
                                                   and d.boooperationinternalid = c.inspplanmatlassgmtintversion and d.isdeleted <> 'X'
                                                   and d.inspectionspecification IN ( 'ITEMASH%' , 'MOISTURE' ) ;

  lt_item_1 = select CAST( a.mandt_1 as Char( 3 ) ) as mandt, a.materialdocument, a.materialdocumentitem,
                   a.materialdocumentyear, a.postingdate, a.supplier, a.suppliername,a.materialbaseunit,
*                   CAST( b.YY1_ChallanNumber_MMI as CHAR( 30 ) ) as challanno,
0.00 as challanno,
                   a.material, a.productname, a.plant, a.storagelocation, a.quantityinentryunit,
*                   a.materialbaseunit, b.YY1_NetWeight_MMI as plantqty,
0.00 as plantqty,
*                   ( a.quantityinentryunit - b.YY1_NetWeight_MMI ) as wtdiff,
0.00 as wtdiff,
                   a.netpriceamount, a.documentcurrency, ( a.quantityinentryunit * a.netpriceamount ) as totbill,
*                   ( b.YY1_NetWeight_MMI * a.netpriceamount ) as totpay,
0.00 as totpay,
                   a.uash, a.umois, c.INSPSPECUPPERLIMIT as uashup, d.INSPSPECUPPERLIMIT as umoisup
            from :lt_item as a
            INNER JOIN i_materialdocumentitemtp as b ON a.materialdocument = b.materialdocument
            AND a.materialdocumentitem = b.materialdocumentitem and a.materialdocumentyear = b.materialdocumentyear
            LEFT OUTER JOIN :lt_item_2 as c on a.materialdocument = c.materialdocument AND a.materialdocumentitem = c.materialdocumentitem
                                           and a.materialdocumentyear = c.materialdocumentyear and c.inspectionspecification = 'ITEMASH%'
            LEFT OUTER JOIN :lt_item_2 as d on a.materialdocument = d.materialdocument AND a.materialdocumentitem = d.materialdocumentitem
                                           and a.materialdocumentyear = d.materialdocumentyear and d.inspectionspecification = 'MOISTURE';

  lt_item_3 = select mandt, materialdocument, materialdocumentitem, materialdocumentyear, postingdate, supplier, suppliername,
                     challanno, material, productname, plant, storagelocation, quantityinentryunit, materialbaseunit, plantqty,
                     wtdiff, netpriceamount, documentcurrency, totbill, totpay, uash, umois, uashup, umoisup
              from :lt_item_1;

  RETURN  select *
       from :lt_item_3
     ORDER BY materialdocument ASC, materialdocumentyear ASC, materialdocumentitem ASC;

  ENDMETHOD.
ENDCLASS.
