CLASS zcl_iterator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_iterator.
    METHODS constructor IMPORTING i_collection TYPE REF TO zif_collection.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA predicates TYPE STANDARD TABLE OF REF TO zif_predicate.
    METHODS check_predicates IMPORTING i_element       TYPE REF TO object
                             RETURNING VALUE(r_accept) TYPE xsdboolean.

ENDCLASS.



CLASS ZCL_ITERATOR IMPLEMENTATION.


  METHOD check_predicates.
    IF i_element IS NOT BOUND.
      RETURN.
    ENDIF.

    LOOP AT me->predicates ASSIGNING FIELD-SYMBOL(<fs_predicate>).
      DATA(accepted) = <fs_predicate>->accept( i_element = i_element ).
      IF accepted = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    r_accept = abap_true.
  ENDMETHOD.


  METHOD constructor.
    me->zif_iterator~collection = i_collection.
    me->zif_iterator~increment = 1.
  ENDMETHOD.


  METHOD zif_iterator~add_predicate.
    IF i_predicate IS BOUND.
      APPEND i_predicate TO me->predicates.
    ENDIF.
  ENDMETHOD.


  METHOD zif_iterator~clear_predicates.
    CLEAR me->predicates.
  ENDMETHOD.


  METHOD zif_iterator~get_current.
    r_object = me->zif_iterator~collection->get( me->zif_iterator~current_index ).
  ENDMETHOD.


  METHOD zif_iterator~get_next.
    IF check_predicates( me->zif_iterator~collection->get( me->zif_iterator~current_index ) ).
      r_object = me->zif_iterator~collection->get( me->zif_iterator~current_index ).
    ELSE.
      me->zif_iterator~current_index = me->zif_iterator~current_index + me->zif_iterator~increment.
      r_object = me->zif_iterator~get_next( ).
    ENDIF.
  ENDMETHOD.


  METHOD zif_iterator~has_next.
    IF check_predicates( me->zif_iterator~collection->get(
                            me->zif_iterator~current_index + me->zif_iterator~increment ) ).
      me->zif_iterator~current_index = me->zif_iterator~current_index + me->zif_iterator~increment.
      r_has_next = abap_true.
    ELSE.
      IF me->zif_iterator~current_index < me->zif_iterator~collection->size( ).
        me->zif_iterator~current_index = me->zif_iterator~current_index + me->zif_iterator~increment.
        r_has_next = me->zif_iterator~has_next( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD zif_iterator~reset.
    me->zif_iterator~current_index = 0.
  ENDMETHOD.
ENDCLASS.
