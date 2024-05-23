CLASS zzreq_dely_date_exped DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_sd_sls_check_before_save .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zzreq_dely_date_exped IMPLEMENTATION.


  METHOD if_sd_sls_check_before_save~check_document.
    DATA(lv_target_date) = CONV zzexp_dely_date( cl_abap_context_info=>get_system_date( ) + 8 ).
    IF salesdocument-requesteddeliverydate LT cl_abap_context_info=>get_system_date(  ).
      messages = VALUE #( ( messagetype = 'E'
                          messagetext = 'Requested Delivery Date cannot be in the past' ) ).
    ELSEIF salesdocument-requesteddeliverydate LT lv_target_date AND
     salesdocument_extension-zz1_reasonforexpedited_sdh IS INITIAL.
      messages = VALUE #( ( messagetype = 'E'
                            messagetext = 'Enter Reason for Expediting in case of expedited delivery' ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
