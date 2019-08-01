
CREATE TABLE Rental_item (
                item_key VARCHAR2(5) NOT NULL,
                item_no VARCHAR2(5) NOT NULL,
                classification VARCHAR2(5) NOT NULL,
                rating VARCHAR2(5) NOT NULL,
                new_release_flag VARCHAR2(5) NOT NULL,
                director VARCHAR2(5) NOT NULL,
                lead_male VARCHAR2(5) NOT NULL,
                lead_female VARCHAR2(5) NOT NULL,
                sub_classification VARCHAR2(5) NOT NULL,
                genre VARCHAR2(5) NOT NULL,
                CONSTRAINT ITEM_KEY PRIMARY KEY (item_key)
);


CREATE TABLE Time (
                time_key VARCHAR2(6) NOT NULL,
                date_1 DATE NOT NULL,
                day_of_month VARCHAR2(10) NOT NULL,
                week_end_flag VARCHAR2(10) NOT NULL,
                month VARCHAR2(5) NOT NULL,
                quarter VARCHAR2(4) NOT NULL,
                year VARCHAR2(4) NOT NULL,
                CONSTRAINT TIME_KEY PRIMARY KEY (time_key)
);


CREATE TABLE Store (
                store_key VARCHAR2(5) NOT NULL,
                store_name VARCHAR2(6) NOT NULL,
                store_code VARCHAR2(6) NOT NULL,
                zip_code NUMBER(6) NOT NULL,
                manager VARCHAR2(10) NOT NULL,
                CONSTRAINT STORE_KEY PRIMARY KEY (store_key)
);


CREATE TABLE Promotion (
                promotion_key VARCHAR2(5) NOT NULL,
                promotion_type VARCHAR2(6) NOT NULL,
                discount_rate NUMBER(6) NOT NULL,
                promotion_code VARCHAR2(5) NOT NULL,
                CONSTRAINT PROMOTION_KEY PRIMARY KEY (promotion_key)
);


CREATE TABLE Customer (
                customer_key VARCHAR2(5) NOT NULL,
                address VARCHAR2(5) NOT NULL,
                state VARCHAR2(5) NOT NULL,
                rental_plan_type VARCHAR2(5) NOT NULL,
                zip NUMBER(6) NOT NULL,
                customer_code VARCHAR2(5) NOT NULL,
                customer_name VARCHAR2(5) NOT NULL,
                CONSTRAINT CUSTOMER_KEY PRIMARY KEY (customer_key)
);


CREATE TABLE Rental_Facts (
                rental_id VARCHAR2(5) NOT NULL,
                time_key VARCHAR2(5) NOT NULL,
                store_key VARCHAR2(5) NOT NULL,
                promotion_key VARCHAR2(5) NOT NULL,
                customer_key VARCHAR2(5) NOT NULL,
                item_key VARCHAR2(5) NOT NULL,
                rental_fee NUMBER(4) NOT NULL,
                late_charge NUMBER(4) NOT NULL,
                Time_time_key VARCHAR2(6) NOT NULL,
                CONSTRAINT RENTAL_ID PRIMARY KEY (rental_id)
);


ALTER TABLE Rental_Facts ADD CONSTRAINT RENTAL_ITEM_RENTAL_FACTS_FK
FOREIGN KEY (item_key)
REFERENCES Rental_item (item_key)
NOT DEFERRABLE;

ALTER TABLE Rental_Facts ADD CONSTRAINT TIME_RENTAL_FACTS_FK
FOREIGN KEY (Time_time_key)
REFERENCES Time (time_key)
NOT DEFERRABLE;

ALTER TABLE Rental_Facts ADD CONSTRAINT STORE_RENTAL_FACTS_FK
FOREIGN KEY (store_key)
REFERENCES Store (store_key)
NOT DEFERRABLE;

ALTER TABLE Rental_Facts ADD CONSTRAINT PROMOTION_RENTAL_FACTS_FK
FOREIGN KEY (promotion_key)
REFERENCES Promotion (promotion_key)
NOT DEFERRABLE;

ALTER TABLE Rental_Facts ADD CONSTRAINT CUSTOMER_RENTAL_FACTS_FK
FOREIGN KEY (customer_key)
REFERENCES Customer (customer_key)
NOT DEFERRABLE;




INSERT INTO Customer values('cs101','wn','maha','month','440008','c0001','ansh');
INSERT INTO Customer values('cs102','pardi','maha','month','440008','c0002','raj');


INSERT INTO Promotion values('pr001','L','10','p0001');
INSERT INTO Promotion values('pr002','L','25','p0002');


INSERT INTO Store values('st001','s_one','s0001','440002','mg001');
INSERT INTO Store values('st002','s_two','s0002','440003','mg002');

INSERT INTO Time values('ti001',DATE '2001-01-01','2','yes','jan','2','2001');
INSERT INTO Time values('ti002',DATE '2001-01-02','3','yes','jan','3','2001');
