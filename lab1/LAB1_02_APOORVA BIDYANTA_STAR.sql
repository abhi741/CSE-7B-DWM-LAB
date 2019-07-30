/*AIM:CREATING STAR SCHEMA*/
CREATE TABLE TIME (
                TIME_KEY VARCHAR2(10) NOT NULL,
                MONTH_NUMBER NUMBER NOT NULL,
                MONTH VARCHAR2(20) NOT NULL,
                QUARTER NUMBER NOT NULL,
                FISCAL_PERIOD NUMBER NOT NULL,
                YEAR NUMBER NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (TIME_KEY)
);


CREATE TABLE PLAN (
                PLAN_KEY VARCHAR2(10) NOT NULL,
                PLAN_NAME VARCHAR2(20) NOT NULL,
                PLAN_CODE NUMBER NOT NULL,
                NUM_OF_PHONES NUMBER NOT NULL,
                MONTHLY_MINUTES NUMBER NOT NULL,
                ROLLOVER_MINUTES NUMBER NOT NULL,
                CONSTRAINT PLAN_PK PRIMARY KEY (PLAN_KEY)
);


CREATE TABLE STATUS (
                STATUS_KEY VARCHAR2(10) NOT NULL,
                NEW_CUSTOMER VARCHAR2(20) NOT NULL,
                NEW_ADDRESS VARCHAR2(45) NOT NULL,
                PAYMENT_OVERDUE NUMBER NOT NULL,
                CLOSED_THIS_PERIOD NUMBER NOT NULL,
                CONSTRAINT STATUS_PK PRIMARY KEY (STATUS_KEY)
);


CREATE TABLE CUSTOMER (
                CUSTOMER_KEY VARCHAR2(10) NOT NULL,
                CUSTOMER_NAME VARCHAR2(20) NOT NULL,
                CUSTOMER_CODE NUMBER NOT NULL,
                FAMILY_SIZE NUMBER NOT NULL,
                ADDRESS VARCHAR2(45) NOT NULL,
                STATE VARCHAR2(20) NOT NULL,
                ZIP NUMBER NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (CUSTOMER_KEY)
);


CREATE TABLE USAGE_FACTS (
                PLAN_MINUTES NUMBER NOT NULL,
                MNTHLY_ACCESS_CHARGES NUMBER NOT NULL,
                OVERAGE_MINUTES NUMBER NOT NULL,
                MNTHLY_OVERAGE_CHARGES NUMBER NOT NULL,
                VOICE_USAGE NUMBER NOT NULL,
                DATA_USAGE VARCHAR2(10) NOT NULL,
                CUSTOMER_KEY VARCHAR2(10) NOT NULL,
                STATUS_KEY VARCHAR2(10) NOT NULL,
                TIME_KEY VARCHAR2(10) NOT NULL,
                PLAN_KEY VARCHAR2(10) NOT NULL
);


ALTER TABLE USAGE_FACTS ADD CONSTRAINT TIME_USAGE_FACTS_FK
FOREIGN KEY (TIME_KEY)
REFERENCES TIME (TIME_KEY)
NOT DEFERRABLE;

ALTER TABLE USAGE_FACTS ADD CONSTRAINT PLAN_USAGE_FACTS_FK
FOREIGN KEY (PLAN_KEY)
REFERENCES PLAN (PLAN_KEY)
NOT DEFERRABLE;

ALTER TABLE USAGE_FACTS ADD CONSTRAINT STATUS_USAGE_FACTS_FK
FOREIGN KEY (STATUS_KEY)
REFERENCES STATUS (STATUS_KEY)
NOT DEFERRABLE;

ALTER TABLE USAGE_FACTS ADD CONSTRAINT CUSTOMER_USAGE_FACTS_FK
FOREIGN KEY (CUSTOMER_KEY)
REFERENCES CUSTOMER (CUSTOMER_KEY)
NOT DEFERRABLE;

DESC CUSTOMER;
 Name                    Null?    Type
 ----------------------- -------- ----------------
 CUSTOMER_KEY            NOT NULL VARCHAR2(10)
 CUSTOMER_NAME           NOT NULL VARCHAR2(20)
 CUSTOMER_CODE           NOT NULL NUMBER
 FAMILY_SIZE             NOT NULL NUMBER
 ADDRESS                 NOT NULL VARCHAR2(45)
 STATE                   NOT NULL VARCHAR2(20)
 ZIP                     NOT NULL NUMBER

INSERT INTO CUSTOMER VALUES('C101','APOORVA',10,4,'BESA','MAHARASHTRA',37);
INSERT INTO CUSTOMER VALUES('C102','JANHAVI',11,3,'SOMALWADA','MAHARASHTRA',13);

SELECT* FROM CUSTOMER;

CUSTOMER_K CUSTOMER_NAME        CUSTOMER_CODE FAMILY_SIZE ADDRESS                                    STATE                          ZIP
---------- -------------------- ------------- ----------- --------------------------------------------- -------------------- ----------
C101       APOORVA                         10           4 BESA                                       MAHARASHTRA                     37
C102       JANHAVI                         11           3 SOMALWADA                                  MAHARASHTRA                     13

SQL> DESC STATUS;
 Name                    Null?    Type
 ----------------------- -------- ----------------
 STATUS_KEY              NOT NULL VARCHAR2(10)
 NEW_CUSTOMER            NOT NULL VARCHAR2(20)
 NEW_ADDRESS             NOT NULL VARCHAR2(45)
 PAYMENT_OVERDUE         NOT NULL NUMBER
 CLOSED_THIS_PERIOD      NOT NULL NUMBER
 
 INSERT INTO STATUS VALUES('S101','SHALINI','MANEWADA',1000,2020);
 INSERT INTO STATUS VALUES('S102','SHIKHA','DHARAMPETH',10,2019);
 
SQL> SELECT* FROM STATUS;

STATUS_KEY NEW_CUSTOMER         NEW_ADDRESS                                   PAYMENT_OVERDUE CLOSED_THIS_PERIOD
---------- -------------------- --------------------------------------------- --------------- ------------------
S101       SHALINI              MANEWADA                                                 1000            2020
S102       SHIKHA               DHARAMPETH                                                 10            2019

DESC PLAN;
 Name                          Null?    Type
 ----------------------------- -------- --------------------
 PLAN_KEY                      NOT NULL VARCHAR2(10)
 PLAN_NAME                     NOT NULL VARCHAR2(20)
 PLAN_CODE                     NOT NULL NUMBER
 NUM_OF_PHONES                 NOT NULL NUMBER
 MONTHLY_MINUTES               NOT NULL NUMBER
 ROLLOVER_MINUTES              NOT NULL NUMBER
 
 INSERT INTO PLAN VALUES('P101','DTH',21,1,500,20);
 INSERT INTO PLAN VALUES('P102','DATAPACK',22,1,600,30);
 
SQL> SELECT* FROM PLAN;

PLAN_KEY   PLAN_NAME             PLAN_CODE NUM_OF_PHONES MONTHLY_MINUTES ROLLOVER_MINUTES
---------- -------------------- ---------- ------------- --------------- ----------------
P101       DTH                          21             1             500               20
P102       DATAPACK                     22             1             600               30

DESC TIME;
 Name                          Null?    Type
 ----------------------------- -------- --------------------
 TIME_KEY                      NOT NULL VARCHAR2(10)
 MONTH_NUMBER                  NOT NULL NUMBER
 MONTH                         NOT NULL VARCHAR2(20)
 QUARTER                       NOT NULL NUMBER
 FISCAL_PERIOD                 NOT NULL NUMBER
 YEAR                          NOT NULL NUMBER
 
 INSERT INTO TIME VALUES('T101',3,'MARCH',1,3,2020);
 INSERT INTO TIME VALUES('T102',5,'MAY',2,4,2020);
 
SQL> SELECT* FROM TIME;

TIME_KEY   MONTH_NUMBER MONTH                   QUARTER FISCAL_PERIOD       YEAR
---------- ------------ -------------------- ---------- ------------- ----------
T101                  3 MARCH                         1             3       2020
T102                  5 MAY                           2             4       2020


SQL> DESC USAGE_FACTS;
 Name                          Null?    Type
 ----------------------------- -------- --------------------
 PLAN_MINUTES                  NOT NULL NUMBER
 MNTHLY_ACCESS_CHARGES         NOT NULL NUMBER
 OVERAGE_MINUTES               NOT NULL NUMBER
 MNTHLY_OVERAGE_CHARGES        NOT NULL NUMBER
 VOICE_USAGE                   NOT NULL NUMBER
 DATA_USAGE                    NOT NULL VARCHAR2(10)
 CUSTOMER_KEY                  NOT NULL VARCHAR2(10)
 STATUS_KEY                    NOT NULL VARCHAR2(10)
 TIME_KEY                      NOT NULL VARCHAR2(10)
 PLAN_KEY                      NOT NULL VARCHAR2(10)
 
 INSERT INTO USAGE_FACTS VALUES(200,900,300,705,5000,'5GB','C101','S101','T101','P101');
 INSERT INTO USAGE_FACTS VALUES(400,1000,600,703,50000,'7GB','C102','S102','T102','P102');
 
SQL> SELECT* FROM USAGE_FACTS;

PLAN_MINUTES MNTHLY_ACCESS_CHARGES OVERAGE_MINUTES MNTHLY_OVERAGE_CHARGES VOICE_USAGE DATA_USAGE CUSTOMER_K STATUS_KEY TIME_KEY   PLAN_KEY
------------ --------------------- --------------- ---------------------- ----------- ---------- ---------- ---------- ---------- ----------
         200                   900             300                    705        5000 5GB        C101       S101       T101       P101
         400                  1000             600                    703       50000 7GB        C102       S102       T102       P102
