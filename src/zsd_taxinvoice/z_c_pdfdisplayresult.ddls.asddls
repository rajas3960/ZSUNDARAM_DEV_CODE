@EndUserText.label: 'PDF Display Result'
define abstract entity Z_C_PdfDisplayResult
{
  Content  : abap.rawstring;
  MimeType : abap.char( 128 );
  FileName : abap.char( 255 );
}
