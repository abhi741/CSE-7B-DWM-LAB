CREATE TABLE Timee (
                Time_Key VARCHAR2(3) NOT NULL,
                Date1 VARCHAR2(8) NOT NULL,
                Day_Number NUMBER(2) NOT NULL,
                Day_Of_Week VARCHAR2(9) NOT NULL,
                Week_Number NUMBER(2) NOT NULL,
                Month VARCHAR2(12) NOT NULL,
                Month_Number NUMBER(2) NOT NULL,
                Fiscal_Period VARCHAR2(9) NOT NULL,
                Quarter VARCHAR2(8) NOT NULL,
                Year NUMBER(4) NOT NULL,
                CONSTRAINT TIMEE_PK PRIMARY KEY (Time_Key)
);


CREATE TABLE Promotion (
                Promotion_Key VARCHAR2(3) NOT NULL,
                Promotion_Medium VARCHAR2(10) NOT NULL,
                Discount_Rate VARCHAR2(3) NOT NULL,
                Production_Code VARCHAR2(3) NOT NULL,
                Promotion_Type VARCHAR2(4) NOT NULL,
                CONSTRAINT PROMOTION_PK PRIMARY KEY (Promotion_Key)
);


CREATE TABLE Store (
                Store_Key VARCHAR2(3) NOT NULL,
                Store_Name VARCHAR2(10) NOT NULL,
                Store_Code VARCHAR2(3) NOT NULL,
                Address VARCHAR2(6) NOT NULL,
                State VARCHAR2(4) NOT NULL,
                Zip VARCHAR2(6) NOT NULL,
                Manager_Name VARCHAR2(10) NOT NULL,
                CONSTRAINT STORE_PK PRIMARY KEY (Store_Key)
);


CREATE TABLE Product (
                Product_Key VARCHAR2(3) NOT NULL,
                Product_Name VARCHAR2(10) NOT NULL,
                Product_Code VARCHAR2(3) NOT NULL,
                Product_Line VARCHAR2(3) NOT NULL,
                Brand VARCHAR2(10) NOT NULL,
                Department VARCHAR2(10) NOT NULL,
                CONSTRAINT PRODUCT_PK PRIMARY KEY (Product_Key)
);


CREATE TABLE Sales_Fact (
                Product_Key VARCHAR2(3) NOT NULL,
                Store_Key VARCHAR2(3) NOT NULL,
                Time_Key VARCHAR2(3) NOT NULL,
                Promotion_Key VARCHAR2(3) NOT NULL,
                Sold_Quantity NUMBER(6) NOT NULL,
                Gross_Sales NUMBER(6) NOT NULL,
                Net_Sales NUMBER(6) NOT NULL,
                Cost NUMBER(6) NOT NULL,
                Store_Coupon_Amt NUMBER(4) NOT NULL,
                Mfr_Coupon_Amt NUMBER(4) NOT NULL,
                CONSTRAINT SALES_FACT_PK PRIMARY KEY (Product_Key, Store_Key, Time_Key, Promotion_Key)
);


ALTER TABLE Sales_Fact ADD CONSTRAINT TIME_SALES_FACT_FK
FOREIGN KEY (Time_Key)
REFERENCES Timee (Time_Key)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT PROMOTION_SALES_FACT_FK
FOREIGN KEY (Promotion_Key)
REFERENCES Promotion (Promotion_Key)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT STORE_SALES_FACT_FK
FOREIGN KEY (Store_Key)
REFERENCES Store (Store_Key)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT PRODUCT_SALES_FACT_FK
FOREIGN KEY (Product_Key)
REFERENCES Product (Product_Key)
NOT DEFERRABLE;

insert into Product values('p01','pen','pn1','100','Natraj','Writing');
insert into Product values('p02','shirt','sh1','500','Puma','Clothing');

insert into Store values('s01','S shoppie','ss1','Itwari','MAH','440022','Sushant');
insert into Store values('s02','K shoppie','ks1','Ajni','TEL','770023','Sarthak');

insert into Promotion values('pr1','paper','10','001','gen');
insert into Promotion values('pr2','tv','20','010','spl');

insert into Timee values('t01','20072019',20,'Saturday',29,'July',7,'2019-20','Quarter3',2019);
insert into Timee values('t02','26031998',26,'Thursday',12,'March',3,'1998-99','Quarter1',1998);

insert into Sales_Fact values('p01','s02','t02','pr1',10,7,3,1000,200,50);
insert into Sales_Fact values('p02','s02','t01','pr2',20,10,10,5000,250,60);

/*ambigious*/
insert into Sales_Fact values('p02','s02','t03','pr2',20,10,10,5000,250,60); 
