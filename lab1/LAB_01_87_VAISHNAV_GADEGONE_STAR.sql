
CREATE TABLE Status (
                Status_Key VARCHAR2(5) NOT NULL,
                New_Customer VARCHAR2(1) NOT NULL,
                New_Address VARCHAR2(20) NOT NULL,
                Payment_Overdue NUMBER(5) NOT NULL,
                Closed_This_Period VARCHAR2(5) NOT NULL,
                CONSTRAINT STATUS_PK PRIMARY KEY (Status_Key)
);


CREATE TABLE Time (
                Time_Key VARCHAR2(5) NOT NULL,
                Month_Number NUMBER(2) NOT NULL,
                Month VARCHAR2(3) NOT NULL,
                Quarter NUMBER(1) NOT NULL,
                Fiscal_Period NUMBER(4) NOT NULL,
                Year NUMBER(4) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (Time_Key)
);


CREATE TABLE Customer (
                Customer_Key VARCHAR2(5) NOT NULL,
                Customer_Name VARCHAR2(20) NOT NULL,
                Customer_Code VARCHAR2(5) NOT NULL,
                Family_Size NUMBER(3) NOT NULL,
                Address VARCHAR2(20) NOT NULL,
                State_ VARCHAR2(10) NOT NULL,
                Zip NUMBER(6) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_Key)
);


CREATE TABLE Plan (
                Plan_Key VARCHAR2(5) NOT NULL,
                Plan_Name VARCHAR2(10) NOT NULL,
                Plan_Code VARCHAR2(5) NOT NULL,
                Num_Of_Phones NUMBER(5) NOT NULL,
                Mnthly_Minutes NUMBER(5) NOT NULL,
                Rollover_Minutes NUMBER(5) NOT NULL,
                CONSTRAINT PLAN_PK PRIMARY KEY (Plan_Key)
);


CREATE TABLE Usage_Facts (
                Usage_Facts_ID VARCHAR2(5) NOT NULL,
                Customer_Key VARCHAR2(5) NOT NULL,
                Pla_Key VARCHAR2(5) NOT NULL,
                Time_Key VARCHAR2(5) NOT NULL,
                Status_Key VARCHAR2(5) NOT NULL,
                Plan_Minutes NUMBER(10) NOT NULL,
                Average_Minutes NUMBER(10) NOT NULL,
                Mnthly_Access_Charges NUMBER(10) NOT NULL,
                Mnthly_Avg_Charges NUMBER(10) NOT NULL,
                Voice_Usage NUMBER(10) NOT NULL,
                Data_Usage NUMBER(10) NOT NULL,
                CONSTRAINT USAGE_FACTS_PK PRIMARY KEY (Usage_Facts_ID, Customer_Key, Pla_Key, Time_Key, Status_Key)
);


ALTER TABLE Usage_Facts ADD CONSTRAINT STATUS_USAGE_FACTS_FK
FOREIGN KEY (Status_Key)
REFERENCES Status (Status_Key)
NOT DEFERRABLE;

ALTER TABLE Usage_Facts ADD CONSTRAINT TIME_USAGE_FACTS_FK
FOREIGN KEY (Time_Key)
REFERENCES Time (Time_Key)
NOT DEFERRABLE;

ALTER TABLE Usage_Facts ADD CONSTRAINT CUSTOMER_USAGE_FACTS_FK
FOREIGN KEY (Customer_Key)
REFERENCES Customer (Customer_Key)
NOT DEFERRABLE;

ALTER TABLE Usage_Facts ADD CONSTRAINT PLAN_USAGE_FACTS_FK
FOREIGN KEY (Pla_Key)
REFERENCES Plan (Plan_Key)
NOT DEFERRABLE;

INSERT INTO CUSTOMER VALUES('C101','VAISHNAV GADEGONE','V1901',4,'MANISH NAGAR,NAGPUR','MH',440015);
INSERT INTO CUSTOMER VALUES('C102','SWAROOP PRAJAPATI','V1902',4,'ITWARI,NAGPUR','MH',440018);

INSERT INTO PLAN VALUES('T101','PLAN1','P1',3,100,10);
INSERT INTO PLAN VALUES('T101','PLAN2','P2',3,50,5);