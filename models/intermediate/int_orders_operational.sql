with orders_margin as (

    -- Sipariş bazında marj modeli
    select *
    from {{ ref('int_orders_margin') }}

),

ship as (

    -- Ship staging modeli
    select *
    from {{ ref('stg_raw__ship') }}

),

orders_operational as (

    select
        o.orders_id,
        o.date_date,

        -- operasyonel marj = marj + shipping_fee - log_cost - ship_cost
        cast(o.margin as float64)
        + coalesce(safe_cast(s.shipping_fee as float64), 0)
        - coalesce(safe_cast(s.log_cost  as float64), 0)
        - coalesce(s.ship_cost, 0)
        as operational_margin

    from orders_margin as o
    inner join ship as s
        on o.orders_id = s.orders_id

)

select *
from orders_operational
