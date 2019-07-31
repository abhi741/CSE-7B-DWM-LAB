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