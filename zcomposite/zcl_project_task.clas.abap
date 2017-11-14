CLASS zcl_project_task DEFINITION
  PUBLIC
  INHERITING FROM zcl_project
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS create_task
      IMPORTING
        i_id            TYPE zcom_project-project_id OPTIONAL
        i_parent_id     TYPE zcom_project-parent_id OPTIONAL
        i_title         TYPE zcom_project-title
        i_assignee      TYPE uname
        i_done          TYPE abap_bool
      RETURNING
        VALUE(r_result) TYPE REF TO zcl_project_task.

    METHODS:
      get_assignees REDEFINITION,
      assign_to REDEFINITION,
      add REDEFINITION.

  PROTECTED SECTION.
    METHODS create_struct_for_saving REDEFINITION.
    METHODS:
      create_struct_representation REDEFINITION.
  PRIVATE SECTION.
    DATA:
        assignee   TYPE uname.
ENDCLASS.



CLASS ZCL_PROJECT_TASK IMPLEMENTATION.


  METHOD add.
    RAISE EXCEPTION TYPE zcx_project_error
      EXPORTING
        textid = zcx_project_error=>operation_not_supported.
  ENDMETHOD.


  METHOD assign_to.
    modified = abap_true.
    assignee = i_assignee.
  ENDMETHOD.


  METHOD create_struct_for_saving.
    r_result = super->create_struct_for_saving( ).
    r_result-type = project_type-task.
    r_result-assignee = assignee.
  ENDMETHOD.


  METHOD create_struct_representation.
    r_result = super->create_struct_representation( ).
    r_result-assignee = assignee.
  ENDMETHOD.


  METHOD create_task.

    CREATE OBJECT r_result
      EXPORTING
        i_id        = i_id
        i_parent_id = i_parent_id
        i_title     = i_title.

    r_result->assignee = i_assignee.
    IF i_done = abap_true.
      r_result->mark_as_done( ).
    ENDIF.

  ENDMETHOD.


  METHOD get_assignees.
    INSERT assignee INTO TABLE r_assignees.
  ENDMETHOD.
ENDCLASS.
