CREATE TABLE buyer (
                buyer_id VARCHAR2(3) NOT NULL,
                buyer_name VARCHAR2(10) NOT NULL,
                buyer_code VARCHAR2(3) NOT NULL,
                buyer_type VARCHAR2(5) NOT NULL,
                buyer_address VARCHAR2(20) NOT NULL,
                buyer_state VARCHAR2(15) NOT NULL,
                buyer_zip NUMBER(6) NOT NULL,
                CONSTRAINT BUYER_PK PRIMARY KEY (buyer_id)
);


CREATE TABLE consignor (
                consignor_id VARCHAR2(3) NOT NULL,
                consignor_name VARCHAR2(10) NOT NULL,
                consignor_code VARCHAR2(3) NOT NULL,
                consignor_type VARCHAR2(5) NOT NULL,
                consignor_address VARCHAR2(20) NOT NULL,
                consignor_state VARCHAR2(10) NOT NULL,
                consignor_zip NUMBER(6) NOT NULL,
                CONSTRAINT CONSIGNOR_PK PRIMARY KEY (consignor_id)
);


CREATE TABLE location (
                location_id VARCHAR2(3) NOT NULL,
                auction_location VARCHAR2(15) NOT NULL,
                country VARCHAR2(10) NOT NULL,
                continent VARCHAR2(10) NOT NULL,
                hemisphere VARCHAR2(10) NOT NULL,
                CONSTRAINT LOCATION_PK PRIMARY KEY (location_id)
);


CREATE TABLE time1 (
                time1_id VARCHAR2(3) NOT NULL,
                day1 NUMBER(2) NOT NULL,
                month1 NUMBER(2) NOT NULL,
                quater NUMBER(2) NOT NULL,
                year1 NUMBER(2) NOT NULL,
                CONSTRAINT TIME1_PK PRIMARY KEY (time1_id)
);


CREATE TABLE item (
                item_id VARCHAR2(3) NOT NULL,
                item_name VARCHAR2(7) NOT NULL,
                item_number NUMBER(3) NOT NULL,
                department VARCHAR2(10) NOT NULL,
                sold_flag RAW(1) NOT NULL,
                CONSTRAINT ITEM_PK PRIMARY KEY (item_id)
);


CREATE TABLE sales (
                sales_id VARCHAR2(3) NOT NULL,
                item_id VARCHAR2(3) NOT NULL,
                time1_id VARCHAR2(3) NOT NULL,
                location_id VARCHAR2(3) NOT NULL,
                consignor_id VARCHAR2(3) NOT NULL,
                buyer_id VARCHAR2(3) NOT NULL,
                profit NUMBER(4) NOT NULL,
                low_estimate NUMBER(5) NOT NULL,
                high_estimate NUMBER(5) NOT NULL,
                reserve_price NUMBER(5) NOT NULL,
                sold_price NUMBER(5) NOT NULL,
                CONSTRAINT SALES_PK PRIMARY KEY (sales_id, item_id, time1_id, location_id, consignor_id, buyer_id)
);


ALTER TABLE sales ADD CONSTRAINT BUYER_SALES_FK
FOREIGN KEY (buyer_id)
REFERENCES buyer (buyer_id)
NOT DEFERRABLE;

ALTER TABLE sales ADD CONSTRAINT CONSIGNOR_SALES_FK
FOREIGN KEY (consignor_id)
REFERENCES consignor (consignor_id)
NOT DEFERRABLE;

ALTER TABLE sales ADD CONSTRAINT LOCATION_SALES_FK
FOREIGN KEY (location_id)
REFERENCES location (location_id)
NOT DEFERRABLE;

ALTER TABLE sales ADD CONSTRAINT TIME1_SALES_FK
FOREIGN KEY (time1_id)
REFERENCES time1 (time1_id)
NOT DEFERRABLE;

ALTER TABLE sales ADD CONSTRAINT ITEM_SALES_FK
FOREIGN KEY (item_id)
REFERENCES item (item_id)
NOT DEFERRABLE;