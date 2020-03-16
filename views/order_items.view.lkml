view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    label: " "
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }


  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
#     Date formatting  https://help.looker.com/hc/en-us/articles/360023800253-Easy-Date-Formatting-with-Liquid
#     html: {{ rendered_value | date: "%b %Y" }};; does not preserve drill
    html: <a href="{{link}}"> {{value | date: "%b %Y"}} </a>;;
    drill_fields: [id]
  }



  dimension_group: days_between_orders_and_returns {
    type: duration
    convert_tz: no
    intervals: [day]
#     sql_start: timestamp(${returned_raw})  ;;
#     sql_end: Current_timestamp;;
    sql_start: timestamp(${orders.created_raw});;
    sql_end:timestamp(${returned_raw});;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension: transaction_tier {
    label: "Transaction Tier"
    type: string
    sql:case
      when ${sale_price} <= 1
      then '1 $0 to $15'
      when ${sale_price} > 0 and ${sale_price} <= 1
      then '2 $15 to $50'
      when ${sale_price} > 1 and ${sale_price} <= 2
      then '3 $50 to $100'
      when ${sale_price} > 2 and ${sale_price} <= 3
      then '4 $100 to $250'
      when ${sale_price} > 4 and ${sale_price} <= 6
      then '5 $250 to $500'
      when ${sale_price} > 6 and ${sale_price} <= 9
      then '6 $500 to $1000'
      when ${sale_price} > 9
      then '7 over $1000'
      end;;
  }

  dimension: tier {
    type: tier
    tiers: [1,2,3,6,9]
    style: integer
    sql: ${sale_price} ;;
  }

  dimension: price_range {
    case: {
      when: {
        sql: ${sale_price} < 20 ;;
        label: "Inexpensive"
      }
      when: {
        sql: ${sale_price} >= 20 AND ${sale_price} < 100 ;;
        label: "Normal"
      }
      when: {
        sql: ${sale_price} >= 100 ;;
        label: "Expensive"
      }
      else: "Unknown"
    }
  }


  measure: count {
    type: count
    drill_fields: [
      id,
      returned_time,
      sale_price,
      products.name
    ]
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }


  measure: least_expensive_item {
    type: min
    sql: ${sale_price} ;;
  }

  measure: most_expensive_item {
    type: max
    sql: ${sale_price} ;;
  }
}
