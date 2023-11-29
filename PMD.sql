-------------FUNCTIONS---------------
GO--user defined functions:
CREATE FUNCTION dbo.CalculateAge(@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DateOfBirth, GETDATE()) -
           CASE
               WHEN (MONTH(@DateOfBirth) > MONTH(GETDATE())) OR
                    (MONTH(@DateOfBirth) = MONTH(GETDATE()) AND DAY(@DateOfBirth) > DAY(GETDATE()))
               THEN 1
               ELSE 0
           END
END;

GO
CREATE FUNCTION dbo.GetFullName (@PersonID INT)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @FullName VARCHAR(200);

    SELECT @FullName = FirstName + ' ' + LastName
    FROM Person
    WHERE PersonID = @PersonID;

    RETURN @FullName;
END;

GO
CREATE FUNCTION dbo.GetTotalBillingAmount (@PersonID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalAmount DECIMAL(10, 2);

    SELECT @TotalAmount = SUM(TotalAmount)
    FROM Billing
    WHERE PersonID = @PersonID;

    RETURN ISNULL(@TotalAmount, 0);
END;
--------------------Tables & Triggers------------------
GO-- Creating the Person table
CREATE TABLE Person (
  PersonID INT IDENTITY(1,1) PRIMARY KEY,
  FirstName VARCHAR(100),
  LastName VARCHAR(100),
  DateOfBirth DATE,
  Age AS dbo.CalculateAge(DateOfBirth),
  MailId VARCHAR(50),
  SocialSecurityNumber VARCHAR(11) UNIQUE,
  Area VARCHAR(100),
  City VARCHAR(100),
  "State" VARCHAR(100),
  ZipCode VARCHAR(10),
  EmergencyContactNumber VARCHAR(12),
  GuardianID INT,
  CreationDate DATETIME,
  LastModifiedDate DATETIME,
  CreatedBy VARCHAR(50),
  LastModifiedBy VARCHAR(50),
  FOREIGN KEY (GuardianID) REFERENCES Person(PersonID)
);

GO
CREATE TRIGGER trg_Person_Insert
ON Person
AFTER INSERT
AS
BEGIN
  UPDATE Person
  SET CreationDate = GETDATE(),
      CreatedBy = SYSTEM_USER -- Replace with actual logic to capture user
  WHERE PersonID IN (SELECT PersonID FROM inserted);
END

GO
CREATE TRIGGER trg_Person_Update
ON Person
AFTER UPDATE
AS
BEGIN
  UPDATE Person
  SET LastModifiedDate = GETDATE(),
      LastModifiedBy = SYSTEM_USER -- Replace with actual logic to capture user
  WHERE PersonID IN (SELECT PersonID FROM inserted);
END

GO-- Creating the Hospital table
CREATE TABLE Hospital (
  HospitalID INT IDENTITY(1,1) PRIMARY KEY,
  HospitalName VARCHAR(100),
  Area VARCHAR(100),
  City VARCHAR(100),
  "State" VARCHAR(100),
  ZipCode VARCHAR(10),
  PhoneNumber VARCHAR(12)
);


GO-- Creating the Doctor table
CREATE TABLE Doctor (
  DoctorID INT IDENTITY(1,1) PRIMARY KEY,
  DoctorName VARCHAR(100),
  LicenseNumber VARCHAR(50) UNIQUE,
  Specialization VARCHAR(100),
  Qualification VARCHAR(100),
  YearsOfExperience INT,
  ContactInformation VARCHAR(12),
  HospitalID INT,
  FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);


GO-- Creating the Hospital table
ALTER TABLE Hospital
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Hospital_Insert
ON Hospital
AFTER INSERT
AS
BEGIN
    UPDATE Hospital
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE HospitalID IN (SELECT HospitalID FROM inserted);
END;

GO
CREATE TRIGGER trg_Hospital_Update
ON Hospital
AFTER UPDATE
AS
BEGIN
    UPDATE Hospital
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE HospitalID IN (SELECT HospitalID FROM inserted);
END;


GO-- Creating the Doctor table
ALTER TABLE Doctor
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Doctor_Insert
ON Doctor
AFTER INSERT
AS
BEGIN
    UPDATE Doctor
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE DoctorID IN (SELECT DoctorID FROM inserted);
END;

GO
CREATE TRIGGER trg_Doctor_Update
ON Doctor
AFTER UPDATE
AS
BEGIN
    UPDATE Doctor
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE DoctorID IN (SELECT DoctorID FROM inserted);
END;



GO-- Creating the Billing table
ALTER TABLE Billing
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);


GO-- Creating the Billing table
CREATE TABLE Billing (
  BillingID INT IDENTITY(1,1) PRIMARY KEY,
  BillingDate DATE,
  TotalAmount DECIMAL(10, 2),
  PaymentMethod VARCHAR(50),
  PersonID INT,
  FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);


GO-- Creating the Appointment table
CREATE TABLE Appointment (
  AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
  Date DATE,
  Time TIME,
  Appointment_Reason VARCHAR(255),
  DoctorID INT,
  BillingID INT,
  FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
  FOREIGN KEY (BillingID) REFERENCES Billing(BillingID)
);


GO-- Creating the Diagnosis table
CREATE TABLE Diagnosis (
  DiagnosisID INT IDENTITY(1,1) PRIMARY KEY,
  DiagnosisName VARCHAR(100),
  Category VARCHAR(50),
  Severity VARCHAR(50),
  OnsetDate DATE,
  OffsetDate DATE,
  FirstAidNeeded BIT
);

GO-- Creation of the MEDICINE table
CREATE TABLE MEDICINE (
    MedicineID INT IDENTITY(1,1) PRIMARY KEY,
    MedicineName VARCHAR(255),
    Description TEXT
);


GO-- Creation of the PRESCRIPTION table
CREATE TABLE Prescription (
    PrescriptionID INT IDENTITY(1,1)  PRIMARY KEY,
    BillingID INT,
    DoctorID INT,
    FOREIGN KEY (BillingID) REFERENCES Billing(BillingID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);


GO-- Creation of the Prescription_Medication associative table
CREATE TABLE Prescription_Medication (
    PrescriptionID INT,
    MedicineID INT,
    Dosage VARCHAR(255),
    EndDate DATE,
    Frequency VARCHAR(255),
    StartDate DATE,
    PRIMARY KEY (PrescriptionID, MedicineID),
    FOREIGN KEY (PrescriptionID) REFERENCES PRESCRIPTION (PrescriptionID),
    FOREIGN KEY (MedicineID) REFERENCES MEDICINE (MedicineID)
);


GO-- Creation of the TEST table
CREATE TABLE Test (
  TestID INT IDENTITY(1,1) PRIMARY KEY,
  TestName VARCHAR(255)
);


GO-- Creation of the LABREPORT table
CREATE TABLE LabReport (
  LabReportID INT IDENTITY(1,1) PRIMARY KEY,
  Hospital INT,
  DoctorID INT,
  LabReportDate DATE, 
  FOREIGN KEY (Hospital) REFERENCES Hospital(HospitalID),
  FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);



GO-- Creation of the LABREPORT_TEST_VALUE table
CREATE TABLE LABREPORT_TEST_VALUE (
  TestID INT,
  LabReportID INT,
  Value DECIMAL(10,2),
  Unit VARCHAR(50),
  PRIMARY KEY (TestID, LabReportID),
  FOREIGN KEY (TestID) REFERENCES TEST(TestID),
  FOREIGN KEY (LabReportID) REFERENCES LABREPORT(LabReportID)
);


GO-- Creating the Immunization table
CREATE TABLE Vaccine (
  VaccineID INT IDENTITY(1,1) PRIMARY KEY,
  VaccineName VARCHAR(100)
);


GO
CREATE TRIGGER trg_Billing_Insert
ON Billing
AFTER INSERT
AS
BEGIN
    UPDATE Billing
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE BillingID IN (SELECT BillingID FROM inserted);
END;

GO
CREATE TRIGGER trg_Billing_Update
ON Billing
AFTER UPDATE
AS
BEGIN
    UPDATE Billing
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE BillingID IN (SELECT BillingID FROM inserted);
END;

GO-- Creating the Appointment table
ALTER TABLE Appointment
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Appointment_Insert
ON Appointment
AFTER INSERT
AS
BEGIN
    UPDATE Appointment
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE AppointmentID IN (SELECT AppointmentID FROM inserted);
END;

GO
CREATE TRIGGER trg_Appointment_Update
ON Appointment
AFTER UPDATE
AS
BEGIN
    UPDATE Appointment
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE AppointmentID IN (SELECT AppointmentID FROM inserted);
END;


GO-- Creating the Diagnosis table
ALTER TABLE Diagnosis
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Diagnosis_Insert
ON Diagnosis
AFTER INSERT
AS
BEGIN
    UPDATE Diagnosis
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE DiagnosisID IN (SELECT DiagnosisID FROM inserted);
END;

GO
CREATE TRIGGER trg_Diagnosis_Update
ON Diagnosis
AFTER UPDATE
AS
BEGIN
    UPDATE Diagnosis
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE DiagnosisID IN (SELECT DiagnosisID FROM inserted);
END;


GO-- Creation of the MEDICINE table
ALTER TABLE Medicine
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Medicine_Insert
ON Medicine
AFTER INSERT
AS
BEGIN
    UPDATE Medicine
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE MedicineID IN (SELECT MedicineID FROM inserted);
END;

GO
CREATE TRIGGER trg_Medicine_Update
ON Medicine
AFTER UPDATE
AS
BEGIN
    UPDATE Medicine
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE MedicineID IN (SELECT MedicineID FROM inserted);
END;

GO-- Creation of the PRESCRIPTION table
ALTER TABLE Prescription
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Prescription_Insert
ON Prescription
AFTER INSERT
AS
BEGIN
    UPDATE Prescription
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE PrescriptionID IN (SELECT PrescriptionID FROM inserted);
END;

GO
CREATE TRIGGER trg_Prescription_Update
ON Prescription
AFTER UPDATE
AS
BEGIN
    UPDATE Prescription
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE PrescriptionID IN (SELECT PrescriptionID FROM inserted);
END;


GO-- Creation of the Prescription_Medication associative table
ALTER TABLE Prescription_Medication
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Prescription_Medication_Insert
ON Prescription_Medication
AFTER INSERT
AS
BEGIN
    UPDATE Prescription_Medication
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE PrescriptionID IN (SELECT PrescriptionID FROM inserted);
END;

GO
CREATE TRIGGER trg_Prescription_Medication_Update
ON Prescription_Medication
AFTER UPDATE
AS
BEGIN
    UPDATE Prescription_Medication
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE PrescriptionID IN (SELECT PrescriptionID FROM inserted);
END;


GO-- Creation of the TEST table
ALTER TABLE Test
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Test_Insert
ON Test
AFTER INSERT
AS
BEGIN
    UPDATE Test
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE TestID IN (SELECT TestID FROM inserted);
END;

GO
CREATE TRIGGER trg_Test_Update
ON Test
AFTER UPDATE
AS
BEGIN
    UPDATE Test
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE TestID IN (SELECT TestID FROM inserted);
END;


GO-- Creation of the LABREPORT table
ALTER TABLE LabReport
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_LabReport_Insert
ON LabReport
AFTER INSERT
AS
BEGIN
    UPDATE LabReport
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE LabReportID IN (SELECT LabReportID FROM inserted);
END;

GO
CREATE TRIGGER trg_LabReport_Update
ON LabReport
AFTER UPDATE
AS
BEGIN
    UPDATE LabReport
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE LabReportID IN (SELECT LabReportID FROM inserted);
END;



GO-- Creation of the LABREPORT_TEST_VALUE table
ALTER TABLE LABREPORT_TEST_VALUE
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_LABREPORT_TEST_VALUE_Insert
ON LABREPORT_TEST_VALUE
AFTER INSERT
AS
BEGIN
    UPDATE LABREPORT_TEST_VALUE
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE LabReportID IN (SELECT LabReportID FROM inserted);
END;

GO
CREATE TRIGGER trg_LABREPORT_TEST_VALUE_Update
ON LABREPORT_TEST_VALUE
AFTER UPDATE
AS
BEGIN
    UPDATE LABREPORT_TEST_VALUE
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE LabReportID IN (SELECT LabReportID FROM inserted);
END;


GO-- Creating the Immunization table
ALTER TABLE Vaccine
ADD CreationDate DATETIME,
    LastModifiedDate DATETIME,
    CreatedBy VARCHAR(50),
    LastModifiedBy VARCHAR(50);

GO
CREATE TRIGGER trg_Vaccine_Insert
ON Vaccine
AFTER INSERT
AS
BEGIN
    UPDATE Vaccine
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE VaccineID IN (SELECT VaccineID FROM inserted);
END;

GO
CREATE TRIGGER trg_Vaccine_Update
ON Vaccine
AFTER UPDATE
AS
BEGIN
    UPDATE Vaccine


GO-- Creating the Immunizations associative table
CREATE TABLE Immunizations (
   VaccineID INT,
   PersonID INT,
   Date_Administered DATE,
   CreationDate DATETIME,
   LastModifiedDate DATETIME,
   CreatedBy VARCHAR(50),
   LastModifiedBy VARCHAR(50),
   PRIMARY KEY (VaccineID, PersonID),
   FOREIGN KEY (VaccineID) REFERENCES Vaccine(VaccineID),
   FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

GO
CREATE TRIGGER trg_Immunizations_Insert
ON Immunizations
AFTER INSERT
AS
BEGIN
    UPDATE Immunizations
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE VaccineID IN (SELECT VaccineID FROM inserted);
END;

GO
CREATE TRIGGER trg_Immunizations_Update
ON Immunizations
AFTER UPDATE
AS
BEGIN
    UPDATE Immunizations
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE VaccineID IN (SELECT VaccineID FROM inserted);
END;


GO-- Creating the Psychographics table
CREATE TABLE Psychographics (
   PsychographicsID INT IDENTITY(1,1) PRIMARY KEY,
   Hobbies VARCHAR(100),
   Diet VARCHAR(100),
   Exercise VARCHAR(50),
   LastTravel DATE,
   TechnologyUsage VARCHAR(50),
   PersonID INT,
   CreationDate DATETIME,
   LastModifiedDate DATETIME,
   CreatedBy VARCHAR(50),
   LastModifiedBy VARCHAR(50),
   FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

GO
CREATE TRIGGER trg_Psychographics_Insert
ON Psychographics
AFTER INSERT
AS
BEGIN
    UPDATE Psychographics
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE PsychographicsID IN (SELECT PsychographicsID FROM inserted);
END;

GO
CREATE TRIGGER trg_Psychographics_Update
ON Psychographics
AFTER UPDATE
AS
BEGIN
    UPDATE Psychographics
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE PsychographicsID IN (SELECT PsychographicsID FROM inserted);
END;


GO-- Creating the Record table
CREATE TABLE Record (
   RecordID INT IDENTITY(1,1) PRIMARY KEY,
   RecordDate DATE,
   PhysicianNotes TEXT,
   PersonID INT,
   DiagnosisID INT,
   SymptomID INT,
   LabReportID INT,
   AppointmentID INT,
   PrescriptionID INT,
   CreationDate DATETIME,
   LastModifiedDate DATETIME,
   CreatedBy VARCHAR(50),
   LastModifiedBy VARCHAR(50),
   FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
   FOREIGN KEY (DiagnosisID) REFERENCES Diagnosis(DiagnosisID),
   FOREIGN KEY (LabReportID) REFERENCES LabReport(LabReportID),
   FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
   FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID)
);

GO
CREATE TRIGGER trg_Record_Insert
ON Record
AFTER INSERT
AS
BEGIN
    UPDATE Record
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE RecordID IN (SELECT RecordID FROM inserted);
END;

GO
CREATE TRIGGER trg_Record_Update
ON Record
AFTER UPDATE
AS
BEGIN
    UPDATE Record
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE RecordID IN (SELECT RecordID FROM inserted);
END;


GO-- Creating the Symptom table
CREATE TABLE Symptom (
   SymptomID INT IDENTITY(1,1) PRIMARY KEY,
   SymptomName VARCHAR(100),
   CreationDate DATETIME,
   LastModifiedDate DATETIME,
   CreatedBy VARCHAR(50),
   LastModifiedBy VARCHAR(50)
);

GO
CREATE TRIGGER trg_Symptom_Insert
ON Symptom
AFTER INSERT
AS
BEGIN
    UPDATE Symptom
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE SymptomID IN (SELECT SymptomID FROM inserted);
END;

GO
CREATE TRIGGER trg_Symptom_Update
ON Symptom
AFTER UPDATE
AS
BEGIN
    UPDATE Symptom
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE SymptomID IN (SELECT SymptomID FROM inserted);
END;


GO-- Creating the Record Symptom table
CREATE TABLE Record_Symptom (
   RecordID INT,
   SymptomID INT,
   Severity VARCHAR(50),
   CreationDate DATETIME,
   LastModifiedDate DATETIME,
   CreatedBy VARCHAR(50),
   LastModifiedBy VARCHAR(50),
   PRIMARY KEY (RecordID, SymptomID),
   FOREIGN KEY (RecordID) REFERENCES Record(RecordID),
   FOREIGN KEY (SymptomID) REFERENCES Symptom(SymptomID)
);

GO
CREATE TRIGGER trg_Record_Symptom_Insert
ON Record_Symptom
AFTER INSERT
AS
BEGIN
    UPDATE Record_Symptom
    SET CreationDate = GETDATE(),
        CreatedBy = SYSTEM_USER
    WHERE RecordID IN (SELECT RecordID FROM inserted);
END;

GO
CREATE TRIGGER trg_Record_Symptom_Update
ON Record_Symptom
AFTER UPDATE
AS
BEGIN
    UPDATE Record_Symptom
    SET LastModifiedDate = GETDATE(),
        LastModifiedBy = SYSTEM_USER
    WHERE RecordID IN (SELECT RecordID FROM inserted);
END;



---------------- Additional Checks---------------

ALTER TABLE Person
ADD CONSTRAINT CHK_Person_DateOfBirth CHECK (DateOfBirth <= GETDATE());

ALTER TABLE Billing
ADD CONSTRAINT CHK_Billing_Amount CHECK (TotalAmount >= 0.00);

ALTER TABLE Person
ADD CONSTRAINT CHK_Person_Age CHECK (DATEDIFF(YEAR, DateOfBirth, GETDATE()) <= 150);

ALTER TABLE Prescription_Medication
ADD CONSTRAINT CHK_Prescription_ValidDuration CHECK (StartDate <= EndDate);

ALTER TABLE Diagnosis
ADD CONSTRAINT CHK_Diagnosis_Severity CHECK (Severity IN ('Low', 'Medium', 'High'));

ALTER TABLE Appointment
ADD CONSTRAINT CHK_Appointment_Date CHECK (Date <= CAST(GETDATE() AS DATE));

ALTER TABLE Appointment
DROP CONSTRAINT CHK_Appointment_Date

ALTER TABLE Doctor
ADD CONSTRAINT CHK_Doctor_YearsOfExperience CHECK (YearsOfExperience >= 0);

ALTER TABLE Hospital
ADD CONSTRAINT CHK_Hospital_PhoneNumber_Format CHECK (PhoneNumber LIKE '[+][1][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE Person
ADD CONSTRAINT CHK_Person_EmergencyContactNumber_Format CHECK (EmergencyContactNumber LIKE '[+][1][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE Person
ADD CONSTRAINT CHK_Person_SSN_Format CHECK (SocialSecurityNumber LIKE '[0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][0-9][0-9]');

ALTER TABLE Billing
ADD CONSTRAINT CHK_Billing_PaymentMethod CHECK (PaymentMethod IN ('Cash', 'Credit', 'Debit'));

GO
CREATE TRIGGER VerifySSNBeforeInsertOrUpdate
ON Person
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE SocialSecurityNumber IS NOT NULL AND SocialSecurityNumber NOT LIKE '___-__-____'
    )
    BEGIN
        THROW 50000, 'Invalid SSN format', 1;
    END
END;


-- Adding Encrypted Column
ALTER TABLE Person
ADD EncryptedSocialSecurityNumber VARBINARY(MAX);

UPDATE Person
SET EncryptedSocialSecurityNumber = ENCRYPTBYPASSPHRASE('Secret', SocialSecurityNumber);

SELECT ENCRYPTBYPASSPHRASE('Secret', '123-45-6789');

ALTER TABLE Record
DROP COLUMN SymptomID;


