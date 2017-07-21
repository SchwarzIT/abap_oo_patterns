CLASS zcl_simple_output DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_output.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_simple_output IMPLEMENTATION.
  METHOD zif_output~display_data.
    cl_demo_output=>set_mode( cl_demo_output=>text_mode ).
    cl_demo_output=>write_data( value = i_data ).
    DATA(string) = cl_demo_output=>get( ).
    DO.
      SPLIT string AT cl_abap_char_utilities=>newline INTO DATA(line) string.
      IF line = '<AB_DATA></AB_DATA>'.
        EXIT.
      ENDIF.
      IF string IS INITIAL.
        WRITE: / line.
        EXIT.
      ENDIF.
      WRITE: / line.
    ENDDO.

*    cl_demo_output=>display( data = i_data ).
  ENDMETHOD.

ENDCLASS.
