/*   1.	Create a view (called vwNurseDays) with the name and phone details of any nurse (registered or not) and the days that they work. Execute the SQL statements to create the view.*/
USE Medicalpractice;
GO



-- Create the view to combine Practitioner and Appointment data for nurses
CREATE VIEW vwNurseDays
AS
SELECT p.FirstName, p.MobilePhone, p.HomePhone, p.PractitionerType_Ref, a.WeekDayName_Ref
FROM Practitioner AS p 
INNER JOIN Availability AS a ON p.Practitioner_ID = a.Practitioner_Ref
where p.PractitionerType_Ref like '%Nurse%'
GO


SELECT*
FROM vwNurseDays

/*2.	Using your view, write a query to retrieve the name and phone number details of all nurses who are scheduled to work on a Wednesday.*/

SELECT FirstName, MobilePhone, PractitionerType_Ref,WeekDayName_Ref
FROM vwNurseDays
WHERE WeekDayName_Ref = 'Wednesday';



/*3.	Create a view (called vwNSWPatients) that contains all patient details for patients whose address is in NSW. Execute the SQL statements to create the view.*/

CREATE VIEW vwNSWPatients
AS
SELECT *
FROM Patient
WHERE [State]='NSW';

SELECT *
FROM vwNSWPatients

/*4.	Create a stored procedure (called spSelect_vwNSWPatients) to retrieve all records and columns from vwNSWPatients in postcode order ascending. Execute the stored procedure.*/

CREATE PROCEDURE spSelect_vwNSWPatients
AS 
BEGIN
    SET NOCOUNT ON;  -- this one for return message if there has issue 
    SELECT *
    FROM vwNSWPatients
    ORDER  BY PostCode ASC;
end;

EXECUTE spSelect_vwNSWPatients  -- if I want to create specific I can add next to stroage name
GO


/*
5.	Create a stored procedure (called spInsert_vwNSWPatients) to insert a new record into vwNSWPatients, 
using parameters for all relevant data. Execute the stored procedure inserting a record for 
a new patient named Mr Mickey M Mouse from 1 Smith St, Smithville, NSW 2222. 
Run a query to verify that the record has been added to the Patient table.*/
--drop PROCEDURE if EXISTS spSelect_vwNSWPatients

-- does not have dateofbirth and 


CREATE PROCEDURE spInsert_vwNSWPatients (
    @Title NVARCHAR(20),
    @FirstName NVARCHAR(50),
    @MiddleInitial NCHAR(1),
    @LastName NVARCHAR(50),
    @HouseUnitLotNum NVARCHAR(5),
    @Street NVARCHAR(50),
    @Suburb NVARCHAR(50),
    @State NVARCHAR(3),
    @PostCode NCHAR(4),
    @DateOfBirth date,
    @Gender NVARCHAR(20)
)
AS
BEGIN
    INSERT INTO Patient (
        Title, FirstName, MiddleInitial, LastName, 
        HouseUnitLotNum, Street, Suburb, State, PostCode, 
        DateOfBirth, Gender
    )
    VALUES (
        @Title, @FirstName, @MiddleInitial, @LastName, 
        @HouseUnitLotNum, @Street, @Suburb, @State, @PostCode, 
        @DateOfBirth, @Gender
    );
END;

GO
    



EXEC spInsert_vwNSWPatients 'Mr', 'Mickey', 'M', 'Mouse', '1', 'Smith St', 'Smithville', 'NSW', '2222', '1985-09-17', 'Male';

SELECT *
from Patient;


/*6.	Create a stored procedure (called spModify_PractitionerMobilePhone) using the Practitioner table to change 
a practitioner’s mobile phone number, using the Practitioner ID and the new mobile number as parameters. Execute the stored procedure to 
change Hilda Brown’s mobile number to 0412345678.
Run a query to verify that the record has been updated in the Practitioner table.*/



CREATE PROCEDURE spModify_PractitionerMobilePhone
    @PractitionerID INT,
    @NewMobilePhone NVARCHAR(10)
AS
BEGIN
    UPDATE Practitioner
    SET MobilePhone = @NewMobilePhone
    WHERE Practitioner_ID = @PractitionerID;
END;

EXEC spModify_PractitionerMobilePhone @PractitionerID = 10001, @NewMobilePhone = '0412345678';


SELECT *
FROM Practitioner;


/*
7.	Manipulate the Practitioner table to store a driver’s licence number.
 For privacy and security purposes this data needs to be encrypted. Name the new column DriversLicenceHash. 
 For encrypting the column, use a one-way hashing algorithm. Execute the statement to create the new column.
Add the drivers licence number of 1066AD Dr Ludo Vergenargen’s (Practitioner ID 10005) drivers licence using a SHA hashing function.
Display Dr Vertenargen’s record to view the hashed number.
*/

ALTER TABLE  Practitioner
add  DriversLicenceHash VARBINARY(MAX);




DECLARE @DriverLicenceNumber NVARCHAR(50) = '1066AD';
DECLARE @HashedDriverLicence VARBINARY(MAX);


SET @HashedDriverLicence = HASHBYTES('SHA2_256', @DriverLicenceNumber);

UPDATE Practitioner
SET DriversLicenceHash = @HashedDriverLicence
WHERE Practitioner_ID = '10005';


SELECT DriversLicenceHash
from Practitioner
WHERE Practitioner_ID='10005';




/*8.	Manipulate the Patient table to add a new column that will store a date value which is the last date they made contact.
 The default value should be the date of record creation. 
Name the new column LastContactDate. Execute the statement to create the new column.*/





ALTER TABLE Patient
ADD LastContactDate DATE not null DEFAULT GETDATE();





SELECT LastContactDate
FROM Patient;




--9.	Create a trigger on the Appointment table that will update LastContactDate on the Patient table each 
--time a new record is added to the Appointment table. The value of the LastContactDate should be the date the record
 --is added. Name the trigger tr_Appointment_AfterInsert.


CREATE TRIGGER tr_Appointment_AfterInsert
ON Appointment
AFTER INSERT
AS
BEGIN
    UPDATE Patient
    SET LastContactDate = GETDATE()
    FROM Patient p
    INNER JOIN INSERTED i ON p.Patient_ID = i.Patient_Ref;
END;
GO

INSERT INTO Appointment (Practitioner_Ref, AppDate, AppStartTime, Patient_Ref)
VALUES (10007, '2019-09-24', '08:15:00', 10002),
(10006, '2019-09-23', '08:15:00', 10001);


-- Verify the updated LastContactDate
SELECT *
FROM Patient

UPDATE Patient
SET LastContactDate = '1970-01-01';

DELETE FROM dbo.Appointment;

DELETE FROM Appointment
WHERE Practitioner_Ref = 10005
  AND AppDate = '2019-09-24'
  AND AppStartTime = '08:15:00'
  AND Patient_Ref = 10000;

DROP TRIGGER tr_Appointment_AfterInsert;




--10.	Delete the view vwNurseDays from the database.*/

drop VIEW vwNurseDays;

--11.	Delete the stored procedure spSelect_vwNSWPatients from the database.*/

drop procedure spSelect_vwNSWPatients  