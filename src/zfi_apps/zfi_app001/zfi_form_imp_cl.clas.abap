CLASS zfi_form_imp_cl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZFI_FORM_IMP_CL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

**********************************************************************
    if not io_request->is_data_requested(  ).
        RETURN.
    endif.
**********************************************************************
    DATA(lo_filter) = io_request->get_filter(  ).

    TRY.
        DATA(lt_range) = lo_filter->get_as_ranges(  ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.
**********************************************************************
    IF NOT line_exists( lt_range[  name = 'ACCOUNTINGDOCUMENT' ] ) and
        not line_exists( lt_range[ name = 'FISCALYEAR' ] ) and
        NOT line_exists( lt_range[ name = 'COMPANYCODE' ] ).
      "Need select parameter!
      RETURN.
    ENDIF.

**********************************************************************
    DATA rt_table TYPE TABLE OF ZFI_FORM_OUTPUT.
    DATA: lv_accdoc TYPE ZFI_FORM_OUTPUT-AccountingDocument.
    data: lv_date TYPE I_JournalEntry-PostingDate.
*    "" ++ 28.07.25 BY SP
    data lvgateno type c length 10 .
    DATA: lv_accodoc TYPE ZFI_FORM_OUTPUT-AccountingDocument.

**********************************************************************
    LOOP AT lt_range[ name = 'ACCOUNTINGDOCUMENT' ]-range ASSIGNING FIELD-SYMBOL(<ls_Acc>).
    LOOP AT lt_range[ name = 'FISCALYEAR' ]-range ASSIGNING FIELD-SYMBOL(<ls_fis>).
    LOOP AT lt_range[ name = 'COMPANYCODE' ]-range ASSIGNING FIELD-SYMBOL(<ls_com>).
        data(lv_acc) = <ls_acc>-low.
        data(lv_fis) = <ls_fis>-low.
        data(lv_com) = <ls_com>-low.
**********************************************************************
        select SINGLE * from ZFI_HEAD_VIEW wiTH PRIVILEGED ACCESS
        whERE AccountingDocument = @lv_acc
        and FiscalYear = @lv_fis
        and CompanyCode = @lv_com
        into @data(ls_acchd).
**********************************************************************
        select single CompanyCode,FiscalYear,InvoiceReference,NetDueDate,
                      AccountingDocument,LedgerGLLineItem,DocumentItemText,postingdate
                      from I_JournalEntryItem with PRIVILEGED ACCESS
                      where AccountingDocument = @lv_acc
                      and FiscalYear = @lv_fis
                      and CompanyCode = @lv_com
                      and Ledger = '0L'
                      and LedgerGLLineItem = '000001'


        into @data(ls_formtype).
**********************************************************************
        select single * from I_JournalEntry WITH PRIVILEGED ACCESS
        where AccountingDocument = @ls_formtype-InvoiceReference
        and CompanyCode = @ls_formtype-CompanyCode
        and FiscalYear = @ls_formtype-FiscalYear
        into @data(lv_post).
**********************************************************************
        if lv_post is INITIAL.
            lv_date = ls_formtype-PostingDate.
        else.
             lv_date = lv_post-PostingDate.
        endif.
**********************************************************************
        data(ls_desform) = ls_formtype-DocumentItemText+0(3).
**********************************************************************
        select single SupplierInvoice,FiscalYear,
                    CompanyCode,DocumentDate,SupplierInvoiceIDByInvcgParty
                    from I_SupplierInvoiceAPI01 WITH PRIVILEGED ACCESS
                    where SupplierInvoice = @ls_acchd-MiroNo
                    into @data(ls_suppinv).

**********************************************************************
        data: lv_orno TYPE c LENGTH 16,
              lv_ordate TYPE I_JournalEntry-PostingDate,
              lv_val type c LENGTH 20.

        if ls_acchd-TransactionCode = 'MIRO'.
            lv_orno = ls_suppinv-SupplierInvoiceIDByInvcgParty.
            lv_ordate = ls_suppinv-DocumentDate.
        ELSEIF ls_acchd-TransactionCode = 'FB60'.
            lv_orno = ls_acchd-DocumentReferenceID.
            lv_ordate = ls_acchd-DocumentDate.
        ENDIF.
**********************************************************************
        ""RCM self invoice form
        if ls_acchd-gstin is not INITIAL.
            lv_val = 'Registered'.

        else.
            lv_val = 'Unregistered'.

        endif.

            select single * from I_RegionText WITH PRIVILEGED ACCESS
            WHERE Country = @ls_acchd-Country
            and Region = @ls_acchd-Region
            and Language = 'E'
            into @data(lv_state).

**********************************************************************
        INSERT VALUE ZFI_FORM_OUTPUT(
                        AccountingDocument = ls_acchd-AccountingDocument
                        FiscalYear = ls_acchd-FiscalYear
                        CompanyCode = ls_acchd-CompanyCode
                        AccountingDocumentType = ls_acchd-AccountingDocumentType
                        AccountingDocumentTypeName = ls_acchd-AccountingDocumentTypeName
                        DocumentDate = ls_acchd-PostingDate
                        OriginalReferenceDocument = lv_orno
                        PostingDate = ls_acchd-PostingDate
                        CompanyCodeCurrency = ls_acchd-CompanyCodeCurrency
                        Supplier = ls_acchd-Supplier
                        Plant = ls_acchd-Plant
                        SupplierName = ls_acchd-SupplierName
                        gstin = ls_acchd-gstin
                        pan = ls_acchd-pan
                        EmailAddress = ''
                        CityName = ls_acchd-CityName
                        PostalCode = ls_acchd-PostalCode
                        StreetName = ls_acchd-StreetName
                        Region = ls_acchd-Region
                        Country = ls_acchd-Country
                        StreetPrefixName1 = ls_acchd-StreetPrefixName1
                        StreetPrefixName2 = ls_acchd-StreetPrefixName2
                        AddressTimeZone = ls_acchd-AddressTimeZone
                        FormType = ls_desform
                        Dateofinvoice = lv_ordate
                        CDNReson = ls_formtype-DocumentItemText
                        status = lv_val
                        RegionText = lv_state-RegionName
                        )
                        into table rt_table.

**********************************************************************
    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).

    ENDLOOP.
    ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
