
CREATE TABLE Promotion (
                promotion_key_pk VARCHAR2(4) NOT NULL,
                promotion_type VARCHAR2(3) NOT NULL,
                promotion_medium VARCHAR2(3) NOT NULL,
                discount_rate NUMBER(2) NOT NULL,
                promotion_code VARCHAR2(4) NOT NULL,
                CONSTRAINT PROMOTION_KEY_PK PRIMARY KEY (promotion_key_pk)
);


CREATE TABLE Store (
                store_key_pk VARCHAR2(2) NOT NULL,
                store_name VARCHAR2(4) NOT NULL,
                store_code VARCHAR2(4) NOT NULL,
                address VARCHAR2(4) NOT NULL,
                state VARCHAR2(2) NOT NULL,
                zip NUMBER(6) NOT NULL,
                manager_name VARCHAR2(5) NOT NULL,
                CONSTRAINT STORE_KEY_PK PRIMARY KEY (store_key_pk)
);


CREATE TABLE Product (
                product_key_pk VARCHAR2(3) NOT NULL,
                product_name VARCHAR2(4) NOT NULL,
                product_code VARCHAR2(4) NOT NULL,
                product_line VARCHAR2(3) NOT NULL,
                brand VARCHAR2(4) NOT NULL,
                department VARCHAR2(4) NOT NULL,
                CONSTRAINT PRODUCT_KEY_PK PRIMARY KEY (product_key_pk)
);


CREATE TABLE Time (
                time_key_pk NUMBER(2) NOT NULL,
                date1 VARCHAR2(2) NOT NULL,
                week_number NUMBER(2) NOT NULL,
                month VARCHAR2(3) NOT NULL,
                month_number NUMBER(2) NOT NULL,
                fiscal_period NUMBER(2) NOT NULL,
                quarter NUMBER(1) NOT NULL,
                year NUMBER(2) NOT NULL,
                day_number NUMBER(2) NOT NULL,
                day_of_week VARCHAR2(3) NOT NULL,
                CONSTRAINT TIME1_PK PRIMARY KEY (time_key_pk)
);


CREATE TABLE Sales (
                sales_key_pk VARCHAR2(4) NOT NULL,
                store_key_pk VARCHAR2(2) NOT NULL,
                promotion_key_pk VARCHAR2(4) NOT NULL,
                time_key_pk NUMBER(2) NOT NULL,
                product_key VARCHAR2(3) NOT NULL,
                sold_quantites NUMBER(3) NOT NULL,
                net_sales NUMBER(3) NOT NULL,
                gross_sales VARCHAR2(2) NOT NULL,
                cost NUMBER(4) NOT NULL,
                store_coupon_amt VARCHAR2(4) NOT NULL,
                mfr_coupon_amt NUMBER(4) NOT NULL,
                CONSTRAINT SALES_PK PRIMARY KEY (sales_key_pk, store_key_pk, promotion_key_pk, time_key_pk, product_key)
);


ALTER TABLE Sales ADD CONSTRAINT PROMOTION_SALES_FK
FOREIGN KEY (promotion_key_pk)
REFERENCES Promotion (promotion_key_pk)
NOT DEFERRABLE;

ALTER TABLE Sales ADD CONSTRAINT STORE_SALES_FK
FOREIGN KEY (store_key_pk)
REFERENCES Store (store_key_pk)
NOT DEFERRABLE;

ALTER TABLE Sales ADD CONSTRAINT PRODUCT_SALES_FK
FOREIGN KEY (product_key)
REFERENCES Product (product_key_pk)
NOT DEFERRABLE;

ALTER TABLE Sales ADD CONSTRAINT TIME_SALES_FK
FOREIGN KEY (time_key_pk)
REFERENCES Time (time_key_pk)
NOT DEFERRABLE;
