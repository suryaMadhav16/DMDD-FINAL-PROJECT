-- Variables to store foreign key values
DECLARE @PersonID INT
DECLARE @HospitalID INT
DECLARE @DoctorID INT
DECLARE @BillingID INT
DECLARE @DiagnosisID INT
DECLARE @MedicineID INT
DECLARE @PrescriptionID INT
DECLARE @TestID INT
DECLARE @LabReportID INT
DECLARE @SymptomID INT
DECLARE @RecordID INT
DECLARE @AppointmentID INT  

-- Insert data into Person table
INSERT INTO Person (FirstName, LastName, DateOfBirth, MailId, SocialSecurityNumber, Area, City, [State], ZipCode, EmergencyContactNumber, GuardianID)
VALUES ('John', 'Smith', '1970-12-12', 'john.smith@example.com', '611-15-2128', '123 Main St', 'Anytown', 'CA', '12345', NULL, NULL);

-- Get the last inserted PersonID
SET @PersonID = SCOPE_IDENTITY();

-- Insert data into Hospital table
INSERT INTO Hospital (HospitalName, Area, City, [State], ZipCode, PhoneNumber)
VALUES ('ABC Hospital', 'Downtown', 'Anytown', 'CA', '54321', '+15551234567');

-- Get the last inserted HospitalID
SET @HospitalID = SCOPE_IDENTITY();

-- Insert data into Doctor table
INSERT INTO Doctor (DoctorName, LicenseNumber, Specialization, Qualification, YearsOfExperience, ContactInformation, HospitalID)
VALUES ('Dr. Emily Johnson', 'MD11345', 'Neurologist', 'MD', 15, 'emily.com', @HospitalID);

-- Get the last inserted DoctorID
SET @DoctorID = SCOPE_IDENTITY();

-- Insert data into Billing table
INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES ('2013-11-10', 150.0, 'Cash', @PersonID);

-- Get the last inserted BillingID
SET @BillingID = SCOPE_IDENTITY();

-- Insert data into Appointment table
INSERT INTO Appointment (Date, Time, Appointment_Reason, DoctorID, BillingID)
VALUES ('2013-11-15', '10:00 AM', 'Routine Checkup', @DoctorID, @BillingID);

-- Get the last inserted AppointmentID
SET @AppointmentID = SCOPE_IDENTITY();  -- Assign the value here

-- Insert data into Diagnosis table
INSERT INTO Diagnosis (DiagnosisName, Category, Severity, OnsetDate, OffsetDate, FirstAidNeeded)
VALUES ('Parkinson''s Disease', 'Neurological', 'Medium', '2013-11-10', NULL, 1);

-- Get the last inserted DiagnosisID
SET @DiagnosisID = SCOPE_IDENTITY();

-- Insert data into MEDICINE table
INSERT INTO MEDICINE (MedicineName, Description)
VALUES ('Levodopa', 'Parkinson medication');

-- Get the last inserted MedicineID
SET @MedicineID = SCOPE_IDENTITY();

-- Insert data into Prescription table
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (@BillingID, @DoctorID);

-- Get the last inserted PrescriptionID
SET @PrescriptionID = SCOPE_IDENTITY();

-- Insert data into Prescription_Medication table
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES (@PrescriptionID, @MedicineID, '10mg', NULL, 'Once daily', '2013-11-10');

-- Insert data into Test table
INSERT INTO Test (TestName)
VALUES ('MRI Scan');

-- Get the last inserted TestID
SET @TestID = SCOPE_IDENTITY();

-- Insert data into LabReport table
INSERT INTO LabReport (Hospital, DoctorID, LabReportDate)
VALUES (@HospitalID, @DoctorID, '2013-11-10');

-- Get the last inserted LabReportID
SET @LabReportID = SCOPE_IDENTITY();

-- Insert data into LABREPORT_TEST_VALUE table
INSERT INTO LABREPORT_TEST_VALUE (TestID, LabReportID, Value, Unit)
VALUES (@TestID, @LabReportID, 10, 'mmol/L');

-- Insert data into Record table
INSERT INTO Record (RecordDate, PhysicianNotes, PersonID, DiagnosisID, LabReportID, AppointmentID, PrescriptionID)
VALUES ('2013-11-10', 'Patient presented with Parkinson''s symptoms.', @PersonID, @DiagnosisID, @LabReportID, @AppointmentID, @PrescriptionID);

-- Get the last inserted RecordID
SET @RecordID = SCOPE_IDENTITY();

-- Insert data into Symptom table
INSERT INTO Symptom (SymptomName)
VALUES ('Tremors');

-- Get the last inserted SymptomID
SET @SymptomID = SCOPE_IDENTITY();

-- Insert data into Record_Symptom table
INSERT INTO Record_Symptom (RecordID, SymptomID, Severity)
VALUES (@RecordID, @SymptomID, 'Medium');
