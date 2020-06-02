explore: agg_monthly {}
view: agg_monthly {
    derived_table: {
      sql: -- raw sql results do not include filled-in values for 'orders.created_month'


              SELECT
                DATE_FORMAT(orders.created_at ,'%Y-%m') AS `orders.created_month`,
                COUNT(DISTINCT orders.id ) AS `orders.count`
              FROM demo_db.order_items  AS order_items
              LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id

              GROUP BY 1
              ORDER BY DATE_FORMAT(orders.created_at ,'%Y-%m') DESC
              LIMIT 500
               ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: orders_created_month {
      type: string
      sql: ${TABLE}.`orders.created_month` ;;
    }

    dimension: orders_count {
      type: number
      sql: ${TABLE}.`orders.count` ;;
    }

    set: detail {
      fields: [orders_created_month, orders_count]
    }
    }
