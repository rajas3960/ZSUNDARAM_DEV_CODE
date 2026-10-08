@EndUserText.label: 'Form Type'
define abstract entity ZFORM_TYPE
//  with parameters parameter_name : parameter_type
{   
    @EndUserText.label: 'FI Form Type'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZFI_FORM_TYPE_VH', element: 'text' }, 
                                    distinctValues: true }] //this one for Dropdown option
    FormType : abap.char( 50 );
    
}
