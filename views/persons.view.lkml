view: persons {
  sql_table_name: demo_db.persons ;;

  dimension: age {
    type: number
    sql: ${TABLE}.Age ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.FirstName ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LastName ;;
  }

  measure: count {
    type: count
    drill_fields: [last_name, first_name]
  }
}
