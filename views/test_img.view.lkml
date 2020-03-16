view: test_img {
  sql_table_name: demo_db.testImg ;;

  dimension: image_source {
    type: string
    sql: ${TABLE}.imageSource ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
