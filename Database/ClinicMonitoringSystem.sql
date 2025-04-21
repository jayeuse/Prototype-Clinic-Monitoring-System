-- Create a database
CREATE DATABASE ClinicMonitoringSystem;

-- Use the database
USE ClinicMonitoringSystem;

-- & Patient Attributes
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    PatientRegistrationID INT,
    UserID INT
);

CREATE TABLE PatientRegistration (
    PatientRegistrationID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    StudentID VARCHAR(50),
    Age INT,
    Sex ENUM('Male', 'Female', 'Other') NOT NULL,
    Birthdate DATE NOT NULL,
    Address VARCHAR(255),
    EmergencyContact VARCHAR(50)
);

-- & Staff Attributes
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    StaffRegistrationID INT,
    UserID INT
);

CREATE TABLE StaffRegistration (
    StaffRegistrationID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    StaffID VARCHAR(50) NOT NULL,
    Sex ENUM('Male', 'Female', 'Other') NOT NULL,
    Position ENUM('Doctor', 'Nurse', 'Dentist') NOT NULL,
    Address VARCHAR(255),
    Contact VARCHAR(50)
);

-- & Visit Logs for Patients and Attendance for Staffs
CREATE TABLE VisitLogs (
    VisitLogID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Date DATE NOT NULL,
    TimeIn TIME NOT NULL,
    TimeOut TIME NULL,
    ReasonForVisit TEXT
);

CREATE TABLE StaffAttendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    StaffID INT,
    Date DATE NOT NULL,
    TimeIn TIME NOT NULL,
    TimeOut TIME NULL
);

-- & Diagnoses Table
CREATE TABLE Diagnoses (
    DiagnosisID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    StaffID INT,
    VisitLogID INT,
    TreatmentPlanID INT
);

CREATE TABLE Symptoms (
    SymptomID INT PRIMARY KEY AUTO_INCREMENT,
    DiagnosisID INT,
    SymptomDescription VARCHAR(255) NOT NULL,
    FOREIGN KEY (DiagnosisID) REFERENCES Diagnoses(DiagnosisID) ON DELETE CASCADE
);

CREATE TABLE TreatmentPlan (
    TreatmentPlanID INT PRIMARY KEY AUTO_INCREMENT,
    DiagnosisID INT UNIQUE
);

CREATE TABLE Medications (
    MedicationsID INT PRIMARY KEY AUTO_INCREMENT,
    TreatmentPlanID INT,
    MedicineName VARCHAR(255),
    Dosage VARCHAR(100),
    Duration VARCHAR(100)
);

CREATE TABLE LifestyleRecommendations (
    LRecommendID INT PRIMARY KEY AUTO_INCREMENT,
    TreatmentPlanID INT,
    Recommendations TEXT
);

-- & Assigning Patients to Staffs
CREATE TABLE PatientStaffAssignment (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    StaffID INT,
    Date DATE NOT NULL
);

-- & Login Credentials
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Identifier VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role ENUM('Patient', 'Staff', 'Admin') NOT NULL
);

-- Foreign Key Assignments
ALTER TABLE Patients
ADD FOREIGN KEY (PatientRegistrationID) REFERENCES PatientRegistration(PatientRegistrationID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Staff
ADD FOREIGN KEY (StaffRegistrationID) REFERENCES StaffRegistration(StaffRegistrationID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE VisitLogs
ADD FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE StaffAttendance
ADD FOREIGN KEY (StaffID) REFERENCES Staff(StaffID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Diagnoses
ADD FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (StaffID) REFERENCES Staff(StaffID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (VisitLogID) REFERENCES VisitLogs(VisitLogID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE TreatmentPlan
ADD FOREIGN KEY (DiagnosisID) REFERENCES Diagnoses(DiagnosisID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Medications
ADD FOREIGN KEY (TreatmentPlanID) REFERENCES TreatmentPlan(TreatmentPlanID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE LifestyleRecommendations
ADD FOREIGN KEY (TreatmentPlanID) REFERENCES TreatmentPlan(TreatmentPlanID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PatientStaffAssignment
ADD FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (StaffID) REFERENCES Staff(StaffID) ON DELETE CASCADE ON UPDATE CASCADE;

-- Make foreign keys NOT NULL

-- Patients
ALTER TABLE Patients
MODIFY PatientRegistrationID INT NOT NULL,
MODIFY UserID INT NOT NULL;

-- Staff
ALTER TABLE Staff
MODIFY StaffRegistrationID INT NOT NULL,
MODIFY UserID INT NOT NULL;

-- VisitLogs
ALTER TABLE VisitLogs
MODIFY PatientID INT NOT NULL;

-- StaffAttendance
ALTER TABLE StaffAttendance
MODIFY StaffID INT NOT NULL;

-- Diagnoses
ALTER TABLE Diagnoses
MODIFY PatientID INT NOT NULL,
MODIFY StaffID INT NOT NULL,
MODIFY VisitLogID INT NOT NULL,
MODIFY TreatmentPlanID INT;

-- TreatmentPlan
ALTER TABLE TreatmentPlan
MODIFY DiagnosisID INT NOT NULL;

-- Medications
ALTER TABLE Medications
MODIFY TreatmentPlanID INT NOT NULL;

-- LifestyleRecommendations
ALTER TABLE LifestyleRecommendations
MODIFY TreatmentPlanID INT NOT NULL;

-- PatientStaffAssignment
ALTER TABLE PatientStaffAssignment
MODIFY PatientID INT NOT NULL,
MODIFY StaffID INT NOT NULL;

ALTER TABLE PatientRegistration
    DROP COLUMN Name,
    ADD COLUMN LastName VARCHAR(50) NOT NULL,
    ADD COLUMN FirstName VARCHAR(50) NOT NULL,
    ADD COLUMN MiddleName VARCHAR(50) NOT NULL,
    ADD COLUMN Suffix VARCHAR(10) NOT NULL;

ALTER TABLE StaffRegistration
    DROP COLUMN Name,
    ADD COLUMN LastName VARCHAR(50) NOT NULL,
    ADD COLUMN FirstName VARCHAR(50) NOT NULL,
    ADD COLUMN MiddleName VARCHAR(50) NOT NULL,
    ADD COLUMN Suffix VARCHAR(10) NOT NULL;

CREATE VIEW view_PatientInformation AS
SELECT
    Patients.PatientID,
    CONCAT_WS(' ', PatientRegistration.FirstName, PatientRegistration.MiddleName, PatientRegistration.LastName, PatientRegistration.Suffix) AS FullName,
    PatientRegistration.StudentID,
    PatientRegistration.Age,
    PatientRegistration.Sex,
    PatientRegistration.Birthdate,
    CONCAT_WS(', ', PatientRegistration.UnitNo, PatientRegistration.Street, PatientRegistration.Baranggay, PatientRegistration.City) AS Address,
    PatientRegistration.EmergencyContact
FROM
    Patients
JOIN
    PatientRegistration ON Patients.PatientRegistrationID = PatientRegistration.PatientRegistrationID;

CREATE VIEW view_patientvisitlogs AS
SELECT 
    v.PatientID, 
    v.Date, 
    v.TimeIn, 
    v.TimeOut,
    v.ReasonForVisit,
    CONCAT(sr.FirstName, ' ', sr.MiddleName, ' ', sr.LastName, ' ', sr.Suffix) AS StaffInCharge
FROM 
    VisitLogs v
JOIN 
    Diagnoses d ON v.VisitLogID = d.VisitLogID
JOIN 
    Staff s ON d.StaffID = s.StaffID
JOIN 
    StaffRegistration sr ON s.StaffRegistrationID = sr.StaffRegistrationID;

CREATE VIEW view_patientclinicalsummary AS
SELECT 
    p.PatientID,
    d.ConfirmedDiagnosis,
    vl.Date AS DateOfDiagnosis, 
    GROUP_CONCAT(s.SymptomDescription SEPARATOR ', ') AS IdentifiedSymptoms,
    GROUP_CONCAT(m.MedicineName, ' (', m.Dosage, ')' SEPARATOR ', ') AS PrescribedMedications,
    GROUP_CONCAT(lr.Recommendations SEPARATOR ', ') AS RecommendedLifestyles,
    CONCAT(sr.FirstName, ' ', sr.MiddleName, ' ', sr.LastName, ' ', sr.Suffix) AS ConsultingPhysician 
FROM 
    Patients p
JOIN 
    Diagnoses d ON p.PatientID = d.PatientID
JOIN 
    VisitLogs vl ON d.VisitLogID = vl.VisitLogID
JOIN 
    Symptoms s ON s.DiagnosisID = d.DiagnosisID
JOIN 
    Medications m ON m.TreatmentPlanID = d.TreatmentPlanID
JOIN 
    LifestyleRecommendations lr ON lr.TreatmentPlanID = d.TreatmentPlanID
JOIN 
    Staff st ON d.StaffID = st.StaffID
JOIN 
    StaffRegistration sr ON st.StaffRegistrationID = sr.StaffRegistrationID
GROUP BY 
    p.PatientID, d.ConfirmedDiagnosis, vl.Date, sr.FirstName, sr.MiddleName, sr.LastName, sr.Suffix;

CREATE VIEW view_patient_all_clinical_summaries AS
SELECT 
    p.PatientID,  
    d.ConfirmedDiagnosis,  
    vl.Date AS DateOfDiagnosis, 
    GROUP_CONCAT(s.SymptomDescription SEPARATOR ', ') AS IdentifiedSymptoms,  (concatenated if multiple)
    GROUP_CONCAT(m.MedicineName, ' (', m.Dosage, ')' SEPARATOR ', ') AS PrescribedMedications,  
    GROUP_CONCAT(lr.Recommendations SEPARATOR ', ') AS RecommendedLifestyles,  
    CONCAT(sr.FirstName, ' ', sr.MiddleName, ' ', sr.LastName, ' ', sr.Suffix) AS ConsultingPhysician 
FROM 
    Patients p
JOIN 
    Diagnoses d ON p.PatientID = d.PatientID
JOIN 
    VisitLogs vl ON d.VisitLogID = vl.VisitLogID
JOIN 
    Symptoms s ON s.DiagnosisID = d.DiagnosisID  
JOIN 
    Medications m ON m.TreatmentPlanID = d.TreatmentPlanID  
JOIN 
    LifestyleRecommendations lr ON lr.TreatmentPlanID = d.TreatmentPlanID  
JOIN 
    Staff st ON d.StaffID = st.StaffID  
JOIN 
    StaffRegistration sr ON st.StaffRegistrationID = sr.StaffRegistrationID  
GROUP BY 
    p.PatientID, d.ConfirmedDiagnosis, vl.Date, sr.FirstName, sr.MiddleName, sr.LastName, sr.Suffix;

CREATE VIEW view_patient_latest_clinical_summary AS
SELECT 
    p.PatientID,  
    d.ConfirmedDiagnosis,  
    vl.Date AS DateOfDiagnosis,  
    GROUP_CONCAT(s.SymptomDescription SEPARATOR ', ') AS IdentifiedSymptoms,  -
    GROUP_CONCAT(m.MedicineName, ' (', m.Dosage, ')' SEPARATOR ', ') AS PrescribedMedications,  
    GROUP_CONCAT(lr.Recommendations SEPARATOR ', ') AS RecommendedLifestyles, 
    CONCAT(sr.FirstName, ' ', sr.MiddleName, ' ', sr.LastName, ' ', sr.Suffix) AS ConsultingPhysician  
FROM 
    Patients p
JOIN 
    Diagnoses d ON p.PatientID = d.PatientID
JOIN 
    VisitLogs vl ON d.VisitLogID = vl.VisitLogID
JOIN 
    Symptoms s ON s.DiagnosisID = d.DiagnosisID 
JOIN 
    Medications m ON m.TreatmentPlanID = d.TreatmentPlanID  
JOIN 
    LifestyleRecommendations lr ON lr.TreatmentPlanID = d.TreatmentPlanID  
JOIN 
    Staff st ON d.StaffID = st.StaffID  
JOIN 
    StaffRegistration sr ON st.StaffRegistrationID = sr.StaffRegistrationID  
WHERE 
    vl.Date = (SELECT MAX(Date) FROM VisitLogs WHERE PatientID = p.PatientID)  
GROUP BY 
    p.PatientID, d.ConfirmedDiagnosis, vl.Date, sr.FirstName, sr.MiddleName, sr.LastName, sr.Suffix;
