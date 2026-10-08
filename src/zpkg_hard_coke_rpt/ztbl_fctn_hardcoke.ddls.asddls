@AccessControl.authorizationCheck: #NOT_ALLOWED
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Table Function for Hard Coke Report'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define table function ZTBL_FCTN_HARDCOKE
  with parameters
    @Environment.systemField: #CLIENT
    mandt : abap.clnt
returns
{
  key mandt                : abap.clnt;
  key MaterialDocument     : abap.char(10);
  key MaterialDocumentItem : abap.numc(4);
  key MaterialDocumentYear : gjahr;
      PostingDate          : sydate;
      Supplier             : lifnr;
      SupplierName         : abap.char(100);
      ChallanNo            : abap.char(30);
      Material             : matnr;
      ProductName          : abap.char(40);
      Plant                : werks_d;
      StorageLocation      : lgort_d;
      QuantityInEntryUnit  : abap.dec( 13, 3 );
      MaterialBaseUnit     : meins;
      plantqty             : abap.dec( 13, 3 );
      wtdiff               : abap.dec( 13, 3 );  
      NetPriceAmount       : abap.dec( 23, 2 );
      DocumentCurrency     : waers;
      totbill              : abap.dec( 23, 2 );
      totpay               : abap.dec( 23, 2 );
      uash                 : abap.dec( 13, 3 );
      umois                : abap.dec( 13, 3 );
      uashup               : abap.dec( 13, 3 );
      umoisup              : abap.dec( 13, 3 );            
      
}
implemented by method
  zcl_hard_coke_rpt=>get_data;