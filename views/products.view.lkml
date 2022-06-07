view: products {
  sql_table_name: looker-private-demo.ecomm.products ;;
  view_label: "Products"
  ### DIMENSIONS ###

  dimension: id {
    label: "ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: category {
    label: "Category"
    sql: TRIM(${TABLE}.category) ;;
    drill_fields: [item_name]
  }

  dimension: item_name {
    label: "Item Name"
    sql: TRIM(${TABLE}.name) ;;
    drill_fields: [id]
  }

  dimension: brand {
    label: "Brand"
    sql: TRIM(${TABLE}.brand) ;;
    link: {
      label: "{{value}} Brand Lookup Dashboard"
      url: "/dashboards-next/125?Brand%20Name={{ value | encode_uri }}"
    }
  }

  dimension: retail_price {
    label: "Retail Price"
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: department {
    label: "Department"
    sql: TRIM(${TABLE}.department) ;;
  }

  dimension: sku {
    label: "SKU"
    sql: ${TABLE}.sku ;;
  }

  dimension: distribution_center_id {
    label: "Distribution Center ID"
    type: number
    sql: CAST(${TABLE}.distribution_center_id AS INT64) ;;
  }

  ## MEASURES ##

  measure: count {
    label: "Count"
    type: count
    drill_fields: [detail*]
  }

  measure: brand_count {
    label: "Brand Count"
    type: count_distinct
    sql: ${brand} ;;
    drill_fields: [brand, detail2*, -brand_count] # show the brand, a bunch of counts (see the set below), don't show the brand count, because it will always be 1
  }

  measure: category_count {
    label: "Category Count"
    alias: [category.count]
    type: count_distinct
    sql: ${category} ;;
    drill_fields: [category, detail2*, -category_count] # don't show because it will always be 1
  }

  measure: department_count {
    label: "Department Count"
    alias: [department.count]
    type: count_distinct
    sql: ${department} ;;
    drill_fields: [department, detail2*, -department_count] # don't show because it will always be 1
  }

  set: detail {
    fields: [id, item_name, brand, category, department, retail_price, customers.count, orders.count, order_items.count, inventory_items.count]
  }

  set: detail2 {
    fields: [category_count, brand_count, department_count, count, customers.count, orders.count, order_items.count, inventory_items.count, products.count]
  }
}
