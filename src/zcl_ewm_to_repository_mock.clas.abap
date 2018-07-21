class ZCL_EWM_TO_REPOSITORY_MOCK definition
  public
  final
  create public .

  public section.
    interfaces zif_ewm_to_repository.

  protected section.
  private section.
    methods GET_RESOURCE_FOR_USER
      importing
        !user           type uname
      returning
        value(resource) type string.
ENDCLASS.



CLASS ZCL_EWM_TO_REPOSITORY_MOCK IMPLEMENTATION.
  METHOD GET_RESOURCE_FOR_USER.
*    select rsrc from  /SCWM/USER into @data(lv_resource) where uname = @user.
*      if sy-subrc = 0.
*        output = lv_resource.
*      endif.
    resource = 'EMPILHADOR5'.
  ENDMETHOD.

  METHOD ZIF_EWM_TO_REPOSITORY~GET_TRANSFER_ORDER_FOR_USER.
     data: lo_order type ref to zcl_ewm_transfer_order,
           lo_origin type ref to zcl_ewm_location,
           lo_destination type ref to zcl_ewm_location.

     create object output.
     data(lv_resource) = me->get_resource_for_user( user ).

     "Mock data to replace with the real select
*    select tanum, MATID, BATCHID, MEINS, VLTYP, VLBER, VLPLA,
*           NLTYP, NLBER, NLPLA, VLENR FROM /SCWM/ORDIM_O
*           where PROcty = '3010'.
*    ENDSELECT.
     create object lo_origin.
     lo_origin->tipo_posicao = '001'.
     lo_origin->posicao = '1-23-12-23'.
     lo_origin->area_armazenamento = '002'.
     create object lo_destination.
     lo_destination->tipo_posicao = '001'.
     lo_destination->posicao = '2-23-12-23'.
     lo_destination->area_armazenamento = '002'.
     create object lo_order.
     lo_order->order_id = '1'.
     lo_order->origin = lo_origin.
     lo_order->destination = lo_destination.
     lo_order->material = 'XEC-123233'.
     lo_order->material_description = 'Material de Teste'.
     lo_order->origin_uc = '102300000123'.
     lo_order->unit = 'UN'.
     lo_order->quantity = '1'.
     output->add( lo_order ).
     create object lo_order.
     lo_order->order_id = '2'.
     lo_order->origin = lo_origin.
     lo_order->destination = lo_destination.
     lo_order->material = 'XEC-123423'.
     lo_order->material_description = 'Teste de Material'.
     lo_order->origin_uc = '102300000124'.
     lo_order->quantity = '1'.
     lo_order->unit = '2'.
     output->add( lo_order ).
  ENDMETHOD.

  METHOD ZIF_EWM_TO_REPOSITORY~CONFIRM_ORDER.
    "Mock a substituir
    create object output.
    " If 1 or 2 confirm, otherwise reject.
    if ( orderid = '1' OR orderid = '2' ).
        output->type = 'S'.
        output->number = '1'.
        output->text = 'Sucesso'.
    else.
        output->type = 'E'.
        output->number = '1'.
        output->text = 'Ordem nao existe'.
    endif.
  ENDMETHOD.

  METHOD ZIF_EWM_TO_REPOSITORY~GET_TRANSFER_ORDER_FOR_ID.
    data lo_order type ref to zcl_ewm_transfer_order.
    data(lo_collection) = me->zif_ewm_to_repository~get_transfer_order_for_user( user ).
    data(lo_order_it) = lo_collection->GET_ITERATOR( ).
    while ( lo_order_it->HAS_NEXT( ) ).
       lo_order = CAST #( lo_order_it->get_next( ) ).
       if lo_order->order_id = orderid.
            output = lo_order.
            return.
       endif.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
