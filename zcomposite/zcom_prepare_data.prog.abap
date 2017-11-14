*&---------------------------------------------------------------------*
*& Report  zfbtest
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zcom_prepare_data.


START-OF-SELECTION.

  TYPES tt_project TYPE STANDARD TABLE OF zcom_project WITH DEFAULT KEY.

  DATA(projects) = VALUE tt_project(
    ( project_id = 1   title = 'My very big project'      parent_id = 0    assignee = ''        type = 'P'    done = abap_false )
    ( project_id = 2   title = 'Create a subtask'         parent_id = 1    assignee = 'JOHN'    type = 'T'    done = abap_true  )
    ( project_id = 3   title = 'Create a subproject'      parent_id = 1    assignee = 'TINA'    type = 'T'    done = abap_false )
    ( project_id = 4   title = 'Some new subproject'      parent_id = 1    assignee = ''        type = 'P'    done = abap_false )
    ( project_id = 5   title = '1. task of subproject'    parent_id = 4    assignee = 'TIM'     type = 'T'    done = abap_false )
    ( project_id = 6   title = '2. task of subproject'    parent_id = 4    assignee = 'ANNA'    type = 'T'    done = abap_true  )
    ( project_id = 7   title = 'second subproject'        parent_id = 1    assignee = ''        type = 'P'    done = abap_false )
    ( project_id = 8   title = 'another task'             parent_id = 7    assignee = 'JANE'    type = 'T'    done = abap_false )
  ).

  DELETE FROM zcom_project.

  INSERT zcom_project FROM TABLE projects.

  WRITE sy-subrc.
