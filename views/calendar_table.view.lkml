view: calendar_table {
  sql_table_name: demo_db.calendar_table ;;

  dimension: d {
    type: yesno
    sql: ${TABLE}.d ;;
  }

  dimension: day_name {
    type: string
    sql: ${TABLE}.dayName ;;
  }

  dimension_group: dt {
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
    sql: ${TABLE}.dt ;;
  }

  dimension: dw {
    type: yesno
    sql: ${TABLE}.dw ;;
  }

  dimension: holiday_descr {
    type: string
    sql: ${TABLE}.holidayDescr ;;
  }

  dimension: is_holiday {
    type: string
    sql: ${TABLE}.isHoliday ;;
  }

  dimension: is_payday {
    type: string
    sql: ${TABLE}.isPayday ;;
  }

  dimension: is_weekday {
    type: string
    sql: ${TABLE}.isWeekday ;;
  }

  dimension: m {
    type: yesno
    sql: ${TABLE}.m ;;
  }

  dimension: month_name {
    type: string
    sql: ${TABLE}.monthName ;;
  }

  dimension: q {
    type: yesno
    sql: ${TABLE}.q ;;
  }

  dimension: w {
    type: yesno
    sql: ${TABLE}.w ;;
  }

  dimension: y {
    type: number
    sql: ${TABLE}.y ;;
  }

  measure: count {
    type: count
    drill_fields: [day_name, month_name]
  }
}
