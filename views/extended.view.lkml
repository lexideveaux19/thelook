include: "orders.view"

explore: extended {}
view: extended {
  extends: [orders]

  dimension: status {
    label: "test"
    type: string
    sql: ${TABLE}.status ;;
#     order_by_field: count
  }

  measure: additional_measure {
    type: count
  }

  }
