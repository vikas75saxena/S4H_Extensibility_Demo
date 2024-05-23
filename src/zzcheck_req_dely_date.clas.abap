CLASS zzcheck_req_dely_date DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_sd_sls_check_head .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzcheck_req_dely_date IMPLEMENTATION.


  METHOD if_sd_sls_check_head~check_fields.
*    if salesdocument-requesteddeliverydate lt cl_abap_context_info=>get_system_date(  ).
*       messages = VALUE #( ( messagetype = 'E'
*                           messagetext = 'Requested Delivery Date cannot be in the past' ) ).
*    endif.
  ENDMETHOD.
ENDCLASS.
