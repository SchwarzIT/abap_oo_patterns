*"* use this source file for your ABAP unit test classes
CLASS ltcl_project DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: project TYPE REF TO zcl_project,
          task    TYPE REF TO zcl_project_task.
    METHODS:
      setup,
      assert_project_status_is IMPORTING i_status TYPE i,
      status_of_inital_project_is_0 FOR TESTING RAISING cx_static_check,
      status_of_done_project_is_100 FOR TESTING RAISING cx_static_check,
      status_with_half_tasks_done_50 FOR TESTING RAISING cx_static_check,
      project_done_closes_subtasks FOR TESTING RAISING cx_static_check,
      add_new_task_to_project
        RETURNING
          VALUE(r_task) TYPE REF TO zcl_project_task.
ENDCLASS.


CLASS ltcl_project IMPLEMENTATION.

  METHOD setup.
    CLEAR task.
    CREATE OBJECT project
      EXPORTING
        i_title = 'My Project'.
  ENDMETHOD.

  METHOD assert_project_status_is.
    cl_abap_unit_assert=>assert_equals( exp = i_status act = project->calculate_status( ) ).
  ENDMETHOD.

  METHOD status_of_inital_project_is_0.
    assert_project_status_is( 0 ).
  ENDMETHOD.

  METHOD status_of_done_project_is_100.
    project->mark_as_done( ).
    assert_project_status_is( 100 ).
  ENDMETHOD.

  METHOD status_with_half_tasks_done_50.
    add_new_task_to_project( ).
    task = add_new_task_to_project( ).
    task->mark_as_done( ).
    assert_project_status_is( 50 ).
  ENDMETHOD.

  METHOD add_new_task_to_project.
    CREATE OBJECT r_task
      EXPORTING
        i_title = 'Some Task'.
    project->add( r_task ).
  ENDMETHOD.

  METHOD project_done_closes_subtasks.
    task = add_new_task_to_project( ).
    project->mark_as_done( ).
    cl_abap_unit_assert=>assert_equals( exp = 100 act = task->calculate_status( ) ).
  ENDMETHOD.

ENDCLASS.
