"! This class implements the builder pattern for zcl_car
"!
"! A builder encapsulates complex instaniation logic of
"! another class. It makes coping with different configurations
"! of a class easy where normally a lot of optional constructor
"! parameters would be used the builder can provide separate methods
"! for parameters or one method per configuration of parameters
"! (the latter one is not implemented here). In this implementation
"! I choose to automatically fill not passed parameters. This is not
"! part of the pattern but a adaption I made.
CLASS zcl_car_builder DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:

      "! Constructs car with the values passed to the other method
      "!
      "! Missing values are filled with suitable defaults.
      build_car  RETURNING VALUE(r_car)   TYPE REF TO zcl_car,
      add_wheels IMPORTING       i_count  TYPE i,
      add_wheel  IMPORTING       i_wheel  TYPE REF TO zcl_wheel,
      add_seat   IMPORTING       i_seat   TYPE REF TO zcl_seat,
      set_engine IMPORTING       i_engine TYPE REF TO zcl_engine ,
      add_seats  IMPORTING       i_count  TYPE i,
      "! Deletes all previously received values.
      reset.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      wheels TYPE zcl_car=>wheel_table,
      seats  TYPE zcl_car=>seat_table,
      engine TYPE REF TO zcl_engine.

    METHODS:
      "! Check that the car gets at least one seat
      "! an engine, and 4 wheels. Missing components
      "! are created with default values.
      ensure_minimal_configuration.

ENDCLASS.



CLASS zcl_car_builder IMPLEMENTATION.


  METHOD add_seat.
    INSERT i_seat INTO TABLE seats.
  ENDMETHOD.


  METHOD add_seats.
    DO i_count TIMES.
      add_seat( NEW #( ) ).
    ENDDO.
  ENDMETHOD.


  METHOD add_wheel.
    INSERT i_wheel INTO TABLE wheels.
  ENDMETHOD.


  METHOD add_wheels.
    DO i_count TIMES.
      add_wheel( NEW #( ) ).
    ENDDO.
  ENDMETHOD.


  METHOD build_car.
    ensure_minimal_configuration( ).
    r_car = NEW #(
        i_wheels = wheels
        i_seats = seats
        i_engine = engine
        ).
  ENDMETHOD.


  METHOD ensure_minimal_configuration.
    DATA(missing_wheels) = lines( wheels ) - zcl_car=>min_wheel_count.
    IF wheels IS INITIAL.
      add_wheels( zcl_car=>min_wheel_count ).
    ENDIF.
    IF seats IS INITIAL.
      add_seat( NEW #(  ) ).
    ENDIF.
    IF engine IS INITIAL.
      set_engine( NEW #(  ) ).
    ENDIF.

  ENDMETHOD.


  METHOD reset.
    CLEAR: engine, wheels, seats.
  ENDMETHOD.


  METHOD set_engine.
    engine = i_engine.
  ENDMETHOD.
ENDCLASS.
