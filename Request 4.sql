/*1 . Produce a report that calculates the incremental Sold Quantity(ISU%) for each category during the Diwali campaign. Additionally provide rankings for the categories based on their ISU%.


with cte as (
	select 
	p.category,
	sum([quantity_sold(before_promo)]) as qty_sold_bp,
	sum([quantity_sold(after_promo)]) as qty_sold_ap,
	cast(100.00 * (sum([quantity_sold(after_promo)]) - sum([quantity_sold(before_promo)])) / (sum([quantity_sold(before_promo)])) as decimal(10,2)) as isu
	from fact_events_promo f
	left join [dbo].[dim_products] p on f.product_code = p.product_code
	where f.campaign_id like 'CAMP_DIW_01'
	group by p.category)

select 
category,
isu as 'isu%',
rank() over(order by isu desc) as 'rank order'
from cte
