CLASS zcl_sap_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING i_firstname     TYPE char20
                                  i_lastname      TYPE char30
                                  i_date_of_birth TYPE datum.
    METHODS get_name RETURNING VALUE(r_name) TYPE string.
    METHODS get_age RETURNING VALUE(r_age) TYPE i.
    Methods to_string returning value(r_object) type string.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: firstname     TYPE char20,
          lastname      TYPE char30,
          date_of_birth TYPE datum.
ENDCLASS.



CLASS ZCL_SAP_USER IMPLEMENTATION.


  METHOD constructor.
    me->firstname = i_firstname.
    me->lastname = i_lastname.
    me->date_of_birth = i_date_of_birth.
  ENDMETHOD.

  METHOD get_age.
    DATA years TYPE pea_scryy.
    CALL FUNCTION 'HR_HK_DIFF_BT_2_DATES'
      EXPORTING
        date1 = sy-datum
        date2 = me->date_of_birth
      IMPORTING
        years = years.

    r_age = years.
  ENDMETHOD.

  METHOD get_name.
    r_name = me->firstname && | | && me->lastname.
  ENDMETHOD.

  METHOD to_string.
    r_object = me->get_name( ) && | (| && me->get_age( ) && |) |.
  ENDMETHOD.
ENDCLASS.
