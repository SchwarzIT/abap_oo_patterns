CLASS zcl_project DEFINITION
  PUBLIC
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_project_dao.

  PUBLIC SECTION.
    TYPES:
      tty_assignees TYPE SORTED TABLE OF uname WITH UNIQUE KEY table_line,

      BEGIN OF ty_display,
        title      TYPE zcom_project-title,
        assignee   TYPE zcom_project-assignee,
        completion TYPE zproject_completion,
        done       TYPE zcom_project-done,
        ref        TYPE REF TO zcl_project,
      END OF ty_display,
      tty_display TYPE STANDARD TABLE OF ty_display WITH DEFAULT KEY.

    CONSTANTS:
      BEGIN OF project_type,
        project TYPE zcom_project-type VALUE 'P',
        task    TYPE zcom_project-type VALUE 'T',
      END OF project_type.

    CLASS-METHODS create_project
      IMPORTING
        i_id            TYPE zcom_project-project_id OPTIONAL
        i_parent_id     TYPE zcom_project-parent_id OPTIONAL
        i_title         TYPE zcom_project-title
        i_done          TYPE abap_bool
      RETURNING
        VALUE(r_result) TYPE REF TO zcl_project.

    METHODS:
      constructor
        IMPORTING
          i_title     TYPE zcom_project-title
          i_id        TYPE zcom_project-project_id OPTIONAL
          i_parent_id TYPE zcom_project-parent_id OPTIONAL ,

      mark_as_done ,

      assign_to IMPORTING i_assignee TYPE uname,

      add
        IMPORTING i_sub TYPE REF TO zcl_project
        RAISING   zcx_project_error,

      calculate_status RETURNING VALUE(r_status) TYPE i,

      get_assignees RETURNING VALUE(r_assignees) TYPE tty_assignees,

      display_in_tree IMPORTING i_tree TYPE REF TO cl_salv_tree,

      recreate_tree_table RETURNING VALUE(r_result) TYPE tty_display.
    .

  PROTECTED SECTION.
    METHODS create_struct_representation
      RETURNING
        VALUE(r_result) TYPE ty_display.
    METHODS create_struct_for_saving
      RETURNING
        VALUE(r_result) TYPE zcom_project.


    DATA: modified TYPE abap_bool VALUE abap_false.

  PRIVATE SECTION.

    DATA:
      title      TYPE zcom_project-title,
      components TYPE STANDARD TABLE OF REF TO zcl_project WITH DEFAULT KEY,
      done       TYPE abap_bool,
      id         TYPE zcom_project-project_id,
      parent_id  TYPE zcom_project-parent_id.
    METHODS display_in_tree_internal
      IMPORTING
                i_nodes       TYPE REF TO cl_salv_nodes
                i_par_key     TYPE salv_de_node_key OPTIONAL
      RETURNING VALUE(r_node) TYPE REF TO cl_salv_node.



ENDCLASS.



CLASS ZCL_PROJECT IMPLEMENTATION.


  METHOD add.
    INSERT i_sub INTO TABLE components.
  ENDMETHOD.


  METHOD assign_to.
    FIELD-SYMBOLS: <comp> TYPE REF TO zcl_project.
    LOOP AT components ASSIGNING <comp>.
      <comp>->assign_to( i_assignee  ).
    ENDLOOP.
  ENDMETHOD.


  METHOD calculate_status.
    DATA: total_status TYPE i VALUE 0.
    FIELD-SYMBOLS: <comp> TYPE REF TO zcl_project.

    IF done = abap_true.
      r_status = 100.
      RETURN.
    ENDIF.
    LOOP AT components ASSIGNING <comp>.
      total_status = total_status + <comp>->calculate_status( ).
    ENDLOOP.
    r_status = total_status / lines(  components ).
  ENDMETHOD.


  METHOD constructor.
    me->title = i_title.
    me->id = i_id.
    me->parent_id = i_parent_id.
  ENDMETHOD.


  METHOD create_project.
    CREATE OBJECT r_result
      EXPORTING
        i_id        = i_id
        i_parent_id = i_parent_id
        i_title     = i_title.
    r_result->done = i_done.
  ENDMETHOD.


  METHOD create_struct_for_saving.
    r_result-project_id = id.
    r_result-title = title.
    r_result-parent_id = parent_id.
    r_result-type = project_type-project.
    r_result-done = done.
  ENDMETHOD.


  METHOD create_struct_representation.
    r_result-title = title.
    r_result-done = done.
    r_result-completion = calculate_status( ).
    r_result-ref = me.
  ENDMETHOD.


  METHOD display_in_tree.
    DATA: node  TYPE REF TO cl_salv_node,
          nodes TYPE REF TO cl_salv_nodes.

    nodes = i_tree->get_nodes( ).
    node = display_in_tree_internal(
        i_nodes = nodes
    ).
    TRY.
        node->get_children( ).
        node->expand( complete_subtree = abap_true ).
      CATCH cx_salv_msg.  "
    ENDTRY.
  ENDMETHOD.


  METHOD display_in_tree_internal.
    FIELD-SYMBOLS: <comp> TYPE REF TO zcl_project.

    i_nodes->add_node(
      EXPORTING
        related_node   =  i_par_key   " Schlüssel zum verwanten Knoten
        relationship   =  cl_gui_column_tree=>relat_last_child   " Knotenrelationen im Tree
        data_row       =  create_struct_representation( )
      RECEIVING
        node           =  r_node    " Knotenschlüssel
    ).
    LOOP AT components ASSIGNING <comp>.
      <comp>->display_in_tree_internal(
        EXPORTING
          i_nodes   = i_nodes
          i_par_key = r_node->get_key( )
      ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_assignees.
    FIELD-SYMBOLS:
      <comp>     TYPE REF TO zcl_project,
      <assignee> TYPE uname.

    LOOP AT components ASSIGNING <comp>.
      LOOP AT <comp>->get_assignees( ) ASSIGNING <assignee>.
        INSERT <assignee> INTO TABLE r_assignees.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD mark_as_done.
    FIELD-SYMBOLS: <comp> TYPE REF TO zcl_project.

    modified = done = abap_true.
    LOOP AT components ASSIGNING <comp>.
      <comp>->mark_as_done( ).
    ENDLOOP.
  ENDMETHOD.


  METHOD recreate_tree_table.
    FIELD-SYMBOLS: <comp> TYPE REF TO zcl_project.
    INSERT create_struct_representation( ) INTO TABLE r_result.
    LOOP AT components ASSIGNING <comp>.
      INSERT LINES OF <comp>->recreate_tree_table( ) INTO TABLE r_result.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
