CLASS zcl_alv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_output.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_alv IMPLEMENTATION.


  METHOD zif_output~display_data.
    DATA salv_object TYPE REF TO cl_salv_table.
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table   = salv_object
          CHANGING
            t_table        = i_data  ).
      CATCH cx_salv_msg.
    ENDTRY.

    IF salv_object IS BOUND.
      salv_object->display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
