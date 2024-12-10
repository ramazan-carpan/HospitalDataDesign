USE Medicalpractice
GO
/*
1.	List the first name and last name of female patients who live in St Kilda or Lidcombe.*/
SELECT *
FROM Patient
WHERE Gender = 'Female' AND (Suburb = 'Lidcombe' OR Suburb = 'St Kilda');


/*
2.	List the first name, last name, state and Medicare Number of any patients who do not live in NSW.*/
SELECT FirstName,LastName,State,MedicareNumber
from Patient
Where State!='NSW';


/*
3.	List each patient's first name, last name, Medicare Number and their date of birth. Sort the list by date of birth, listing the youngest patients first.*/

SELECT FirstName,LastName,MedicareNumber,DateOfBirth
FROM Patient
ORDER BY DateOfBirth DESC;


/*
4.	For each practitioner, list their ID, first name, last name, the total number of days and the total number of hours they are scheduled to work in a standard week at the Medical Practice. Assume a workday is nine hours long.*/

SELECT p.Practitioner_ID, p.FirstName, p.LastName,
       COUNT(DISTINCT a.WeekdayName_Ref) AS TotalDays,
       COUNT(DISTINCT a.WeekdayName_Ref) * 9 AS TotalHours
FROM Practitioner AS p
LEFT JOIN Availability AS a ON p.Practitioner_ID = a.Practitioner_Ref
GROUP BY p.Practitioner_ID, p.FirstName, p.LastName;








/*
5.	List the Patient's first name, last name and the appointment date and time, for all appointments held on the 18/09/2019 by Dr Anne Funsworth.*/
SELECT p.FirstName, p.LastName,a.AppDate,a.AppStartTime
FROM Patient AS p
    INNER JOIN Appointment AS a 
    ON p.Patient_ID = a.Patient_Ref 
        INNER JOIN Practitioner AS pr
            ON pr.Practitioner_ID=a.Practitioner_Ref
WHERE a.AppDate = '2019-09-18' 
    AND pr.FirstName = 'Anne' 
    AND pr.LastName = 'Funsworth';





/*
6.	List the ID and date of birth of any patient who has not had an appointment and was born before 1950.*/

SELECT P.Patient_ID, P.DateOfBirth
FROM Patient AS P
LEFT JOIN Appointment AS A ON P.Patient_ID = A.Patient_Ref
WHERE A.Patient_Ref IS NULL AND P.DateOfBirth < '1950-01-01';


/*
7.	List the patient ID, first name, last name and the number of appointments for patients who have had at least three appointments. List the patients in 'number of appointments' order from most to least.*/

SELECT P.Patient_ID,P.FirstName,P.LastName,
       Count(A.Patient_Ref) AS  [number of appointments]
FROM Patient AS p
INNER JOIN Appointment AS a
    ON p.Patient_ID=a.Patient_Ref
GROUP BY P.Patient_ID,P.FirstName,P.LastName
HAVING Count( A.Patient_Ref)>=3
order by  [number of appointments] desc;



/*
8.	List the first name, last name, gender, and the number of days since the last appointment of each patient and the 23/09/2019.*/
-- check the dublicate

SELECT DISTINCT p.FirstName, p.LastName, p.Gender,
       DATEDIFF(DAY, MAX(a.AppDate), '2019-09-23') AS NumberOfDays
FROM Patient AS p
LEFT JOIN Appointment AS a ON p.Patient_ID = a.Patient_Ref
GROUP BY p.FirstName, p.LastName, p.Gender, p.Patient_ID
ORDER BY p.FirstName, p.LastName;

/*
9.	List the full name and full address of each practitioner in the following format exactly.
Dr Mark P. Huston. 21 Fuller Street SUNSHINE, NSW 2343
Make sure you include the punctuation and the suburb in upper case.
Sort the list by last name, then first name, then middle initial.*/

SELECT CONCAT(Title,' ',FirstName,' ',MiddleInitial,'. ',LastName,'.',HouseUnitLotNum,' ',Street,' ',upper(Suburb),', ',[State],' ',PostCode) AS FullNameAndAdress
FROM Practitioner
Order by LastName,FirstName,MiddleInitial;







/*
10.	List the patient id, first name, last name and date of birth of the fifth oldest patient(s). */

SELECT TOP 1 WITH TIES Patient_ID, FirstName, LastName, DateOfBirth
FROM (
    SELECT TOP  5 WITH TIES Patient_ID, FirstName, LastName, DateOfBirth  
    FROM Patient
    ORDER BY DateOfBirth ASC
) AS FifthOldest
ORDER BY DateOfBirth DESC;


insert into dbo.Patient
(Title, FirstName, LastName, MiddleInitial, HouseUnitLotNum, Street, Suburb, State, PostCode, HomePhone,
	MobilePhone, MedicareNumber, DateOfBirth, Gender)
VALUES
('Mr', 'Michael', 'Brown', 'E', 'Lot23', 'Johnston Road', 'Warwick Farm', 'NSW', '2170', '0297465243',
	'0417335224', '8356273321176546', '1972-03-05', 'male');

select * from dbo.Patient;


/*
11.	List the patient ID, first name, last name, appointment date (in the format 'Tuesday 17 September, 2019') and appointment time (in the format '14:15 PM') for all patients who have had appointments on any Tuesday after 10:00 AM.*/


SELECT p.Patient_ID, p.FirstName, p.LastName,
       FORMAT(a.AppDate, 'dddd dd MMMM, yyyy') AS [Appointment Date],
	   FORMAT(CAST(a.AppStartTime AS datetime), 'T') AS [Appointment Time]
FROM Patient AS p
Left JOIN Appointment AS a
    ON p.Patient_ID = a.Patient_Ref
WHERE DATEPART(WEEKDAY, a.AppDate) = 3 -- this show tuesdays
      AND a.AppStartTime > '10:00:00'; 


/*
12.	Create an address list for a special newsletter to all patients and practitioners. The mailing list should contain all relevant address fields for each household. Note that each household should only receive one newsletter.*/

SELECT DISTINCT [Full Address]
FROM (
    SELECT CONCAT(HouseUnitLotNum,' ',Street,' ',Suburb,' ',[State],' ',PostCode) AS [Full Address]
    FROM Patient 
    UNION ALL  
    SELECT CONCAT(HouseUnitLotNum,' ',Street,' ',Suburb,' ',[State],' ',PostCode) AS [Full Address]
    FROM Practitioner
) AS Addresses;





Select *
from Practitioner;

Select *
from Patient

