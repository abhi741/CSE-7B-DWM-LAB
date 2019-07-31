
CREATE TABLE Location (
                Location_id VARCHAR2(10) NOT NULL,
                House_name_no VARCHAR2(10) NOT NULL,
                Street VARCHAR2(10) NOT NULL,
                City VARCHAR2(10) NOT NULL,
                State VARCHAR2(10) NOT NULL,
                Pin_code NUMBER(6) NOT NULL,
                Country VARCHAR2(10) NOT NULL,
                CONSTRAINT LOCATION_PK PRIMARY KEY (Location_id)
);


CREATE TABLE Patient (
                Patient_id VARCHAR2(10) NOT NULL,
                Location_id VARCHAR2(10) NOT NULL,
                Patient_name VARCHAR2(15) NOT NULL,
                Patient_gender CHAR(1) NOT NULL,
                Patient_age NUMBER NOT NULL,
                Patient_pno NUMBER(10) NOT NULL,
                Patient_disease VARCHAR2(10) NOT NULL,
                CONSTRAINT PATIENT_PK PRIMARY KEY (Patient_id)
);


CREATE TABLE Time (
                Time_id VARCHAR2(10) NOT NULL,
                Day NUMBER NOT NULL,
                Day_of_week VARCHAR2(10) NOT NULL,
                Week NUMBER NOT NULL,
                Month NUMBER NOT NULL,
                Quarter NUMBER NOT NULL,
                Year NUMBER NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (Time_id)
);


CREATE TABLE Doctor (
                Doctor_id VARCHAR2(10) NOT NULL,
                Doctor_name VARCHAR2(15) NOT NULL,
                Doctor_qualification VARCHAR2(20) NOT NULL,
                Doctor_gender CHAR(1) NOT NULL,
                Doctor_experience NUMBER NOT NULL,
                Specialization VARCHAR2(20) NOT NULL,
                CONSTRAINT DOCTOR_PK PRIMARY KEY (Doctor_id)
);


CREATE TABLE Hospital (
                Hospital_id VARCHAR2(10) NOT NULL,
                Time_id VARCHAR2(10) NOT NULL,
                Patient_id VARCHAR2(10) NOT NULL,
                Doctor_id VARCHAR2(10) NOT NULL,
                Count NUMBER(5) NOT NULL,
                Charge NUMBER(5,2) NOT NULL,
                CONSTRAINT HOSPITAL_PK PRIMARY KEY (Hospital_id)
);


ALTER TABLE Patient ADD CONSTRAINT LOCATION_PATIENT_FK
FOREIGN KEY (Location_id)
REFERENCES Location (Location_id)
NOT DEFERRABLE;

ALTER TABLE Hospital ADD CONSTRAINT PATIENT_HOSPITAL_FK
FOREIGN KEY (Patient_id)
REFERENCES Patient (Patient_id)
NOT DEFERRABLE;

ALTER TABLE Hospital ADD CONSTRAINT TIME_HOSPITAL_FK
FOREIGN KEY (Time_id)
REFERENCES Time (Time_id)
NOT DEFERRABLE;

ALTER TABLE Hospital ADD CONSTRAINT DOCTOR_HOSPITAL_FK
FOREIGN KEY (Doctor_id)
REFERENCES Doctor (Doctor_id)
NOT DEFERRABLE;
