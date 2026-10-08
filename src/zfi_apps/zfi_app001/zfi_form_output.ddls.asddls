@EndUserText.label: 'Credit-Debit Form Output Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZFI_FORM_IMP_CL'
define custom entity ZFI_FORM_OUTPUT
  // with parameters parameter_name : parameter_type
{
  key AccountingDocument         : vbeln;
  key FiscalYear                 : fis_gjahr_no_conv;
  key CompanyCode                : bukrs;
      AccountingDocumentType     : blart;
      AccountingDocumentTypeName : abap.char( 20 );
      DocumentDate               : bldat;
//      OriginalReferenceDocument  : awkey;
      OriginalReferenceDocument  : abap.char(16);      
      PostingDate                : fis_budat;
      CompanyCodeCurrency        : abap.cuky( 5 );
      Supplier                   : lifnr;
      Plant                      : werks_d;
      SupplierName               : abap.char( 80 );
      GSTIN                      : stcd3;
      PAN                        : abap.char( 40 );
      EmailAddress               : abap.char( 241 );
      CityName                   : abap.char( 35 );
      PostalCode                 : pstlz;
      StreetName                 : abap.char( 35 );
      Region                     : regio;
      Country                    : land1;
      StreetPrefixName1          : abap.char( 40 );
      StreetPrefixName2          : abap.char( 40 );
      AddressTimeZone            : abap.char( 6 );
      FormType                   : abap.char( 50 );
      Dateofinvoice              : bldat;
      CDNReson                   : abap.char(50);
      reversecharge              : abap.char(10);
      status                     : abap.char(20);
      state                      : abap.char( 20 );
      RegionText                 : abap.char(20);
      @ObjectModel.filter.enabled  : false
      _item :association [1..*] to ZFI_ITEM_OUT on $projection.AccountingDocument = _item.AccountingDocument
                                                 and $projection.FiscalYear = _item.FiscalYear
                                                 and $projection.CompanyCode = _item.CompanyCode;
}
