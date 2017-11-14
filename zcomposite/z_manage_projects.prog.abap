*&---------------------------------------------------------------------*
*& Report  z_manage_projects
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT z_manage_projects.

DATA:
  project TYPE REF TO zcl_project,
  dao     TYPE REF TO zcl_project_dao,
  outtab  TYPE STANDARD TABLE OF zcl_project=>ty_display WITH DEFAULT KEY.

CLASS   lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS:
      double_click FOR EVENT double_click OF cl_salv_events_tree
        IMPORTING node_key columnname sender,
      constructor IMPORTING i_tree TYPE REF TO cl_salv_tree,

      on_function_click FOR EVENT added_function OF cl_salv_events_tree
        IMPORTING e_salv_function.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      tree  TYPE REF TO cl_salv_tree,
      nodes TYPE REF TO cl_salv_nodes.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD constructor.
    me->tree = i_tree.
    nodes = tree->get_nodes( ).
  ENDMETHOD.

  METHOD double_click.
    DATA: row  TYPE REF TO zcl_project=>ty_display,
          node TYPE REF TO cl_salv_node.

    node = nodes->get_node( node_key  ).
    row ?= node->get_data_row( ).

    IF columnname = 'COMPLETION' OR columnname = 'DONE'.
      row->ref->mark_as_done( ).
    ELSE.
      row->ref->assign_to( sy-uname ).
    ENDIF.
    nodes->delete_all( ).

    project->display_in_tree( tree ).

  ENDMETHOD.


  METHOD on_function_click.

    CASE e_salv_function.
      WHEN'SAVE'.
        dao->save_modified_parts_of_project( project ).
      WHEN 'BACK'.
        LEAVE TO screen 0.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.



PARAMETER prj_id TYPE zcom_project-project_id.

START-OF-SELECTION.

  DATA:
    tree      TYPE REF TO cl_salv_tree,
    projects  TYPE SORTED TABLE OF zcom_project WITH UNIQUE KEY parent_id project_id,
    functions TYPE REF TO cl_salv_functions_tree,
    columns   TYPE REF TO cl_salv_columns_tree,
    event     TYPE REF TO cl_salv_events_tree,
    handler   TYPE REF TO lcl_event_handler.


  cl_salv_tree=>factory(
    IMPORTING
      r_salv_tree   = tree     " ALV: Tree model
    CHANGING
      t_table       = outtab ).
  CREATE OBJECT dao.


  project = dao->load_project_by_id( prj_id ).

  IF project IS BOUND.
    project->display_in_tree( tree ).
  ENDIF.

  columns = tree->get_columns( ).
  columns->set_optimize( abap_true ).

  tree->set_screen_status(
    EXPORTING
      report        = 'Z_MANAGE_PROJECTS'
      pfstatus      = 'SAVE'
  ).

  event = tree->get_event( ).

  CREATE OBJECT handler
    EXPORTING
      i_tree = tree.

  SET HANDLER handler->double_click FOR event.
  SET HANDLER handler->on_function_click FOR event.

  tree->display( ).
