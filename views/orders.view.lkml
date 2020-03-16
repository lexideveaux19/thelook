view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }


#testing out fitler
  parameter: date_filter {
    type: date

  }

  dimension: date_satisfies_filter {
    type: yesno
    hidden: no
    sql: {% condition date_filter %} date_sub(${created_date}, interval 1 day) {% endcondition %} ;;
  }

measure: testing {
  type: count
  label: "{% parameter date_filter %}"
  filters: {
    field: date_satisfies_filter
    value: "yes"
  }
}


  measure: test {
    type: max
    sql: ${created_date} ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
#     order_by_field: count
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }
}
