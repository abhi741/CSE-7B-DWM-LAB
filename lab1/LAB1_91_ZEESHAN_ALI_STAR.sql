
CREATE TABLE RENTAL_ITEM (
                Item_id VARCHAR2(3) NOT NULL,
                Title VARCHAR2(10) NOT NULL,
                Item_No NUMBER(8) NOT NULL,
                Rating VARCHAR2(4) NOT NULL,
                New_Release_Flag VARCHAR2(7) NOT NULL,
                Genre VARCHAR2(8) NOT NULL,
                Classification VARCHAR2(10) NOT NULL,
                Sub_Classification VARCHAR2(10) NOT NULL,
                Director VARCHAR2(10) NOT NULL,
                Lead_Male VARCHAR2(10) NOT NULL,
                Lead_Female VARCHAR2(10) NOT NULL,
                CONSTRAINT RENTAL_ITEM_PK PRIMARY KEY (Item_id)
);


CREATE TABLE TIME1 (
                Time_id VARCHAR2(3) NOT NULL,
                Date1 VARCHAR2(8) NOT NULL,
                Day_Of_Month VARCHAR2(8) NOT NULL,
                Week_End_Flag VARCHAR2(8) NOT NULL,
                Month VARCHAR2(8) NOT NULL,
                Quarter VARCHAR2(8) NOT NULL,
                Year VARCHAR2(8) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (Time_id)
);


CREATE TABLE STORE (
                Store_id VARCHAR2(3) NOT NULL,
                Store_Name VARCHAR2(10) NOT NULL,
                Store_Code VARCHAR2(6) NOT NULL,
                ZIp_Code VARCHAR2(6) NOT NULL,
                Manager VARCHAR2(10) NOT NULL,
                CONSTRAINT STORE_PK PRIMARY KEY (Store_id)
);


CREATE TABLE PROMOTION (
                Promotion_id VARCHAR2(3) NOT NULL,
                Promotion_Code VARCHAR2(8) NOT NULL,
                Promotion_Type VARCHAR2(10) NOT NULL,
                Discount_Rate VARCHAR2(10) NOT NULL,
                CONSTRAINT PROMOTION_PK PRIMARY KEY (Promotion_id)
);


CREATE TABLE CUSTOMER (
                Customer_id VARCHAR2(3) NOT NULL,
                Customer_name VARCHAR2(10) NOT NULL,
                Customer_code VARCHAR2(10) NOT NULL,
                Address VARCHAR2(20) NOT NULL,
                State VARCHAR2(10) NOT NULL,
                Zip VARCHAR2(6) NOT NULL,
                Rental_Plan_Type VARCHAR2(10) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (Customer_id)
);


CREATE TABLE RENTAL_FACTS (
                Rental_id VARCHAR2(3) NOT NULL,
                Customer_id VARCHAR2(3) NOT NULL,
                Promotion_id VARCHAR2(3) NOT NULL,
                Store_id VARCHAR2(3) NOT NULL,
                time_id VARCHAR2(3) NOT NULL,
                Item_id VARCHAR2(3) NOT NULL,
                Rental_fee NUMBER(8) NOT NULL,
                Late_charge NUMBER(5) NOT NULL,
                CONSTRAINT RENTAL_FACTS_PK PRIMARY KEY (Rental_id, Customer_id, Promotion_id, Store_id, time_id, Item_id)
);


ALTER TABLE RENTAL_FACTS ADD CONSTRAINT RENTAL_ITEM_RENTAL_FACTS_FK
FOREIGN KEY (Item_id)
REFERENCES RENTAL_ITEM (Item_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT TIME1_RENTAL_FACTS_FK
FOREIGN KEY (time_id)
REFERENCES TIME1 (Time_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT STORE_RENTAL_FACTS_FK
FOREIGN KEY (Store_id)
REFERENCES STORE (Store_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT PROMOTION_RENTAL_FACTS_FK
FOREIGN KEY (Promotion_id)
REFERENCES PROMOTION (Promotion_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT CUSTOMER_RENTAL_FACTS_FK
FOREIGN KEY (Customer_id)
REFERENCES CUSTOMER (Customer_id)
NOT DEFERRABLE;
