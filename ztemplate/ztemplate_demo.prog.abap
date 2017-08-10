*&---------------------------------------------------------------------*
*& Report  ztemplate_demo
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ztemplate_demo.

PARAMETER: p_minexp TYPE zworker-experience,
           p_minfre TYPE zworker-cur_tasks.

START-OF-SELECTION.

  DATA:
    workers          TYPE STANDARD TABLE OF zworker,
    exp_filter       TYPE REF TO zcl_filter,
    free_task_filter TYPE REF TO zcl_filter,
    log              TYPE REF TO zif_log.



  workers = VALUE #(
      ( name = 'Petra'    experience = 2   cur_tasks = 1  max_tasks = 2 )
      ( name = 'Tom'      experience = 7   cur_tasks = 1  max_tasks = 5 )
      ( name = 'Moritz'   experience = 10  cur_tasks = 5  max_tasks = 8 )
      ( name = 'Tamara'   experience = 7   cur_tasks = 1  max_tasks = 5 )
      ( name = 'Peter'    experience = 2   cur_tasks = 1  max_tasks = 2 )
      ( name = 'Melanie'  experience = 5   cur_tasks = 4  max_tasks = 4 )
      ( name = 'Max'      experience = 5   cur_tasks = 4  max_tasks = 4 )
      ( name = 'Marie'    experience = 10  cur_tasks = 5  max_tasks = 8 ) ).

  log = NEW zcl_salv_log( ).

  exp_filter = NEW zcl_worker_experience_filter(
      i_log            = log
      i_min_experience = p_minexp ).

  free_task_filter = NEW zcl_worker_free_tasks_filter(
      i_log            = log
      i_min_free_tasks =  p_minfre ).


  exp_filter->filter(
    CHANGING
      c_table = workers ).


  free_task_filter->filter(
    CHANGING
      c_table = workers ).

  log->finish( ).
