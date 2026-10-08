@ObjectModel.query.implementedBy: 'ABAP:ZCL_QAL_BO_IMPL'
@EndUserText.label: 'Quality Print'
define custom entity ZI_QAL_PRINT
{

  key id              : sysuuid_x16;
  key billingdoc      : abap.char(10);
  key billingitem     : abap.numc(6);
      plant           : werks_d;
      vehicleno       : abap.char(20);
      material        : matnr;
      thickness       : abap.char(10);
      width           : abap.char(60);
      quantity        : abap.char(10);
      batch           : abap.char(10);
      grade           : abap.char(10);
      customer        : abap.char(35);
      treatment       : abap.char(25);
      coatside        : abap.char(25);
      filmtype        : abap.char( 30 );
      pono            : abap.char( 10 );
      deliveryno      : abap.char(60);
      deliveryitem    : abap.numc(6);
      salesord        : abap.char(60);
      salesitem       : abap.char(30);
      invdate         : abap.dats;
      testcertprnt    : abap.char(1);
      textbox         : abap.char(50);
      inspecplangroup : abap.char(8);
      inspecplan      : abap.char(2);
      remarks         : abap.char(150);
      qc_cert_no      : abap.char(20);
      prod_name       : abap.char(40);
      prod_group      : abap.char(10);
      chem_metal      : abap.char(40);
      companycode     : bukrs;
      companycodename : butxt;

      //Associations
      _item           : association [1..*] to ZI_QAL_PRINT_ITM on $projection.id = _item.Id;
      _item2          : association [1..*] to zi_qal_print_itm2 on $projection.id = _item2.id;
      _item3          : association [1..*] to zi_qal_print_itm3 on $projection.id = _item3.id;

}
