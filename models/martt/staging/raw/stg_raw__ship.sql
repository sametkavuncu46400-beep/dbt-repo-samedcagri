with source as (

    select *
    from {{ source('raw', 'ship') }}

),

renamed as (

    select
        orders_id,
        shipping_fee,

        -- raw tablodaki camelCase kolon:
        -- logCost → staging'de snake_case: log_cost
        logCost as log_cost,

        cast(ship_cost as float64) as ship_cost
    from source

)

select *
from renamed




