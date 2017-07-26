CLASS zcl_car DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      wheel_table TYPE STANDARD TABLE OF REF TO zcl_wheel WITH DEFAULT KEY,
      seat_table  TYPE STANDARD TABLE OF REF TO  zcl_seat WITH DEFAULT KEY.
    CONSTANTS min_wheel_count TYPE i VALUE 4.

    METHODS:
      constructor
        IMPORTING
                  i_engine TYPE REF TO zcl_engine
                  i_wheels TYPE wheel_table
                  i_seats  TYPE seat_table
        RAISING   zcx_incomplete_car,

      start_engine,
      drive.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      engine TYPE REF TO zcl_engine,
      wheels TYPE wheel_table,
      seats  TYPE seat_table.
ENDCLASS.



CLASS zcl_car IMPLEMENTATION.


  METHOD constructor.
    engine = i_engine.
    wheels = i_wheels.
    seats = i_seats.
    IF engine IS INITIAL.
      RAISE EXCEPTION TYPE zcx_incomplete_car.
    ENDIF.

    IF lines( wheels ) < min_wheel_count.
      RAISE EXCEPTION TYPE zcx_incomplete_car.
    ENDIF.

    IF seats IS INITIAL.
      RAISE EXCEPTION TYPE zcx_incomplete_car.
    ENDIF.
  ENDMETHOD.


  METHOD drive.
    WRITE: 'Starting to drive', /.
    engine->accelerate( ).
    LOOP AT wheels ASSIGNING FIELD-SYMBOL(<wheel>).
      <wheel>->turn( ).
    ENDLOOP.
  ENDMETHOD.


  METHOD start_engine.
    WRITE: 'Starting Engine', /.
    engine->start( ).
  ENDMETHOD.
ENDCLASS.
