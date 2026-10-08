@AbapCatalog.sqlViewName: 'ZSMS_REP3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SMS Report3'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view ZSMS_REPORT3 
with parameters
    p_from_date : datum,
    p_to_date   : datum,
    p_plant     : werks_d 
    
as select distinct from ZSMS_REPORT ( p_from_date:$parameters.p_from_date , p_to_date:$parameters.p_to_date,p_plant:$parameters.p_plant  ) as  A 
{  
    @EndUserText.label: 'Material'
    key A.Material,
    @EndUserText.label: 'Plant'
    key A.Plant,
     @EndUserText.label: 'Product Name'
    key  A.Product_name,
    @EndUserText.label: 'Posting Date'
    key A.postingdate,
    
    //added by SAR Team
    @EndUserText.label: 'CAPTIVE POWER'
    key   A.CaptivePower,
    @EndUserText.label: 'Grid Power'
    key A.Gridpower,
    @EndUserText.label: 'Total Power'
    A.TotalPower,
    A.MaterialBaseUnit,
    @EndUserText.label: 'OPENING'
    A.OPENING,
    @EndUserText.label: 'PRODUCTION'
    A.PRODUCTION,
    @EndUserText.label: 'CONSUMPTION'
    A.CONSUMPTION,
    @EndUserText.label: 'PURCHASE GR'
    A.PURCHASE_GR,
    @EndUserText.label: 'TRANSFER(OUT)'
    A.TRANSFER_OUT,
    @EndUserText.label: 'TRANSFER(IN)'
    A.TRANSFER_IN,
     @EndUserText.label: 'STO(641)'
    A.STO_641,
    @EndUserText.label: 'COMP.COST CENTER(201)'
    A.COMP_COST_CENTER_201,
    @EndUserText.label: 'TRF MATE 2 MATE(309)'
    A.TRF_MATE_2_MATE_309,
    @EndUserText.label: 'SALES'
    A.SALES,
    @EndUserText.label: 'CLOSING STOCK'
    A.CLOSING_STOCK,
    @EndUserText.label: 'UoM'
    A.UOM,
    @EndUserText.label: 'PIECE'
    A.PIECE,
    @EndUserText.label: 'RECOVERY'
    A.Recovery,
    @EndUserText.label: 'METAL'
    A.Metal,
    @EndUserText.label: '% METAL'
    A.PercentMetal,
//    @EndUserText.label: 'CAPTIVE POWER'
 //  A.CaptivePower,
 //  @EndUserText.label: 'Grid Power'
 //   A.Gridpower,
 //   @EndUserText.label: 'Total Power'
 //  A.TotalPower,
     @EndUserText.label: 'Average'
    A.Average,
    @EndUserText.label: 'Sales Return'
    A.SALES_RETUN,
    @EndUserText.label: 'PURCHASE GR RETURN'
    A.PURCHASE_GR_RETURN,
    @EndUserText.label: 'Return to Delivery'
    A.Return_to_Delivery
}
where A.postingdate <> $parameters.p_from_date
