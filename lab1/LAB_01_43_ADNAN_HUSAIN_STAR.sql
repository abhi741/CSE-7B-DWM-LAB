
CREATE TABLE buyer (
                buyer_id VARCHAR(5) NOT NULL,
                buyer_address VARCHAR(10) NOT NULL,
                buyer_name VARCHAR(10) NOT NULL,
                buyer_type VARCHAR(10) NOT NULL,
                buyer_zip NUMERIC(10) NOT NULL,
                buyer_state VARCHAR(10) NOT NULL,
                CONSTRAINT buyer_pk PRIMARY KEY (buyer_id)
);


CREATE TABLE location (
                location_id VARCHAR(5) NOT NULL,
                location_name VARCHAR(10) NOT NULL,
                location_continent VARCHAR(10) NOT NULL,
                location_hemisphere VARCHAR(10) NOT NULL,
                location_country VARCHAR(10) NOT NULL,
                CONSTRAINT location_pk PRIMARY KEY (location_id)
);


CREATE TABLE time (
                time_id VARCHAR(5) NOT NULL,
                time_date VARCHAR(2) NOT NULL,
                time_month VARCHAR(2) NOT NULL,
                time_qaurter VARCHAR(1) NOT NULL,
                time_year VARCHAR(4) NOT NULL,
                CONSTRAINT time_pk PRIMARY KEY (time_id)
);


CREATE TABLE consigner (
                consigner_id VARCHAR(5) NOT NULL,
                consigner_name VARCHAR(10) NOT NULL,
                consigner_state VARCHAR(10) NOT NULL,
                consigner_type VARCHAR(10) NOT NULL,
                consigner_address VARCHAR(10) NOT NULL,
                consigner_zip NUMERIC(6) NOT NULL,
                CONSTRAINT consigner_pk PRIMARY KEY (consigner_id)
);


CREATE TABLE item (
                item_id VARCHAR(5) NOT NULL,
                item_number NUMERIC(10) NOT NULL,
                item_dept VARCHAR(10) NOT NULL,
                sold_flag VARCHAR(3) NOT NULL,
                item_name VARCHAR(10) NOT NULL,
                CONSTRAINT item_pk PRIMARY KEY (item_id)
);


CREATE TABLE auc_sales (
                sales_id VARCHAR(5) NOT NULL,
                item_id VARCHAR(5) NOT NULL,
                sold_price NUMERIC(5) NOT NULL,
                consigner_id VARCHAR(5) NOT NULL,
                high_estimate NUMERIC(5) NOT NULL,
                low_estimate NUMERIC(5) NOT NULL,
                reserve_price NUMERIC(5) NOT NULL,
                buyer_id VARCHAR(5) NOT NULL,
                location_id VARCHAR(5) NOT NULL,
                time_id VARCHAR(5) NOT NULL,
                CONSTRAINT auc_sales_pk PRIMARY KEY (sales_id)
);


ALTER TABLE auc_sales ADD CONSTRAINT buyer_auc_sales_fk
FOREIGN KEY (buyer_id)
REFERENCES buyer (buyer_id)
NOT DEFERRABLE;

ALTER TABLE auc_sales ADD CONSTRAINT location_auc_sales_fk
FOREIGN KEY (location_id)
REFERENCES location (location_id)
NOT DEFERRABLE;

ALTER TABLE auc_sales ADD CONSTRAINT time_auc_sales_fk
FOREIGN KEY (time_id)
REFERENCES time (time_id)
NOT DEFERRABLE;

ALTER TABLE auc_sales ADD CONSTRAINT consigner_auc_sales_fk
FOREIGN KEY (consigner_id)
REFERENCES consigner (consigner_id)
NOT DEFERRABLE;

ALTER TABLE auc_sales ADD CONSTRAINT item_auc_sales_fk
FOREIGN KEY (item_id)
REFERENCES item (item_id)
NOT DEFERRABLE;

SQL> insert into item values('I0001',100,'FOOD','NO','ICECREAM');

1 row created.

SQL> insert into item values('I0002',101,'CLOTHES','NO','TROUSER');

1 row created.

SQL> insert into time values('T0001','10','11','4','2019');

1 row created.

SQL> insert into time values('T0002','28','2','1','2018');

1 row created.

SQL> insert into consigner values('C0001','FEDEX','GUJURAT','AIR','INDIA',440002);

1 row created.

SQL> insert into consigner values('C0002','DTDC','PUNJAB','RAIL','PAKISTAN',440003);

1 row created.
SQL> insert into BUYER values('B0001','ITWARI','ADNAN','RETAIL',440003,'MAHARASTRA');

1 row created.

SQL> insert into BUYER values('B0002','COLABA','HRITIK','WHOLESALE',440050,'KERELA');

1 row created.

SQL> insert into LOCATION values('L0001','SADAR','ASIA','SOUTH','INDIA');

1 row created.

SQL> insert into LOCATION values('L0002','SARAFA','EUROPE','NORTH','RUSSIA');

1 row created.

SQL> SELECT * FROM ITEM ;

ITEM_ ITEM_NUMBER ITEM_DEPT  SOL ITEM_NAME
----- ----------- ---------- --- ----------
I0001         100 FOOD       NO  ICECREAM
I0002         101 CLOTHES    NO  TROUSER

SQL> SELECT * FROM LOCATION;

LOCAT LOCATION_N LOCATION_C LOCATION_H LOCATION_C
----- ---------- ---------- ---------- ----------
L0001 SADAR      ASIA       SOUTH      INDIA
L0002 SARAFA     EUROPE     NORTH      RUSSIA

SQL> SELECT * FROM TIME;

TIME_ TI TI T TIME
----- -- -- - ----
T0001 10 11 4 2019
T0002 28 2  1 2018

SQL> SELECT * FROM CONSIGNER;

CONSI CONSIGNER_ CONSIGNER_ CONSIGNER_ CONSIGNER_ CONSIGNER_ZIP
----- ---------- ---------- ---------- ---------- -------------
C0001 FEDEX      GUJURAT    AIR        INDIA             440002
C0002 DTDC       PUNJAB     RAIL       PAKISTAN          440003

SQL> SELECT * FROM BUYER;

BUYER BUYER_ADDR BUYER_NAME BUYER_TYPE  BUYER_ZIP BUYER_STAT
----- ---------- ---------- ---------- ---------- ----------
B0001 ITWARI     ADNAN      RETAIL         440003 MAHARASTRA
B0002 COLABA     HRITIK     WHOLESALE      440050 KERELA
