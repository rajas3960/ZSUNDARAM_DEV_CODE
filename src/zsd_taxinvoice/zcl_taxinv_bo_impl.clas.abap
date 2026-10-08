CLASS zcl_taxinv_bo_impl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TAXINV_BO_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA rt_table TYPE TABLE OF zi_taxinvhdr_print.

    IF NOT io_request->is_data_requested( ).
      RETURN.
    ENDIF.

    FINAL(lo_filter) = io_request->get_filter( ).
    TRY.
        FINAL(lt_range) = lo_filter->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'SERIALINVOICENO' ] ).
      " Need select parameter!
      RETURN.
    ENDIF.


    DATA: lv_amount          TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_total_amount    TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_total_amount1   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tax_amount1     TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tax_amount      TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_disc_amount     TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_overall_freight TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tax_rate_value  TYPE i_billingdocumentitemprcgelmnt-conditionratevalue,
          lv_rate_per_unit   TYPE i_salesdocumentitem-netpriceamount,
          lv_tax             TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_total_tax       TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_order_quantity  TYPE i_billingdocumentitem-billingquantity,
          lt_item            TYPE TABLE OF zsd_taxitemprint.

    DATA:roundoff_char TYPE string.
    DATA: lv_samplediv TYPE i_salesdocumentitem-division.

    CLEAR lv_samplediv.

    DATA(ls_id) = VALUE #( lt_range[ name = 'SERIALINVOICENO' ]-range[ 1 ] OPTIONAL ).
    DATA(lv_id1) = ls_id-low.

    SELECT SINGLE salesdocument, billingdocument, transactioncurrency
        FROM i_billingdocumentitem WITH PRIVILEGED ACCESS
        WHERE billingdocument = @lv_id1
        INTO @DATA(ls_doc).

    IF sy-subrc IS INITIAL.
      SELECT * FROM i_billingdocumentitem WITH PRIVILEGED ACCESS
         WHERE billingdocument = @lv_id1
         INTO TABLE @DATA(lt_bdoc).

      IF sy-subrc IS INITIAL.

        SELECT * FROM i_billingdocumentitemprcgelmnt WITH PRIVILEGED ACCESS
            WHERE billingdocument = @lv_id1
            INTO TABLE @DATA(lt_tax).

        LOOP AT lt_bdoc INTO DATA(ls_bdoc) WHERE billingdocument = ls_doc-billingdocument.
          CLEAR lv_amount.
          CLEAR lv_tax_amount.
          CLEAR lv_disc_amount.
          CLEAR lv_overall_freight.
          CLEAR lv_tax.
          lv_order_quantity = ls_bdoc-billingquantity.

          LOOP AT lt_tax INTO DATA(ls_rate) WHERE billingdocument = ls_doc-billingdocument AND billingdocumentitem = ls_bdoc-billingdocumentitem
              AND ( conditiontype = 'ZPR1' OR conditiontype = 'ZPR0' OR conditiontype = 'ZPR2' OR conditiontype = 'ZPEX' OR conditiontype = 'ZP01' OR
              conditiontype = 'ZP02' OR conditiontype = 'ZSRP' OR conditiontype = 'ZAST' OR conditiontype = 'ZSAM' OR conditiontype = 'ZSTO' OR
              conditiontype = 'ZVPR' ).

            IF ls_rate-conditioninactivereason EQ 'X'.

              CONTINUE.

            ENDIF.

            lv_amount = lv_amount + ls_rate-conditionrateamount * lv_order_quantity.

            IF ls_bdoc-division NE '1S'.

              LOOP AT lt_tax INTO DATA(ls_tax1) WHERE billingdocument = ls_doc-billingdocument AND billingdocumentitem = ls_bdoc-billingdocumentitem
           AND ( conditiontype = 'ZVOL' OR conditiontype = 'ZCSH'  OR conditiontype = 'ZSPL' OR conditiontype = 'ZADV' OR conditiontype = 'ZFIT').

*                  lv_disc_amount = lv_disc_amount + ( lv_amount * ls_tax1-ConditionRateValue ) / 100.
                lv_amount = lv_amount + ls_tax1-conditionamount.
                IF ls_tax1-conditionamount IS NOT INITIAL.
                  DATA(lv_disflag) = 'X'.
                ENDIF.

              ENDLOOP.

              LOOP AT lt_tax INTO DATA(ls_tax2) WHERE billingdocument = ls_doc-billingdocument AND billingdocumentitem = ls_bdoc-billingdocumentitem
           AND ( conditiontype = 'ZFR1' OR conditiontype = 'ZFRT' ).
                lv_amount = lv_amount + ls_tax2-conditionamount.
                IF ls_tax2-conditionamount IS NOT INITIAL.
                  DATA(lv_freflag) = 'X'.
                ENDIF.

              ENDLOOP.

              LOOP AT lt_tax INTO DATA(ls_tax) WHERE billingdocument = ls_doc-billingdocument AND billingdocumentitem = ls_bdoc-billingdocumentitem
           AND ( conditiontype = 'JOCG' OR conditiontype = 'JOSG' OR conditiontype = 'JOIG' OR conditiontype = 'JOUG' OR conditiontype = 'JTC1' OR conditiontype = 'JTC2' ).
*                    lv_tax_amount = lv_tax_amount + ( lv_amount * ls_tax-conditionratevalue ) / 100 .
                IF ls_tax-conditionquantity NE 0.
                  lv_amount = lv_amount + ( lv_amount * ls_tax-conditionratevalue ) / 100 .
                  lv_tax = lv_tax +  ( lv_amount * ls_tax-conditionratevalue ) / 100.
                ELSE.
                  lv_amount = lv_amount + ls_tax-conditionamount.
                  lv_tax = lv_tax + ls_tax-conditionamount.
                ENDIF.
                IF ls_tax-conditiontype EQ 'JOCG' AND ls_tax-conditionamount IS NOT INITIAL.
                  DATA(lv_cgstflag) = 'X'.
                ELSEIF ls_tax-conditiontype EQ 'JOSG' AND ls_tax-conditionamount IS NOT INITIAL.
                  DATA(lv_sgstflag) = 'X'.
                ELSEIF ls_tax-conditiontype EQ 'JOIG' AND ls_tax-conditionamount IS NOT INITIAL.
                  DATA(lv_igstflag) = 'X'.
                ELSEIF ls_tax-conditiontype EQ 'JOUG' AND ls_tax-conditionamount IS NOT INITIAL.
                  DATA(lv_utgstflag) = 'X'.
                ELSEIF ( ls_tax-conditiontype EQ 'JTC1' OR ls_tax-conditiontype EQ 'JTC2' ) AND ls_tax-conditionamount IS NOT INITIAL.
                  DATA(lv_tcsflag) = 'X'.
                ENDIF.
              ENDLOOP.

            ELSEIF lv_samplediv NE '1S'.

              lv_samplediv = '1S'.

            ENDIF.

          ENDLOOP.
          lv_total_amount = lv_total_amount + lv_amount. "+ lv_tax_amount + lv_disc_amount.
          lv_total_tax = lv_total_tax + lv_tax.
          lv_total_amount1 = lv_total_amount + lv_total_tax .
        ENDLOOP.

      ENDIF.
    ENDIF.

    SELECT SINGLE exchangedrate FROM zi_taxinvoice_header
     WHERE serialinvoiceno = @lv_id1
      INTO @DATA(lv_er).

    IF sy-subrc IS INITIAL.

      lv_total_amount = lv_total_amount * lv_er.
      lv_total_tax = lv_total_tax * lv_er.
      lv_total_amount1 = lv_total_amount1 * lv_er.
    ENDIF.


*************************************************************************************
*    SELECT SUM( conditionamount ) AS taxvalue, billingdocument
*      FROM i_billingdocumentitemprcgelmnt WITH PRIVILEGED ACCESS
*     WHERE  billingdocument = @lv_id1
*     AND conditiontype IN ( 'JOCG','JOSG','JOIG','JTC2','ZCES' )
*     GROUP BY billingdocument
*     INTO TABLE @DATA(lt_condn).
*
*    SELECT SUM( conditionamount ) AS taxvalue, billingdocument
*    FROM i_billingdocumentitemprcgelmnt
*    WITH PRIVILEGED ACCESS
*    WHERE billingdocument = @lv_id1
*    AND conditiontype IN ( 'ZPR0','JOCG','JOSG','JOIG','JTC2','DRD1','ZCES' )
*    GROUP BY billingdocument
*    INTO TABLE @DATA(lt_totalamount).
*    READ TABLE lt_totalamount INTO DATA(ls_tot) WITH KEY billingdocument = lv_id1.
*    READ TABLE lt_condn INTO DATA(ls_condn) WITH KEY billingdocument = lv_id1.
    SELECT SUM( taxableamount ) AS billamt,billingdocument FROM zi_taxinvoice_item
    WHERE billingdocument = @lv_id1
    GROUP BY billingdocument
    INTO TABLE @DATA(lt_sum_amt).

    SELECT SUM( cgst ) AS cgst,
    SUM( sgst ) AS sgst,
    SUM( igst ) AS igst,
    SUM( tcs ) AS tcs,
    SUM( freight ) AS freight,
    SUM( roundoff ) AS roundoff,
    billingdocument FROM zi_taxinvoice_item
   WHERE billingdocument = @lv_id1
   GROUP BY billingdocument
   INTO TABLE @DATA(lt_sum_tax).
    READ TABLE lt_sum_amt INTO DATA(ls_sum_amt) WITH KEY billingdocument = lv_id1.
    READ TABLE lt_sum_tax INTO DATA(ls_sum_tax) WITH KEY billingdocument = lv_id1.
    data:totAL_TAX TYPE DMBTR.
    total_tax = ls_sum_tax-cgst + ls_sum_tax-sgst + ls_sum_tax-igst ."+ ls_sum_tax-tcs + ls_sum_tax-freight ."+ ls_sum_tax-roundoff.

    CLEAR: roundoff_char.
    IF ls_sum_tax-roundoff < 0.
      roundoff_char = ls_sum_tax-roundoff * -1.
      roundoff_char = |-| && roundoff_char.
      ELSE.
          roundoff_char = ls_sum_tax-roundoff.
    ENDIF.

**************************************************************************************
    DATA : lv_dec TYPE string.
    DATA : lv_dec2 TYPE string.
    DATA: lv_amt TYPE string .
    DATA: lv_amt2 TYPE string .
    DATA: lv_amtinword TYPE string.
    DATA: lv_taxinword TYPE string.
*   lv_amt = lv_total_amount.                -- by sp on 01.08.25
*    lv_amt2 = lv_total_tax.                 -- by sp on 01.08.25
    lv_amt = ls_sum_amt-billamt + total_tax + ls_sum_tax-tcs + ls_sum_tax-freight + ls_sum_tax-roundoff .
    lv_amt2 =  total_tax ."ls_condn-taxvalue.
    DATA(lv_amtwrd) = zcl_amount_in_words=>znumword( EXPORTING iv_num = lv_amt
                           CHANGING rv_dec_words = lv_dec ).
*    DATA(lv_amtwrd) = yy1_yy1_decimal2word=>dec2word( EXPORTING iv_num = lv_amt
*                           CHANGING cv_dec = lv_dec ).

*    YY1_AMOUNTINWORDS_BDI = |{ lv_amtwrd } Rupees { lv_dec } Paise|.
    IF ls_doc-transactioncurrency = 'INR'
    OR lv_er NE 1.
      lv_amtinword = |{ lv_amtwrd } Rupees Only| .  " { lv_dec } Paise
    ELSEIF ls_doc-transactioncurrency = 'USD'.
      lv_amtinword = |{ lv_amtwrd } Dollars Only| . " { lv_dec } Cents
    ENDIF.

    DATA(lv_amtwrd2) = zcl_amount_in_words=>znumword( EXPORTING iv_num = lv_amt2
                           CHANGING rv_dec_words = lv_dec2 ).
*    DATA(lv_amtwrd) = yy1_yy1_decimal2word=>dec2word( EXPORTING iv_num = lv_amt
*                           CHANGING cv_dec = lv_dec ).

*    YY1_AMOUNTINWORDS_BDI = |{ lv_amtwrd } Rupees { lv_dec } Paise|.
    IF ls_doc-transactioncurrency = 'INR'
    OR lv_er NE 1.
      lv_taxinword = |{ lv_amtwrd2 } Rupees { lv_dec2 } Paise Only| .  "
    ELSEIF ls_doc-transactioncurrency = 'USD'.
      lv_taxinword = |{ lv_amtwrd2 } Dollars { lv_dec2 } Cents Only| . "
    ENDIF.

    LOOP AT lt_range[ name = 'SERIALINVOICENO' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      FINAL(lv_id) = <ls_range>-low.
      SELECT SINGLE * FROM zi_taxinvoice_header
        WHERE serialinvoiceno = @lv_id
        INTO @DATA(ls_rev).

      SELECT SINGLE soldtoparty AS consignee, receiver, caddressid, raddressid
        FROM zr_rec_con WHERE billingdocument = @ls_rev-serialinvoiceno INTO @DATA(ls_address).

      SELECT SINGLE *
     FROM zdt_einveway WHERE vbeln = @ls_rev-serialinvoiceno INTO @DATA(ls_irn).

      SELECT SINGLE *
      FROM zdt_ccodeaddress
      WHERE bukrs = @ls_rev-companycode INTO @DATA(ls_code).

      IF ls_address-consignee IS NOT INITIAL.

        SELECT SINGLE address
          FROM  zdt_address
          WHERE bp = @ls_address-consignee
*          AND   addressid = @ls_address-caddressid
          INTO  @DATA(lv_cfulladdress).
*
        IF sy-subrc IS INITIAL.
*
          REPLACE ALL OCCURRENCES OF '\r' IN lv_cfulladdress WITH ''.
          REPLACE ALL OCCURRENCES OF '\n' IN lv_cfulladdress WITH ' '.
*
          CONDENSE lv_cfulladdress.
*
        ENDIF.

      ENDIF.

      IF ls_address-receiver IS NOT INITIAL.

        SELECT SINGLE address
          FROM  zdt_address
          WHERE bp = @ls_address-receiver
*          AND   addressid = @ls_address-RAddressid
          INTO  @DATA(lv_rfulladdress).
*
        IF sy-subrc IS INITIAL.
*
          REPLACE ALL OCCURRENCES OF '\r' IN lv_rfulladdress WITH ''.
          REPLACE ALL OCCURRENCES OF '\n' IN lv_rfulladdress WITH ' '.
*
          CONDENSE lv_rfulladdress.
*
        ENDIF.
*
      ENDIF.

      IF ls_rev-bitmapcode IS NOT INITIAL.

        DATA(lv_bitmapflag) = 'X'.

      ENDIF.

      IF ls_rev-orderdate IS NOT INITIAL.

        DATA(lv_date) = ls_rev-orderdate+6(2) && '/' && ls_rev-orderdate+4(2) && '/' && ls_rev-orderdate+0(4).

      ENDIF.

      REPLACE ALL OCCURRENCES OF '\r' IN ls_rev-rfulladdress WITH ''.
      REPLACE ALL OCCURRENCES OF '\n' IN ls_rev-rfulladdress WITH ' '.

      CONDENSE ls_rev-rfulladdress.

      REPLACE ALL OCCURRENCES OF '\r' IN ls_rev-cfulladdress WITH ''.
      REPLACE ALL OCCURRENCES OF '\n' IN ls_rev-cfulladdress WITH ' '.

      CONDENSE ls_rev-cfulladdress.
      "" write query here for email and contact no

""new code added by SAR Tech Team by 12.06-2026..
        select single BillingDocument,TotalTaxAmount from I_BillingDocument wiTH PRIVILEGED ACCESS
        where BillingDocument = @lv_id1
        into @data(taxcode).
        if taxcode-TotalTaxAmount is not INITIAL.
            data(lv_taxcode) = 'X'.
        else.
            lv_taxcode = 'Y'.
        endif.

      SELECT SINGLE * FROM zdt_invtax
      WHERE company_code = @ls_rev-companycode
      INTO @DATA(ls_cocode).
      INSERT VALUE zi_taxinvhdr_print( serialinvoiceno   = ls_rev-serialinvoiceno
                                       documenttype      = ls_rev-documenttype
                                       deliveryterms     = ls_rev-deliveryterms
                                       ordernumber       = ls_rev-ordernumber
                                       salesorder        = ls_rev-salesorder
*                                       orderdate         = ls_rev-orderdate
                                       orderdate         = lv_date
                                       paymentterms      = ls_rev-paymentterms
*                                       lcnumber          = ls_rev-lcnumber
*                                       lcdate            = ls_rev-lcdate
                                       dateofinvoice     = ls_rev-dateofinvoice
                                       timeofinvoice     = ls_rev-timeofinvoice
                                       dateofremoval     = ls_rev-dateofremoval
                                       timeofremoval     = ls_rev-timeofremoval
                                       discountflag      = lv_disflag
                                       freightflag       = lv_freflag
                                       cgstflag          = lv_cgstflag
                                       sgstflag          = lv_sgstflag
                                       igstflag          = lv_igstflag
                                       utgstflag         = lv_utgstflag
                                       tcsflag           = lv_tcsflag
                                       irnnumber         = ls_irn-irn
                                       irndate           = ls_irn-erdat
                                       ackno = ls_irn-ackno
                                       ackdate = ls_irn-erdat
                                       eway = ls_irn-eway
                                       signedqrcode = ls_irn-signedqrcode
                                       bitmapcode        = ls_rev-bitmapcode
                                       bitmapflag        = lv_bitmapflag
                                       rbusinessname     = ls_rev-rbusinessname
*                                       raddress          = ls_rev-raddress
                                       raddress          = lv_rfulladdress
                                       rcityname         = ls_rev-rcityname
                                       rstatename        = ls_rev-rstatename
                                       rstatecode        = ls_rev-rstatecode
                                       rgstin            = ls_rev-rgstin
                                       rfulladdress      = ls_rev-rfulladdress
*                                      COND #( when ls_rev-DocumentType NE 'JSTO'                                                                                                        then lv_cfulladdress
*                                                                   else ls_rev-rfulladdress )
                                       cbusinessname     = ls_rev-cbusinessname
*                                       caddress          = ls_rev-caddress
                                       caddress          =  lv_cfulladdress
                                       ccityname         = ls_rev-ccityname
                                       cstatename        = ls_rev-cstatename
                                       cstatecode        = ls_rev-cstatecode
                                       cgstin            = ls_rev-cgstin
                                       cfulladdress      = ls_rev-cfulladdress
*                                       COND #( when ls_rev-DocumentType NE 'JSTO'
**                                                                   then lv_rfulladdress
*                                                                  else ls_rev-cfulladdress )
                                       transportername   = ls_rev-transportername
                                       transporterno     = ls_rev-transporterno
                                       transportdate     = ls_rev-transporterdate
                                       destination       = ls_rev-destination
*                                       lrnumber          = ls_rev-lrnumber
*                                       lrdate            = ls_rev-lrdate
                                       vehiclenumber     = ls_rev-vehiclenumber
*                                       dispatchedthrough = ls_rev-dispatchedthrough
                                       exchangedrate     = ls_rev-exchangedrate
*                                       containernumber   = ls_rev-containernumber
                                       customer          = ls_rev-customer
                                       customername      = ls_rev-customername
                                       plantbank         = ls_rev-plantbank
                                       bankname          = ls_rev-bankname
                                       bankaddress       = ls_rev-bankaddress
                                       accountnumber     = ls_rev-accountnumber
*                                       accountname       = ls_rev-accountname
                                       ifsccode          = ls_rev-ifsccode
*                                       unitpkg           = ls_rev-yy1_unitpackage_dlh
                                       companycode       = ls_rev-companycode
                                       plantno           = ls_rev-plantno
                                       plantname         = ls_rev-plantname
                                       plantaddress      = ls_rev-plantaddress
                                       stateofsupply     = ls_rev-stateofsupply
                                       statecode         = ls_rev-statecode
                                       gstno             = ls_rev-gstno
                                       isono             = ls_rev-isono
                                       purchaseorderbycustomer = ls_rev-purchaseorderbycustomer
                                       referencesddocument = ls_rev-referencesddocument
                                       contact           = ls_rev-contact
                                       cin               = ls_rev-cin
                                       website           = ls_rev-website
                                       email             = ls_rev-email
                                       regoffice         = ls_rev-regoffice
                                       companyname       = ls_code-legalname
                                       gstin             = ls_code-gstin
*                                       descofitems       = ls_rev-descofitems
                                       remarks           = ls_rev-remarks
                                       incotermslocation1 = ls_rev-incotermslocation1
                                       division          = lv_samplediv
                                       rpanno            = ls_rev-rgstin+2(10)
                                       amountinwords     = lv_amtinword
                                       taxinwords        = lv_taxinword
                                       emailid            = ls_cocode-email
                                       contact_no_plant   = ls_cocode-contact_no
                                       roundoff = ls_sum_tax-roundoff
                                       roundoff_char = roundoff_char
                                       totalamt = lv_amt
                                       totalamt_int = lv_amt
                                       taxcodeamt = lv_taxcode )
      INTO TABLE rt_table.

      CLEAR: lv_bitmapflag,
            lv_cfulladdress,
             lv_rfulladdress,
             lv_date.

    ENDLOOP.
*    SORT rt_table BY serialinvoiceno.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).

*  new logic added by SAR Tech Team...14.04.2026..

*            select * from ZI_TAXINVITEM_PRINT WITH PRIVILEGED ACCESS
*            where billingdocument = @lv_id1
*            into table @DATA(lt_taxitem).
*
*            if lt_taxitem is not initial.
*            data: lt_taxitem_db type zsd_taxitemprint.
*
*            sort lt_taxitem ASCENDING BY billingdocumentitem.
*
*            loop at lt_taxitem ASSIGNING FIELD-SYMBOL(<ls_taxitem>).
*                if <ls_taxitem> is ASSIGNED.
*                    MOVE-CORRESPONDING <ls_taxitem> TO lt_taxitem_db.
*                    lt_taxitem_db-orderunit1 = <ls_taxitem>-OrderUnit1.
*                    modify zsd_taxitemprint from @lt_taxitem_db.
*                endif.
*            endloop.
*
*            endif.

  ENDMETHOD.
ENDCLASS.
