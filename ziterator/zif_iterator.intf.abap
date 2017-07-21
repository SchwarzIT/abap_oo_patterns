INTERFACE zif_iterator PUBLIC .

  METHODS has_next RETURNING VALUE(r_has_next) TYPE abap_bool.
  METHODS get_next RETURNING VALUE(r_object) TYPE REF TO object.
  METHODS get_current RETURNING VALUE(r_object) TYPE REF TO object.
  METHODS reset.
  METHODS add_predicate IMPORTING i_predicate TYPE REF TO zif_predicate.
  METHODS clear_predicates.

  DATA current_index TYPE i.
  DATA increment TYPE i.
  DATA collection TYPE REF TO zif_collection.
ENDINTERFACE.
