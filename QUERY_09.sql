CREATE PROCEDURE `SUPPLIER_SERVICE`()
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
END