
---# Question 3. How many taxi trips were there on January 15?

--*******Answer:- Answer = 53,024

with tips as (
	select *
	from yellow_taxi_data
	where date(tpep_pickup_datetime)= '2021-01-15'
	
)

select count(*)
from tips


---# Question 4. Find the largest tip for each day. 
On which day it was the largest tip in January?

--*******Answer:-  Date = 2021-01-20 and Value = 1140.44

 with tips as (
	select date (tpep_pickup_datetime) as dt, max(tip_amount) as tip
	from yellow_taxi_data
	where date(tpep_pickup_datetime) between '2021-01-01' and '2021-01-31'
	group by date(tpep_pickup_datetime)
),

final as (
	select * 
	from tips 
	order by tip desc
	limit 1
	
)

select * 
from final


---# Question 5. Most popular destination

What was the most popular destination for passengers picked up 
in central park on January 14?

Enter the district name (not id)

--*******Answer:- Answer = Upper East Side South

with taxi as (
	select tx.*, zs."Zone"
	from yellow_taxi_data tx 
	join zones zs 
	on tx."PULocationID"=zs."LocationID"
	where zs."Zone"='Central Park' 
	and date(tx.tpep_pickup_datetime)='2021-01-14'
),

final as (
	select zones."Zone", count(*)
	from taxi 
	join zones 
	on taxi."DOLocationID"=zones."LocationID"
	group by 1
	order by 2 desc 
)
select * 
from final


---Quesiton 6 :- What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)?

---*******Answer :- Alphabet City / Unknown
with dt as (

	select tx.*, zs."Zone" as pickup, 
		case when ds."Zone" is null then 'unknwown'
		else ds."Zone"
		end as dropoff,
		concat(zs."Zone",' / ', ds."Zone") as pick_dropoff
	from yellow_taxi_data tx 
	join zones zs 
	on tx."PULocationID"=zs."LocationID"
	join zones ds 
	on tx."DOLocationID"=ds."LocationID" 
),

final as (
	
	select dt."pick_dropoff", avg(total_amount) as avg_price
	from dt
	group by 1
	order by avg_price desc 

)

select * 
from final 