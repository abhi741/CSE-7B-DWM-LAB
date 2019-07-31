
CREATE TABLE patient (
                patient_id VARCHAR2(10) NOT NULL,
                patient_name VARCHAR2(15) NOT NULL,
                patient_gender CHAR(1) NOT NULL,
                patient_age NUMBER NOT NULL,
                patient_phone NUMBER(10) NOT NULL,
                patient_address VARCHAR2(30) NOT NULL,
                patient_disease VARCHAR2(20) NOT NULL,
                CONSTRAINT PATIENT_PK PRIMARY KEY (patient_id)
);


CREATE TABLE doctor (
                doctor_id VARCHAR2(10) NOT NULL,
                doctor_name VARCHAR2(15) NOT NULL,
                doctor_qualification VARCHAR2(20) NOT NULL,
                doctor_gender CHAR(1) NOT NULL,
                doctor_experience NUMBER NOT NULL,
                specialization VARCHAR2(20) NOT NULL,
                CONSTRAINT DOCTOR_PK PRIMARY KEY (doctor_id)
);


CREATE TABLE time (
                time_id VARCHAR2(10) NOT NULL,
                day NUMBER NOT NULL,
                day_of_week VARCHAR2(10) NOT NULL,
                week NUMBER NOT NULL,
                month NUMBER NOT NULL,
                quarter NUMBER NOT NULL,
                year NUMBER NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (time_id)
);


CREATE TABLE hospital (
                hospital_id VARCHAR2(10) NOT NULL,
                patient_id VARCHAR2(10) NOT NULL,
                doctor_id VARCHAR2(10) NOT NULL,
                time_id VARCHAR2(10) NOT NULL,
                count NUMBER(5) NOT NULL,
                charge NUMBER(5,2) NOT NULL,
                CONSTRAINT HOSPITAL_PK PRIMARY KEY (hospital_id)
);


ALTER TABLE hospital ADD CONSTRAINT PATIENT_HOSPITAL_FK
FOREIGN KEY (patient_id)
REFERENCES patient (patient_id)
NOT DEFERRABLE;

ALTER TABLE hospital ADD CONSTRAINT DOCTOR_HOSPITAL_FK
FOREIGN KEY (doctor_id)
REFERENCES doctor (doctor_id)
NOT DEFERRABLE;

ALTER TABLE hospital ADD CONSTRAINT TIME_HOSPITAL_FK
FOREIGN KEY (time_id)
REFERENCES time (time_id)
NOT DEFERRABLE;
