view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: id_name {
    type: string
    sql: Concat(${id},' ','id') ;;
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
  dimension: date_test {
    type: yesno
    sql: CASE WHEN extract(day from current_date()) = 1 THEN extract(month from ${created_date}) = extract(month from current_date) - 1
    ELSE extract(month from ${created_date}) = extract(month from current_date) END;;
  }

  dimension: year {
    type: date
    sql:    {% if created_year._in_query %}
    ${created_month}
  {% elsif created_quarter._in_query %}
    ${created_month}
  {% else %}
    ${created_date}
  {% endif %} ;;

  }



#   dimension: date_satisfies_filter {
#     type: yesno
#     hidden: no
#     sql: {% condition date_filter %} date_sub(${created_date}, interval 1 day) {% endcondition %} ;;
#   }


# measure: testing {
#   type: count
#   label: "{% if testing._is_selected %}{{ date_filter._parameter_value | date: '%s' | minus: 86400 | date: '%Y-%m-%d'}}{%else%}Testing Count Closed One Day Ago{%endif%}"
#   filters: {
#     field: date_satisfies_filter
#     value: "yes"
#   }
# }



  dimension: status {
    type: string
    sql: case when ${TABLE}.status='cancelled' then 'cancelled'
    when  ${TABLE}.status='pending' then 'pending' when  ${TABLE}.status='complete' then 'complete' else null end;;
#     order_by_field: count
  }

  dimension: status_test {
    sql: ${status};;
#     html: {% if value == 'complete' %}
#          <p><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20> Complete </p>
#       {% elsif value == 'pending' %}
#         <p><img src="http://findicons.com/files/icons/1681/siena/128/clock_blue.png" height=20 width=20> Pending </p>
#       {% else %}
#         <p><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20> Cancelled </p>
#       {% endif %}
# ;;
     html:  {% if value == 'complete' %}
        <p style="font-size: 20px; color : #FF0000"><img src="https://cdn1.iconfinder.com/data/icons/user-avatar-20/64/69-wander_woman-512.png" height=40 width=40> Seniors </p>
      {% elsif value == 'pending' %}
        <p style="font-size: 20px; color : #FF0000"><img src="https://cdn1.iconfinder.com/data/icons/user-avatar-20/64/69-wander_woman-512.png" height=40 width=40> Professionals </p>
      {% else %}
        <p style="font-size: 20px; color : #FF0000"><img src="https://cdn1.iconfinder.com/data/icons/user-avatar-20/64/69-wander_woman-512.png" height=40 width=40>{{ rendered_value }}</p>
      {% endif %}
    ;;
  }

  parameter: view_label {
    type: string
    default_value: "cancelled"
  }

  parameter: filter_status {
    type: string
    allowed_value: {
      label: "cancelled"
      value: "cancelled"
    }
    allowed_value: {
      label: "pending"
      value: "pending"
    }}

  dimension: status_filtered {
    type: string
    sql:case when ${status}='pending' then ${status} when ${status}='cancelled' then ${status} else null end;;
  }

  dimension: testing_filter {
    type: string
    sql: case when ${user_id}=2 then ${status} else null end ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    link: {
      label: "set 1 link"
      url: "{{ count_set_1._link }}"
    }
    link: {
      label: "set 2 link"
      url: "{{ count_set_2._link }}"
    }
  }

  measure: count_coalesce {
    type: number
    sql: case when ${count}= null then ${count}=0 else ${count} end ;;
  }

    measure: count_set_1 {
      type: count
      drill_fields: [users.first_name, users.last_name,id, users.id]
      hidden: no
    }

    measure: count_set_2 {
      type: count
      drill_fields: [order_items.id,  order_items.count, order_items.sale_price]
      hidden: yes
    }

}
