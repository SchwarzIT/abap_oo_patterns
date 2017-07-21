CLASS ZCL_PREDICATE_USER_AGE DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_predicate.
    METHODS constructor IMPORTING i_age  TYPE i
                                  i_option TYPE ddoption.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA age TYPE i.
    DATA option TYPE ddoption.
ENDCLASS.



CLASS ZCL_PREDICATE_USER_AGE IMPLEMENTATION.


  METHOD constructor.
    me->age = i_age.
    me->option = i_option.
  ENDMETHOD.


  METHOD zif_predicate~accept.
    DATA user TYPE REF TO zcl_sap_user.
    IF i_element IS BOUND.
      TRY.
          user ?= i_element.
          DATA(predicate_range) = VALUE rseloption( ( sign = 'I' option = me->option low = me->age ) ).
          IF user->get_age( ) IN predicate_range.
            r_valid = abap_true.
          ENDIF.
        CATCH cx_sy_move_cast_error.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
