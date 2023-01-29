/*
Chemicals in Cosmetics Dataset  Exploration 
Skills used: Joins, CTE's, Aggregate Functions, Creating Views
*/


SELECT TOP 10*
FROM portfolioproject..chemicalsincosmetics1

SELECT *
FROM portfolioproject..chemicalsincosmeticsdatadictionary

SELECT *
FROM portfolioproject..chemicalsincosmeticssubcategories


SELECT TOP 10*
FROM portfolioproject..chemicalsincosmetics3

-- setting out our kpi

SELECT  DISTINCT COUNT(ProductName) as totalno_of_Products
FROM portfolioproject..chemicalsincosmetics

SELECT  COUNT(DISTINCT BrandName) as totalno_of_brands
FROM portfolioproject..chemicalsincosmetics

SELECT  COUNT(DISTINCT CompanyName) as totalno_of_companies
FROM portfolioproject..chemicalsincosmetics

SELECT  COUNT(DISTINCT ChemicalName) as totalno_of_chemicals
FROM portfolioproject..chemicalsincosmetics

---- Q1. Find out which chemicals were used the most in cosmetics and personal care products.

SELECT ChemicalName, COUNT(ChemicalName) AS Chemical_Appearance
FROM portfolioproject..chemicalsincosmetics
GROUP BY ChemicalNameS
ORDER BY 2 DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS ONLY

----q2. Find out which companies used the most reported chemicals in their cosmetics and personal care products.
--Top 10 companies who had reported the most chemicals  

SELECT CompanyName, COUNT(ChemicalName) AS Chemicals_reported
FROM portfolioproject..chemicalsincosmetics
GROUP BY CompanyName
ORDER BY 2 DESC
OFFSET 0 ROWS
FETCH FIRST 10 ROWS ONLY;

--or with second logic using titanium dioxide been the most used chemical, which company uses it most?

SELECT  CompanyName, ChemicalName, COUNT(ChemicalName) AS Chemicals_reported
FROM portfolioproject..chemicalsincosmetics
WHERE ChemicalName LIKE '%Titanium dioxide%'
GROUP BY CompanyName, ChemicalName
ORDER BY 3 DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS ONLY;

----Q3. Which brands had chemicals that were removed and discontinued? Identify the chemicals.

SELECT Brandname, ChemicalName, ChemicalDateRemoved, DiscontinuedDate
FROM portfolioproject..chemicalsincosmetics
WHERE (DiscontinuedDate is not NULL) AND (ChemicalDateRemoved is not NULL)
ORDER BY 1;

--Q4. Identify the brands that had chemicals which were mostly reported in 2018.

SELECT Distinct Brandname, ChemicalName, InitialDateReported, MostRecentDateReported
FROM portfolioproject..chemicalsincosmetics
WHERE (InitialDateReported LIKE '%2018%') AND (MostRecentDateReported LIKE '%2018%')
ORDER BY 2 DESC;

--Q5. Can you tell if discontinued chemicals in bath products were removed. 

SELECT distinct ChemicalName, PrimaryCategory, DiscontinuedDate, ChemicalDateRemoved,
      CASE
      WHEN ChemicalDateRemoved is NULL THEN 'Not_Removed' ELSE 'Removed'
	  END AS Removed_or_Not
FROM portfolioproject..chemicalsincosmetics
WHERE (PrimaryCategory LIKE '%bath products%') AND (DiscontinuedDate is not null) 
ORDER BY 2;


--Q6. How long were removed chemicals in baby products used? (Tip: Use creation date to tell)

SELECT PrimaryCategory, ChemicalName, ChemicalCreatedAt, ChemicalDateRemoved, cast(DATEDIFF(M,ChemicalCreatedAt,ChemicalDateRemoved)/12 as varchar) + ' years ' +
		cast(DATEDIFF(M,ChemicalCreatedAt,ChemicalDateRemoved)%12  as varchar) + ' months ' +
		cast(DATEPART(d, ChemicalDateRemoved) - DATEPART(d, ChemicalCreatedAt) as varchar) + ' days' as Time_Diffrence
FROM portfolioproject..chemicalsincosmetics
WHERE (PrimaryCategory LIKE '%baby products%') AND (ChemicalDateRemoved is not null)
ORDER BY 5
