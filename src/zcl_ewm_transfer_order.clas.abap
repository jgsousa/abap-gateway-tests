class ZCL_EWM_TRANSFER_ORDER definition
  public
  final
  create public .

  public section.
  data: order_id type string,
        origin_uc type string,
        origin type ref to zcl_ewm_location,
        destination type ref to zcl_ewm_location,
        material type string,
        material_description type string,
        quantity type i,
        unit   type string.
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_EWM_TRANSFER_ORDER IMPLEMENTATION.
ENDCLASS.
