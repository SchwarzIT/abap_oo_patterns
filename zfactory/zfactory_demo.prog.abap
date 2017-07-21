*&---------------------------------------------------------------------*
*& Report  zfactory_demo
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zfactory_demo.

DATA result TYPE STANDARD TABLE OF sflight WITH NON-UNIQUE KEY carrid connid fldate.
SELECT * FROM sflight WHERE seatsmax >= 470 INTO TABLE @RESULT UP TO 30 ROWS.

" Display as SALV
DATA(output_object) = zcl_factory=>get_output_instance( i_type = zcl_factory=>output_as_salv ).
output_object->display_data( result ).

" Display as WRITE Output
output_object = zcl_factory=>get_output_instance( i_type = zcl_factory=>output_as_write ).
output_object->display_data( result ).
