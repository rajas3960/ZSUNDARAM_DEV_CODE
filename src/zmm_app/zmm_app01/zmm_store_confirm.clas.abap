CLASS zmm_store_confirm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMM_STORE_CONFIRM IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    data: wa_db TYPE TABLE of ZMM_CONFIRM_DB.

        " Populate the structure with data
        wa_db = VALUE #( (
                         suser = 'CB9980000080'
                         sloc = '1BPR'
                         mail = 'tharmaraj.seenikkalai@zietatech.com'
                         )
                          ).

        " Delete the data into the database table
            DELETE FROM ZMM_CONFIRM_DB.

        " Insert the data into the database table
            INSERT ZMM_CONFIRM_DB from table @wa_db.

        " Fetch the data from database table
            select * from ZMM_CONFIRM_DB into table @wa_db.

        " this is used to display the inserted records in the table as output.
            out->write( EXPORTING data = wa_db ).

  ENDMETHOD.
ENDCLASS.
