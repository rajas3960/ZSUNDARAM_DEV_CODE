@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Custom Tax code rate view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZTAXCODE_RATE 
as select from I_TaxCodeRate
{
    key Country,
    key TaxCalculationProcedure,
    key TaxCode,
    key VATConditionType,
    ConditionRateRatio,
    ConditionRateRatioUnit,
    ConditionStep,
    AccountKeyForGLAccount
}
group by Country, TaxCalculationProcedure,TaxCode,
         VATConditionType,ConditionRateRatio,ConditionRateRatioUnit,
         ConditionStep,AccountKeyForGLAccount
