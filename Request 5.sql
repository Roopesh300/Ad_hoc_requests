/*5 . Create a report featuring top 5 products, ranked by incremental revenue percentage (IR%) across all campaigns.

with cte as (
	select
	p.product_name,
	p.category,
	f.base_price * [quantity_sold(before_promo)] as rev_before_promo ,
	f.promo_price * [quantity_sold(after_promo)] as rev_after_promo
	from fact_events_promo f
	left join [dbo].[dim_products] p on f.product_code = p.product_code
	),
cte_1 as (
	select 
	product_name,
	category,
	sum(rev_before_promo) as rev_before_promo,
	sum(rev_after_promo) as rev_after_promo
	from cte
	group by product_name,category)

select top 5
product_name,
category,
cast(100 * ((rev_after_promo - rev_before_promo) / rev_before_promo) as decimal(10,2)) as 'ir%'
from cte_1
order by 'ir%' desc
