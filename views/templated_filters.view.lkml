
###### EXPLORE ######

  explore: templated_filter {
    from: derived_table_test
  }

###### VIEW ######

  view: derived_table_test {
    derived_table: {
      sql:
      SELECT id
        , status
        , created_at
      FROM orders
      WHERE {% condition templated_filter.status %} orders.status {% endcondition %}
      AND {% condition templated_filter.created_date %} created_at {% endcondition %} ;;
    }

    filter: status {
      type: string
      suggestions: ["Complete", "Pending", "Cancelled"]
    }

    dimension_group: created {
      type: time
      timeframes: [date, week, month, year]
      sql: ${TABLE}.created_at ;;
    }
  }
