CLASS zcl_worker_free_tasks_filter DEFINITION
  PUBLIC
  INHERITING FROM zcl_filter
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          i_log            TYPE REF TO zif_log
          i_min_free_tasks TYPE i.

  PROTECTED SECTION.
    METHODS: log_start_of_filter REDEFINITION,
      log_exclusion REDEFINITION,
      log_filter_execution REDEFINITION,
      is_valid REDEFINITION,
      convert_to_internal_type REDEFINITION.
  PRIVATE SECTION.
    DATA:
      worker         TYPE zworker,
      min_free_tasks TYPE i.
ENDCLASS.



CLASS ZCL_WORKER_FREE_TASKS_FILTER IMPLEMENTATION.


  METHOD constructor.
    super->constructor( i_log ).
    min_free_tasks = i_min_free_tasks.
  ENDMETHOD.


  METHOD convert_to_internal_type.
    worker = i_row.
  ENDMETHOD.


  METHOD is_valid.
    r_result = COND #( WHEN worker-max_tasks - worker-cur_tasks >= min_free_tasks
                       THEN abap_true
                       ELSE abap_false ).
  ENDMETHOD.


  METHOD log_exclusion.
    DATA: free_tasks TYPE i.

    free_tasks = worker-max_tasks - worker-cur_tasks.
    log->log( VALUE #(
        msgid = 'ZPATTERN'
        msgno = '007'
        msgty = 'I'
        msgv1 = worker-name
        msgv2 = free_tasks ) ).
  ENDMETHOD.


  METHOD log_filter_execution.
    DATA(line_count) = lines( i_table ).
    log->log( VALUE #(  msgid = 'ZPATTERN' msgno = '008' msgty = 'I' msgv1 = line_count ) ).
  ENDMETHOD.


  METHOD log_start_of_filter.
    log->log( VALUE #(  msgid = 'ZPATTERN' msgno = '006' msgty = 'I' msgv1 = min_free_tasks ) ).
  ENDMETHOD.
ENDCLASS.
