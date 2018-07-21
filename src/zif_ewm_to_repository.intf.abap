interface ZIF_EWM_TO_REPOSITORY
  public .
  methods GET_TRANSFER_ORDER_FOR_USER
    importing
      !user         type uname
    returning
      value(output) type ref to cl_object_collection.
  methods CONFIRM_ORDER
    importing
      !ORDERID      type string
    returning
      value(output) type ref to ZCL_EWM_ACTION_RESULT.
  methods get_transfer_order_for_id
    importing
      !USER         type uname
      !ORDERID      type string
    returning
      value(output) type ref to zcl_ewm_transfer_order.
endinterface.
