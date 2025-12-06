{{ config(
    materialized = 'table'
) }}


with orders_margin as (

    -- Sipariş bazlı marj ve satış metrikleri
    select *
    from {{ ref('int_orders_margin') }}

),

orders_operational as (

    -- Sipariş bazlı operasyonel marj
    select *
    from {{ ref('int_orders_operational') }}

),

joined as (

    select
        o.date_date,
        o.orders_id,
        o.revenue,
        o.quantity,
        o.purchase_cost,
        o.margin,
        op.operational_margin
    from orders_margin o
    left join orders_operational op
        on o.orders_id = op.orders_id

),

daily_aggregated as (

    select
        date_date,

        -- KPI'lar
        count(distinct orders_id) as nb_of_transactions,
        sum(revenue) as total_revenue,
        sum(quantity) as total_quantity,
        sum(purchase_cost) as total_purchase_cost,
        sum(margin) as total_margin,
        sum(operational_margin) as total_operational_margin,

        -- Ortalama sepet
        sum(revenue) / count(distinct orders_id) as avg_basket

    from joined
    group by date_date
)

select *
from daily_aggregated
order by date_date
