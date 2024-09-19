use apr3;
select * from booking_info;
select * from hotel_info;
select * from transaction_info;

describe booking_info;


-- KPI
-- 1. Year wise sales
-- 2. Month wise sales
-- 3. Total Sales
-- 4. Rating wise sales
-- 5. MOM% change
-- 6. YOY% change
-- 7. Ares wise sales
-- 8. Top 3 Hotels which have highest sales
-- 9. Hotel wise highest sales
-- 10. Total No. of booking per year
-- 11. Total No. of booking per month
-- 12. Category Wise No. of Room Book
-- 13. Average Discount Offered
-- 14. count of incomplete Transaction_Status
-- 15. Transaction Success Rate


#Ques 1) Find the total sales of all the Hotels. 

select sum(sales) as Total_Sale from
(select price-discount as sales from booking_info)dt;


#Ques 2) Find the Month_Wise Total Sales of Hotels.

select monthname(booking_date) as Month_Wise,sum(price-discount) as sales
from booking_info 
group by Month_Wise;

#Ques 3) Find the Year_Wise Total Sales of Hotels.

select year(booking_date) as Year_Wise,sum(price-discount) as sales from booking_info
group by Year_Wise;


#Ques 4) Find the Rating_Wise Total Sales Of Hotels.

select h.Rating,sum(b.price-b.discount) as Sales from booking_info as b
join hotel_info as h
on b.hotel_id = h.hotel_id
group by h.rating
order by sales desc; 

# Ques 5) find the MOM% Change of Hotels.

select * ,round((sales-prev_mon_sale)/prev_mon_sale*100,2) as MOM_Percentage from
(select *,lag(Sales) over (order by  month_wise) prev_mon_Sale from  
(select month(booking_date) as Month_Wise,sum(price-discount) as Sales from booking_info
group by Month_Wise)dt)dt1
order by month_wise;

-- having Year_Wise='2023';


# Ques 6) Find the YOY% Change of Hotels.

select *,round(((sales-prev_year_sale)/prev_year_sale)*100,2) as YOY_Percentage from
(select *,lag(sales) over (order by year_wise) prev_year_sale from
(select year(booking_date) as Year_Wise ,sum(price-discount) as Sales from booking_info
group by year_wise)dt)dt1; 


# Ques 7) Find the Area Wise Total Sales

select h.location,sum(b.price-b.discount) as Sales from booking_info as b
join hotel_info as h
on b.hotel_id = h.hotel_id
group by h.location
order by sales desc;


# Ques 8)  Top 3 Hotels which have highest sales.

select h.hotel_name,sum(b.price-b.discount) as Sales from booking_info as b
join hotel_info as h
on b.hotel_id= h.hotel_id
group by h.hotel_name
order by sales desc
limit 3;

# Ques 9) find Hotel wise and Category Wise sales.

select h.hotel_name,b.room_category,sum(b.price-b.discount) as Sales from booking_info as b
join hotel_info as h
on b.hotel_id= h.hotel_id
group by b.room_category,h.hotel_name
order by h.hotel_name ,sales desc;

-- HOTEL ANALYSIS

# Ques 10)  Total No. of booking per year

select year(booking_date) as Year_Wise,count(booking_id) Total_Booking from booking_info
group by Year_Wise
order by year_wise asc;

select count(booking_id) as total from booking_info;

# Ques 11) find the Total No. of booking per month

select monthname(booking_date) as Month_wise ,
year(booking_date) as Year_Wise,count(booking_id) as Total_booking
from booking_info
group by Month_Wise,Year_Wise
order by year_wise,Month_Wise asc;

# Ques 12) find the Category Wise No. of Room Book

select room_category,count(booking_id) as No_Of_Rooms 
from booking_info 
group by room_category;

# Ques 13) Top 5 Hotels Which Give Max Discount.

select h.hotel_name,Max(b.discount) as Max_Discount 
from booking_info as b
join hotel_info as h
on b.hotel_id= h.hotel_id
group by h.hotel_name
order by Max_Discount desc
Limit 5;


# Ques 14) find the count of  Incomplete Transaction_Status.

select count(status) as Incomplete_Transaction 
from transaction_info
where status='incomplete';

# Ques 15) Transaction Success Rate.

SELECT 
    (SUM(CASE WHEN status = 'Complete' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS TransactionSuccessRate
FROM 
    transaction_info;
    
    
# Ques 16) Average Discount Offered.

select avg(discount) as Avg_Discount from booking_info;

# Ques 17) Transaction mode sale.

select t.transaction_mode,sum(b.price-b.discount) as Sale 
from booking_info as b
join transaction_info as t
on b.booking_id=t.booking_id
group by t.transaction_mode;


#Ques 18) Find the Avg Day Stay in Hotel. 
select avg(Stay_Days) as Avg_Stay_Days from
(select datediff(check_out_date,check_in_date) as Stay_Days 
from booking_info)dt;


with cte1 as 
(select datediff(check_out_date,check_in_date) as Stay_Days from booking_info)
select avg(Stay_Days) Avg_Stay_Days from cte1;


