CLASS zcl_engine DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS start.
    METHODS accelerate.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ENGINE IMPLEMENTATION.


  METHOD accelerate.
    write: 'Engine: vroom, vroom', /.
  ENDMETHOD.


  METHOD start.
    write: 'Engine purs softly', /.
  ENDMETHOD.
ENDCLASS.
