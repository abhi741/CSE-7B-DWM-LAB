CREATE TABLE contact (
                contact_id VARCHAR2(6) NOT NULL,
                email VARCHAR2(20) NOT NULL,
                mob_no NUMERIC(10) NOT NULL,
                CONSTRAINT CONTACT_PK PRIMARY KEY (contact_id)
);


CREATE TABLE instructor (
                instructor_id VARCHAR2(6) NOT NULL,
                instructor_name VARCHAR2(20) NOT NULL,
                specialization VARCHAR2(15) NOT NULL,
                contact_id VARCHAR2(6) NOT NULL,
                CONSTRAINT INSTRUCTOR_PK PRIMARY KEY (instructor_id)
);


CREATE TABLE semester (
                semester_id VARCHAR2(6) NOT NULL,
                sem_number NUMBER(1) NOT NULL,
                sem_year NUMBER(4) NOT NULL,
                student_count NUMBER(3) NOT NULL,
                CONSTRAINT SEMESTER_PK PRIMARY KEY (semester_id)
);


CREATE TABLE student (
                student_id VARCHAR2(6) NOT NULL,
                student_name VARCHAR2(20) NOT NULL,
                student_rollno NUMBER(2) NOT NULL,
                student_branch VARCHAR2(4) NOT NULL,
                student_batchyear NUMBER(4) NOT NULL,
                CONSTRAINT STUDENT_PK PRIMARY KEY (student_id)
);


CREATE TABLE course (
                course_id VARCHAR2(6) NOT NULL,
                course_dept VARCHAR2(4) NOT NULL,
                course_name VARCHAR2(20) NOT NULL,
                course_type VARCHAR2(15) NOT NULL,
                sem_num NUMBER(1) NOT NULL,
                CONSTRAINT COURSE_PK PRIMARY KEY (course_id)
);


CREATE TABLE big_university (
                bu_id VARCHAR2(6) NOT NULL,
                course_id VARCHAR2(6) NOT NULL,
                semester_id VARCHAR2(6) NOT NULL,
                instructor_id VARCHAR2(6) NOT NULL,
                student_id VARCHAR2(6) NOT NULL,
                count NUMBER(3) NOT NULL,
                avg_grade NUMBER(3) NOT NULL,
                CONSTRAINT BU_PK PRIMARY KEY (bu_id)
);

ALTER TABLE instructor ADD CONSTRAINT CONTACT_ID_FK
FOREIGN KEY (contact_id)
REFERENCES contact (contact_id)
NOT DEFERRABLE;

ALTER TABLE big_university ADD CONSTRAINT INSTRUCTOR_BIG_UNIVERSITY_FK
FOREIGN KEY (instructor_id)
REFERENCES instructor (instructor_id)
NOT DEFERRABLE;

ALTER TABLE big_university ADD CONSTRAINT SEMESTER_BIG_UNIVERSITY_FK
FOREIGN KEY (semester_id)
REFERENCES semester (semester_id)
NOT DEFERRABLE;

ALTER TABLE big_university ADD CONSTRAINT STUDENT_BIG_UNIVERSITY_FK
FOREIGN KEY (student_id)
REFERENCES student (student_id)
NOT DEFERRABLE;

ALTER TABLE big_university ADD CONSTRAINT COURSE_BIG_UNIVERSITY_FK
FOREIGN KEY (course_id)
REFERENCES course (course_id)
NOT DEFERRABLE;