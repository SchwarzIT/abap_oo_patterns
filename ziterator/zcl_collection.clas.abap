CLASS zcl_collection DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_collection.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: collection TYPE STANDARD TABLE OF REF TO object.

ENDCLASS.



CLASS zcl_collection IMPLEMENTATION.

  METHOD zif_collection~add.
    APPEND i_element TO collection.
  ENDMETHOD.


  METHOD zif_collection~clear.
    CLEAR collection.
  ENDMETHOD.


  METHOD zif_collection~contains.
    IF line_exists( collection[ table_line = i_element ] ).
      r_contains = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_collection~get.
    IF line_exists( collection[ i_index ] ).
      r_object = collection[ i_index ].
    ENDIF.
  ENDMETHOD.


  METHOD zif_collection~get_iterator.
    r_iterator = NEW zcl_iterator( me ).
  ENDMETHOD.


  METHOD zif_collection~is_empty.
    IF me->zif_collection~size( ) = 0.
      r_is_empty = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD zif_collection~remove.
    DELETE collection WHERE table_line = i_element.
  ENDMETHOD.


  METHOD zif_collection~size.
    r_size = lines( collection ).
  ENDMETHOD.

ENDCLASS.
