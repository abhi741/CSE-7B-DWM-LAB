
CREATE TABLE Promotion (
                prom_id VARCHAR2(4) NOT NULL,
                prom_type VARCHAR2(20) NOT NULL,
                prom_medium VARCHAR2(20) NOT NULL,
                disc_rate NUMBER(7,2) NOT NULL,
                p_code VARCHAR2(7) NOT NULL,
                CONSTRAINT PROMOTION_PK PRIMARY KEY (prom_id)
);


CREATE TABLE Time (
                time_id VARCHAR2(10) NOT NULL,
                date_1 VARCHAR2(10) NOT NULL,
                day_number NUMBER NOT NULL,
                month VARCHAR2(15) NOT NULL,
                year NUMBER NOT NULL,
                fiscal_period VARCHAR2(11) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (time_id)
);


CREATE TABLE Store (
                store_id VARCHAR2(4) NOT NULL,
                store_name VARCHAR2(20) NOT NULL,
                address VARCHAR2(20) NOT NULL,
                state VARCHAR2(20) NOT NULL,
                zip VARCHAR2(4) NOT NULL,
                manager_name VARCHAR2(20) NOT NULL,
                store_code VARCHAR2(5) NOT NULL,
                CONSTRAINT STORE_KEY_PK PRIMARY KEY (store_id)
);


CREATE TABLE Product (
                product_id VARCHAR2(4) NOT NULL,
                product_name VARCHAR2(10) NOT NULL,
                product_code VARCHAR2(4) NOT NULL,
                product_line VARCHAR2(2) NOT NULL,
                brand VARCHAR2(4),
                department VARCHAR2(4) NOT NULL,
                CONSTRAINT PRODUCT_KEY_PK PRIMARY KEY (product_id)
);


CREATE TABLE sales_ft (
                sales_id VARCHAR2(4) NOT NULL,
                product_id VARCHAR2(4) NOT NULL,
                time_id VARCHAR2(10) NOT NULL,
                prom_id VARCHAR2(4) NOT NULL,
                store_id VARCHAR2(4) NOT NULL,
                sold_qty NUMBER NOT NULL,
                gross_sales NUMBER NOT NULL,
                net_sales NUMBER NOT NULL,
                cost NUMBER NOT NULL,
                store_cpn_amt NUMBER NOT NULL,
                mfr_cpn_amt NUMBER NOT NULL,
                CONSTRAINT SALES_FT_PK PRIMARY KEY (sales_id)
);


ALTER TABLE sales_ft ADD CONSTRAINT PROMOTION_SALES_FACT_TABLE_FK
FOREIGN KEY (prom_id)
REFERENCES Promotion (prom_id)
NOT DEFERRABLE;

ALTER TABLE sales_ft ADD CONSTRAINT TIME_SALES_FACT_TABLE_FK
FOREIGN KEY (time_id)
REFERENCES Time (time_id)
NOT DEFERRABLE;

ALTER TABLE sales_ft ADD CONSTRAINT STORE_SALES_FACT_TABLE_FK
FOREIGN KEY (store_id)
REFERENCES Store (store_id)
NOT DEFERRABLE;

ALTER TABLE sales_ft ADD CONSTRAINT PRODUCT_SALES_FACT_TABLE_FK
FOREIGN KEY (product_id)
REFERENCES Product (product_id)
NOT DEFERRABLE;