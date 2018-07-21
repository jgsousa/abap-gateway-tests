class ZCL_EWM_TRANSFER_SERVICES definition
  public
  final
  create public .

  public section.
    data: repository type ref to zif_ewm_to_repository.
    class-methods create
      importing
        !repo         type ref to zif_ewm_to_repository
      returning
        value(output) type ref to zcl_ewm_transfer_services.

    methods get_transfer_orders
      importing
        !USER         type uname
      returning
        value(output) type ref to cl_object_collection.
    methods get_transfer_order_for_id
      importing
        !USER         type uname
        !ORDERID      type string
      returning
        value(output) type ref to zcl_ewm_transfer_order.
    methods confirm_transfer_order
      importing
        !ID           type string
      returning
        value(output) type ref to zcl_ewm_action_result.

  protected section.
  private section.
    methods otimimize_route
      importing
        !orders       type ref to cl_object_collection
      returning
        value(output) type ref to cl_object_collection.
ENDCLASS.



CLASS ZCL_EWM_TRANSFER_SERVICES IMPLEMENTATION.

  METHOD GET_transfer_ORDERS.
    create object output.
    output = repository->get_transfer_order_for_user( user ).
  ENDMETHOD.

  METHOD CONFIRM_TRANSFER_ORDER.
    output = repository->confirm_order(  id ).
  ENDMETHOD.

  METHOD CREATE.
    data: lo_me type ref to zcl_ewm_transfer_services.
    create object lo_me.
    lo_me->repository = repo.
    output = lo_me.
  ENDMETHOD.

  METHOD OTIMIMIZE_ROUTE.
    output = orders.
  ENDMETHOD.

  METHOD GET_TRANSFER_ORDER_FOR_ID.
    output = me->repository->get_transfer_order_for_id( user = user orderid = orderid ).
  ENDMETHOD.

ENDCLASS.
