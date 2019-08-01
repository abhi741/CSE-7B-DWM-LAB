
/*
NAME:SHUBHAM REDDY
BATCH:B4 
ROLL NUMBER-83
*/

1)STAR SCHEMA-WIRELESS PHONE SERVICE

CREATE TABLE status (
                status_key VARCHAR2(5) NOT NULL,
                new_cust VARCHAR2(1) NOT NULL,
                new_addr VARCHAR2(1) NOT NULL,
                pay_overdue VARCHAR2(1) NOT NULL,
                closed_prod VARCHAR2(1) NOT NULL,
                CONSTRAINT STATUS_PK PRIMARY KEY (status_key)
);

insert into status values('S101','Y','N','Y','N');
insert into status values('S102','N','N','Y','Y');

CREATE TABLE time (
                time_key VARCHAR2(5) NOT NULL,
                month_number NUMBER(2) NOT NULL,
                qtr VARCHAR2(10) NOT NULL,
                time_fiscal VARCHAR2(10) NOT NULL,
                time_month VARCHAR2(10) NOT NULL,
                time_year VARCHAR2(10) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (time_key)
);

insert into time values('T101','3','second','third','jan','2017');
insert into time values('T102','4','second','two','feb','2018');


CREATE TABLE plan (
                plan_key VARCHAR2(5) NOT NULL,
                plan_name VARCHAR2(10) NOT NULL,
                plan_code VARCHAR2(10) NOT NULL,
                numofphones NUMBER(5) NOT NULL,
                mon_minutes NUMBER(5) NOT NULL,
                rollover_min NUMBER(5) NOT NULL,
                CONSTRAINT PLAN_PK PRIMARY KEY (plan_key)
);

insert into plan values('P101','PLAN1','P1',7,300,70);
insert into plan values('P102','PLAN2','P2',9,200,50);

CREATE TABLE customer (
                customer_key VARCHAR2(5) NOT NULL,
                cust_name VARCHAR2(10) NOT NULL,
                cust_code VARCHAR2(5) NOT NULL,
                family_size NUMBER(5) NOT NULL,
                cust_adress VARCHAR2(5) NOT NULL,
                cust_state VARCHAR2(10) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (customer_key)
);

insert into customer values('C101','MAHESH','C1',4,'NGP','MAH');
insert into customer values('C102','SURESH','C2',3,'MUM','MAH');

CREATE TABLE usage_facts (
                customer_key VARCHAR2(5) NOT NULL,
                plan_key VARCHAR2(5) NOT NULL,
                time_key VARCHAR2(5) NOT NULL,
                status_key VARCHAR2(5) NOT NULL,
                average_minutes NUMBER(5) NOT NULL,
                mon_access_charges NUMBER(5) NOT NULL,
                plan_minutes NUMBER(5) NOT NULL,
                voice_usage NUMBER(5) NOT NULL,
                data_usage NUMBER(10) NOT NULL,
                mon_avg_charges NUMBER(5) NOT NULL,
                CONSTRAINT USAGE_FACTS_PK PRIMARY KEY (customer_key, plan_key, time_key, status_key)
);
insert into usage_facts VALUES('C101','P101','T101','S101',300,2000,600,60,5,3000);

ALTER TABLE usage_facts ADD CONSTRAINT STATUS_USAGE_FACTS_FK
FOREIGN KEY (status_key)
REFERENCES status (status_key)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT TIME_USAGE_FACTS_FK
FOREIGN KEY (time_key)
REFERENCES time (time_key)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT PLAN_USAGE_FACTS_FK
FOREIGN KEY (plan_key)
REFERENCES plan (plan_key)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT CUSTOMER_USAGE_FACTS_FK
FOREIGN KEY (customer_key)
REFERENCES customer (customer_key)
NOT DEFERRABLE;

2)SNOWFLAKE SCHEMA-WIRELESS PHONE SERVICE

CREATE TABLE cust_adress (
                cust_adress VARCHAR2(10) NOT NULL,
                street VARCHAR2(10) NOT NULL,
                city VARCHAR2(6) NOT NULL,
                landmark VARCHAR2(10) NOT NULL,
                CONSTRAINT CUST_ADRESS_PK PRIMARY KEY (cust_adress)
);


CREATE TABLE status (
                status_key VARCHAR2(5) NOT NULL,
                new_cust VARCHAR2(1) NOT NULL,
                new_addr VARCHAR2(1) NOT NULL,
                pay_overdue VARCHAR2(1) NOT NULL,
                closed_prod VARCHAR2(1) NOT NULL,
                CONSTRAINT STATUS_PK PRIMARY KEY (status_key)
);


CREATE TABLE time (
                time_key VARCHAR2(5) NOT NULL,
                month_number NUMBER(2) NOT NULL,
                qtr VARCHAR2(10) NOT NULL,
                time_fiscal VARCHAR2(10) NOT NULL,
                time_month VARCHAR2(10) NOT NULL,
                time_year VARCHAR2(10) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (time_key)
);


CREATE TABLE plan (
                plan_key VARCHAR2(5) NOT NULL,
                plan_name VARCHAR2(10) NOT NULL,
                plan_code VARCHAR2(10) NOT NULL,
                numofphones NUMBER(5) NOT NULL,
                mon_minutes NUMBER(5) NOT NULL,
                rollover_min NUMBER(5) NOT NULL,
                CONSTRAINT PLAN_PK PRIMARY KEY (plan_key)
);


CREATE TABLE customer (
                customer_key VARCHAR2(5) NOT NULL,
                cust_adress_cust_adress VARCHAR2(10) NOT NULL,
                cust_name VARCHAR2(10) NOT NULL,
                cust_code VARCHAR2(5) NOT NULL,
                family_size NUMBER(5) NOT NULL,
                cust_adress VARCHAR2(5) NOT NULL,
                cust_state VARCHAR2(10) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (customer_key, cust_adress_cust_adress)
);


CREATE TABLE usage_facts (
                customer_key VARCHAR2(5) NOT NULL,
                plan_key VARCHAR2(5) NOT NULL,
                time_key VARCHAR2(5) NOT NULL,
                status_key VARCHAR2(5) NOT NULL,
                average_minutes NUMBER(5) NOT NULL,
                mon_access_charges NUMBER(5) NOT NULL,
                plan_minutes NUMBER(5) NOT NULL,
                voice_usage NUMBER(5) NOT NULL,
                data_usage NUMBER(10) NOT NULL,
                mon_avg_charges NUMBER(5) NOT NULL,
                CONSTRAINT USAGE_FACTS_PK PRIMARY KEY (customer_key, plan_key, time_key, status_key)
);


ALTER TABLE customer ADD CONSTRAINT CUST_ADRESS_CUSTOMER_FK
FOREIGN KEY (cust_adress_cust_adress)
REFERENCES cust_adress (cust_adress)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT STATUS_USAGE_FACTS_FK
FOREIGN KEY (status_key)
REFERENCES status (status_key)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT TIME_USAGE_FACTS_FK
FOREIGN KEY (time_key)
REFERENCES time (time_key)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT PLAN_USAGE_FACTS_FK
FOREIGN KEY (plan_key)
REFERENCES plan (plan_key)
NOT DEFERRABLE;

ALTER TABLE usage_facts ADD CONSTRAINT CUSTOMER_USAGE_FACTS_FK
FOREIGN KEY (customer_key)
REFERENCES customer (customer_key)
NOT DEFERRABLE;
