INTERFACE zif_collection PUBLIC .

  METHODS add IMPORTING i_element TYPE REF TO object.
  METHODS remove IMPORTING i_element TYPE REF TO object.
  METHODS clear.
  METHODS size RETURNING VALUE(r_size) TYPE i.
  METHODS is_empty RETURNING VALUE(r_is_empty) TYPE abap_bool.
  METHODS get IMPORTING i_index         TYPE i
              RETURNING VALUE(r_object) TYPE REF TO object.
  METHODS contains IMPORTING i_element         TYPE REF TO object
                   RETURNING VALUE(r_contains) TYPE abap_bool.
  METHODS get_iterator RETURNING VALUE(r_iterator) TYPE REF TO zif_iterator.

ENDINTERFACE.
