drop database Medicalpractice;

CREATE DATABASE Medicalpractice;

USE Medicalpractice;

CREATE TABLE Patient
(
	Patient_ID  INTEGER IDENTITY(10000,1) CONSTRAINT PK_Patient PRIMARY KEY (Patient_ID),
	Title		NVARCHAR(20),
	FirstName   NVARCHAR(50) NOT NULL,
	MiddleInitial NCHAR(1) NOT NULL,
	LastName	NVARCHAR(50) NOT NULL,
	HouseUnitLotNum NVARCHAR(5) NOT NULL,
	Street NVARCHAR(50) NOT NULL,
	Suburb NVARCHAR(50) NOT NULL,
	[State] NVARCHAR(3) NOT NULL,
	PostCode NCHAR(4) NOT NULL,
	HomePhone NCHAR(10),
	MobilePhone NCHAR(10),
	MedicareNumber NCHAR(16),
	DateOfBirth DATE NOT NULL,
	Gender NCHAR(20) NOT NULL
);

CREATE TABLE Practitioner
(
	Practitioner_ID INTEGER IDENTITY(10000,1) CONSTRAINT PK_Practitioner PRIMARY KEY (Practitioner_ID),
	Title NVARCHAR(20) NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleInitial NCHAR(1),
	LastName NVARCHAR(50) NOT NULL,
	HouseUnitLotNum NVARCHAR(5) NOT NULL,
	Street NVARCHAR(50) NOT NULL,
	Suburb NVARCHAR(50) NOT NULL,
	[State] NVARCHAR(3) NOT NULL,
	PostCode NCHAR(4) NOT NULL,
	HomePhone NCHAR(10),
	MobilePhone NCHAR(10),
	MedicareNumber NCHAR(16),
	MedicalRegistrationNumber NCHAR(11) UNIQUE,
	DateOfBirth DATE NOT NULL,
	Gender NCHAR(20) NOT NULL,
	PractitionerType_Ref NVARCHAR(50) NOT NULL
);

CREATE TABLE WeekDays
(
	WeekDayName NVARCHAR(9) CONSTRAINT PK_WeekDays PRIMARY KEY (WeekDayName)
);


CREATE TABLE [Availability]
(
	Practitioner_Ref INTEGER,
	WeekDayName_Ref NVARCHAR(9),
	CONSTRAINT PK_Availability PRIMARY KEY (WeekDayName_Ref, Practitioner_Ref),
	CONSTRAINT FK_Availability_Practitioner FOREIGN KEY (Practitioner_Ref) REFERENCES Practitioner(Practitioner_ID),
	CONSTRAINT FK_Availability_WeekDays FOREIGN KEY (WeekDayName_Ref) REFERENCES WeekDays(WeekDayName)
);





CREATE TABLE PractitionerType
(
	PractitionerType NVARCHAR(50) CONSTRAINT PK_PractitionerType PRIMARY KEY (PractitionerType)
);

CREATE TABLE Appointment
(
    Practitioner_Ref INTEGER,
    AppDate DATE,
    AppStartTime TIME,
    Patient_Ref INTEGER,
    CONSTRAINT PK_Appointment PRIMARY KEY (Practitioner_Ref, AppDate, AppStartTime),
    CONSTRAINT FK_Appointment_Practitioner FOREIGN KEY (Practitioner_Ref) REFERENCES Practitioner(Practitioner_ID),
    CONSTRAINT FK_Appointment_Patient FOREIGN KEY (Patient_Ref) REFERENCES Patient(Patient_ID),
    CONSTRAINT AK_Appointment_Patient_AppDate_AppStartTime UNIQUE (Patient_Ref, AppDate, AppStartTime)
);


/*Practitioner AK_MedicalRegistrationNumber*/
ALTER TABLE Practitioner
ADD CONSTRAINT AK_MedicalRegistrationNumber UNIQUE (MedicalRegistrationNumber);

/*Practitione FK_Practitioner_PractitionerTyper*/
ALTER TABLE Practitioner
ADD CONSTRAINT FK_Practitioner_PractitionerType FOREIGN KEY (PractitionerType_Ref) REFERENCES PractitionerType(PractitionerType);

/* Patient*/
BULK INSERT Patient
FROM 'C:\ramazan\Cl_Database_AE_Sk_Appx\Database CSV Files - SQL Server\15_PatientData.csv'
WITH (
	FIRSTROW = 1 ,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    
);

SELECT *
FROM Patient;

/*Practitioner*/
BULK INSERT Practitioner
FROM 'C:\ramazan\Cl_Database_AE_Sk_Appx\Database CSV Files - SQL Server\16_PractitionerData.csv'
WITH (
	FIRSTROW = 1 ,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    
);

SELECT *
FROM Practitioner;

DELETE FROM Practitioner;




/*PractitionerType*/
BULK INSERT PractitionerType
FROM 'C:\ramazan\Cl_Database_AE_Sk_Appx\Database CSV Files - SQL Server\17_PractitionerTypeData.csv'
WITH (
	FIRSTROW = 1 ,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    
);

SELECT *
FROM PractitionerType;

/*WeEkdays*/
BULK INSERT WeekDays
FROM 'C:\ramazan\Cl_Database_AE_Sk_Appx\Database CSV Files - SQL Server\19_WeekDaysData.csv'
WITH (
	FIRSTROW = 1 ,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    
);

SELECT *
FROM WeekDays;

/*Appointment*/
BULK INSERT Appointment
FROM 'C:\ramazan\Cl_Database_AE_Sk_Appx\Database CSV Files - SQL Server\12_AppointmentData.csv'
WITH (
	FIRSTROW = 1 ,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    
);

SELECT *
FROM Appointment;

/*Availability*/
BULK INSERT Availability
FROM 'C:\ramazan\Cl_Database_AE_Sk_Appx\Database CSV Files - SQL Server\13_AvailabilityData.csv'
WITH (
	FIRSTROW = 1 ,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
    
);

Select *
from Availability


/*Values*/
INSERT INTO Patient(Title, FirstName, MiddleInitial, LastName, HouseUnitLotNum, Street, Suburb, [State], PostCode, HomePhone, MobilePhone, MedicareNumber, DateOfBirth, Gender)
VALUES
('Mr', 'Mackenzie', 'J', 'Fleetwood', '233', 'Dreaming Street', 'Roseville', 'NSW', '2069', '0298654743', '0465375486', '7253418356478253', '2000-03-12', 'male'),
('Ms', 'Jane', 'P', 'Killingsworth', '34', 'Southern Road', 'Yarramundi', 'NSW', '2753', '0234654345', '0342134679', '9365243640183640', '1943-04-08', 'female'),
('Mr', 'Peter', 'D', 'Leons', '21', 'Constitution Drive', 'West Hoxton', 'NSW', '2171', '0276539183', '0125364927', '1873652945578932', '1962-07-08', 'male'),
('Mr', 'Phill', 'B', 'Greggan', '42', 'Donn Lane', 'Killara', 'NSW', '2071', '0276548709', '1234326789', '6473645782345678', '1971-08-31', 'male'),
('Dr', 'John', 'W', 'Ward', '332', 'Tomorrow Road', 'Chatswood', 'NSW', '2488', '4847383848', '4838382728', '4738294848484838', '1978-02-12', 'male'),
('Mrs', 'Mary', 'D', 'Brown', 'Lot23', 'Johnston Road', 'Warwick Farm', 'NSW', '2170', '0297465243', '0417335224', '9356273321176546', '1972-03-05', 'female'),
('Mr', 'Terrence', 'D', 'Hill', '43', 'Somerland Road', 'La Perouse', 'NSW', '2987', '0266645432', '0365243561', '6363525353535356', '2005-10-04', 'male'),
('Master', 'Adrian', 'B', 'Tamerkand', '44', 'The Hill Road', 'Macquarie Fields', 'NSW', '2756', '0276546783', '4848473738', '9863652527637332', '2008-12-12', 'male'),
('Ms', 'Joan', 'D', 'Wothers', '32', 'Slapping Street', 'Mount Lewis', 'NSW', '2343', '1294848777', '8484737384', '9484746125364765', '1997-06-12', 'female'),
('Mrs', 'Caroline', 'J', 'Barrette', '44', 'Biggramham Road', 'St Kilda', 'VIC', '4332', '0384736278', '9383827373', '1234565725463728', '1965-04-04', 'female'),
('Mrs', 'Wendy', 'J', 'Pilington', '182', 'Parramatta Road', 'Lidcombe', 'NSW', '2345', '4837383848', '8473838383', '8483727616273838', '1985-09-17', 'female');

SELECT *
FROM Patient;

INSERT INTO PractitionerType (PractitionerType)
VALUES
('Diagnostic radiographer'),
('Enrolled nurse'),
('Medical Practitioner (Doctor or GP)'),
('Medical radiation practitioner'),
('Midwife'),
('Nurse'),
('Occupational therapist'),
('Optometrist'),
('Osteopath'),
('Physical therapist'),
('Physiotherapist'),
('Podiatrist'),
('Psychologist'),
('Radiation therapist'),
('Registered nurse');


SELECT *
FROM PractitionerType;






INSERT INTO Practitioner (Title, FirstName, MiddleInitial, LastName, HouseUnitLotNum, Street, Suburb, [State], PostCode, HomePhone, MobilePhone, MedicareNumber, MedicalRegistrationNumber, DateOfBirth, Gender, PractitionerType_Ref)
VALUES
('Dr', 'Mark', 'P', 'Huston', '21', 'Fuller Street', 'Sunshine', 'NSW', '2343', '0287657483', '0476352638', '9878986473892753', '63738276173', '1975-07-07', 'male', 'Medical Practitioner (Doctor or GP)'),
('Mrs', 'Hilda', 'D', 'Brown', '32', 'Argyle Street', 'Bonnels Bay', 'NSW', '2264', '0249756544', '0318466453', '4635278435099921', '37876273849', '1993-12-03','female', 'Registered nurse'),
('Mrs', 'Jennifer', 'J', 'Dunsworth', '45', 'Dora Street', 'Morriset', 'NSW', '2264', '0249767574', '0228484373', '7666777833449876', '48372678939', '1991-06-04','female', 'Registered nurse'),
('Mr', 'Jason', 'D', 'Lithdon', '43', 'Fowler Street', 'Camperdown', 'NSW', '2050', '0298785645', '0317896453', '0487736265377777', '12345678901', '1989-08-09', 'male', 'Nurse'),
('Ms', 'Paula', 'D', 'Yates', '89', 'Tableton Road', 'Newtown', 'NSW', '2051', '0289876432', '0938473625', '6637474433222881', '84763892834', '1982-09-07', 'female', 'Midwife'),
('Dr', 'Ludo', 'V', 'Vergenargen', '27', 'Pembleton Place', 'Redfern', 'NSW', '2049', '9383737627', '8372727283', '8484737626278884', '84737626673', '1986-05-15', 'male', 'Medical Practitioner (Doctor or GP)'),
('Dr', 'Anne', 'D', 'Funsworth', '4/89', 'Pacific Highway', 'St Leonards', 'NSW', '2984', '8847362839', '8372688949', '8477666525173738', '36271663788', '1991-12-11', 'female', 'Psychologist'),
('Mrs', 'Leslie', 'V', 'Gray', '98', 'Dandaraga Road', 'Mirrabooka', 'NSW', '2264', '4736728288', '4837726789', '4847473737277276', '05958474636', '1989-03-11', 'female', 'Podiatrist'),
('Dr', 'Adam', 'J', 'Moody', '35', 'Mullabinga Way', 'Brightwaters', 'NSW', '2264', '8476635678', '2736352536', '7473636527771183', '63635245256', '1990-09-23', 'male', 'Medical Practitioner (Doctor or GP)'),
('Mr', 'Leslie', 'Y', 'Gray', '3', 'Dorwington Place', 'Enmore', 'NSW', '2048', '8473763678', '4484837289', '3827284716390987', '38277121234', '1991-04-11', 'male', 'Nurse');


SELECT *
FROM Practitioner;

INSERT INTO WeekDays (WeekDayName)
VALUES
('Friday'),
('Monday'),
('Thursday'),
('Tuesday'),
('Wednesday');

SELECT *
FROM WeekDays;



INSERT INTO Availability (WeekDayName_Ref, Practitioner_Ref)
VALUES
('Friday', 10000),
('Monday', 10000),
('Wednesday', 10000),
('Thursday', 10001),
('Tuesday', 10001),
('Thursday', 10002),
('Tuesday', 10002),
('Friday', 10003),
('Monday', 10003),
('Wednesday', 10003),
('Friday', 10004),
('Monday', 10004),
('Thursday', 10005),
('Tuesday', 10005),
('Wednesday', 10006),
('Thursday', 10007),
('Tuesday', 10007),
('Friday', 10008),
('Monday', 10008),
('Wednesday', 10008);




Select *
from Availability





INSERT INTO Appointment (Practitioner_Ref, AppDate, AppStartTime, Patient_Ref)
VALUES
(10005, '2019-09-17', '08:15:00', 10000),
(10006, '2019-09-18', '10:00:00', 10000),
(10006, '2019-09-18', '10:15:00', 10000),
(10006, '2019-09-18', '10:30:00', 10000),
(10006, '2019-09-18', '10:45:00', 10000),
(10006, '2019-09-18', '11:00:00', 10000),
(10005, '2019-09-17', '09:00:00', 10002),
(10000, '2019-09-18', '08:00:00', 10003),
(10005, '2019-09-17', '08:30:00', 10005),
(10000, '2019-09-18', '08:30:00', 10005),
(10005, '2019-09-17', '14:15:00', 10006),
(10008, '2019-09-18', '08:30:00', 10006),
(10005, '2019-09-17', '08:00:00', 10008),
(10002, '2019-09-17', '08:30:00', 10008),
(10005, '2019-09-18', '08:00:00', 10008),
(10005, '2019-09-17', '10:00:00', 10009),
(10001, '2019-09-17', '08:00:00', 10010),
(10005, '2019-09-17', '10:15:00', 10010),
(10008, '2019-09-18', '08:00:00', 10010),
(10006, '2019-09-18', '09:30:00', 10010);



select *
FROM Appointment;