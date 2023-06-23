/* Show product report for product in india in 2021 for croma. */

select * from dim_customer
where customer like "%croma%";


SELECT monthname(f.date) as month,f.product_code,d.product as product_name,
d.variant,f.sold_quantity,round(g.gross_price,2) as gross_price_per_item,round(g.gross_price*f.sold_quantity,2) as total_gross_price
FROM fact_sales_monthly f
join dim_product d on d.product_code=f.product_code
join fact_gross_price g on g.product_code=d.product_code and 
g.fiscal_year=get_fiscal_year(f.date)
where customer_code=90002002 and
get_fiscal_year(date) = 2021 and
get_fiscal_quarter(date) = 'Q4'
order by date asc
limit 1000000;


/* Show aggregated monthly gross sales report chroma india customer. */

select f.date as month ,round(sum(g.gross_price*f.sold_quantity),2) as monthly_gross_sales
from fact_sales_monthly f
join fact_gross_price g on g.product_code=f.product_code and g.fiscal_year=get_fiscal_year(f.date)
where f.customer_code='90002002'
group by f.date,f.customer_code
order by f.date asc
limit 1000000;

/* Generate a yearly report for Croma India where there are two columns
1. Fiscal Year
2. Total Gross Sales amount In that year from Croma */

select get_fiscal_year(f.date) as fiscal_year, round(sum(f.sold_quantity*g.gross_price),2) as yearly_sales
from fact_sales_monthly f
join fact_gross_price g on g.product_code=f.product_code and
g.fiscal_year=get_fiscal_year(f.date)
where customer_code=90002002
group by get_fiscal_year(f.date)
order by get_fiscal_year(f.date) asc
limit 1000000;


/* create a stored procedure that can determine market badge based on following language.
if sold_quantity > 5 million then that market is considered as "gold" else "silver". 
input will be --> Market
				  Fiscal year
                  
output shoul be ---> Market Badge */

# stored procedure -->
select case when sum(f.sold_quantity)>5000000 then "Gold" else "Silver" end as "Market Badge"
from fact_sales_monthly f
join dim_customer c on f.customer_code=c.customer_code
where market="India" and get_fiscal_year(f.date)=2021
group by market
limit 1000000;

/* show report top markets, top products, top customers by net sales for given fiscal year for
financial performance.

rank 
market  
net_sales*/

