view: epoch_test {
  sql_table_name: demo_db.epochTest ;;

  dimension: epoch {
    type: number
    sql: ${TABLE}.epoch ;;
  }

  dimension_group: normal {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.normal ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
