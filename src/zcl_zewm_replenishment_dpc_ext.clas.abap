class ZCL_ZEWM_REPLENISHMENT_DPC_EXT definition
  public
  inheriting from ZCL_ZEWM_REPLENISHMENT_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.

  methods TRANSFERORDERS_GET_ENTITYSET
    redefinition .
  methods TRANSFERORDERS_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZEWM_REPLENISHMENT_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION.
    data: ls_parameter type line of /IWBEP/T_MGW_NAME_VALUE_PAIR,
          ls_data type ZCL_ZEWM_REPLENISHMENT_MPC=>TS_MESSAGE.

    data lo_repo type ref to ZCL_EWM_TO_REPOSITORY_MOCK.
    data lo_order type ref to ZCL_EWM_TRANSFER_ORDER.

    create object lo_repo.
    data(lo_service) = ZCL_EWM_TRANSFER_SERVICES=>CREATE( lo_repo ).

    if iv_action_name = 'ConfirmOrder'.
      if not it_parameter is initial.
        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'OrderId'.
        if sy-subrc = 0.
          " Confirmar order
          data(lo_result) = lo_service->CONFIRM_TRANSFER_ORDER( ls_parameter-VALUE ).
          if lo_result is bound and lo_result->TYPE = 'S'.
            ls_data-type = 'S'.
            ls_data-text = 'Ordem confirmada'.
            ls_data-number = '1'.
          else.
            ls_data-type = 'E'.
            ls_data-text = lo_result->TEXT.
            ls_data-number = lo_result->NUMBER.
          endif.
        else.
          ls_data-type = 'E'.
          ls_data-text = 'Ordem não encontrada'.
          ls_data-number = '1'.
        endif.
         copy_data_to_ref( EXPORTING is_data = ls_data
                CHANGING cr_data = er_data ).
      endif.
    endif.
  endmethod.


  method TRANSFERORDERS_GET_ENTITY.
    data: ls_key type line of /IWBEP/T_MGW_NAME_VALUE_PAIR.
    data: ls_data TYPE LINE OF ZCL_ZEWM_REPLENISHMENT_MPC=>TT_TRANSFERORDER.

    data lo_repo type ref to ZCL_EWM_TO_REPOSITORY_MOCK.
    create object lo_repo.
    data(lo_service) = ZCL_EWM_TRANSFER_SERVICES=>CREATE( lo_repo ).

    if iv_entity_name = 'TransferOrder' and not it_key_tab is initial.
      read table it_key_tab into ls_key with key name = 'Id'.
      if sy-subrc = 0.
        data(lo_order) = lo_service->get_transfer_order_for_id( user = sy-uname orderid = ls_key-value ).
        if lo_order is bound.
          ls_data-ID = lo_order->ORDER_ID.
          ls_data-MATERIAL = lo_order->MATERIAL.
          ls_data-MATERIALDESCRIPTION = 'Teste'.
          ls_data-ORIGINTYPE = lo_order->ORIGIN->TIPO_POSICAO.
          ls_data-ORIGINAREA = lo_order->origin->AREA_ARMAZENAMENTO.
          ls_data-ORIGINPOSITION = lo_order->origin->POSICAO.
          ls_data-DESTINATIONTYPE = lo_order->DESTINATION->TIPO_POSICAO.
          ls_data-DESTINATIONAREA = lo_order->destination->AREA_ARMAZENAMENTO.
          ls_data-DESTINATIONPOSITION = lo_order->destination->POSICAO.
          ls_data-QUANTITY = lo_order->QUANTITY.
          ls_data-unit = lo_order->UNIT.
          ls_data-UC = lo_order->ORIGIN_UC.
          er_entity = ls_data.
        endif.

      endif.
    endif.

  endmethod.


  method TRANSFERORDERS_GET_ENTITYSET.

    data: ls_data TYPE LINE OF ZCL_ZEWM_REPLENISHMENT_MPC=>TT_TRANSFERORDER.

    data lo_repo type ref to ZCL_EWM_TO_REPOSITORY_MOCK.
    data lo_order type ref to ZCL_EWM_TRANSFER_ORDER.

    create object lo_repo.
    data(lo_service) = ZCL_EWM_TRANSFER_SERVICES=>CREATE( lo_repo ).

    data(lo_orders) = lo_service->GET_TRANSFER_ORDERS( sy-uname ).
    data(lo_order_it) = lo_orders->GET_ITERATOR( ).
    while ( lo_order_it->HAS_NEXT( ) ).
       lo_order = CAST #( lo_order_it->get_next( ) ).
       ls_data-ID = lo_order->ORDER_ID.
       ls_data-MATERIAL = lo_order->MATERIAL.
       ls_data-MATERIALDESCRIPTION = 'Teste'.
       ls_data-ORIGINTYPE = lo_order->ORIGIN->TIPO_POSICAO.
       ls_data-ORIGINAREA = lo_order->origin->AREA_ARMAZENAMENTO.
       ls_data-ORIGINPOSITION = lo_order->origin->POSICAO.
       ls_data-DESTINATIONTYPE = lo_order->DESTINATION->TIPO_POSICAO.
       ls_data-DESTINATIONAREA = lo_order->destination->AREA_ARMAZENAMENTO.
       ls_data-DESTINATIONPOSITION = lo_order->destination->POSICAO.
       ls_data-QUANTITY = lo_order->QUANTITY.
       ls_data-unit = lo_order->UNIT.
       ls_data-UC = lo_order->ORIGIN_UC.
       append ls_data to et_entityset.

    ENDWHILE.
  endmethod.
ENDCLASS.
