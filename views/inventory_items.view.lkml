view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
#     group_label: "Created"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,month_name
    ]
    sql: ${TABLE}.created_at ;;
  }

  measure: created_test {
    type: date
    sql: ${created_date} ;;
  }

  measure: max_date {
    type: date
    sql: MAX(${created_raw}) ;;
    convert_tz: no
  }


  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: duration {
    type: duration
    intervals: [second, minute, hour,day]
    sql_start: ${created_date} ;;
    sql_end: ${sold_date};;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, products.id, products.item_name, order_items.count]
  }
}
