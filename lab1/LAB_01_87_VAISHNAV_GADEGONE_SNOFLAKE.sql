
CREATE TABLE Address (
                Address_ID VARCHAR2(5) NOT NULL,
                Street VARCHAR2(15) NOT NULL,
                City VARCHAR2(15) NOT NULL,
                State_ VARCHAR2(12) NOT NULL,
                Country VARCHAR2(15) NOT NULL,
                Zip NUMBER(6) NOT NULL,
                CONSTRAINT ADDRESS_PK PRIMARY KEY (Address_ID)
);


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
                Address_ID VARCHAR2(5) NOT NULL,
                Customer_Name VARCHAR2(20) NOT NULL,
                Customer_Code VARCHAR2(5) NOT NULL,
                Family_Size NUMBER(3) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_Key, Address_ID)
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


ALTER TABLE Customer ADD CONSTRAINT ADDRESS_CUSTOMER_FK
FOREIGN KEY (Address_ID)
REFERENCES Address (Address_ID)
NOT DEFERRABLE;

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
