CLASS zcl_contract_data DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS sort_data  FOR TABLE FUNCTION ztabl_fctn_contract.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CONTRACT_DATA IMPLEMENTATION.


  METHOD sort_data BY DATABASE FUNCTION
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING zv_contract_vf2 .


    it_item =  select * from zv_contract_vf2;
  RETURN select mandt as client ,
  salescontract ,
    salescontractitem,
       salesorganization ,
       distributionchannel,
       organizationdivision,
       broker,
       brokername ,
       salescontractdate,
       salescontractvalidityenddate,
       soldtoparty,
       customerfullname,
       transactioncurrency,
       conditionvalue,
       conditionamount ,
       requestedquantityunit,
       contractqty ,
       invoicedqty,
       pendingqty,
       creditsegmentcurrency,
       effectivetotalcreditlimitamt,
       creditlimitamt,
       reservevalue,
       RESERVE,
       dispatchablebalance,
       dispatchableqty,
       projectedvalue,
       receivable,
       sales_order_no,
       grosspriceperton,
       paymenttermsdescription
         from :it_item ORDER BY customerfullname, salescontractdate ;

  ENDMETHOD.
ENDCLASS.
