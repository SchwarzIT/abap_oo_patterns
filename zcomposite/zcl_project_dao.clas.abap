CLASS zcl_project_dao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      load_project_by_id
        IMPORTING i_project_id     TYPE zcom_project-project_id
        RETURNING VALUE(r_project) TYPE REF TO zcl_project,
      load_project_by_struc
        IMPORTING
                  i_project        TYPE zcom_project
        RETURNING VALUE(r_project) TYPE REF TO zcl_project,
      save_modified_parts_of_project
        IMPORTING i_project TYPE REF TO zcl_project.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS instatiate_project
      IMPORTING
        i_project        TYPE zcom_project
      RETURNING
        VALUE(r_project) TYPE REF TO zcl_project.

ENDCLASS.



CLASS ZCL_PROJECT_DAO IMPLEMENTATION.


  METHOD instatiate_project.

    IF i_project-type = zcl_project=>project_type-project.
      r_project = zcl_project=>create_project(
                i_id            = i_project-project_id
                i_parent_id     = i_project-parent_id
                i_title         = i_project-title
                i_done          = i_project-done
            ).
    ELSE.
      r_project = zcl_project_task=>create_task(
                i_id            = i_project-project_id
                i_parent_id     = i_project-parent_id
                i_title         = i_project-title
                i_assignee      = i_project-assignee
                i_done          = i_project-done
            ).
    ENDIF.


  ENDMETHOD.


  METHOD load_project_by_id.
    DATA:
      projects TYPE SORTED TABLE OF zcom_project WITH UNIQUE KEY parent_id project_id,
      project  LIKE LINE OF projects.

    FIELD-SYMBOLS: <project> TYPE zcom_project.

    SELECT *
    FROM zcom_project
    INTO TABLE projects
    WHERE project_id = i_project_id
       OR parent_id  = i_project_id.

    READ TABLE projects  WITH KEY project_id = i_project_id ASSIGNING <project>.
    IF sy-subrc <> 0.
      "todo exception
      RETURN.
    ENDIF.

    r_project = instatiate_project( <project> ).
    LOOP AT projects ASSIGNING <project> WHERE project_id <> i_project_id.
      r_project->add( i_sub = load_project_by_struc( <project> ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD load_project_by_struc.
    DATA:
      projects TYPE SORTED TABLE OF zcom_project WITH UNIQUE KEY parent_id project_id.

    FIELD-SYMBOLS: <project> TYPE zcom_project.

    SELECT *
    FROM zcom_project
    INTO TABLE projects
    WHERE parent_id  = i_project-project_id.

    r_project = instatiate_project( i_project ).


    LOOP AT projects ASSIGNING <project>.
      r_project->add( i_sub = load_project_by_struc( <project> ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD save_modified_parts_of_project.
    DATA: project_struct TYPE zcom_project.

    IF i_project->modified = abap_true.
      project_struct = i_project->create_struct_for_saving( ).

      IF project_struct-project_id IS INITIAL.

        CALL FUNCTION 'NUMBER_GET_NEXT'
          EXPORTING
            nr_range_nr = '01'
            object      = 'ZCOM_PROJ'
          IMPORTING
            number      = project_struct-project_id
          EXCEPTIONS
            OTHERS      = 1.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        INSERT INTO zcom_project VALUES project_struct.
      ELSE.
        UPDATE zcom_project FROM project_struct.
      ENDIF.
    ENDIF.

    LOOP AT i_project->components ASSIGNING FIELD-SYMBOL(<comp>).
      save_modified_parts_of_project( <comp> ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
