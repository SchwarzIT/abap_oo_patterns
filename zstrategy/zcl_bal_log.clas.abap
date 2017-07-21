CLASS zcl_bal_log DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_log .

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      messages TYPE bal_t_msg.
ENDCLASS.



CLASS ZCL_BAL_LOG IMPLEMENTATION.


  METHOD zif_log~finish.

    CHECK messages IS NOT INITIAL.

    DATA: header    TYPE bal_s_log,
          handle    TYPE balloghndl,
          handles   TYPE bal_t_logh,
          timestamp TYPE timestamp.


    GET TIME STAMP FIELD timestamp.

    header-extnumber = |ABAP CDR17 { timestamp }|.
    header-object = 'ZPATTERN'.
    header-aldate = sy-datum.
    header-altime = sy-uzeit.
    header-alprog = sy-repid.
    header-aluser = sy-uname.
    header-aldate_del = sy-datum + 7.


    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = header
      IMPORTING
        e_log_handle            = handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    INSERT handle INTO TABLE handles.


    LOOP AT messages ASSIGNING FIELD-SYMBOL(<msg>).
      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = handle
          i_s_msg          = <msg>
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

    ENDLOOP.



    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_client         = sy-mandt
        i_t_log_handle   = handles
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.


    CLEAR messages.

    CALL FUNCTION 'BAL_LOG_REFRESH'
      EXPORTING
        i_log_handle = handle    " Protokollhandle
      EXCEPTIONS
        OTHERS       = 0.


  ENDMETHOD.


  METHOD zif_log~log.

    INSERT i_message INTO TABLE messages.

  ENDMETHOD.
ENDCLASS.
