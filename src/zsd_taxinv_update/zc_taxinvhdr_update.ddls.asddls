@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for Tax Invoice Header'
@Metadata.allowExtensions: true
define root view entity ZC_TAXINVHDR_UPDATE
  provider contract transactional_query
  as projection on ZI_TAXINVOICE_HEADER_UPDATE
{

        @EndUserText.label: 'Serial Invoice No.'
  key   SerialInvoiceNo,
        DocumentType,
        Deliveryterms,
      //  @EndUserText.label: 'Description of Items'
      //  DESCOFITEMS,
        @EndUserText.label: 'Order No.'
        OrderNumber,
        @EndUserText.label: 'Sales Order No.'
        SalesOrder,
        @EndUserText.label: 'Order Date'
        OrderDate,
        @EndUserText.label: 'Payment Terms'
        PaymentTerms,
      //  @EndUserText.label: 'LC Number'
     //   LCNumber,
     //   @EndUserText.label: 'LC Date'
       // LCDate,
        @EndUserText.label: 'Date of Invoice'
        DateOfInvoice,
        @EndUserText.label: 'Time of Invoice'
        TimeOfInvoice,
        @EndUserText.label: 'Date of Removal'
        DateOfRemoval,
        @EndUserText.label: 'Time of Removal'
        TimeOfRemoval,
        @EndUserText.label: 'IRN Number'
        IRNNumber,
        @EndUserText.label: 'IRN Date'
        IRNDate,
        @EndUserText.label: 'Bitmap Code'
        BitmapCode,
        @EndUserText.label: 'Receiver Business Name'
        RBusinessName,
        @EndUserText.label: 'Receiver Address'
        RAddress,
        @EndUserText.label: 'Receiver City Name'
        RCityName,
        @EndUserText.label: 'Receiver State Name'
        RStateName,
        @EndUserText.label: 'Receiver State Code'
        RStateCode,
        @EndUserText.label: 'Receiver GSTIN'
        RGSTIN,
        @EndUserText.label: 'Receiver Full Address'
        RFullAddress,
        @EndUserText.label: 'Consignee Business Name'
        CBusinessName,
        @EndUserText.label: 'Consignee Address'
        CAddress,
        @EndUserText.label: 'Consignee City Name'
        CCityName,
        @EndUserText.label: 'Consignee State Name'
        CStateName,
        @EndUserText.label: 'Consignee State Code'
        CStateCode,
        @EndUserText.label: 'Consignee GSTIN'
        CGSTIN,
        @EndUserText.label: 'Consignee Full Address'
        CFullAddress,
        @EndUserText.label: 'Transporter Name'
        TransporterName,
        @EndUserText.label: 'Transport Date'
        TransporterDate,
        @EndUserText.label: 'Transport Document Number'
        TransporterNo,
        //@EndUserText.label: 'LR Number'
        //LRNumber,
        //@EndUserText.label: 'LR Date'
        //LRDate,
        @EndUserText.label: 'Vehicle No.'
        VehicleNumber,
        @EndUserText.label: 'Remarks'
        Remarks,
        //@EndUserText.label: 'Dispatched Through'
        //DispatchedThrough,
        @EndUserText.label: 'Exchanged Rate'
        ExchangedRate,
        //@EndUserText.label: 'Container No.'
        //ContainerNumber,
        @EndUserText.label: 'Customer'
        Customer,
        @EndUserText.label: 'Customer Name'
        CustomerName,
        @EndUserText.label: 'Plant for Bank'
        PlantBank,
        @EndUserText.label: 'Bank Name'
        BankName,
        @EndUserText.label: 'Bank Address'
        BankAddress,
        @EndUserText.label: 'Account Number'
        AccountNumber,
//        @EndUserText.label: 'Account Name'
//        AccountName,
        @EndUserText.label: 'Ifsc Code'
        IfscCode,
        @EndUserText.label: 'Company Code'
        CompanyCode,
        @EndUserText.label: 'Plant No.'
        PlantNo,
        @EndUserText.label: 'Plant Name'
        PlantName,
        @EndUserText.label: 'Plant Address'
        PlantAddress,
        @EndUserText.label: 'State of Supply'
        StateOfSupply,
        @EndUserText.label: 'State Code'
        StateCode,
        @EndUserText.label: 'GST No'
        GSTNo,
        @EndUserText.label: 'ISO No'
        ISONo,
        @EndUserText.label: 'PO No'
        PurchaseOrderByCustomer,
        @EndUserText.label: 'Reference Invoice No'
        ReferenceSDDocument,
        @EndUserText.label: 'CIN'
        CIN,
        @EndUserText.label: 'Contact'
        Contact,
        @EndUserText.label: 'Email'
        Email,
        @EndUserText.label: 'Website'
        Website,
        @EndUserText.label: 'Registered Office'
        RegOffice,
        @EndUserText.label: 'Delivery Terms'
        IncotermsLocation1,
        @EndUserText.label: 'Destination'
        Destination,
        //@EndUserText.label: 'Remarks'
        //remarks,
        //@EndUserText.label: 'Unit Package'
        //YY1_unitpackage_DLH,
        tprint,
        amountinwords,
        Attachment,
        Mimetype,
        Filename,
        _Item : redirected to composition child ZC_TAXINVITEM_UPDATE,
        _Item2 : redirected to composition child ZC_TAXINVITEM2_UPDATE

}
