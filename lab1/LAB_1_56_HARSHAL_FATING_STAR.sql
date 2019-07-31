CREATE TABLE Buyer (
                Buyer_Key VARCHAR(20) NOT NULL,
                Buyer_Name VARCHAR(20) NOT NULL,
                Buyer_Type VARCHAR(10) NOT NULL,
                Buyer_Addr VARCHAR(20) NOT NULL,
                Buyer_State VARCHAR(10) NOT NULL,
                Buyer_Zip VARCHAR(6) NOT NULL,
                CONSTRAINT Buyer_Key PRIMARY KEY (Buyer_Key)
);


CREATE TABLE Location (
                Location_Key VARCHAR(20) NOT NULL,
                Auction_Location VARCHAR(20) NOT NULL,
                Country VARCHAR(10) NOT NULL,
                Continent VARCHAR(10) NOT NULL,
                Hemisphere VARCHAR(10) NOT NULL,
                CONSTRAINT Location_Key PRIMARY KEY (Location_Key)
);


CREATE TABLE Time (
                Time_Key VARCHAR(20) NOT NULL,
                Ldate NUMERIC(2) NOT NULL,
                Month NUMERIC(2) NOT NULL,
                Quarter NUMERIC(1) NOT NULL,
                Year NUMERIC(4) NOT NULL,
                CONSTRAINT Time_Key PRIMARY KEY (Time_Key)
);


CREATE TABLE Consignor (
                Consignor_Key VARCHAR(20) NOT NULL,
                Consignor_Name VARCHAR(20) NOT NULL,
                Consignor_Code VARCHAR(20) NOT NULL,
                Consignor_Addr VARCHAR(20) NOT NULL,
                Consignor_State VARCHAR(10) NOT NULL,
                Consignor_Zip VARCHAR(6) NOT NULL,
                CONSTRAINT Consignor_Key PRIMARY KEY (Consignor_Key)
);


CREATE TABLE Item (
                Item_ID VARCHAR(20) NOT NULL,
                Item_Name VARCHAR(20) NOT NULL,
                Item_Number NUMERIC(5) NOT NULL,
                Department VARCHAR(20) NOT NULL,
                Sold_Flag VARCHAR(1) NOT NULL,
                CONSTRAINT Item_Key PRIMARY KEY (Item_ID)
);


CREATE TABLE Auction_Sales (
                Consignor_Key VARCHAR(20) NOT NULL,
                Item_Key VARCHAR(20) NOT NULL,
                Item_Id VARCHAR(20) NOT NULL,
                Buyer_Key VARCHAR(20) NOT NULL,
                Buyer_Key_1 VARCHAR(20) NOT NULL,
                Low_Estimate NUMERIC(5) NOT NULL,
                High_Estimate NUMERIC(5) NOT NULL,
                Reserve_Price NUMERIC(5) NOT NULL,
                Sold_Price NUMERIC(5) NOT NULL,
                CONSTRAINT Auction_Sales_Id PRIMARY KEY (Consignor_Key, Item_Key, Item_Id, Buyer_Key, Buyer_Key_1)
);


ALTER TABLE Auction_Sales ADD CONSTRAINT Buyer_Auction_Sales_fk
FOREIGN KEY (Buyer_Key_1)
REFERENCES Buyer (Buyer_Key)
NOT DEFERRABLE;

ALTER TABLE Auction_Sales ADD CONSTRAINT Location_Auction_Sales_fk
FOREIGN KEY (Buyer_Key)
REFERENCES Location (Location_Key)
NOT DEFERRABLE;

ALTER TABLE Auction_Sales ADD CONSTRAINT Time_Auction_Sales_fk
FOREIGN KEY (Item_Id)
REFERENCES Time (Time_Key)
NOT DEFERRABLE;

ALTER TABLE Auction_Sales ADD CONSTRAINT Consignor_Auction_Sales_fk
FOREIGN KEY (Consignor_Key)
REFERENCES Consignor (Consignor_Key)
NOT DEFERRABLE;

ALTER TABLE Auction_Sales ADD CONSTRAINT Item_Auction_Sales_fk
FOREIGN KEY (Item_Key)
REFERENCES Item (Item_ID)
NOT DEFERRABLE;

Drop Table Auction_sales;
Drop table Buyer;
Drop table Time;
Drop table Consignor;
Drop Table Item;
Drop Table Location;

insert into item values('I0001','FOOD',100,'NO','ICECREAM');
insert into item values('I0002',101,'CLOTHES','NO','TROUSER');
insert into time values('T0001','10','11','4','2019');
insert into time values('T0002','28','2','1','2018');
insert into consigner values('C0001','FEDEX','GUJURAT','AIR','INDIA',440002);
insert into consigner values('C0002','DTDC','PUNJAB','RAIL','PAKISTAN',440003);
insert into BUYER values('B0001','ITWARI','ADNAN','RETAIL',440003,'MAHARASTRA');
insert into BUYER values('B0002','COLABA','HRITIK','WHOLESALE',440050,'KERELA');
insert into LOCATION values('L0001','SADAR','ASIA','SOUTH','INDIA');
insert into LOCATION values('L0002','SARAFA','EUROPE','NORTH','RUSSIA');


insert into item values('I101','Phone','101','Electronics','Y');
insert into item values('I102','Television','102','Electronics','N');
insert into Time values('T101',12,01,3,2019);
insert into Time values('T102',08,06,2,2018);
insert into Location values('L101','Nagpur','India','Asia','Southern');
insert into Location values('L102','Mumbai','India','Asia','Southern');
insert into Consignor values('C101','David','Air','Nagpur','MH','440013');
insert into Consignor values('C102','Robert','Ground','Mumbai','MH','400001');
insert into Buyer values('B101','Atharva','Retail','Nagpur','MH','440013');
insert into Buyer values('B102','Hashir','Retail','Nagpur','MH','440013');
insert into Auction_Sales values('C101','I101','T101','L101','B101',2000,10000,5000,9000);
insert into Auction_Sales values('C102','I102','T102','L102','B102',5000,20000,10000,18000);