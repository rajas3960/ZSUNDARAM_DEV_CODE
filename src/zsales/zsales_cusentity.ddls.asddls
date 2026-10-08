@EndUserText.label: 'custom entity'
define custom entity zsales_CusEntity
// with parameters parameter_name : parameter_type
{
  key SalesDocument:abap.char( 10 );
      SalesDocumentDate :abap.dats;
      SalesDocumentDescription:abap.char( 40 );
      SoldToParty: abap.char( 10 );
      DistributionChannel: abap.char( 2 );
      CreatedByUser:abp_creation_user;
      CreationDate: abap.dats;
  
}
