extend view entity C_SalesOrderManage with {
@UI: { 
fieldGroup: [{qualifier: 'OrderData', importance: #HIGH, type: #FOR_ACTION,
             dataAction: 'zzexpd_dely', label: 'Expedite Delivery' }]
}
  SalesOrder.ZZExpediatedDeliveryReason_SDH as ZZExpediatedDeliveryReason_SDH
}
