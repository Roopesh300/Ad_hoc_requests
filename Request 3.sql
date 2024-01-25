/*3 . Generate a report that displays each campaign along with total revenue generated before and after the campaign? 

with cte as (
	select 
	c.campaign_name,
	f.base_price * [quantity_sold(before_promo)] as total_revenue_before_promotion,
	f.promo_price * [quantity_sold(after_promo)] as total_revenue_after_promotion
	from fact_events_promo f
	left join [dbo].[dim_campaigns] c on f.campaign_id = c.campaign_id
	)

select 
campaign_name,
cast((SUM(total_revenue_before_promotion) / 1000000.00) as decimal(10,2)) AS 'total_revenue(before_promotion)',
cast((SUM(total_revenue_after_promotion) / 1000000.00) as decimal(10,2)) AS 'total_revenue(after_promotion)'
from cte
group by campaign_name
