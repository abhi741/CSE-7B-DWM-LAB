
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


INSERT INTO ITEM VALUES('ITM1','FBALL','101','KICK',1);
1 row created.
INSERT INTO ITEM VALUES('ITM2','BBALL','102','THROW',0);
1 row created.

INSERT INTO LOCATION VALUES('LOC1','CHICAGO','USA','N AMR','NORTHERN');
1 row created.
INSERT INTO LOCATION VALUES('LOC2','SYDNEY','AUS','OCENIA','SOUTHERN');
1 row created.

INSERT INTO TIME VALUES('TIM1',28,02,2,2019);
1 row created.
INSERT INTO TIME VALUES('TIM2',11,11,1,2019);
1 row created.

INSERT INTO BUYER VALUES('BUY1','JOSE MOU','JM11','DEFENCE','CINCINATTI','OHIO','258751');
1 row created.
INSERT INTO BUYER VALUES('BUY2','KOBE BRYANT','NBA2','DUNK','BARCELONA','CATALONIA','569821');
1 row created.

INSERT INTO CONSIGNER VALUES('CSG1','TIGER WOODS','TW101','BEST','MUMBAI','MAHARASHTRA','400002');
1 row created.
INSERT INTO CONSIGNER VALUES('CSG2','RAJNIKANT','RJ45','MINDIT','CHENNAI','TN','600001');
1 row created.

INSERT INTO AUCTION_SALES VALUES('AUC1','ITM1','TIM1','CSG1','BUY1','LOC1',250000,75500,200055,12255);
1 row created.
INSERT INTO AUCTION_SALES VALUES('AUC2','ITM2','TIM2','CSG2','BUY2','LOC2',3200,52200,2000,1500);
1 row created.

INSERT INTO AUCTION_SALES VALUES('AUC2','ITM3','TIM1','CSG1','BUY2','LOC2',33700,800000,201250,15000);
ERROR HERE : PRIMARY KEY CONSTRAINT VIOLATION.