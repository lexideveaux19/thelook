explore: agg_weekly {}
view: agg_weekly {
    derived_table: {
      sql: -- raw sql results do not include filled-in values for 'orders.created_week'


              SELECT
                DATE_FORMAT(TIMESTAMP(DATE(DATE_ADD(orders.created_at ,INTERVAL (0 - MOD((DAYOFWEEK(orders.created_at ) - 1) - 1 + 7, 7)) day))), '%Y-%m-%d') AS `orders.created_week`,
                COUNT(DISTINCT orders.id ) AS `orders.count`
              FROM demo_db.order_items  AS order_items
              LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id

              GROUP BY 1
              ORDER BY DATE_FORMAT(TIMESTAMP(DATE(DATE_ADD(orders.created_at ,INTERVAL (0 - MOD((DAYOFWEEK(orders.created_at ) - 1) - 1 + 7, 7)) day))), '%Y-%m-%d') DESC
              LIMIT 500
               ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: orders_created_week {
      type: string
      sql: ${TABLE}.`orders.created_week` ;;
    }

    dimension: orders_count {
      type: number
      sql: ${TABLE}.`orders.count` ;;
    }

    set: detail {
      fields: [orders_created_week, orders_count]
    }
  }
