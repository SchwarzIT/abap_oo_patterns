CLASS zcl_worker_experience_filter DEFINITION
  PUBLIC
  INHERITING FROM zcl_filter
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          i_log            TYPE REF TO zif_log
          i_min_experience TYPE i.
  PROTECTED SECTION.
    METHODS:
      log_start_of_filter REDEFINITION,
      log_exclusion REDEFINITION,
      log_filter_execution REDEFINITION,
      is_valid REDEFINITION.
    METHODS: convert_to_internal_type REDEFINITION.
  PRIVATE SECTION.

    DATA min_experience TYPE i.
    DATA worker TYPE zworker.
ENDCLASS.



CLASS ZCL_WORKER_EXPERIENCE_FILTER IMPLEMENTATION.


  METHOD constructor.
    super->constructor( i_log  ).

    min_experience = i_min_experience.

  ENDMETHOD.


  METHOD convert_to_internal_type.
    worker = i_row.
  ENDMETHOD.


  METHOD is_valid.
    r_result = cond #( when worker-experience >= min_experience
                       then abap_true
                       else abap_false ) .
  ENDMETHOD.


  METHOD log_exclusion.
    log->log( VALUE #(
        msgid = 'ZPATTERN'
        msgno = '003'
        msgty = 'I'
        msgv1 = worker-name
        msgv2 = worker-experience ) ).

  ENDMETHOD.


  METHOD log_filter_execution.

    data(line_count) = lines(  i_table ).
    log->log( value #( msgid = 'ZPATTERN' msgno = '005' msgty = 'I' msgv1 = line_count ) ).

  ENDMETHOD.


  METHOD log_start_of_filter.
    log->log( VALUE #( msgid = 'ZPATTERN'  msgno = '004' msgty = 'I') ).
  ENDMETHOD.
ENDCLASS.
