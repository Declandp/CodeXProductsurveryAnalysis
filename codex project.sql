-- Created a view of the joined tables using the below query
/*CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `joined_data` AS
    SELECT 
        `f`.`Response_ID` AS `Response_ID`,
        `f`.`Respondent_ID` AS `Respondent_ID`,
        `f`.`Consume_frequency` AS `Consume_frequency`,
        `f`.`Consume_time` AS `Consume_time`,
        `f`.`Consume_reason` AS `Consume_reason`,
        `f`.`Heard_before` AS `Heard_before`,
        `f`.`Brand_perception` AS `Brand_perception`,
        `f`.`General_perception` AS `General_perception`,
        `f`.`Tried_before` AS `Tried_before`,
        `f`.`Taste_experience` AS `Taste_experience`,
        `f`.`Reasons_preventing_trying` AS `Reasons_preventing_trying`,
        `f`.`Current_brands` AS `Current_brands`,
        `f`.`Reasons_for_choosing_brands` AS `Reasons_for_choosing_brands`,
        `f`.`Improvements_desired` AS `Improvements_desired`,
        `f`.`Ingredients_expected` AS `Ingredients_expected`,
        `f`.`Health_concerns` AS `Health_concerns`,
        `f`.`Interest_in_natural_or_organic` AS `Interest_in_natural_or_organic`,
        `f`.`Marketing_channels` AS `Marketing_channels`,
        `f`.`Packaging_preference` AS `Packaging_preference`,
        `f`.`Limited_edition_packaging` AS `Limited_edition_packaging`,
        `f`.`Price_range` AS `Price_range`,
        `f`.`Purchase_location` AS `Purchase_location`,
        `f`.`Typical_consumption_situations` AS `Typical_consumption_situations`,
        `c`.`City` AS `City`,
        `c`.`Tier` AS `Tier`,
        `r`.`Name` AS `Name`,
        `r`.`Age` AS `Age`,
        `r`.`Gender` AS `Gender`
    FROM
        ((`dim_respondents` `r`
        JOIN `dim_cities` `c` ON ((`r`.`City_ID` = `c`.`City_ID`)))
        JOIN `fact_survey_responses` `f` ON ((`r`.`Respondent_ID` = `f`.`Respondent_ID`)))*/

-- looking at the whole data

SELECT * FROM new_schema.joined_data;


-- 1. Demographic Insights 

-- a. Who prefers energy drink more? (male/female/non-binary?)

SELECT Gender, COUNT(Consume_frequency) AS count
FROM joined_data
WHERE Consume_frequency  != ("Rarely")
GROUP BY Gender;
-- We see that males  prefer energy drinks more with 4852 responses being male whereas only 2793 responses being female

-- b. Which age group prefers energy drinks more?

SELECT Age, COUNT(Age) AS count
FROM joined_data
WHERE Consume_frequency  != ("Rarely")
GROUP BY Age
ORDER BY count DESC;

-- We see thaat 19-30 is the  age group which prefers eneergy drinks the most followeed by 31-45 then 15-18

-- c. Which type of marketing reaches the most Youth (15-30)?

SELECT Marketing_channels,count(*)
FROM joined_data
WHERE Age IN ("15-18","19-30")
Group BY 1
ORDER BY 2 DESC;

-- We see that online ads reach the youth group of ages 15-30 the most followed by TV commercials 

-- Consumer Preferences:


-- a. What are the preferred ingredients of energy drinks among respondents?

SELECT Ingredients_expected,count(*)
FROM joined_data
Group BY 1
ORDER BY 2 DESC; 

-- We see that Caffeine and vitamins are the ingredients which consumers most expect in their energy drinks

-- b. What packaging preferences do respondents have for energy drinks

SELECT Packaging_preference,count(*)
FROM joined_data
Group BY 1
ORDER BY 2 DESC;

-- we find that Compact and portable cans as well as Innovative bottle design are highly prefered by consumers






-- COMPETITION ANALYSIS:

-- a. Who are the current market leaders?
 
SELECT Current_brands, COUNT(*) AS count
FROM joined_data
GROUP BY Current_brands
ORDER BY count DESC
LIMIT 5;


-- b. What are the primary reasons consumers prefer those brands over ours
SELECT Reasons_for_choosing_brands, COUNT(*) AS count
FROM joined_data
WHERE Current_brands != 'CodeX'
GROUP BY 1
ORDER BY COUNT DESC;

-- top 3 Primary reasons for chooosing certain brands over CodeX are Brand reputation ,Taste/flavor preference and availability






-- Marketing Channels and Brand Awareness:

-- a. Which marketing channel can be used to reach more customers?

SELECT Marketing_channels, COUNT(*) AS count
FROM joined_data
GROUP BY Marketing_channels
ORDER BY count DESC
LIMIT 1;

-- Online ads can be used to reach more customers

-- b. How effective are different marketing strategies and channels in reaching our customers?

SELECT Marketing_channels, AVG(Taste_experience) AS avg_effectiveness
FROM joined_data
GROUP BY marketing_channels
ORDER BY 2 DESC;
/* We see that the physical marketting channels have a better avg_effectiveness than online marketing channels 
This can be attributed to the possibility that people have a better experience if they were introduced to the the product 
physically rather than digitally"*/


-- Brand Penetration:




-- a. How many have tried our brand?
SELECT Tried_before,count(*) AS cnt
FROM joined_data
GROUP BY Tried_before;

-- We see that more than 50% of respondents have not tried the CodeX Beverage 

-- b. What do people think about our brand? (overall rating)
SELECT AVG(Taste_experience) AS avg_rating
FROM joined_data;

-- The Brand has an average rating of 3.28,which is a fairly good rating but has room for improvement

-- c. Which cities do we need to focus more on?

-- retrieves  the percentage of negative perception of the brand from each city

SELECT City,100*COUNT(Brand_perception)/(SELECT COUNT(Brand_perception) FROM joined_data WHERE brand_perception IN("negative")) AS percentage_of_negative_responses
FROM joined_data
WHERE brand_perception IN("negative")
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- we see that Bangalore,Pune and Hyderabad have the highest percentage of negative perception.

-- retrieves  the percentage of neutral perception of the brand from each city
SELECT City,100*COUNT(Brand_perception)/(SELECT COUNT(Brand_perception) FROM joined_data WHERE brand_perception IN("neutral")) AS percentage_of_neutral_negative_responses
FROM joined_data
WHERE brand_perception IN("neutral")
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- We need to focus more on the brand perception in the city of Bangalore,Pune,Hyderabad,Mumbai,ahmedabad and chennai in that order

-- Purchase Behavior:
-- a. Where do respondents prefer to purchase energy drinks?

SELECT Purchase_location, 100*COUNT(*)/(SELECT Count(*) FROM joined_data) AS Purchase_location_pct
FROM joined_data
GROUP BY purchase_location;

-- We see that more than 80 % or purchases are made from Supermarkets,Online retailers and Gym and fitness centers
-- It can also be seen that more than 50% of purchases are made in physical stores rather than online stores.
-- The CodeX company should therefore put emphasis on shelving their product on large retailers like V-Shal,Big Bazaar.   

-- b. What are the typical consumption situations for energy drinks among respondents?

SELECT Typical_consumption_situations, 100*COUNT(*)/(SELECT Count(*) FROM joined_data)  AS Consumption_situation_pct
FROm joined_data
GROUP BY Typical_consumption_situations
ORDER BY 2 DESC;

-- We find that Sports/excercise along with Studying/working late make up more than 75% of consumption_situations of respondents

-- c. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?

SELECT Price_range,
       100*SUM(CASE WHEN Limited_edition_packaging = 'Yes' THEN 1 ELSE 0 END)/count(*) AS Pct_Yes_count,
       100*SUM(CASE WHEN Limited_edition_packaging = 'No' THEN 1 ELSE 0 END)/count(*) AS Pct_No_count,
       100*SUM(CASE WHEN Limited_edition_packaging = 'Not Sure' THEN 1 ELSE 0 END)/count(*) AS Pct_Not_sure_count,
        COUNT(*) AS total_count
FROM joined_data
GROUP BY Price_range
ORDER BY 5 DESC;

/*We find that 50-99 and 100-150 are the most voted for price ranges,
and that  40% of respondents said that they would buy an energy drink if it was 
limited_edition_packaging*/


/* Product Development
a. Which area of business should we focus more on our product development? 
(Branding/taste/availability)*/



SELECT Taste_experience ,100*Count(*)/(SELECT count(*) FROM joined_data WHERE Tried_before="Yes") AS Percent_of_Taste_experience
FROM joined_data
WHERE Tried_before ="Yes"
GROUP BY 1
ORDER BY 2 DESC;

-- Close to 75% of respondents who have tasted our drink rated it a above average.

SELECT brand_perception,100*COUNT(*)/(SELECT count(*) FROM joined_data) AS Brand_Perception_Percentage
FROM joined_data
GROUP BY 1;

-- Only 22% of respondents have a positive perception of the brand,whereas 59.74% have a neutral perception.
-- The company should therefore put emphasis on changing these potentail customers(neutral) perception to a positive one  .

SELECT Reasons_preventing_trying ,100*Count(*)/(SELECT count(*) FROM joined_data) AS Pct_preventing_trying
FROM joined_data
GROUP BY 1
ORDER BY 2 DESC;

-- We see that unavailability contributes only 24% for respondents not trying the beverage.
-- We should also note that 18.5% are unfamiliar and 22.8% have healt_concerns. 

/*The company should therefore  focus first on Branding before anything else .
They should work on ensuring customers that their beverage are above board on all health regulations 
They also need to improve their product awareness as well as thier availability.*/