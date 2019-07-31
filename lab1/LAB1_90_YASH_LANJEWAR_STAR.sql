
CREATE TABLE RENTAL_ITEM (
                item_id VARCHAR2(5) NOT NULL,
                item_no VARCHAR2(5) NOT NULL,
                rating VARCHAR2(1) NOT NULL,
                new_release_flag VARCHAR2(5) NOT NULL,
                genre VARCHAR2(15) NOT NULL,
                classification VARCHAR2(10) NOT NULL,
                sub_classification VARCHAR2(10) NOT NULL,
                director VARCHAR2(15) NOT NULL,
                lead_male VARCHAR2(15) NOT NULL,
                lead_female VARCHAR2(15) NOT NULL,
                CONSTRAINT ITEM_ID PRIMARY KEY (item_id)
);


CREATE TABLE TIME_1 (
                time_id VARCHAR2(5) NOT NULL,
                date_1 VARCHAR2(10) NOT NULL,
                day_of_month VARCHAR2(2) NOT NULL,
                week_end_flag VARCHAR2(5) NOT NULL,
                month VARCHAR2(2) NOT NULL,
                quarter VARCHAR2(2) NOT NULL,
                year VARCHAR2(10) NOT NULL,
                CONSTRAINT TIME_ID PRIMARY KEY (time_id)
);


CREATE TABLE STORE (
                store_id VARCHAR2(5) NOT NULL,
                store_name VARCHAR2(10) NOT NULL,
                store_code VARCHAR2(5) NOT NULL,
                zip_code VARCHAR2(6) NOT NULL,
                Manager VARCHAR2(15) NOT NULL,
                CONSTRAINT STORE_ID PRIMARY KEY (store_id)
);


CREATE TABLE PROMOTION (
                promotion_id VARCHAR2(5) NOT NULL,
                promotion_code VARCHAR2(5) NOT NULL,
                promotion_type VARCHAR2(15) NOT NULL,
                discount_rate VARCHAR2(5) NOT NULL,
                CONSTRAINT PROMOTION_ID PRIMARY KEY (promotion_id)
);


CREATE TABLE CUSTOMER (
                customer_id VARCHAR2(5) NOT NULL,
                customer_name VARCHAR2(15) NOT NULL,
                customer_code VARCHAR2(5) NOT NULL,
                address VARCHAR2(20) NOT NULL,
                state VARCHAR2(15) NOT NULL,
                zip VARCHAR2(6) NOT NULL,
                rental_plan_type VARCHAR2(15) NOT NULL,
                CONSTRAINT CUSTOMER_ID PRIMARY KEY (customer_id)
);


CREATE TABLE RENTAL_FACTS (
                rental_id VARCHAR2(5) NOT NULL,
                customer_id VARCHAR2(5) NOT NULL,
                promotion_id VARCHAR2(5) NOT NULL,
                store_id VARCHAR2(5) NOT NULL,
                time_id VARCHAR2(5) NOT NULL,
                item_id VARCHAR2(5) NOT NULL,
                rental_fee VARCHAR2(5) NOT NULL,
                late_charge VARCHAR2(5) NOT NULL,
                CONSTRAINT RENTAL_PK PRIMARY KEY (rental_id, customer_id, promotion_id, store_id, time_id, item_id)
);


ALTER TABLE RENTAL_FACTS ADD CONSTRAINT RENTAL_ITEM_RENTAL_FACTS_FK
FOREIGN KEY (item_id)
REFERENCES RENTAL_ITEM (item_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT TIME_RENTAL_FACTS_FK
FOREIGN KEY (time_id)
REFERENCES TIME_1 (time_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT STORE_RENTAL_FACTS_FK
FOREIGN KEY (store_id)
REFERENCES STORE (store_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT PROMOTION_RENTAL_FACTS_FK
FOREIGN KEY (promotion_id)
REFERENCES PROMOTION (promotion_id)
NOT DEFERRABLE;

ALTER TABLE RENTAL_FACTS ADD CONSTRAINT CUSTOMER_RENTAL_FACTS_FK
FOREIGN KEY (customer_id)
REFERENCES CUSTOMER (customer_id)
NOT DEFERRABLE;
