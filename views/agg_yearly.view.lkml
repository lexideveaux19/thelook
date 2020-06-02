explore: agg_yearly {}
view: agg_yearly {
    derived_table: {
      sql: -- raw sql results do not include filled-in values for 'orders.created_year'


              SELECT
                YEAR(orders.created_at ) AS `orders.created_year`,
                COUNT(DISTINCT orders.id ) AS `orders.count`
              FROM demo_db.order_items  AS order_items
              LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id

              GROUP BY 1
              ORDER BY YEAR(orders.created_at ) DESC
              LIMIT 500
               ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: orders_created_year {
      type: number
      sql: ${TABLE}.`orders.created_year` ;;
    }

    dimension: orders_count {
      type: number
      sql: ${TABLE}.`orders.count` ;;
    }

    set: detail {
      fields: [orders_created_year, orders_count]
    }
  }
