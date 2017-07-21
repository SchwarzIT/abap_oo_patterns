INTERFACE zif_log
  PUBLIC .

  METHODS:
    log IMPORTING i_message TYPE bal_s_msg,
    finish.

ENDINTERFACE.
