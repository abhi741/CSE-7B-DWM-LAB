------STAR SCHEMA----
CREATE TABLE TIME_TABLE (
                TIME_ID VARCHAR2(3) NOT NULL,
                TIME_PERIOD NUMBER NOT NULL,
                TIME_DATE DATE NOT NULL,
                TIME_DAY_NO NUMBER NOT NULL,
                TIME_MONTH VARCHAR2(20) NOT NULL,
                TIME_YEAR NUMBER NOT NULL,
                CONSTRAINT TIME_ID_PK PRIMARY KEY (TIME_ID)
);


CREATE TABLE PROMOTION_TABLE (
                PROMOTION_ID NUMBER(4) NOT NULL,
                PROMOTION_TYPE VARCHAR2(10) NOT NULL,
                PROMOTION_MEDIUM VARCHAR2(20) NOT NULL,
                PROMOTION_DISCOUNT_RATE NUMBER(7,2) NOT NULL,
                PROMOTION_CODE VARCHAR2(10) NOT NULL,
                CONSTRAINT PROMOTION_ID_PK PRIMARY KEY (PROMOTION_ID)
);


CREATE TABLE STORE_TABLE (
                STORE_ID VARCHAR2(5) NOT NULL,
                STORE_ZIP VARCHAR2(10) NOT NULL,
                STORE_CODE VARCHAR2(5) NOT NULL,
                STORE_MANAGER VARCHAR2(20) NOT NULL,
                STORE_ADDR VARCHAR2(80) NOT NULL,
                STORE_STATE VARCHAR2(30) NOT NULL,
                STORE_NAME VARCHAR2(30) NOT NULL,
                CONSTRAINT STORE_ID_PK PRIMARY KEY (STORE_ID)
);


CREATE TABLE PRODUCT_TABLE (
                PRODUCT_ID NUMBER(5) NOT NULL,
                PROD_DEPT VARCHAR2(20) NOT NULL,
                PROD_LINE VARCHAR2(20) NOT NULL,
                PROD_BRAND VARCHAR2(20) NOT NULL,
                PROD_NAME VARCHAR2(30) NOT NULL,
                PROD_CODE VARCHAR2(5) NOT NULL,
                CONSTRAINT PRODUCT_ID_PK PRIMARY KEY (PRODUCT_ID)
);


CREATE TABLE SALES_FACT_TABLE (
                SALES_ID VARCHAR2(4) NOT NULL,
                PRODUCT_ID NUMBER(5) NOT NULL,
                TIME_ID VARCHAR2(3) NOT NULL,
                STORE_ID VARCHAR2(5) NOT NULL,
                PROMOTION_ID NUMBER(4) NOT NULL,
                SOLD_QTY NUMBER NOT NULL,
                GROSS_SALES NUMBER NOT NULL,
                NET_SALES NUMBER NOT NULL,
                COST NUMBER(20,2) NOT NULL,
                STORE_COUPON_AMT NUMBER NOT NULL,
                MFR_COUNPON_AMT NUMBER NOT NULL,
                CONSTRAINT SALES_ID_PK PRIMARY KEY (SALES_ID)
);


ALTER TABLE SALES_FACT_TABLE ADD CONSTRAINT TIME_TABLE_SALES_FACT_TABLE_FK
FOREIGN KEY (TIME_ID)
REFERENCES TIME_TABLE (TIME_ID)
NOT DEFERRABLE;

ALTER TABLE SALES_FACT_TABLE ADD CONSTRAINT PROMOTION_TABLE_SALES_FACT_985
FOREIGN KEY (PROMOTION_ID)
REFERENCES PROMOTION_TABLE (PROMOTION_ID)
NOT DEFERRABLE;
3
ALTER TABLE SALES_FACT_TABLE ADD CONSTRAINT STORE_TABLE_SALES_FACT_TABL631
FOREIGN KEY (STORE_ID)
REFERENCES STORE_TABLE (STORE_ID)
NOT DEFERRABLE;

ALTER TABLE SALES_FACT_TABLE ADD CONSTRAINT PRODUCT_TABLE_SALES_FACT_TA245
FOREIGN KEY (PRODUCT_ID)
REFERENCES PRODUCT_TABLE (PRODUCT_ID)
NOT DEFERRABLE;



INSERT INTO PRODUCT_TABLE VALUES(101,'Electronics','Television','SONY','BRAVIA_43inch','LED78');
INSERT INTO PRODUCT_TABLE VALUES(102,'Electronics','Washing Machine','SAMSUNG','AUTOLOAD','S11');
.....
INSERT INTO SALES_FACT_TABLE VALUES('S101',102,'T12','ST144',5555,80,150,200,15000.55,40,625);
.....


------SNOWFLAKE SCHEMA----
CREATE TABLE Item (
                product_code VARCHAR2(3) NOT NULL,
                product_name VARCHAR2(20) NOT NULL,
                product_line VARCHAR2(3) NOT NULL,
                brand VARCHAR2(10) NOT NULL,
                CONSTRAINT ITEM_PK PRIMARY KEY (product_code)
);


CREATE TABLE PROMOTION (
                promotion_key VARCHAR2(3) NOT NULL,
                discount_rate NUMBER(3) NOT NULL,
                promotion_code VARCHAR2(3) NOT NULL,
                promotion_type VARCHAR2(10) NOT NULL,
                promotion_medium VARCHAR2(10) NOT NULL,
                CONSTRAINT PROMOTION_PK PRIMARY KEY (promotion_key)
);


CREATE TABLE TIMEE (
                time_key VARCHAR2(3) NOT NULL,
                date1 VARCHAR2(10) NOT NULL,
                day_number NUMBER(3) NOT NULL,
                month_number NUMBER(2) NOT NULL,
                day_of_week VARCHAR2(10) NOT NULL,
                fiscal_period VARCHAR2(20) NOT NULL,
                month VARCHAR2(10) NOT NULL,
                quarter NUMBER(1) NOT NULL,
                year NUMBER(4) NOT NULL,
                week_number NUMBER(3) NOT NULL,
                CONSTRAINT TIMEE_PK PRIMARY KEY (time_key)
);


CREATE TABLE PRODUCT (
                product_key VARCHAR2(3) NOT NULL,
                product_code VARCHAR2(3) NOT NULL,
                department VARCHAR2(10) NOT NULL,
                CONSTRAINT PRODUCT_PK PRIMARY KEY (product_key, product_code)
);


CREATE TABLE STORE (
                store_key VARCHAR2(3) NOT NULL,
                address VARCHAR2(20) NOT NULL,
                state VARCHAR2(10) NOT NULL,
                manager_name VARCHAR2(20) NOT NULL,
                zip NUMBER(6) NOT NULL,
                store_name VARCHAR2(10) NOT NULL,
                store_code VARCHAR2(4) NOT NULL,
                CONSTRAINT STORE_PK PRIMARY KEY (store_key)
);


CREATE TABLE SALES_FACTS (
                sales_id VARCHAR2(3) NOT NULL,
                store_key VARCHAR2(3) NOT NULL,
                promotion_key VARCHAR2(3) NOT NULL,
                product_key VARCHAR2(3) NOT NULL,
                time_key VARCHAR2(3) NOT NULL,
                net_sales NUMBER(10) NOT NULL,
                sold_quantity NUMBER(5) NOT NULL,
                store_coupon_amt NUMBER(3) NOT NULL,
                cost NUMBER(5) NOT NULL,
                mfr_coupon_amt VARCHAR2(3) NOT NULL,
                gross_sales NUMBER(10) NOT NULL,
                CONSTRAINT SALES_FACTS_PK PRIMARY KEY (sales_id, store_key, promotion_key, product_key, time_key)
);


ALTER TABLE PRODUCT ADD CONSTRAINT ITEM_PRODUCT_FK
FOREIGN KEY (product_code)
REFERENCES Item (product_code)
NOT DEFERRABLE;

ALTER TABLE SALES_FACTS ADD CONSTRAINT PROMOTION_SALES_FACTS_FK
FOREIGN KEY (promotion_key)
REFERENCES PROMOTION (promotion_key)
NOT DEFERRABLE;

ALTER TABLE SALES_FACTS ADD CONSTRAINT TIMEE_SALES_FACTS_FK
FOREIGN KEY (time_key)
REFERENCES TIMEE (time_key)
NOT DEFERRABLE;

ALTER TABLE SALES_FACTS ADD CONSTRAINT PRODUCT_SALES_FACTS_FK
FOREIGN KEY (product_key)
REFERENCES PRODUCT (product_key)
NOT DEFERRABLE;

ALTER TABLE SALES_FACTS ADD CONSTRAINT STORE_SALES_FACTS_FK
FOREIGN KEY (store_key)
REFERENCES STORE (store_key)
NOT DEFERRABLE;