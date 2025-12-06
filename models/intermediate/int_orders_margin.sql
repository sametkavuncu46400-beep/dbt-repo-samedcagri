with sales_margin as (

    -- Bir önceki ara modelimizi kullanıyoruz
    select *
    from {{ ref('int_sales_margin') }}

),

orders_margin as (

    select
        orders_id,
        date_date,

        -- siparişteki toplam gelir
        sum(revenue) as revenue,

        -- siparişteki toplam ürün adedi
        sum(quantity) as quantity,

        -- siparişteki toplam satın alma maliyeti
        sum(purchase_cost) as purchase_cost,

        -- siparişteki toplam marj
        sum(margin) as margin

    from sales_margin
    group by
        orders_id,
        date_date
)

select *
from orders_margin
