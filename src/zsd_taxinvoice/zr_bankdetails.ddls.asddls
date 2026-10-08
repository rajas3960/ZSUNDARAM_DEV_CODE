@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Details of Bank'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BANKDETAILS 
    as select from zdt_bankdetails
{
    key id as Id,
    customer as Customer,
    bank_name as BankName,
    bank_address as BankAddress,
    account_number as AccountNumber,
    account_name as AccountName,
    ifsc_code as IfscCode,
    configdeprecationcode as Configdeprecationcode,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
    
}
