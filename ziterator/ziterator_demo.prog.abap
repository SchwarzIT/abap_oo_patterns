*&---------------------------------------------------------------------*
*& Report  ziterator_demo
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ziterator_demo.

" Create collection and iterator
DATA(collection) = NEW zcl_collection( ).
DATA(iterator) = collection->zif_collection~get_iterator( ).

"Create some dummy Objects
DATA(user) = NEW zcl_sap_user( i_firstname = 'Max' i_lastname = 'Moritz' i_date_of_birth = '19900109' ).
collection->zif_collection~add( user ).
user = NEW zcl_sap_user( i_firstname = 'Tom' i_lastname = 'Muster' i_date_of_birth = '19650809' ).
collection->zif_collection~add( user ).
user = NEW zcl_sap_user( i_firstname = 'Peter' i_lastname = 'Mustermann' i_date_of_birth = '19971121' ).
collection->zif_collection~add( user ).
user = NEW zcl_sap_user( i_firstname = 'Philip' i_lastname = 'Muster' i_date_of_birth = '19850603' ).
collection->zif_collection~add( user ).

"Basic Loop without restrictions
WRITE: / 'start of loop - output complete list'.
WHILE iterator->has_next( ) = abap_true.
  user ?= iterator->get_next( ).
  WRITE: / user->to_string( ).
ENDWHILE.
WRITE: / 'end of loop'.

*********************************************************************************

"Create Predicates
DATA(predicate_1) = NEW zcl_predicate_user_age( i_age = '30'  i_option = 'GE' ).
DATA(predicate_2) = NEW zcl_predicate_user_age( i_age = '50'  i_option = 'LE' ).
iterator->reset( ).
iterator->add_predicate( i_predicate = predicate_1 ).
iterator->add_predicate( i_predicate = predicate_2 ).

"Second Loop considering the Predicates
WRITE: / 'start of loop - predicate age GE 30 and age LE 50'.
WHILE iterator->has_next( ) = abap_true.
  user ?= iterator->get_next( ).
  WRITE: / user->to_string( ).
ENDWHILE.
WRITE: / 'end of loop'.
