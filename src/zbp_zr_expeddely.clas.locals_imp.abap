CLASS  lhc_r_salesordertp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR salesorder RESULT result.
    METHODS request_expedited_delivery FOR MODIFY
      IMPORTING it_keys FOR ACTION salesorder~zzexpd_dely RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
    IMPORTING REQUEST requested_authorizations FOR salesorder RESULT result.

ENDCLASS.


CLASS lhc_r_salesordertp IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF i_salesordertp IN LOCAL MODE
    ENTITY salesorder
    FIELDS ( requesteddeliverydate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_req_dely_date).
    result = VALUE #( FOR <req_dely_date> IN lt_req_dely_date
                    ( %tky = <req_dely_date>-%tky
                      %features-%action-zzexpd_dely =
      COND #( WHEN <req_dely_date>-requesteddeliverydate - cl_abap_context_info=>get_system_date( )
                          GT 7 THEN if_abap_behv=>fc-o-enabled
                               ELSE if_abap_behv=>fc-o-disabled )
*                      %features-%field-ZZExpediatedDeliveryReason_SDH =
*     COND #( WHEN <req_dely_date>-RequestedDeliveryDate - cl_abap_context_info=>get_system_date( )
*                         gt 7 THEN if_abap_behv=>fc-o-enabled
*                              ELSE if_abap_behv=>fc-o-disabled )
                                 ) ) .
  ENDMETHOD.

  METHOD request_expedited_delivery.
    LOOP AT it_keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY salesorder
      UPDATE SET FIELDS WITH VALUE #(
      ( %tky = <ls_key>-%tky
        %data-requesteddeliverydate = cl_abap_context_info=>get_system_date( ) + 7 ) )
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).

      READ ENTITIES OF i_salesordertp IN LOCAL MODE
      ENTITY salesorder BY \_item
      FIELDS ( salesorder salesorderitem product )
      WITH VALUE #( (  %key-salesorder = <ls_key>-%key-salesorder ) )
      RESULT DATA(lt_salesorderitems)
      LINK DATA(itmhdr_link)
      ENTITY salesorderitem BY \_scheduleline
      FIELDS ( salesorder salesorderitem scheduleline requesteddeliverydate )
      WITH VALUE #( (  %key-salesorder = <ls_key>-%key-salesorder
                       %key-salesorderitem = '000010' )  )
      RESULT DATA(lt_salesorderitemschedulelines)
      LINK DATA(itm_sch_link)
      FAILED DATA(item_failed)
      REPORTED DATA(item_mapped).

      LOOP AT lt_salesorderitems ASSIGNING FIELD-SYMBOL(<ls_items>).
        MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
        ENTITY salesorderitem
        UPDATE SET FIELDS WITH VALUE #(
        ( %tky = <ls_items>-%tky
          %data-customerpaymentterms = '0001' ) )
          FAILED DATA(itm_upd_fail)
          MAPPED DATA(itm_upd_mapped)
          REPORTED DATA(itm_upd_reported).
      ENDLOOP.
      LOOP AT lt_salesorderitemschedulelines ASSIGNING FIELD-SYMBOL(<ls_schline>).
        MODIFY ENTITIES OF i_salesordertp IN LOCAL MODE
        ENTITY salesorderscheduleline
        UPDATE SET FIELDS WITH VALUE #(
        ( %tky = <ls_schline>-%tky
          %data-requesteddeliverydate = cl_abap_context_info=>get_system_date( ) + 7 ) )
               FAILED DATA(sch_upd_fail)
          MAPPED DATA(sch_upd_mapped)
          REPORTED DATA(sch_upd_reported).
      ENDLOOP.
      READ ENTITIES OF i_salesordertp IN LOCAL MODE
ENTITY salesorder
ALL FIELDS WITH CORRESPONDING #( it_keys )
RESULT DATA(salesorders).

      result = VALUE #( FOR <ls_salesorder> IN salesorders
                        ( %tky = <ls_salesorder>-%tky
                          %param = <ls_salesorder> ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

  ENDMETHOD.

ENDCLASS.
