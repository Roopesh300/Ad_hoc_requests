/*2 . Generate a report that provides an overview of the number of stores in each city. The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence.

select 
city,
count(store_id) as 'store count'
from [dbo].[dim_stores]
group by city
order by 'store count' desc
