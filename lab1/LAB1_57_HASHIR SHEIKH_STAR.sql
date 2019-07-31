CREATE TABLE BUYER (
                Buyer_Id VARCHAR(30) NOT NULL,
                Buyer_Name VARCHAR(30) NOT NULL,
                Buyer_Type VARCHAR(30) NOT NULL,
                Buyer_Addr VARCHAR(50) NOT NULL,
                Buyer_State VARCHAR(30) NOT NULL,
                Buyer_Zip VARCHAR(30) NOT NULL,
                CONSTRAINT Buyer_Key PRIMARY KEY (Buyer_Id)
);
insert into BUYER values('B0001','ADNAN','RETAIL','ITWARI','MAHARASTRA',440003);

insert into BUYER values('B0002','HRITIK','WHOLESALE','COLABA','KERELA',440050);

CREATE TABLE LOCATION (
                Location_Key VARCHAR(30) NOT NULL,
                Auction_Location VARCHAR(30) NOT NULL,
                Country VARCHAR(30) NOT NULL,
                Continent VARCHAR(30) NOT NULL,
                Hemisphere VARCHAR(30) NOT NULL,
                CONSTRAINT Location_Key PRIMARY KEY (Location_Key)
);


insert into LOCATION values('L0001','SADAR','INDIA','ASIA','SOUTH');

insert into LOCATION values('L0002','SARAFA','RUSSIA','EUROPE','NORTH');


CREATE TABLE TIME (
                Time_Key VARCHAR(30) NOT NULL,
                Date_dt NUMERIC(2) NOT NULL,
                Month NUMERIC(2) NOT NULL,
                Quarter NUMERIC(2) NOT NULL,
                Year NUMERIC(2) NOT NULL,
                CONSTRAINT Time_Key PRIMARY KEY (Time_Key)
);

insert into time values('T0001',10,11,4,19);

insert into time values('T0002',28,2,1,18);

CREATE TABLE CONSIGNOR (
                Consignor_Key VARCHAR(30) NOT NULL,
                Consignor_Name VARCHAR(30) NOT NULL,
                Consignor_Type VARCHAR(30) NOT NULL,
                Consignor_Addr VARCHAR(50) NOT NULL,
                Consignor_State VARCHAR(30) NOT NULL,
                Consignor_Zip VARCHAR(30) NOT NULL,
                CONSTRAINT Consignor_Key PRIMARY KEY (Consignor_Key)
);
insert into CONSIGNOR values('C0001','FEDEX','AIR','GUJURAT','INDIA','440002');

insert into CONSIGNOR values('C0002','DTDC','RAIL','PUNJAB','PAKISTAN','440003');

CREATE TABLE ITEM (
                Item_Key VARCHAR(30) NOT NULL,
                Item_Name VARCHAR(30) NOT NULL,
                Item_Number NUMERIC(5) NOT NULL,
                Department VARCHAR(30) NOT NULL,
                Sold_Flag VARCHAR(30) NOT NULL,
                CONSTRAINT Item_Key PRIMARY KEY (Item_Key)
);

insert into item values('I0001','ICECREAM',100,'FOOD','NO');

insert into item values('I0002','TROUSER',101,'CLOTHES','NO');

CREATE TABLE AUCTION_SALES (
                Location_key VARCHAR(30) NOT NULL,
                Consignor_Key VARCHAR(30) NOT NULL,
                Buyer_Id VARCHAR(30) NOT NULL,
                Time_Key VARCHAR(30) NOT NULL,
                Item_Key VARCHAR(30) NOT NULL,
                Low_Estimate NUMERIC(5) NOT NULL,
                High_Estimate NUMERIC(5) NOT NULL,
                Reverse_Price NUMERIC(5) NOT NULL,
                Sold_Price NUMERIC(5) NOT NULL,
                CONSTRAINT Sales_Id PRIMARY KEY (Location_key, Consignor_Key, Buyer_Id, Time_Key, Item_Key)
);


ALTER TABLE AUCTION_SALES ADD CONSTRAINT BUYER_AUCTION_SALES_fk
FOREIGN KEY (Buyer_Id)
REFERENCES BUYER (Buyer_Id)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT LOCATION_AUCTION_SALES_fk
FOREIGN KEY (Location_key)
REFERENCES LOCATION (Location_Key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT TIME_AUCTION_SALES_fk
FOREIGN KEY (Time_Key)
REFERENCES TIME (Time_Key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT CONSIGNOR_AUCTION_SALES_fk
FOREIGN KEY (Consignor_Key)
REFERENCES CONSIGNOR (Consignor_Key)
NOT DEFERRABLE;

ALTER TABLE AUCTION_SALES ADD CONSTRAINT ITEM_AUCTION_SALES_fk
FOREIGN KEY (Item_Key)
REFERENCES ITEM (Item_Key)
NOT DEFERRABLE;
