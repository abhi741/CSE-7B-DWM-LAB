
CREATE TABLE instructor (
                instructor_id VARCHAR2(6) NOT NULL,
                instructor_name VARCHAR2(20) NOT NULL,
                specialization VARCHAR2(15) NOT NULL,
                email VARCHAR2(20) NOT NULL,
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

-- insert queries

insert into semester values('S02', 2, 2, 30);
insert into semester values('S07', 7, 4, 30);

insert into student values('ST76', 'Sarthak', 76, 'CS', 2020);
insert into student values('ST77', 'Saurabh', 77, 'CS', 2020);

insert into course values('C101', 'CS', 'DBMS', 'regular', 6);
insert into course values('C102', 'IT', 'OS', 'elective', 5);

insert into instructor values('I01', 'Prof. A. Raipurkar', 'DWM', 'rai123@rknec.edu');
insert into instructor values('I02', 'Prof. D. Borikar', 'DB', 'borikar12@rknec.edu');

insert into big_university values('BU_01', 'C101', 'S02', 'I01', 'ST76', 60, 9);
insert into big_university values('BU_02', 'C102', 'S07', 'I02', 'ST77', 50, 8);

SQL> insert into big_university values('BU90','C234','S07','I02','ST77',55,8);
insert into big_university values('BU90','C234','S07','I02','ST77',55,8)
*
ERROR at line 1:
ORA-02291: integrity constraint (SARTHAK.COURSE_BIG_UNIVERSITY_FK) violated -
parent key not found
