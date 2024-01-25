
-- Buisness Requests -- 
--creating facts table with new promo price after applying the promotions -- 
select * into fact_events_promo from
(
select *,
case 
	when promo_type like '25% OFF' then (base_price - 0.25 * base_price)
	when promo_type like '33% OFF' then  (base_price - 0.33 * base_price)
	when promo_type like '50% OFF' then  (base_price - 0.50 * base_price)
	when promo_type like 'BOGOF' then  (base_price / 2)
	when promo_type like '500 Cashback' then  (base_price - 500)
	end as promo_price
from [dbo].[fact_events]
)tbl

-- 1. -- 
select 
distinct
f.product_code,
p.product_name,
f.base_price,
f.promo_price
from fact_events_promo f
left join [dbo].[dim_products] p on f.product_code = p.product_code
where promo_type like 'BOGOF' and base_price > 500


--2--
select 
city,
count(store_id) as 'store count'
from [dbo].[dim_stores]
group by city
order by 'store count' desc

-- 3 -- 
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

-- 4 -- 
with cte as (
	select 
	p.category,
	sum([quantity_sold(before_promo)]) as qty_sold_bp,
	sum([quantity_sold(after_promo)]) as qty_sold_ap,
	cast(100 * (sum([quantity_sold(after_promo)]) - sum([quantity_sold(before_promo)])) / (sum([quantity_sold(before_promo)])) as decimal(10,2)) as isu
	from fact_events_promo f
	left join [dbo].[dim_products] p on f.product_code = p.product_code
	where f.campaign_id like 'CAMP_DIW_01'
	group by p.category)

select 
category,
isu as 'isu%',
rank() over(order by isu desc) as 'rank order'
from cte


-- 5 --
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



