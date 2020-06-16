

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
#     label: " "
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id;;
  }

  measure: status_count {
    view_label: "{% parameter orders.view_label %}"
    type: count_distinct
  }

  dimension: test {
    type: number
    # hidden: yes
    sql: case when ${TABLE}.order_id=3 or then 'yes' else 'no' end;;
  }

  dimension: testing {
    type: number
    # hidden: yes
    sql: case when ${inventory_item_id}=25 or ${inventory_item_id}=27 then ${order_id} else null end;;
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
  measure: count_test {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [orders.created_date, sale_price]
    link: {
      label: "Show as scatter plot"
      url: "
      {% assign vis_config = '{
      \"stacking\" : \"\",
      \"show_value_labels\" : false,
      \"label_density\" : 25,
      \"legend_position\" : \"center\",
      \"x_axis_gridlines\" : true,
      \"y_axis_gridlines\" : true,
      \"show_view_names\" : false,
      \"limit_displayed_rows\" : false,
      \"y_axis_combined\" : true,
      \"show_y_axis_labels\" : true,
      \"show_y_axis_ticks\" : true,
      \"y_axis_tick_density\" : \"default\",
      \"y_axis_tick_density_custom\": 5,
      \"show_x_axis_label\" : false,
      \"show_x_axis_ticks\" : true,
      \"x_axis_scale\" : \"auto\",
      \"y_axis_scale_mode\" : \"linear\",
      \"show_null_points\" : true,
      \"point_style\" : \"circle\",
      \"ordering\" : \"none\",
      \"show_null_labels\" : false,
      \"show_totals_labels\" : false,
      \"show_silhouette\" : false,
      \"totals_color\" : \"#808080\",
      \"type\" : \"looker_scatter\",
      \"interpolation\" : \"linear\",
      \"series_types\" : {},
      \"colors\": [
      \"palette: Santa Cruz\"
      ],
      \"series_colors\" : {},
      \"x_axis_datetime_tick_count\": null,
      \"trend_lines\": [
      {
      \"color\" : \"#000000\",
      \"label_position\" : \"left\",
      \"period\" : 30,
      \"regression_type\" : \"average\",
      \"series_index\" : 1,
      \"show_label\" : true,
      \"label_type\" : \"string\",
      \"label\" : \"30 day moving average\"
      }
      ]
      }' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000"
    }
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
    value_format: "$#,##0"
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

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: "usd"
  }

  measure: percent_complete {type: number sql: 1.0*(${count});;
    html: <div style="float: left
          ; width:{{ value | divided_by:2 }}
          ; background-color: rgba(0,180,0,{{ value| divided_by:2 }})
          ; text-align:left
          ; color: #FFFFFF
          ; border-radius: 5px"> <p style="margin-bottom: 0; margin-left: 4px;">{{ value | times:100 }}%</p>
          </div>
      ;;
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
