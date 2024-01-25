/*1 . Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF' (Buy One Get One Free) . 

select 
distinct
f.product_code,
p.product_name,
f.base_price,
f.promo_price
from fact_events_promo f
left join [dbo].[dim_products] p on f.product_code = p.product_code
where promo_type like 'BOGOF' and base_price > 500
