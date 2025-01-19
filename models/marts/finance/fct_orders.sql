with orders as (
    select *
    from {{ ref('stg_jaffle_shop__orders')}}
),

payments as (
    select * 
    from {{ ref('stg_stripe__payments')}}
),

order_payments as (
    select *
    from payments
    where status = 'success'
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (order_payments.amount, 0) as amount
    from orders
    left join order_payments using (order_id)
)

select * from final
