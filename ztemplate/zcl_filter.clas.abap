CLASS zcl_filter DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: any_table TYPE REF TO data.

    METHODS:
      constructor
        IMPORTING
          i_log TYPE REF TO zif_log,
      filter FINAL
        CHANGING
          c_table TYPE INDEX TABLE .
  PROTECTED SECTION.


    METHODS:
      log_start_of_filter ABSTRACT
        IMPORTING i_table TYPE INDEX TABLE,

      log_exclusion ABSTRACT,

      log_filter_execution ABSTRACT
        IMPORTING i_table TYPE INDEX TABLE,

      is_valid ABSTRACT
        RETURNING VALUE(r_result) TYPE abap_bool,

      convert_to_internal_type ABSTRACT
        IMPORTING i_row TYPE any.

    DATA log TYPE REF TO zif_log.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_FILTER IMPLEMENTATION.


  METHOD constructor.
    me->log = i_log.
  ENDMETHOD.


  METHOD filter.

    log_start_of_filter( c_table ).

    LOOP AT c_table ASSIGNING FIELD-SYMBOL(<row>).
      convert_to_internal_type( <row> ).
      IF is_valid( ) = abap_false.
        log_exclusion( ).
        DELETE c_table.
      ENDIF.
    ENDLOOP.

    log_filter_execution( c_table ).

  ENDMETHOD.
ENDCLASS.
