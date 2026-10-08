@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST Integration Status'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZGST_STATUS 
as select from zgst_up_statusdb
{
    @UI.lineItem: [{ position: 10, label: 'Invoice No' }]
    key invoiceno as Invoiceno,
    @UI.lineItem: [{ position: 20, label: 'Item No' }]    
    key billingdocumentitem as Billingdocumentitem,
    @UI.hidden: true
    key accountingdocument as Accountingdocument,
    @UI.hidden: true
    key accountingdocumentitem as Accountingdocumentitem,
    @UI.lineItem: [{ position: 30, label: 'Status Code' }]    
    statuscode as Statuscode,
    @UI.lineItem: [{ position: 40, label: 'Ack No' }]    
    ackno as Ackno,
    @UI.hidden: true
    createdby as Createdby,
    @UI.hidden: true
    createdat as Createdat
}
