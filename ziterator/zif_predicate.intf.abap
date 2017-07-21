INTERFACE zif_predicate PUBLIC .
  METHODS accept IMPORTING i_element      TYPE REF TO object
                 RETURNING VALUE(r_valid) TYPE abap_bool.
ENDINTERFACE.
