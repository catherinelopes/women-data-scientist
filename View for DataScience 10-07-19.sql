USE [CLopesExplore]
GO

/****** Object:  View [dbo].[GitHub_Analysis_2015-19_SurveyData]    Script Date: 10/07/2019 9:42:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




  ALTER View [dbo].[GitHub_Analysis_2015-19_SurveyData] as

	With TimeComputerFix as

	(
	Select Case When TimeComputer = '9-12 Hours' Then 10.5
				When TimeComputer = '5-8 Hours' Then 6.5
				When TimeComputer = '1-4 Hours' Then 2.5
				When TimeComputer = 'Over 12 hours' Then 14
				When TimeComputer = 'Less than 1 hour' then 0.5
				When TimeComputer = 'NA' then 0
				When TimeComputer = '1 - 4 hours' Then 2.5
				When TimeComputer = '9 - 12 Hours' Then 10.5
				When TimeComputer = '5 - 8 Hours' Then 6.5

				Else 0 
				
				END TimeComputer 
				,year
				,Country 
	
	from [CLopesExplore].[dbo].[Analysis_2015-19_SurveyData]
	),
	Companysizefix as

	(
	select Case When CompanySize = '5,000 to 9,999 employees' Then 7500
			    When CompanySize = '100 to 499 employees' Then 300  
				When CompanySize = '1,000-4,999 employees' Then 3000 
				When CompanySize = '1,000-4,999 employees' Then 3000
				When CompanySize = '10-19 employees' Then 15
				When CompanySize = 'Fewer than 10 employees' Then 5
				When CompanySize = '10,000+ employees' Then 15000
				When CompanySize = '100-499 employees' Then 300
				When CompanySize = '20 to 99 employees' Then 60
				When CompanySize = 'Just me - I am a freelancer, sole proprietor, etc.' Then  1
				When CompanySize = '10 to 19 employees' Then 15
				When CompanySize = '500 to 999 employees' Then 700
				When CompanySize = '500-999 employees' Then 700
				When CompanySize = '2-9 employees' Then 5
				When CompanySize = '10,000 or more employees' Then 15000
				When CompanySize = '5-9 employees' Then 7
				When CompanySize = '5,000-9,999 employees' Then 7500
				When CompanySize = '20-99 employees' Then 60
				When CompanySize = '1,000 to 4,999 employees' Then 3000
				When CompanySize = '1-4 employees' Then 2

				Else 0

				End as CompanySize
				,year
				,country

	
	from [CLopesExplore].[dbo].[Analysis_2015-19_SurveyData]

	),
	LastJobFix as
		(
	select Case When LastJob = 'Less than a year ago' Then 0.5
				When LastJob = 'Between 2 and 4 years ago' Then 3
				When LastJob like '%never had a job%' Then 0
				When LastJob = 'NA - I am an independent contractor or self employed' Then 0
				When LastJob = 'Between 1 and 2 years ago' Then 1.5
				When LastJob = 'More than 4 years ago' Then 6
			    
				Else 0

				End as LastJob
				,year
				,country

	
	from [CLopesExplore].[dbo].[Analysis_2015-19_SurveyData]
	)


  Select		Case When Gender = 'Man' then 'Male' 
					   When Gender = 'Woman' then 'Female'
					   When Gender = 'Male' Then 'Male'
					   When Gender = 'Female' Then 'Female'
					   When Gender = '' then 'Unknown'
					   When Gender = 'Prefer not to disclose' or Gender = 'NA' then 'NA'
					   When Gender like '%Transgender%' then 'Transgender'
					   Else 'Other or Non-Conforming'
				 End Gender
				 ,Case When (Age is null and Year = 2017) Then(Select Avg(age) from [CLopesExplore].[dbo].[Analysis_2015-19_SurveyData] T1 Where T1.Country = T2.Country) 
					   When (Age is null and Year = 2017) Then(Select Avg(age) from [CLopesExplore].[dbo].[Analysis_2015-19_SurveyData]) 
				 
				 else Age 
				 
				 END Age
				 ,AgeRange
				 ,Year 
				 ,Case When Country like '%Ivoire%' Then 'Cote d Ivoire' Else Country END as Country
				 ,[Years StartCoding ]
				 ,[Years Coding PRO]
				 ,EducationAttain
				 ,UnderGradMajor
				 ,Case When TimeComputer = 'Unknown Computer Time' Then(Select Cast(Avg(TimeComputer) as Int) from TimeComputerFix T1 Where T1.Country = T2.Country) 
						When TimeComputer = '9-12 Hours' Then 10.5
						When TimeComputer = '1-4 Hours' Then 2.5
						When TimeComputer = 'Over 12 hours' Then 14
						When TimeComputer = 'Less than 1 hour' then 0.5
						When TimeComputer = 'NA' then 0
						When TimeComputer = '5 - 8 hours' Then 6.5
						When TimeComputer = '1 - 4 hours' Then 2.5
						When TimeComputer = '5-8 hours' Then 6.5
						When TimeComputer = '9 - 12 Hours' Then 10.5
				  
								  
				  End TimeComputerFix
				  ,TimeComputer
				  ,Case When CompanySize = 'Unknown Company Size' Then(Select Cast(Avg(CompanySize) as Int) from Companysizefix T1 Where T1.Country = T2.Country)  
						When CompanySize = '5,000 to 9,999 employees' Then 7500
						When CompanySize = '100 to 499 employees' Then 300  
						When CompanySize = '1,000-4,999 employees' Then 3000 
						When CompanySize = '1,000-4,999 employees' Then 3000
						When CompanySize = '10-19 employees' Then 15
						When CompanySize = 'Fewer than 10 employees' Then 5
						When CompanySize = '10,000+ employees' Then 15000
						When CompanySize = '100-499 employees' Then 300
						When CompanySize = '20 to 99 employees' Then 60
						When CompanySize = 'Just me - I am a freelancer, sole proprietor, etc.' Then  1
						When CompanySize = '10 to 19 employees' Then 15
						When CompanySize = '500 to 999 employees' Then 700
						When CompanySize = '500-999 employees' Then 700
						When CompanySize = '2-9 employees' Then 5
						When CompanySize = '10,000 or more employees' Then 15000
						When CompanySize = '5-9 employees' Then 7
						When CompanySize = '5,000-9,999 employees' Then 7500
						When CompanySize = '20-99 employees' Then 60
						When CompanySize = '1,000 to 4,999 employees' Then 3000
						When CompanySize = '1-4 employees' Then 2
						When CompanySize = 'I am not part of a company' Then 1

						END CompanySizeFix
				  ,CompanySize
				  ,LanguagesWorkedWith
				  ,EmploymentStatus
				  ,Industry
				  ,JobSatisfaction
				  ,Case When LastJob = 'Unknown Last Job Change' Then(Select Cast(Avg(LastJob) as Int) from LastJobFix T1 Where T1.Country = T2.Country)  
						When LastJob = 'Less than a year ago' Then 0.5
						When LastJob = 'Between 2 and 4 years ago' Then 3
						When LastJob like '%never had a job%' Then 0
						When LastJob = 'NA - I am an independent contractor or self employed' Then 0
						When LastJob = 'Between 1 and 2 years ago' Then 1.5
						When LastJob = 'More than 4 years ago' Then 6
			    
						Else 0

					End as LastJobFix
				  ,LastJob
				  ,JobSearch
				  ,Occupation
				  ,ParentsEducation



								



  
  FROM [CLopesExplore].[dbo].[Analysis_2015-19_SurveyData] T2

  /*

  Select TOP 1000 * from [CLopesExplore].[dbo].[GitHub_Analysis_2015-19_SurveyData]

  */


GO


