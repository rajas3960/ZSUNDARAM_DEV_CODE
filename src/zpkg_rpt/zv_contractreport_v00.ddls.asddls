@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for maximun sales order against a contract'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_CONTRACTREPORT_V00 as select from I_SalesContract as a
inner join I_SalesDocumentItem  as b on b.ReferenceSDDocument = a.SalesContract
{
    a.SalesContract as SalesContract,
    min( b.SalesDocument ) as SalesOrder      // Or max or whatever rule fits
}
group by
    a.SalesContract
