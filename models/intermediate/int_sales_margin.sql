with sales as (

    select *
    from {{ ref('stg_raw__sales') }}

),

product as (

    select *
    from {{ ref('stg_raw__product') }}

),

joined as (

    select
        s.date_date,
        s.orders_id,
        s.products_id,
        s.quantity,
        s.revenue,
        p.purchase_price,

        -- satın alma maliyeti = miktar * satın alma fiyatı
        cast(s.quantity as float64) * p.purchase_price as purchase_cost,

        -- marj = gelir - satın alma maliyeti
        s.revenue - cast(s.quantity as float64) * p.purchase_price as margin

    from sales as s
    inner join product as p
        on s.products_id = p.products_id

)

select *
from joined

