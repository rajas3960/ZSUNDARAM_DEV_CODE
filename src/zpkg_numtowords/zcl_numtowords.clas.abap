CLASS zcl_numtowords DEFINITION
   PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS znumword
      IMPORTING
        VALUE(iv_num)       TYPE string OPTIONAL
      CHANGING
        VALUE(rv_dec_words) TYPE string OPTIONAL
      RETURNING
        VALUE(rv_words)     TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_NUMTOWORDS IMPLEMENTATION.


  METHOD znumword.

    TYPES: BEGIN OF str_d,
             num   TYPE i,
             word1 TYPE string,
             word2 TYPE string,
           END OF str_d.

    DATA: ls_h TYPE str_d,
          ls_k TYPE str_d,
          ls_m TYPE str_d,
          ls_b TYPE str_d,
          ls_t TYPE str_d,
          ls_o TYPE str_d.

    DATA lv_int(20) TYPE c.
    DATA : lv_int_d(20) TYPE c.

    DATA: lv_part1(20) TYPE c.
    DATA: lv_part2(5) TYPE c.
    DATA lv_inp1 TYPE string.
    DATA lv_inp2 TYPE string.
    DATA : floor(20) TYPE c.
    DATA : mod(20) TYPE c.
    DATA : floord(20) TYPE c.
    DATA : floord1(20) TYPE c.
    DATA : modd(20) TYPE c.
    DATA : number(20) TYPE c.

    DATA : int_word TYPE string.
    DATA : dec_word TYPE string.

    ls_h-num = 100.
    ls_h-word1 = 'Hundred'.
    ls_h-word2 = 'Hundred and'.

    ls_k-num = ls_h-num * 10.
    ls_k-word1 = 'Thousand'.
    ls_k-word2 = 'Thousand'.

    ls_m-num = ls_k-num * 100.
    ls_m-word1 = 'Lakh'.
    ls_m-word2 = 'Lakh'.

    ls_b-num = ls_m-num * 100.
    ls_b-word1 = 'Crore'.
    ls_b-word2 = 'Crore'.

    SPLIT iv_num AT '.' INTO  lv_part1 lv_part2.
    lv_int_d = lv_part2 .
    lv_int = lv_part1.

    "CONCATENATE lv_int_d1 '0'  INTO  lv_int_d.
    SELECT * FROM zdt_words INTO TABLE @DATA(lt_d).

    IF lt_d IS NOT INITIAL.
      IF lv_int_d =  00.
        lv_int_d = 0.
        CONDENSE lv_int_d.
      ENDIF.
      IF lv_int_d <= 20.
        READ TABLE lt_d  INTO DATA(ls_d) WITH KEY num = lv_int_d.
        IF ls_d IS NOT INITIAL.
          dec_word = ls_d-word.
        ENDIF.
      ENDIF.

      IF lv_int_d < 100 AND lv_int_d > 20.
        modd = lv_int_d MOD 10.
        floord = ceil( lv_int_d DIV 10 ).
        CONDENSE modd.
        CONDENSE floord.
        IF modd = 0.
          READ TABLE lt_d  INTO ls_d WITH KEY num = lv_int_d.
          IF ls_d IS NOT INITIAL.
            dec_word = ls_d-word.
            rv_words = int_word .
            rv_dec_words =  dec_word .
          ENDIF.
        ELSE.
          floord1 = floord * 10.
          CONDENSE floord1.
          READ TABLE lt_d  INTO ls_d WITH KEY num = floord1.
          IF ls_d IS NOT INITIAL.
            DATA(pos11) = ls_d-word.
          ENDIF.
          READ TABLE lt_d  INTO ls_d WITH KEY num = modd.
          IF ls_d IS NOT INITIAL.
            DATA(pos21) = ls_d-word.
            dec_word = |{ pos11 } | && |{ pos21 } |.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_d IS NOT INITIAL.
      CONDENSE lv_int.
      IF lv_int <= 20.
        READ TABLE lt_d  INTO ls_d WITH KEY num = lv_int.
        IF ls_d IS NOT INITIAL.
          int_word = ls_d-word.
          rv_words = int_word .
          rv_dec_words =  dec_word .
        ENDIF.
      ELSEIF lv_int < 100 AND lv_int > 20 .
        mod = lv_int MOD 10.
        floor = ceil( lv_int DIV 10 ).
        CONDENSE mod.
        CONDENSE floor.
        IF mod = 0.
          READ TABLE lt_d  INTO ls_d WITH KEY num = lv_int.
          IF ls_d IS NOT INITIAL.
            int_word = ls_d-word .
            rv_words    = int_word .
            rv_dec_words =  dec_word .
            RETURN.
          ENDIF.
        ELSE.
          DATA: number1(5) TYPE c.
          number1 = floor * 10.
          CONDENSE number1.
          READ TABLE lt_d  INTO ls_d WITH KEY num = number1..
          IF ls_d IS NOT INITIAL.
            DATA(pos1) = ls_d-word.
          ENDIF.
          READ TABLE lt_d  INTO ls_d WITH KEY num = mod.
          IF ls_d IS NOT INITIAL.
            DATA(pos2) = ls_d-word.
            int_word = |{ pos1 } | && |{ pos2 } | .
            rv_words = int_word .
            rv_dec_words =  dec_word .
            RETURN.
          ENDIF.
        ENDIF.
      ELSE.
        IF lv_int  < ls_k-num.
          ls_o = ls_h.
        ELSEIF lv_int < ls_m-num.
          ls_o = ls_k.
        ELSEIF lv_int < ls_b-num.
          ls_o = ls_m.
        ELSE.
          ls_o = ls_b.
        ENDIF.
        mod = lv_int MOD ls_o-num.
        floor = floor( iv_num DIV ls_o-num ).
        lv_inp1 = floor.
        lv_inp2 = mod.
        CLEAR ls_d.
        IF mod = 0.
          DATA(output2) = znumword( lv_inp1 ).
          SHIFT output2 LEFT DELETING LEADING space.
          SHIFT output2 RIGHT DELETING TRAILING space.
          int_word =  |{ output2 } | && | { ls_o-word1 } | .
          SHIFT int_word LEFT DELETING LEADING space.
          SHIFT int_word  RIGHT DELETING TRAILING space.
          rv_words    = int_word .
          rv_dec_words =  dec_word .
          RETURN.

        ELSE.
          output2 = znumword( lv_inp1 ).
          SHIFT output2 LEFT DELETING LEADING space.
          SHIFT output2 RIGHT DELETING TRAILING space.
          DATA(output3) = znumword( lv_inp2 ).
          SHIFT output3 LEFT DELETING LEADING space.
          SHIFT output3 RIGHT DELETING TRAILING space.
          int_word = |{ output2 } | && |{ ls_o-word2 } | && |{ output3 } |  .
          SHIFT int_word LEFT DELETING LEADING space.
          SHIFT int_word  RIGHT DELETING TRAILING space.
          rv_words = int_word .
          rv_dec_words =  dec_word .
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
