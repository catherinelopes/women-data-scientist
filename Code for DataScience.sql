ALTER PROC [dbo].[CleanRawDataGenderStudy] --change this to ALTER from Create
-- =============================================
-- Author:		<Tiago Valente>
-- Create date: 2019-02-26
-- Description:	<RAW -> WRK>
-- MOD DATE:
-- =============================================
AS
BEGIN

-- =============================================
-- CLEAN TABLES ENCODING CHARACTER 
-- =============================================

Update [CLopesExplore].[dbo].[2018 Survey Table]
SET UpdateCV = REPLACE(UpdateCV, 'â€™', '’')

Update [CLopesExplore].[dbo].[2018 Survey Table]
SET FormalEducation = REPLACE(FormalEducation, 'â€™', '’')

Update [CLopesExplore].[dbo].[2018 Survey Table]
SET FormalEducation = REPLACE(FormalEducation, 'â€™', '’')

Update [CLopesExplore].[dbo].[2018 Survey Table]
Set JobSearchStatus = REPLACE(JobSearchStatus, 'â€™', '’')

Update [CLopesExplore].[dbo].[2018 Survey Table]
Set [EducationParents] = REPLACE([EducationParents], 'â€™', '’')

Update [CLopesExplore].[dbo].[2017 Survey Table]
Set Race = REPLACE(Race, 'â€™', '’')

-- =============================================
-- Create Unified Table
-- =============================================

IF OBJECT_ID ('Analysis_2015-18_SurveyData') IS NOT NULL
DROP TABLE [Analysis_2015-18_SurveyData]

-- =============================================
-- CREATE TABLE 
-- =============================================
CREATE TABLE [Analysis_2015-18_SurveyData] 

( 
   -- [RowNumber]     INT IDENTITY(1,1)
	 [AgeRange]		VARCHAR(1000)
	,[Age]			INT
	,[Gender]	    VARCHAR(1000)
	,[Year]         VARCHAR(1000)
	,[Occupation]	VARCHAR(1000)
	,[Country]		VARCHAR(1000)
	,[Hobby]		VARCHAR(50)
	,[Years Coding PRO Range] VARCHAR(1000)
	,[Years Coding PRO] FLOAT
	,[Ethnicity] VARCHAR(1000)
	,[SexualOrientation] VARCHAR(1000)
	,[ParentsEducation] VARCHAR(1000)
	,[WakeTime] VARCHAR(1000)
	,[TimeComputer] VARCHAR(1000)
	,[SpendOutside] VARCHAR(1000)
	,[Exercise] VARCHAR(1000)
	,[AIConcerns] VARCHAR(1000)
	,[AIFuture] VARCHAR(1000)
	,[AIDangerous] VARCHAR(1000)
	,EmploymentStatus VARCHAR(1000)
	,Industry VARCHAR(1000)
	,CompanySize VARCHAR(1000)
	,Hope5Years VARCHAR(1000)
	,JobSatisfaction VARCHAR(1000)
	,EthicsView VARCHAR(1000)
	,EthicsReport VARCHAR(1000)
	,EthicsResponsible VARCHAR(1000)
	,EthicsImplication VARCHAR(1000)
	,JobSearch VARCHAR(1000)
	,LastJob VARCHAR(1000)



	,TimeFullyProductive VARCHAR(1000)
	,CheckinCode VARCHAR(1000)

)

-- =============================================
-- TRUNCATE TABLE
-- =============================================
TRUNCATE TABLE [Analysis_2015-18_SurveyData] 

-- =============================================
-- INSERT INTO TABLE 
-- =============================================

INSERT INTO [Analysis_2015-18_SurveyData] 
(
 
	 [AgeRange]
	,[Age]	  
	,[Gender]       
	,[Year]
	,[Occupation]   
	,[Country]
	,[Hobby]
	,[Years Coding PRO Range] 
	,[Years Coding PRO]
	,[Ethnicity]
	,[SexualOrientation]
	,[ParentsEducation]
	,[WakeTime]
	,[TimeComputer]
	,[SpendOutside]
	,[Exercise]
	,[AIConcerns]
	,[AIFuture]
	,AIDangerous
	,EmploymentStatus
	,Industry
	,CompanySize
	,Hope5Years
	,JobSatisfaction
	,EthicsView
	,EthicsReport
	,EthicsResponsible
	,EthicsImplication
	,JobSearch
	,LastJob



	,TimeFullyProductive
	,CheckinCode
)

--UNION SELECT

SELECT 

	[Age]	 
	,CASE WHEN CAST(CHARINDEX('-',Age) as INT) <> 0 Then
	(CAST(SUBSTRING(Age,0,3) as INT) + CAST(SUBSTRING(Age,CHARINDEX('-',Age)+1,Len(age)) as INT))/2
	When Left(Age,1) = '<' Then
	16
	When Left(Age,1) = '>' Then
	65
	When Age = 'Prefer not to disclose' Then
	NULL
	Else Age
	END as [Age]
	,[Gender]       
	,'2015'
	,[Occupation]
	,[Country]
	,CASE WHEN [How many hours programming as hobby per week?] = 'None' Then 'No' 
			WHEN [How many hours programming as hobby per week?] ='' Then 'No'
			WHEN [How many hours programming as hobby per week?] ! ='' Then 'Yes'
			Else 'No' 
	END as [Hobby]
	,[Years IT   Programming Experience]
	,Case When [Years IT   Programming Experience] = 'Less than 1 year' Then 0.5
		When [Years IT   Programming Experience] = '1 - 2 years' Then 1.5
		When [Years IT   Programming Experience] = '11+ years' Then 13.0
		When [Years IT   Programming Experience] = '2 - 5 years' Then 3.5
		When [Years IT   Programming Experience] = '6 - 10 years' Then 8.0

		ELSE 0.0 
		
	END
	,'Unknown Race'
	,'Unknown Orientation'
	,'Unknown Parents Education'
	,'Unknown WakeTime'
	,Case When [How many hours programming as hobby per week?] ='1-2 hours per week' then '1-4 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 1.5
		When [How many hours programming as hobby per week?] ='2-5 hours per week' then '5-8 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 3.5
		When [How many hours programming as hobby per week?] ='5-10 hours per week' then '9-12 Hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 7.5
		When [How many hours programming as hobby per week?] ='10-20 hours per week' then 'Over 12 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 15
		When [How many hours programming as hobby per week?] ='20+ hours per week' then 'Over 12 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 15
		When [How many hours programming as hobby per week?] = 'None' or [How many hours programming as hobby per week?] = '' or [How many hours programming as hobby per week?]= 'Other (please specify)' then 'NA' 

	END as [TimeComputer]
	,'Unknown Time Outside'
	,'Unknown Exercise'
	,'Unknown AI View'
	,'Unknown Future AI View'
	,'Unknown AI Dangerous View'
	,Case When [Employment Status] = 'Unemployed' Then 'Not employed, and not looking for work' 
		When [Employment Status] = 'Prefer not to disclose' Then 'NA' 
		When [Employment Status] = '' Then 'NA' 
	    When [Employment Status] = 'Other' Then 'NA' 
		When [Employment Status] = 'Freelance / Contractor' Then 'Independent contractor, freelancer, or self-employed' 

	ELSE [Employment Status]

	END
	,Industry
	,'Unknown Company Size'
	,'Unknown 5 Years'
	,Case When [Job Satisfaction] = 'I''m somewhat satisfied with my job' Then 'Slightly satisfied' 
		When [Job Satisfaction] = 'I''m somewhat dissatisfied with my job' Then 'Slightly dissatisfied'
		When [Job Satisfaction] = 'I love my job' Then 'Extremely satisfied'
		When [Job Satisfaction] = 'Other (please specify)' Then 'NA'
		When [Job Satisfaction] = '' Then 'NA'
		When [Job Satisfaction] = 'I''m neither satisfied nor dissatisfied with my job' Then 'Neither satisfied nor dissatisfied'
		When [Job Satisfaction] = 'I''m somewhat satisfied with my job' Then 'Moderately satisfied'
		When [Job Satisfaction] = 'I hate my job' Then 'Extremely dissatisfied'

	End
	,'Unknown Ethics View'
	,'Unknown Ethics Report'
	,'Unknown Ethics Responsible'
	,'Unknown Ethics Implication'
	,Case When [Open to new job opportunities] ='I am not interested in other job opportunities' Then 'I’m not actively looking, but I am open to new opportunities'
	    When [Open to new job opportunities] = 'I am open to new job opportunities' Then 'I am actively looking for a job'
		When [Open to new job opportunities] = 'I am actively looking for a new job' Then 'I am actively looking for a job'
		When [Open to new job opportunities] = '' Then 'NA'

	 END
	,Case When [Changed Jobs in last 12 Months]= 'Yes' Then 'Between 1 and 2 years ago'
	   When [Changed Jobs in last 12 Months]= 'No (I''m a student)' Then 'I''ve never had a job' 
	   Else 'NA'
	 END
	,'Unknown Time Productive View'
	,'Unknown Checkin Code'
	
FROM [CLopesExplore].[dbo].[2015 Survey Table]

UNION ALL

SELECT

	[age_range]	 
	 ,CASE WHEN CAST(CHARINDEX('-',age_range) as INT) <> 0 Then
		(CAST(SUBSTRING(age_range,0,3) as INT) + CAST(SUBSTRING(age_range,CHARINDEX('-',age_range)+1,Len(age_range)) as INT))/2
		When Left(age_range,1) = '<' Then
		16
		When Left(age_range,1) = '>' Then
		65
		When age_range = 'Prefer not to disclose' Then
		NULL
		Else age_range
	 END as [Age]
	,[gender]       
	,'2016'
	,[Occupation]
	,[country]
	,CASE WHEN [hobby] = 'None' Then 'No' 
		  WHEN [hobby] ='' Then 'No'
		  WHEN [hobby] ! ='' Then 'Yes'
		  Else 'No' 
	END as [Hobby]
	,experience_range
	,[experience_midpoint]
	,'Unknown Race'
	,'Unknown Orientation'
	,'Unknown Parents Education'
	,'Unknown Wake Time'
	,Case When Hobby ='1-2 hours per week' then '1-4 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 1.5
		When Hobby ='2-5 hours per week' then '5-8 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 3.5
		When Hobby ='5-10 hours per week' then '9-12 Hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 7.5
		When Hobby ='10-20 hours per week' then 'Over 12 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 15
		When Hobby ='20+ hours per week' then 'Over 12 hours' --assuming one quarter working day on computer (8*0.25) = 2 hours + 15
		When Hobby = 'None' or Hobby = '' or Hobby= 'Other (please specify)' then 'NA' 

	END as [TimeComputer]
	,'Unknown Time Outside'
	,'Unknown Exercise'
	,'Unknown AI View'
	,'Unknown Future AI View'
	,'Unknown AI Dangerous View'
	,Case When employment_status = 'Unemployed' Then 'Not employed, and not looking for work' 
		When employment_status = 'Prefer not to disclose' Then 'NA' 
		When employment_status = '' Then 'NA' 
		When employment_status = 'Other (please specify)' Then 'NA' 
		When employment_status = 'Freelance / Contractor' Then 'Independent contractor, freelancer, or self-employed' 

	ELSE employment_status

	END
	,Industry
	,[company_size_range]
	,'Unknown 5 Years'
	,Case When [job_satisfaction] = 'I''m somewhat satisfied with my job' Then 'Slightly satisfied' 
		When [job_satisfaction] = 'I''m somewhat dissatisfied with my job' Then 'Slightly dissatisfied'
		When [job_satisfaction] = 'I love my job' Then 'Extremely satisfied'
		When [job_satisfaction] = 'Other (please specify)' Then 'NA'
		When [job_satisfaction] = '' Then 'NA'
		When [job_satisfaction] = 'I''m neither satisfied nor dissatisfied' Then 'Neither satisfied nor dissatisfied'
		When [job_satisfaction] = 'I''m somewhat satisfied with my job' Then 'Moderately satisfied'
		When [job_satisfaction] = 'I hate my job' Then 'Extremely dissatisfied'
		When [job_satisfaction] = 'I don''t have a job' Then 'Unemployed'
	End
	,'Unknown Ethics View'
	,'Unknown Ethics Report'
	,'Unknown Ethics Responsible'
	,'Unknown Ethics Implication'
	,Case When open_to_new_job = 'I am not interested in new job opportunities' Then 'I am not interested in new job opportunities'
		When open_to_new_job = 'I''m not actively looking, but I am open to new opportunities' Then 'I’m not actively looking, but I am open to new opportunities'
		When open_to_new_job = 'I am actively looking for a new job' Then 'I am actively looking for a job'
		When open_to_new_job = '' Then 'NA'
	 END


	,'Unknown Last Job Change'
	,'Unknown Time Productive View'
	,'Unknown Checkin Code'
  
FROM [CLopesExplore].[dbo].[2016 Survey Table] 

UNION ALL

SELECT

	 NULL 
	,NULL 
	,[Gender]       
	,'2017'
	,Case When (DeveloperType like '%Scientist%' or DeveloperType like '%Machine learning specialist%') Then'Data Scientist' 
		When DeveloperType like '%Graphics%' Then 'Graphics programmer'
		When DeveloperType like '%Graphic%' Then 'Designer'
		When DeveloperType like '%Web%' and (Len(DeveloperType) > 80 or WebDeveloperType = 'Full stack web developer') Then 'Full-stack web developer'
		When DeveloperType like '%Web%' and (Len(DeveloperType) < 80) Then 'Front-end web developer'
		When DeveloperType like '%Web%' and DeveloperType like '%Database%' Then 'Back-end web developer'
		When WebDeveloperType = 'Back-end Web developer' Then 'Back-end web developer'
		When WebDeveloperType = 'Front-end Web developer' Then 	'Front-end web developer'
		When DeveloperType like '%Mobile%' Then	'Mobile developer' 
		When DeveloperType like '%DevOps%' Then	'DevOps'
		When DeveloperType like '%Desktop%' Then 'Desktop developer'
		When DeveloperType like '%Database%' Then 'Database administrator'
		When DeveloperType like '%Embedded applications%' Then 'Embedded application developer'
		When DeveloperType like '%Systems administrator%' Then 'System administrator'
		When DeveloperType like '%Quality assurance engineer%' Then 'Quality Assurance'
		When DeveloperType = 'NA' Then 	'NA'
		When DeveloperType = 'Student' Then	'Student'
		ELSE
		'other'
	 END as Occupation
	,Country
	,CASE WHEN LEFT([ProgramHobby],3) = 'Yes' Then 'Yes' 
			WHEN [ProgramHobby] = 'No' Then 'No'
			Else 'No' 
	END as [Hobby]
	,[YearsCodedJob]
	,CASE WHEN [YearsCodedJob] = 'NA' Then 0 
		WHEN [YearsCodedJob] = 'Less than a year' Then 0.5
		WHEN [YearsCodedJob] = '20 or more years' Then 23.0
		ELSE
		(CAST(LEFT(SUBSTRING([YearsCodedJob],CHARINDEX('to',[YearsCodedJob])+2,Len([YearsCodedJob])),3) as FLOAT)
		+
		CAST(LEFT([YearsCodedJob],2) as FLOAT)) / 2
		
	END
	,[Race]
	,'Unknown Orientation'
	,HighestEducationParents
	,'Unknown Wake Time'
	,'Unknown Computer Time'
	,'Unknown Time Outside'
	,'Unkown Exercise'
	,'Unknown AI View'
	,'Unknown Future AI View'
	,'Unknown AI Dangerous View'
	,EmploymentStatus
	,CompanyType
	,CompanySize
	,'Unknown 5 Years'
	,Case When CareerSatisfaction = '0' or CareerSatisfaction = '1' or CareerSatisfaction = '2'  Then 'Extremely dissatisfied' 	
			When CareerSatisfaction = '3' Then 'Slightly dissatisfied' 
			When CareerSatisfaction = '4'  Then 'Moderately dissatisfied' 	
			When CareerSatisfaction = '5' Then 'Neither satisfied nor dissatisfied' 
			When CareerSatisfaction = '6' or CareerSatisfaction = '7' Then 'Slightly satisfied' 
			When CareerSatisfaction = '8' or CareerSatisfaction = '9' Then 'Moderately satisfied'
			When CareerSatisfaction = '10' Then 'Extremely satisfied'

			ELSE 'NA'
	END
	,'Unknown Ethics View'
	,'Unknown Ethics Report'
	,'Unknown Ethics Responsible'
	,'Unknown Ethics Implication'
	,Case When [JobSeekingStatus] = 'I am not interested in new job opportunities' Then 'I am not interested in new job opportunities'
			 When [JobSeekingStatus] = 'I''m not actively looking, but I am open to new opportunities' Then 'I’m not actively looking, but I am open to new opportunities'
			 When [JobSeekingStatus] = 'I am actively looking for a job' Then 'I am actively looking for a job'
			 When [JobSeekingStatus] = 'NA' Then 'NA'


	END

	,Case When LastNewJob = 'Not applicable/ never' Then 'I''ve never had a job'
		  Else LastNewJob 
	 END
	,'Unknown Time Productive View'
	,CheckInCode

FROM [CLopesExplore].[dbo].[2017 Survey Table] 

UNION ALL

SELECT

	 Age 
	,Case When Age = 'Under 18 years old' Then 16 
	   When Age = '35 - 44 years old' Then 39.5 
	   When Age = '18 - 24 years old' Then 21
	   When Age = '55 - 64 years old' Then 59.5
	   When Age = '25 - 34 years old' Then 29.5
	   When Age = '45 - 54 years old' Then 49.5
	   When Age = '65 years or older' Then 65
	   ELSE
	   NULL
	 END as Age 
	,[Gender]       
	,'2018'
	,Case When (DevType like '%Scientist%' or DevType like '%Machine learning specialist%') Then
		'Data Scientist' 
		When DevType like '%Graphics%' Then 
		'Graphics programmer'
		When DevType like '%Graphic%' Then 
		'Designer'
		When DevType like '%Full-stack developer%' Then 
		'Full-stack web developer'
		When DevType like '%Front-end developer%'  Then 
		'Front-end web developer'
		When DevType like '%Back-end developer%'  Then 
		'Back-end web developer'
		When DevType like '%Mobile%' Then
		'Mobile developer' 
		When DevType like '%DevOps%' Then
		'DevOps'
		When DevType like '%Desktop%' Then
		'Desktop developer'
		When DevType like '%Embedded applications%' Then
		'Embedded application developer'
		When DevType like '%C-suite executive (CEO, CTO, etc.)%' Then
		'Executive (VP of Eng., CTO, CIO, etc.)'
		When DevType like '%Database%' Then
		'Database administrator'
		When DevType like '%Designer%' Then 
		'Designer'
		When DevType like '%System administrator%' Then
		'System administrator'
		When DevType like '%QA%' Then
		'Quality Assurance'
		When DevType like '%Student%' Then
		'Student'
		When DevType like '%Educator or academic researcher%' Then
		'Academic Researcher'
		When DevType like '%business analyst%' or DevType like '%manager%' or Devtype like '%sales professional%' Then
		'Business Professional'
		When DevType = 'NA' Then
		'NA'
		ELSE
		'other'
  
	END as Occupation
		,Country
		,[Hobby]
		,[YearsCodingProf]
		,CASE WHEN YearsCodingProf = 'NA' Then 0 
			WHEN YearsCodingProf = '12-14 years' Then 13.0
			WHEN YearsCodingProf = '15-17 years' Then 16.0
			WHEN YearsCodingProf = '27-29 years' Then 28.0
			WHEN YearsCodingProf = '18-20 years' Then 19.0
			WHEN YearsCodingProf = '24-26 years' Then 50.0
			WHEN YearsCodingProf = '21-23 years' Then 22.0
			WHEN YearsCodingProf = '6-8 years' Then 7.0
			WHEN YearsCodingProf = '9-11 years' Then 10.0
			WHEN YearsCodingProf = '0-2 years' Then 1.0
			WHEN YearsCodingProf = '3-5 years' Then 4.0
			WHEN YearsCodingProf = '30 or more years' Then 33.0
				
		END
		,[RaceEthnicity]
		,SexualOrientation
		,Case When EducationParents = 'Bachelor’s degree (BA, BS, B.Eng., etc.)' Then 'A bachelor''s degree' 
			When EducationParents = 'Master’s degree (MA, MS, M.Eng., MBA, etc.)' Then 'A master''s degree'
			When EducationParents = 'Some college/university study without earning a degree' Then 'Some college/university study, no bachelor''s degree'
			When EducationParents = 'Primary/elementary school' Then 'Primary/elementary school' 
			When EducationParents = 'Secondary school (e.g. American high school, German Realschule or Gymnasium, etc.)' Then 'High school' 
			When EducationParents = 'Other doctoral degree (Ph.D, Ed.D., etc.)' Then 'A doctoral degree'
			When EducationParents = 'NA' Then 'NA'
			When EducationParents = 'Professional degree (JD, MD, etc.)' Then 'A professional degree'
			When EducationParents ='They never completed any formal education' Then 'No education' 

			Else EducationParents
		END 
		,[WakeTime]
		,[HoursComputer]
	    ,HoursOutside
		,Exercise
		,AIResponsible
		,AIFuture
		,AIDangerous
		,Employment
		,'Unknown Industry'
		,CompanySize
		,HopeFiveYears
		,CareerSatisfaction
		,EthicsChoice
		,EthicsReport
		,EthicsResponsible
		,EthicalImplications
		,[JobSearchStatus]



		,LastNewJob
		,TimeFullyProductive
		,CheckInCode

FROM [CLopesExplore].[dbo].[2018 Survey Table] 

/*
With TempTable as

(

Select Distinct DeveloperType
			   ,WebDeveloperType 
				,Case When (DeveloperType like '%Scientist%' or DeveloperType like '%Machine learning specialist%') Then
				'Data Scientist' 
				When DeveloperType like '%Graphics%' Then 
				'Graphics programmer'

				When DeveloperType like '%Graphic%' Then 
				'Designer'

				When DeveloperType like '%Web%' and (Len(DeveloperType) > 80 or WebDeveloperType = 'Full stack web developer') Then 
				'Full-stack web developer'

				When DeveloperType like '%Web%' and DeveloperType like '%Database%' Then 
				'Back-end web developer'

				When WebDeveloperType = 'Back-end Web developer' Then 
				'Back-end web developer'

				When WebDeveloperType = 'Front-end Web developer' Then 
				'Front-end web developer'

				When DeveloperType like '%Mobile%' Then
				
				'Mobile developer' 

				When DeveloperType like '%DevOps%' Then

				'DevOps'
  
				END as Occupation
			   
			   from [CLopesExplore].[dbo].[2017 Survey Table] 

)

Select * from TempTable

Where Occupation is null

	Select DISTINCT JobSearch, LastJob ,TimeFullyProductive ,CheckinCode from [dbo].[Analysis_2015-18_SurveyData]

	ORDER BY YEAR ASC
	

	Select Distinct Occupation from [dbo].[2015 Survey Table]

	Select Count(*) from [CLopesExplore].[dbo].[2015 Survey Table]  
	Select Count(*) from [CLopesExplore].[dbo].[2016 Survey Table] 
	Select Count(*) from [CLopesExplore].[dbo].[2017 Survey Table]
	Select Count(*) from [CLopesExplore].[dbo].[2018 Survey Table]

*/

END