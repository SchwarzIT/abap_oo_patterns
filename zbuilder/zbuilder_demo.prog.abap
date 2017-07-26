*&---------------------------------------------------------------------*
*& Report  zbuilder_demo
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zbuilder_demo.


CLASS lcl_fast_engine DEFINITION CREATE PUBLIC INHERITING FROM zcl_engine.

  PUBLIC SECTION.
    METHODS:
      start REDEFINITION,
      accelerate REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_fast_engine IMPLEMENTATION.


  METHOD start.
    WRITE: 'The beast awakens', /.
  ENDMETHOD.

  METHOD accelerate.
    WRITE: 'VROOM, VROOM!', /.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_fast_wheel DEFINITION CREATE PUBLIC INHERITING FROM zcl_wheel.

  PUBLIC SECTION.
    METHODS:
      turn REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_fast_wheel IMPLEMENTATION.

  METHOD turn.
    WRITE: 'wheel spins really fast', /.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA: normal_car  TYPE REF TO zcl_car,
        tuned_car   TYPE REF TO zcl_car,
        car_builder TYPE REF TO zcl_car_builder.

  car_builder = NEW #( ).

  normal_car = car_builder->build_car( ).
  WRITE: 'Driving with normal car', /.
  normal_car->start_engine( ).
  normal_car->drive( ).

  car_builder->reset( ).

  car_builder->set_engine( NEW lcl_fast_engine( )  ).
  DO 4 TIMES.
    car_builder->add_wheel( NEW lcl_fast_wheel( ) ).
  ENDDO.

  tuned_car = car_builder->build_car( ).

  WRITE: 'Driving with fast car', /.
  tuned_car->start_engine( ).
  tuned_car->drive( ).
