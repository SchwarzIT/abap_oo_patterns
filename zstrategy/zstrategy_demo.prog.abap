*&---------------------------------------------------------------------*
*& Report  zstrategy_demo
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zstrategy_demo.

PARAMETER: p_batch TYPE sybatch AS CHECKBOX.

CLASS lcl_greeter DEFINITION.
  PUBLIC SECTION.

    METHODS:
      constructor IMPORTING i_logger TYPE REF TO zif_log,
      greet_participants.

  PRIVATE SECTION.
    DATA logger TYPE REF TO zif_log.
ENDCLASS.

CLASS lcl_greeter IMPLEMENTATION.

  METHOD constructor.
    me->logger = i_logger.
  ENDMETHOD.

  METHOD greet_participants.
    logger->log( VALUE #( msgid = 'ZPATTERN' msgno = '001'  msgty = 'I' ) ).
    logger->log( VALUE #( msgid = 'ZPATTERN' msgno = '002'  msgty = 'I' ) ).
    logger->finish( ).
  ENDMETHOD.

ENDCLASS.


START-OF-SELECTION.
  DATA:
    logger  TYPE REF TO zif_log,
    greeter TYPE REF TO lcl_greeter.

  IF p_batch IS INITIAL.
    logger = new zcl_salv_log( ).
  ELSE.
    logger = new zcl_bal_log( ).
  ENDIF.

    greeter = new lcl_greeter( logger  ).

    greeter->greet_participants( ).
