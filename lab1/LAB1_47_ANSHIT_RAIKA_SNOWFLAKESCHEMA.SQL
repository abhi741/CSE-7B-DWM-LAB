CREATE TABLE RENTAL_ITEM (
	item_Key VARCHAR(10) NOT NULL,
	Genre VARCHAR(10) NOT NULL,
	Item_No VARCHAR(10) NOT NULL,
	Rental_Key VARCHAR(10) NOT NULL,
	Director VARCHAR(10) NOT NULL,
	Lead_Male VARCHAR(15) NOT NULL,
	Classification VARCHAR(10) NOT NULL,
	Lead_Female VARCHAR(15) NOT NULL,
	Rating VARCHAR(5) NOT NULL,
	New_Release_Flag VARCHAR(10) NOT NULL,
	CONSTRAINT iTEM_kEY PRIMARY KEY (item_Key)
);

CREATE TABLE PROMOTION (
	Promotion_Key VARCHAR(10) NOT NULL,
	Promotion_Code VARCHAR(10) NOT NULL,
	Discount_Rate NUMERIC NOT NULL,
	Promotion_Type VARCHAR(10) NOT NULL,
	CONSTRAINT Promotion_Key PRIMARY KEY (Promotion_Key)
);

CREATE TABLE STORE (
	Store_Key VARCHAR(10) NOT NULL,
	Store_Name VARCHAR(10) NOT NULL,
	Store_Code VARCHAR(5) NOT NULL,
	Manager VARCHAR(20) NOT NULL,
	Zip_Code VARCHAR(10) NOT NULL,
	CONSTRAINT Store_Key PRIMARY KEY (Store_Key)
);

CREATE TABLE Time (
	Time_Key VARCHAR(10) NOT NULL,
	Day_Of_Month VARCHAR(4) NOT NULL,
	Month VARCHAR(5) NOT NULL,	
	Quater VARCHAR(5) NOT NULL,
	Year VARCHAR(4) NOT NULL,
	Date_1 VARCHAR(12) NOT NULL,
	Week_End_Flag VARCHAR(2) NOT NULL,
	CONSTRAINT Time_Key PRIMARY KEY (Time_Key)
);

CREATE TABLE CUSTOMER (
	Customer_Key VARCHAR(10) NOT NULL,
	Address VARCHAR(10) NOT NULL,	
	Rental_Plan_Type VARCHAR(5) NOT NULL,
	Customer_Name VARCHAR(10) NOT NULL,
	State VARCHAR(10) NOT NULL,
	Zip NUMERIC NOT NULL,
	CONSTRAINT Customer_Key PRIMARY KEY (Customer_Key)
);

CREATE TABLE Rental_Facts (
	Rental_Key VARCHAR(10) NOT NULL,
	Rental_Fee NUMERIC(5),
	Customer_Key VARCHAR(10) NOT NULL,
	Item_Key VARCHAR(10) NOT NULL,
	Time_Key VARCHAR(10) NOT NULL,
	Store_Key VARCHAR(10) NOT NULL,
	Late_Charge NUMERIC(2),
	Promotion_Key VARCHAR(10) NOT NULL,
	CONSTRAINT Rental_Fee PRIMARY KEY (Rental_Key)
);

CREATE TABLE Rent_type (
	Rent_type_key VARCHAR(20) NOT NULL,
	Rental_Plan_Type VARCHAR(20) NOT NULL,
	CONSTRAINT Rent_type_key PRIMARY KEY (Rent_type_key)
);

CREATE TABLE category (
	category_key VARCHAR(20) NOT NULL,
	SubClassification VARCHAR(20) NOT NULL,
	genre VARCHAR(10) NOT NULL,
	Classification VARCHAR(20) NOT NULL,
	CONSTRAINT category_key PRIMARY KEY (category_key)
);

CREATE TABLE Actor (
	actor_key VARCHAR(20) NOT NULL,
	Lead_Male VARCHAR(20) NOT NULL,
	Lead_Female VARCHAR(20) NOT NULL,
	CONSTRAINT actor_key PRIMARY KEY (actor_key)
);

ALTER TABLE CUSTOMER ADD CONSTRAINT Rent_type_CUSTOMER_fk
FOREIGN KEY (Rent_type_key)
REFERENCES Rent_type (Rent_type_key);

ALTER TABLE RENTAL_ITEM ADD CONSTRAINT category_RENTAL_ITEM_fk
FOREIGN KEY (category_key)
REFERENCES category (category_key);

ALTER TABLE RENTAL_ITEM ADD CONSTRAINT Actor_RENTAL_ITEM_fk
FOREIGN KEY (actor_key)
REFERENCES Actor (actor_key);

ALTER TABLE Rental_Facts ADD CONSTRAINT RENTAL_ITEM_Rental_Facts_fk
FOREIGN KEY (Item_Key)
REFERENCES RENTAL_ITEM (item_Key);

ALTER TABLE Rental_Facts ADD CONSTRAINT PROMOTION_Rental_Facts_fk
FOREIGN KEY (Promotion_Key)
REFERENCES PROMOTION (Promotion_Key);

ALTER TABLE Rental_Facts ADD CONSTRAINT STORE_Rental_Facts_fk
FOREIGN KEY (Store_Key)
REFERENCES STORE (Store_Key);

ALTER TABLE Rental_Facts ADD CONSTRAINT Time_Rental_Facts_fk
FOREIGN KEY (Time_Key)
REFERENCES Time (Time_Key);

ALTER TABLE Rental_Facts ADD CONSTRAINT CUSTOMER_Rental_Facts_fk
FOREIGN KEY (Customer_Key)
REFERENCES CUSTOMER (Customer_Key);