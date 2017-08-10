CLASS zcl_salv_log DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_log.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA messages TYPE STANDARD TABLE OF bal_s_msg.
ENDCLASS.



CLASS ZCL_SALV_LOG IMPLEMENTATION.


  METHOD zif_log~finish.
    TYPES: BEGIN OF gty_string,
             message TYPE string,
           END OF gty_string.

    DATA:
      message_texts TYPE STANDARD TABLE OF gty_string,
      text       LIKE LINE OF message_texts,
      salv       TYPE REF TO cl_salv_table.

    LOOP AT messages ASSIGNING FIELD-SYMBOL(<msg>).
      MESSAGE ID     <msg>-msgid
              TYPE   <msg>-msgty
              NUMBER <msg>-msgno
              WITH   <msg>-msgv1 <msg>-msgv2 <msg>-msgv3 <msg>-msgv4
              INTO text-message.
      CONDENSE text-message.
      INSERT text INTO TABLE message_texts.
    ENDLOOP.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table   = salv     " Basisklasse einfache ALV Tabellen
          CHANGING
            t_table        = message_texts ).
      CATCH cx_salv_msg.
    ENDTRY.
    salv->display( ).

  ENDMETHOD.


  METHOD zif_log~log.
    INSERT i_message INTO TABLE messages.
  ENDMETHOD.
ENDCLASS.
