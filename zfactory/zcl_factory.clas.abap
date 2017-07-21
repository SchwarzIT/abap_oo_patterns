CLASS zcl_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: output_as_salv  TYPE char1 VALUE 'S',
               output_as_write TYPE char1 VALUE 'W'.

    CLASS-METHODS get_output_instance IMPORTING i_type            TYPE char1
                                      RETURNING VALUE(r_instance) TYPE REF TO zif_output.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_factory IMPLEMENTATION.

  METHOD get_output_instance.
    r_instance = SWITCH #( i_type
                           WHEN output_as_salv THEN NEW zcl_alv( )
                           WHEN output_as_write THEN NEW zcl_simple_output( ) ).
  ENDMETHOD.

ENDCLASS.
