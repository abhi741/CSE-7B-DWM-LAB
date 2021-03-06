
CREATE TABLE STATUS (
                STATUS_KEY VARCHAR2(4) NOT NULL,
                NEW_CUSTOMER VARCHAR2(6) NOT NULL,
                NEW_ADDRESS VARCHAR2(100) NOT NULL,
                PAYMENT_OVERDUE NUMBER(5) NOT NULL,
                CLOSED_THIS_PERIOD NUMBER(4) NOT NULL,
                CONSTRAINT STATUS_PK PRIMARY KEY (STATUS_KEY)
);


CREATE TABLE CUSTOMER (
                CUSTOMER_KEY VARCHAR2(4) NOT NULL,
                CUSTOMER_NAME VARCHAR2(12) NOT NULL,
                CUSTOMER_CODE NUMBER(3) NOT NULL,
                FAMILY_SIZE NUMBER(2) NOT NULL,
                ADDRESS VARCHAR2(100) NOT NULL,
                STATE VARCHAR2(15) NOT NULL,
                ZIP NUMBER(6) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (CUSTOMER_KEY)
);


CREATE TABLE TIME (
                TIME_KEY VARCHAR2(4) NOT NULL,
                MTH_NO NUMBER(2) NOT NULL,
                MONTH NUMBER(2) NOT NULL,
                QUARTER NUMBER(1) NOT NULL,
                FISCAL_PERIOD NUMBER(4) NOT NULL,
                YEAR NUMBER(4) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (TIME_KEY)
);


CREATE TABLE PLAN (
                PLAN_KEY VARCHAR2(6) NOT NULL,
                PLAN_NAME VARCHAR2(12) NOT NULL,
                PLAN_CODE NUMBER(4) NOT NULL,
                NUM_OF_PHONES NUMBER(3) NOT NULL,
                MHTLY_MINUTES NUMBER(2) NOT NULL,
                ROLLOVER_MINUTES NUMBER(2) NOT NULL,
                CONSTRAINT PLAN_PK PRIMARY KEY (PLAN_KEY)
);


CREATE TABLE USAGE_FACTS (
                USAGE_KEY VARCHAR2(6) NOT NULL,
                PLAN_MINUTES NUMBER(2) NOT NULL,
                AVERAGE_MINUTES NUMBER(2) NOT NULL,
                MTHLY_ACCESS_CHARGES NUMBER(5) NOT NULL,
                MTHLY_AVG_CHARGES NUMBER(5) NOT NULL,
                VOICE_USAGE NUMBER(5) NOT NULL,
                DATA_USAGE NUMBER(5) NOT NULL,
                CUSTOMER_KEY VARCHAR2(4) NOT NULL,
                STATUS_KEY VARCHAR2(4) NOT NULL,
                PLAN_KEY VARCHAR2(6) NOT NULL,
                TIME_KEY VARCHAR2(4) NOT NULL,
                CONSTRAINT USAGE_FACTS_PK PRIMARY KEY (USAGE_KEY)
);


ALTER TABLE USAGE_FACTS ADD CONSTRAINT STATUS_USAGE_FACTS_FK
FOREIGN KEY (STATUS_KEY)
REFERENCES STATUS (STATUS_KEY)
NOT DEFERRABLE;

ALTER TABLE USAGE_FACTS ADD CONSTRAINT CUSTOMER_USAGE_FACTS_FK
FOREIGN KEY (CUSTOMER_KEY)
REFERENCES CUSTOMER (CUSTOMER_KEY)
NOT DEFERRABLE;

ALTER TABLE USAGE_FACTS ADD CONSTRAINT TIME_USAGE_FACTS_FK
FOREIGN KEY (TIME_KEY)
REFERENCES TIME (TIME_KEY)
NOT DEFERRABLE;

ALTER TABLE USAGE_FACTS ADD CONSTRAINT PLAN_USAGE_FACTS_FK
FOREIGN KEY (PLAN_KEY)
REFERENCES PLAN (PLAN_KEY)
NOT DEFERRABLE;
