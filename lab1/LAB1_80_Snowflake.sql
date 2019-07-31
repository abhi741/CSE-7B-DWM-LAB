
CREATE TABLE personal_det (
                personal_det_id VARCHAR2(3) NOT NULL,
                email_add VARCHAR2(10) NOT NULL,
                fax_no VARCHAR2(9) NOT NULL,
                CONSTRAINT PERSONAL_DET_PK PRIMARY KEY (personal_det_id)
);


CREATE TABLE store (
                store_id VARCHAR2(3) NOT NULL,
                store_name VARCHAR2(8) NOT NULL,
                store_code VARCHAR2(4) NOT NULL,
                zip_code VARCHAR2(6) NOT NULL,
                manager VARCHAR2(8) NOT NULL,
                CONSTRAINT STORE_PK PRIMARY KEY (store_id)
);


CREATE TABLE time1 (
                time_id VARCHAR2(3) NOT NULL,
                date1 VARCHAR2(10) NOT NULL,
                day_of_month VARCHAR2(8) NOT NULL,
                week_end_flag VARCHAR2(1) NOT NULL,
                month VARCHAR2(8) NOT NULL,
                quarter VARCHAR2(1) NOT NULL,
                year1 VARCHAR2(4) NOT NULL,
                CONSTRAINT TIME1_PK PRIMARY KEY (time_id)
);


CREATE TABLE rental_item (
                item_id VARCHAR2(3) NOT NULL,
                item_no VARCHAR2(3) NOT NULL,
                rating VARCHAR2(1) NOT NULL,
                new_release_flag VARCHAR2(1) NOT NULL,
                genre VARCHAR2(8) NOT NULL,
                classification VARCHAR2(10) NOT NULL,
                sub_classifiaction VARCHAR2(8) NOT NULL,
                director VARCHAR2(8) NOT NULL,
                lead_male VARCHAR2(8) NOT NULL,
                lead_female VARCHAR2(8) NOT NULL,
                CONSTRAINT RENTAL_ITEM_PK PRIMARY KEY (item_id)
);


CREATE TABLE promotion (
                promotionid VARCHAR2(3) NOT NULL,
                promotion_code VARCHAR2(4) NOT NULL,
                promotion_type VARCHAR2(8) NOT NULL,
                discount_rate VARCHAR2(2) NOT NULL,
                CONSTRAINT PROMOTION_PK PRIMARY KEY (promotionid)
);


CREATE TABLE customer (
                customer_id VARCHAR2(3) NOT NULL,
                personal_det_id VARCHAR2(3) NOT NULL,
                customer_name VARCHAR2(10) NOT NULL,
                customer_code VARCHAR2(4) NOT NULL,
                address VARCHAR2(12) NOT NULL,
                state VARCHAR2(10) NOT NULL,
                zip VARCHAR2(6) NOT NULL,
                rental_plan_type VARCHAR2(8) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (customer_id, personal_det_id)
);


CREATE TABLE rental (
                rental_id VARCHAR2(3) NOT NULL,
                item_id VARCHAR2(3) NOT NULL,
                customer_id VARCHAR2(3) NOT NULL,
                time_id VARCHAR2(3) NOT NULL,
                store_id VARCHAR2(3) NOT NULL,
                promotion_id VARCHAR2(3) NOT NULL,
                late_charge NUMBER(5) NOT NULL,
                rental_fee NUMBER(8) NOT NULL,
                CONSTRAINT RENTAL_PK PRIMARY KEY (rental_id, item_id, customer_id, time_id, store_id, promotion_id)
);


ALTER TABLE customer ADD CONSTRAINT PERSONAL_DET_CUSTOMER_FK
FOREIGN KEY (personal_det_id)
REFERENCES personal_det (personal_det_id)
NOT DEFERRABLE;

ALTER TABLE rental ADD CONSTRAINT STORE_RENTAL_FK
FOREIGN KEY (store_id)
REFERENCES store (store_id)
NOT DEFERRABLE;

ALTER TABLE rental ADD CONSTRAINT TIME1_RENTAL_FK
FOREIGN KEY (time_id)
REFERENCES time1 (time_id)
NOT DEFERRABLE;

ALTER TABLE rental ADD CONSTRAINT RENTAL_ITEM_RENTAL_FK
FOREIGN KEY (item_id)
REFERENCES rental_item (item_id)
NOT DEFERRABLE;

ALTER TABLE rental ADD CONSTRAINT PROMOTION_RENTAL_FK
FOREIGN KEY (promotion_id)
REFERENCES promotion (promotionid)
NOT DEFERRABLE;

ALTER TABLE rental ADD CONSTRAINT CUSTOMER_RENTAL_FK
FOREIGN KEY (customer_id)
REFERENCES customer (customer_id)
NOT DEFERRABLE;
