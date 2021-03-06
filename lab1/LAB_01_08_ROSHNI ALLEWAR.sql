
CREATE TABLE CONSIGNOR1 (
                CONSIGNOR_ID VARCHAR2(5) NOT NULL,
                CONSIGNOR_NAME VARCHAR2(10) NOT NULL,
                CONSIGNOR_CODE NUMBER(10) NOT NULL,
                CONSIGNOR_TYPE VARCHAR2(10) NOT NULL,
                CONSIGNOR_ADDR VARCHAR2(20) NOT NULL,
                CONSIGNOR_STATE VARCHAR2(12) NOT NULL,
                CONSIGNOR_ZIP NUMBER(6) NOT NULL,
                CONSTRAINT CONSIGNOR_ID PRIMARY KEY (CONSIGNOR_ID)
);


CREATE TABLE BUYER1 (
                BUYER_ID VARCHAR2(5) NOT NULL,
                BUYER_NAME VARCHAR2(20) NOT NULL,
                BUYER_CODE VARCHAR2(6) NOT NULL,
                BUYER_TYPE VARCHAR2(10) NOT NULL,
                BUYER_ADDRESS VARCHAR2(20) NOT NULL,
                BUYER_STATE VARCHAR2(15) NOT NULL,
                BUYER_ZIP NUMBER(6) NOT NULL,
                CONSTRAINT BUYER_ID PRIMARY KEY (BUYER_ID)
);


CREATE TABLE LOCATION1 (
                LOCATION_ID VARCHAR2(5) NOT NULL,
                AUC_LOCATION VARCHAR2(20) NOT NULL,
                COUNTRY VARCHAR2(15) NOT NULL,
                CONTINENT VARCHAR2(15) NOT NULL,
                HEMISPHERE VARCHAR2(10) NOT NULL,
                CONSTRAINT LOCATION_ID PRIMARY KEY (LOCATION_ID)
);


CREATE TABLE TIME1 (
                TIME_ID VARCHAR2(5) NOT NULL,
                DATE_1 NUMBER(2) NOT NULL,
                MONTH NUMBER(2) NOT NULL,
                QUATER NUMBER(1) NOT NULL,
                YEAR NUMBER(4) NOT NULL,
                CONSTRAINT TIME_ID PRIMARY KEY (TIME_ID)
);


CREATE TABLE ITEM1 (
                ITEM_ID VARCHAR2(5) NOT NULL,
                ITEM_NAME VARCHAR2(5) NOT NULL,
                ITEM_NUMBER NUMBER(5) NOT NULL,
                DEPARTMENT VARCHAR2(12) NOT NULL,
                SOLD_FLAG NUMBER(5) NOT NULL,
                CONSTRAINT ITEM_ID PRIMARY KEY (ITEM_ID)
);


CREATE TABLE AUCTION_SALES1 (
                SALES_ID VARCHAR2(5) NOT NULL,
                ITEM_ITEM_ID VARCHAR2(5) NOT NULL,
                TIME_ID VARCHAR2(5) NOT NULL,
                LOCATION_ID VARCHAR2(5) NOT NULL,
                BUYER_ID VARCHAR2(5) NOT NULL,
                CONSIGNOR_ID VARCHAR2(5) NOT NULL,
                LOW_ESTIMATE NUMBER(5) NOT NULL,
                HIGH_ESTIMATE NUMBER(5) NOT NULL,
                RESERVE_PRICE NUMBER(5) NOT NULL,
                SOLD_PRICE NUMBER(5) NOT NULL,
                CONSTRAINT AUCTION_SALES_PK PRIMARY KEY (SALES_ID)
);


ALTER TABLE AUCTION_SALES1 ADD CONSTRAINT CONSIGNOR_AUCTION_SALES_FK
FOREIGN KEY (CONSIGNOR_ID)
REFERENCES CONSIGNOR1 (CONSIGNOR_ID)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES1 ADD CONSTRAINT BUYER_AUCTION_SALES_FK
FOREIGN KEY (BUYER_ID)
REFERENCES BUYER1 (BUYER_ID)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES1 ADD CONSTRAINT LOCATION_AUCTION_SALES_FK
FOREIGN KEY (LOCATION_ID)
REFERENCES LOCATION1 (LOCATION_ID)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES1 ADD CONSTRAINT TIME_AUCTION_SALES_FK
FOREIGN KEY (TIME_ID)
REFERENCES TIME1 (TIME_ID)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES1 ADD CONSTRAINT ITEM_SALES_FK
FOREIGN KEY (ITEM_ITEM_ID)
REFERENCES ITEM1 (ITEM_ID)
NOT DEFERRABLE;
