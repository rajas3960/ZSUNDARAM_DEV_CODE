@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final View for Plant Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PLANT_DETAILS_FINAL 
    as select distinct from I_BillingDocumentItem as a
    left outer join ZI_PlantDetails as b on b.PlantNo = a.Plant
    left outer join zdt_state_code1 as c on c.sapstatecode = b.StateCode
{
    key a.BillingDocument,
    b.Id,
    b.PlantNo,
    b.PlantName,
    b.PlantAddress,
    b.State,
    c.gststatecode as StateCode
}
