-- Inserting John Doe's information into the Person table
INSERT INTO Person (FirstName, LastName, DateOfBirth, MailId, SocialSecurityNumber)
VALUES ('John', 'Doe', '1968-01-01', 'john.doe@example.com', '123-45-6789');

-- Inserting John Doe's initial diagnosis into the Diagnosis table
INSERT INTO Diagnosis (DiagnosisName, Category, Severity, OnsetDate, OffsetDate, FirstAidNeeded)
VALUES ('Hypertension', 'Cardiovascular', 'Medium', '2013-01-01', NULL, 0);

-- Insert a Hospital record
INSERT INTO Hospital (HospitalName, Area, City, "State", ZipCode, PhoneNumber)
VALUES ('City General Hospital', 'Downtown', 'Cityville', 'Stateville', '12345', '+15518990090');


-- Insert a Doctor record
INSERT INTO Doctor (DoctorName, LicenseNumber, Specialization, Qualification, YearsOfExperience, ContactInformation, HospitalID)
VALUES ('Dr. Emily Johnson', 'DR56789', 'Dermatologist', 'MD', 12, '+15518990090', 1);


-- Inserting John Doe's medical record for the initial diagnosis into the Record table
INSERT INTO Record (RecordDate, PhysicianNotes, PersonID, DiagnosisID)
VALUES ('2013-01-01', 'Patient presented with occasional dizziness and frequent headaches. Blood pressure consistently high (averaging around 160/100 mm Hg). Diagnosed with hypertension. Advised dietary modifications and regular exercise.', 1, 1);

-- Inserting a symptom record for John Doe's dizziness and headaches into the Symptom table
INSERT INTO Symptom (SymptomName)
VALUES ('Dizziness and Headaches');

-- Inserting a record in Record_Symptom table to associate John Doe's symptom with his medical record
INSERT INTO Record_Symptom (RecordID, SymptomID, Severity)
VALUES (1, 1, 'Mild');

-- Inserting an appointment record for John Doe's follow-up appointment into the Appointment table
INSERT INTO Appointment (Date, Time, Appointment_Reason, DoctorID, BillingID)
VALUES ('2013-02-01', '10:00:00', 'Follow-up for Hypertension', 1, NULL);

-- Inserting billing information for John Doe's follow-up appointment into the Billing table
INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES 
    ('2013-02-01', 150.00, 'Credit', 1),
    ('2013-02-01', 150.00, 'Debit', 1);

-- Inserting a prescription record for John Doe's hypertension medication into the Prescription table
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (2, 1);

-- Inserting records for the prescribed medications
INSERT INTO MEDICINE (MedicineName, Description)
VALUES
  ('Amlodipine', 'Prescribed for hypertension.'),
  ('Hydrochlorothiazide', 'Prescribed for hypertension.');
  
-- Inserting the prescription-medication associations
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES
  (1, 1, '5 mg daily', NULL, NULL, '2013-02-01'),
  (1, 2, '25 mg daily', NULL, NULL, '2013-02-01');








-- Year 2: Medication Adjustment
-- John's PCP adjusted his medication due to persistent high blood pressure.
-- New medication: Amlodipine and Hydrochlorothiazide

-- Inserting a new prescription record for John Doe's medication adjustment
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (2, 1);

-- Inserting records for the new prescribed medications
INSERT INTO MEDICINE (MedicineName, Description)
VALUES
  ('Amlodipine', 'Prescribed to manage hypertension.'),
  ('Hydrochlorothiazide', 'Prescribed to manage hypertension.');

-- Inserting the prescription-medication associations for the new medications
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES
  (2, 1, '10 mg daily', NULL, NULL, '2014-03-10'), -- Amlodipine
  (2, 2, '25 mg daily', NULL, NULL, '2014-03-10'); -- Hydrochlorothiazide

-- Year 3: Lifestyle Changes
-- John continued to make efforts to manage his blood pressure through lifestyle changes.
-- He improved his diet, exercised regularly, and reduced his sodium intake.

-- Inserting lifestyle-related notes into the Record table
INSERT INTO Record (RecordDate, PhysicianNotes, PersonID, DiagnosisID)
VALUES ('2015-01-15', 'Patient made significant improvements in lifestyle. Committed to a low-sodium diet and regular exercise routine. Blood pressure readings improving.', 1, 1);

-- Year 4: Ongoing Blood Pressure Management
-- John's blood pressure readings remained in the pre-hypertensive range despite lifestyle changes and medication.
-- He continued to monitor his blood pressure and adherence to medication.

-- Inserting follow-up appointment and billing records for Year 4
INSERT INTO Appointment (Date, Time, Appointment_Reason, DoctorID, BillingID)
VALUES ('2016-02-01', '11:00:00', 'Blood Pressure Check', 1, NULL);

-- Inserting billing information for the Year 4 appointment
INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES ('2016-02-01', 75.00, 'Credit', 1),
        ('2016-02-01', 75.00, 'Credit', 1),
       ('2016-02-01', 75.00, 'Debit', 1);

-- Inserting a prescription record for continued medication
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (4, 1);

-- Inserting records for John Doe's ongoing medication
INSERT INTO MEDICINE (MedicineName, Description)
VALUES
  ('Amlodipine', 'Continued for hypertension management.'),
  ('Hydrochlorothiazide', 'Continued for hypertension management.');

-- Inserting the prescription-medication associations for the ongoing medications
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES
  (3, 1, '10 mg daily', NULL, NULL, '2016-02-01'), -- Amlodipine
  (3, 2, '25 mg daily', NULL, NULL, '2016-02-01'); -- Hydrochlorothiazide



INSERT INTO Test (TestName)
VALUES ('Kidney Function Test'),
       ('Electrolyte Levels Test');

-- Inserting symptom records
INSERT INTO Symptom (SymptomName)
VALUES
  ('Dizziness and Headaches'),
  ('Cough'),
  ('Dizziness');
-- Inserting diagnosis records
INSERT INTO Diagnosis (DiagnosisName, Category, Severity, OnsetDate, OffsetDate, FirstAidNeeded)
VALUES
  ('Hypertension', 'Cardiovascular', 'Medium', '2013-01-01', NULL, 0);

INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES 
    ('2018-04-10', 150.00, 'Credit', 1),
    ('2018-04-10', 150.00, 'Debit', 1);

-- Year 5-7: Medication Adjustments and Lab Tests
-- Despite John's efforts, his blood pressure remained elevated.
-- His PCP added an ACE inhibitor (lisinopril) to his medication regimen.
-- Regular lab tests were conducted to monitor his kidney function and electrolyte levels due to the medication.
-- John experienced some cough and dizziness as side effects of the ACE inhibitor but continued with the medication.
-- Blood pressure readings fluctuated but generally improved to around 130/85 mm Hg.

-- Year 5: ACE Inhibitor Prescription
-- John's PCP added lisinopril to his medication regimen for better blood pressure control.

-- Inserting a new prescription record for adding lisinopril
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (6, 1);

-- Inserting records for the new prescribed medication (lisinopril)
INSERT INTO MEDICINE (MedicineName, Description)
VALUES ('Lisinopril', 'Prescribed as an ACE inhibitor for better blood pressure control.');

-- Inserting the prescription-medication association for lisinopril
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES (4, 7, '10 mg daily', NULL, NULL, '2017-02-15');

-- Year 6-7: Lab Tests and Monitoring
-- Regular lab tests were conducted to monitor John's kidney function and electrolyte levels.

-- Inserting lab report records for Year 6 and Year 7
INSERT INTO LabReport (Hospital, DoctorID, LabReportDate)
VALUES (1, 1, '2018-04-10'),
       (1, 1, '2019-06-20');

-- Inserting lab test values for Year 6 and Year 7 (kidney function and electrolytes)
INSERT INTO LABREPORT_TEST_VALUE (TestID, LabReportID, Value, Unit)
VALUES (1, 1, 1.2, 'mg/dL'),
       (2, 1, 140, 'mEq/L'),
       (1, 2, 1.1, 'mg/dL'),
       (2, 2, 138, 'mEq/L');

-- Year 7: Medication Side Effects
-- John experienced cough and dizziness as side effects of lisinopril but continued with the medication.
-- Inserting a record for medication side effects

-- Inserting a record for medication side effects of lisinopril
INSERT INTO Record (RecordDate, PhysicianNotes, PersonID, DiagnosisID)
VALUES ('2019-06-25', 'Patient experienced cough and dizziness as side effects of lisinopril but continued with the medication. Blood pressure readings improved.', 1, 1);

-- Inserting follow-up appointment and billing records for Year 7
INSERT INTO Appointment (Date, Time, Appointment_Reason, DoctorID, BillingID)
VALUES ('2019-06-30', '14:00:00', 'Follow-up for Medication Side Effects',1, NULL);

-- Inserting billing information for the Year 7 appointment
INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES ('2019-06-30', 75.00, 'Credit', 1);

INSERT INTO Record_Symptom (RecordID, SymptomID, Severity)
VALUES
  (3, 1, 'Mild'), -- Cough
  (3, 2, 'Mild'); -- Dizziness




  -- Year 8: Cardiologist Referral and Echocardiogram
-- John's PCP referred him to a cardiologist for evaluation

-- Inserting a diagnosis record for left ventricular hypertrophy
INSERT INTO Diagnosis (DiagnosisName, Category, Severity, OnsetDate, OffsetDate, FirstAidNeeded)
VALUES ('Left Ventricular Hypertrophy', 'Cardiovascular', 'Medium', '2020-01-15', NULL, 0);

-- Inserting a cardiology appointment for John's evaluation
INSERT INTO Appointment (Date, Time, Appointment_Reason, DoctorID, BillingID)
VALUES ('2020-02-01', '09:30:00', 'Cardiology Evaluation', 1, NULL);

-- Inserting billing information for the cardiology appointment
INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES ('2020-02-01', 200.00, 'Credit', 1);

-- Year 9: Medication Adjustment and Ankle Swelling
-- The cardiologist prescribed a calcium channel blocker (amlodipine) in addition to John's current medications

-- Inserting a new prescription record for amlodipine
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (9, 1);

-- Inserting the prescription-medication association for amlodipine
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES (4, 2, '5 mg daily', NULL, NULL, '2021-03-10');

-- Inserting a symptom record for ankle swelling as a side effect of amlodipine
INSERT INTO Symptom (SymptomName)
VALUES ('Ankle Swelling');

-- Inserting a medical record for Year 8-9 hypertension-related complications
INSERT INTO Record (RecordDate, PhysicianNotes, PersonID, DiagnosisID, AppointmentID, PrescriptionID)
VALUES ('2020-02-01', 'Referred to a cardiologist for evaluation of left ventricular hypertrophy. Echocardiogram recommended. Medication adjusted with the addition of amlodipine.', 1, 1, 4, 4);


-- Inserting a record in Record_Symptom table to associate ankle swelling with John's medical record
INSERT INTO Record_Symptom (RecordID, SymptomID, Severity)
VALUES (3, 5, 'Mild');



-- Year 10: Co-Existing Conditions

-- Inserting a symptom record for erectile dysfunction
INSERT INTO Symptom (SymptomName)
VALUES ('Erectile Dysfunction');

-- Inserting a diagnosis record for erectile dysfunction
INSERT INTO Diagnosis (DiagnosisName, Category, Severity, OnsetDate, OffsetDate, FirstAidNeeded)
VALUES ('Erectile Dysfunction', 'Urological', 'Low', '2022-04-15', NULL, 0);

-- Inserting regular follow-up appointment and billing records for monitoring
INSERT INTO Appointment (Date, Time, Appointment_Reason, DoctorID, BillingID)
VALUES ('2022-05-01', '10:30:00', 'Follow-up for Blood Pressure and Erectile Dysfunction', 1, NULL);

-- Inserting a medical record for erectile dysfunction evaluation and medication adjustment
INSERT INTO Record (RecordDate, PhysicianNotes, PersonID, DiagnosisID, AppointmentID)
VALUES ('2022-04-15', 'Patient reported symptoms of erectile dysfunction. Further evaluation revealed hypertension-related erectile dysfunction. Medication adjusted to losartan.', 1, 4, 5);

-- Inserting a record in Record_Symptom table to associate erectile dysfunction with John's medical record
INSERT INTO Record_Symptom (RecordID, SymptomID, Severity)
VALUES (6, 6, 'Mild');


INSERT INTO Billing (BillingDate, TotalAmount, PaymentMethod, PersonID)
VALUES 
    ('2013-02-01', 150.00, 'Credit', 1),
    ('2013-02-01', 150.00, 'Debit', 1);

-- Inserting a new prescription record for losartan
INSERT INTO Prescription (BillingID, DoctorID)
VALUES (10, 1);

-- Inserting a record for the prescribed medication (losartan)
INSERT INTO MEDICINE (MedicineName, Description)
VALUES ('Losartan', 'Prescribed as an antihypertensive medication with a lower risk of sexual side effects.');

-- Inserting the prescription-medication association for losartan
INSERT INTO Prescription_Medication (PrescriptionID, MedicineID, Dosage, EndDate, Frequency, StartDate)
VALUES (6, 8, '50 mg daily', NULL, NULL, '2022-04-15');

DELETE FROM Diagnosis
WHERE DiagnosisID = 2;
