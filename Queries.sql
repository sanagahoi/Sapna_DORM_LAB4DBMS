-- 3)Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

SELECT COUNT(OC2.CUS_GENDER) AS NoOfCustomers, OC2.CUS_GENDER FROM
(SELECT OC.CUS_ID, OC.CUS_GENDER, OC.CUS_NAME FROM
(SELECT `ORDER`.*, CUSTOMER.CUS_NAME, CUS_GENDER FROM `ORDER` 
INNER JOIN
CUSTOMER WHERE 
`ORDER`.CUS_ID = CUSTOMER.CUS_ID HAVING `ORDER`. ORD_AMOUNT >= 3000) AS OC 
GROUP BY  OC.CUS_ID) AS OC2 GROUP BY OC2.CUS_GENDER;


-- 4)Display all the orders along with product name ordered by a customer having Customer_Id=2

SELECT `ORDER`.ORD_ID, `order`.ORD_AMOUNT, `ORDER`.ORD_DATE, `ORDER`.CUS_ID , product.PRO_NAME 
FROM `ORDER` , supplier_pricing, product 
WHERE
 `ORDER`.PRICING_ID = SUPPLIER_PRICING.PRICING_ID and
 supplier_pricing.PRO_ID =  product.PRO_ID AND `order`.CUS_ID = 2; 
 
 -- 5)Display the Supplier details who can supply more than one product.

SELECT supplier.* FROM supplier where supplier.SUPP_ID in
(select supplier_pricing.SUPP_ID from supplier_pricing group by supp_id having 
	count(supp_id)>1) group by supplier.SUPP_ID;


-- 6)Find the least expensive product from each category and print the table with category id, name, product name and price of the product

select category.CAT_ID, category.CAT_NAME, CP.PRO_NAME ,min(CP.MIN_PRICE) AS Price_Of_The_Product FROM category 
inner join
(select product.PRO_NAME, product.CAT_ID, SP.* FROM product 
inner join
(select PRO_ID, min(SUPP_PRICE) as MIN_PRICE FROM supplier_pricing  group by PRO_ID) as SP
where
 SP.PRO_ID = product.PRO_ID) as CP
WHERE 
CP.CAT_ID = category.CAT_ID group by CP.CAT_ID; 

-- 7)	Display the Id and Name of the Product ordered after “2021-10-05”.

select product.PRO_ID, product.PRO_NAME from `ORDER` , supplier_pricing , product 
where `order`.PRICING_ID = supplier_pricing.PRICING_ID 
and supplier_pricing.PRO_ID = product.PRO_ID AND `order`.ORD_DATE > "2021-10-05"; 


-- 8)	Display customer name and gender whose names start or end with character 'A'.
SELECT customer.CUS_NAME, customer.CUS_GENDER FROM customer 
where customer.CUS_NAME like 'A%' or customer.CUS_NAME like '%A' ;

-- 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,
-- If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

DELIMITER &&  
   CREATE PROCEDURE `SUPPLIER_DETAILS`()
BEGIN
   SELECT FINAL.SUPP_ID, FINAL.SUPP_NAME, FINAL.RATINGS  ,
   CASE
   WHEN FINAL.RATINGS = 5 THEN 'Excellent Service'
   WHEN FINAL.RATINGS > 4 THEN 'Good Service'
   WHEN FINAL.RATINGS > 2 THEN 'Average Service'
   ELSE 'Poor Service'
   END AS Type_of_Service FROM
   (SELECT SD.SUPP_ID, supplier.SUPP_NAME, SD.RATES AS RATINGS FROM SUPPLIER 
   INNER JOIN 
  (SELECT supplier_pricing.SUPP_ID , O_RAT.RAT_RATSTARS AS RATES FROM supplier_pricing
  INNER JOIN 
  (SELECT `ORDER`.PRICING_ID, rating.RAT_RATSTARS FROM `ORDER` 
  INNER JOIN 
  rating ON rating.ORD_ID = `ORDER`.ORD_ID) AS O_RAT
  ON O_RAT.PRICING_ID = supplier_pricing.PRICING_ID) AS SD) AS FINAL ;
  END &&  
DELIMITER ;

CALL SUPPLIER_DETAILS();
