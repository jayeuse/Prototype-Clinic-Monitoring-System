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
    Symptoms TEXT,
    TreatmentPlanID INT
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
