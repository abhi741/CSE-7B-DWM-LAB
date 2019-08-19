/* CREATION OF STAR SCHEMA */

CREATE TABLE consigner (
                consigner_key VARCHAR2(4) NOT NULL,
                consigner_name VARCHAR2(20) NOT NULL,
                consigner_code VARCHAR2(10) NOT NULL,
                consigner_type VARCHAR2(10) NOT NULL,
                consigner_addr VARCHAR2(20) NOT NULL,
                consigner_state VARCHAR2(20) NOT NULL,
                consigner_zip VARCHAR2(20) NOT NULL,
                CONSTRAINT CONNECTION_PK PRIMARY KEY (consigner_key)
);


CREATE TABLE buyer (
                buyer_key VARCHAR2(4) NOT NULL,
                buyer_name VARCHAR2(15) NOT NULL,
                buyer_code VARCHAR2(5) NOT NULL,
                buyer_type VARCHAR2(15) NOT NULL,
                buyer_addr VARCHAR2(20) NOT NULL,
                buyer_state VARCHAR2(20) NOT NULL,
                buyer_zip VARCHAR2(20) NOT NULL,
                CONSTRAINT BUYER_PK PRIMARY KEY (buyer_key)
);


CREATE TABLE location (
                location_key VARCHAR2(4) NOT NULL,
                auction_location VARCHAR2(15) NOT NULL,
                country VARCHAR2(15) NOT NULL,
                continent VARCHAR2(15) NOT NULL,
                hemisphere VARCHAR2(15) NOT NULL,
                CONSTRAINT LOCATION_PK PRIMARY KEY (location_key)
);


CREATE TABLE time (
                time_key VARCHAR2(4) NOT NULL,
                tdate NUMBER(2) NOT NULL,
                month NUMBER(2) NOT NULL,
                quarter NUMBER(1) NOT NULL,
                year NUMBER(4) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (time_key)
);


CREATE TABLE item (
                item_key VARCHAR2(4) NOT NULL,
                item_name VARCHAR2(15) NOT NULL,
                item_number VARCHAR2(5) NOT NULL,
                department VARCHAR2(4) NOT NULL,
                sold_flag VARCHAR2(1) NOT NULL,
                CONSTRAINT ITEM_PK PRIMARY KEY (item_key)
);


CREATE TABLE AUCTION_SALES (
                sales_id VARCHAR2(4) NOT NULL,
                item_key VARCHAR2(4) NOT NULL,
                time_key VARCHAR2(4) NOT NULL,
                consigner_key VARCHAR2(4) NOT NULL,
                buyer_key VARCHAR2(4) NOT NULL,
                location_key VARCHAR2(4) NOT NULL,
                low_estimate NUMBER(8) NOT NULL,
                high_estimate NUMBER(8) NOT NULL,
                Reserve_price NUMBER(8) NOT NULL,
                sold_price NUMBER(8) NOT NULL,
                CONSTRAINT AUCTION_SALES_PK PRIMARY KEY (sales_id)
);


ALTER TABLE AUCTION_SALES ADD CONSTRAINT CONSIGNER_AUCTION_SALES_FK
FOREIGN KEY (consigner_key)
REFERENCES consigner (consigner_key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT BUYER_AUCTION_SALES_FK
FOREIGN KEY (buyer_key)
REFERENCES buyer (buyer_key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT LOCATION_AUCTION_SALES_FK
FOREIGN KEY (location_key)
REFERENCES location (location_key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT TIME_AUCTION_SALES_FK
FOREIGN KEY (time_key)
REFERENCES time (time_key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT ITEM_AUCTION_SALES_FK
FOREIGN KEY (item_key)
REFERENCES item (item_key)
NOT DEFERRABLE;


INSERT INTO ITEM VALUES('I101','TV','101','ELEC',1);
1 row created.
INSERT INTO ITEM VALUES('I102','AC','102','ELEC',0);
1 row created.

INSERT INTO LOCATION VALUES('L101','CHICAGO','USA','NA','NORTHEN');
1 row created.
INSERT INTO LOCATION VALUES('L102','MUMBAI','INDIA','ASIA','NORTHEN');
1 row created.

INSERT INTO TIME VALUES('T101',21,10,4,2019);
1 row created.
INSERT INTO TIME VALUES('T102',04,03,1,2019);
1 row created.

INSERT INTO BUYER VALUES('B101','JC GADA','J101','CUSTOMER','MUMBAI','MAHARASHTRA','440002');
1 row created.
INSERT INTO BUYER VALUES('B102','FAIRDEAL','F102','FIRM','DELHI','DELHI','440001');
1 row created.

INSERT INTO CONSIGNER VALUES('C101','JC GADA','J101','CUSTOMER','MUMBAI','MAHARASHTRA','440002');
1 row created.
INSERT INTO CONSIGNER VALUES('C102','FAIRDEAL','F102','FIRM','DELHI','DELHI','440001');
1 row created.

INSERT INTO AUCTION_SALES VALUES('A101','I101','T101','C101','B101','L101',100000,500000,200000,100000);
1 row created.
INSERT INTO AUCTION_SALES VALUES('A102','I102','T102','C102','B102','L102',200000,500000,200000,100000);
1 row created.

INSERT INTO AUCTION_SALES VALUES('A102','I103','T102','C102','B102','L102',200000,500000,200000,100000);
ERROR HERE : PRIMARY KEY CONSTRAINT VIOLATION.