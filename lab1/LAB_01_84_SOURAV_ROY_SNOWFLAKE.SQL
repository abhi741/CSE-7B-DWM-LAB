
CREATE TABLE Manager (
                Manager1_Id VARCHAR2(4) NOT NULL,
                Name VARCHAR2(10) NOT NULL,
                Phone NUMBER(10) NOT NULL,
                Age VARCHAR2(2) NOT NULL,
                Gender VARCHAR2(6) NOT NULL,
                Address VARCHAR2(10) NOT NULL,
                CONSTRAINT MANAGER_PK PRIMARY KEY (Manager1_Id)
);


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
                Store_Id VARCHAR2(3) NOT NULL,
                Manager1_Id VARCHAR2(4) NOT NULL,
                Store_Name VARCHAR2(10) NOT NULL,
                Store_Code VARCHAR2(3) NOT NULL,
                Address VARCHAR2(6) NOT NULL,
                State VARCHAR2(4) NOT NULL,
                Zip VARCHAR2(6) NOT NULL,
                CONSTRAINT STORE_PK PRIMARY KEY (Store_Id)
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
                Store_Id VARCHAR2(3) NOT NULL,
                Time_Key VARCHAR2(3) NOT NULL,
                Promotion_Key VARCHAR2(3) NOT NULL,
                Sold_Quantity NUMBER(6) NOT NULL,
                Gross_Sales NUMBER(6) NOT NULL,
                Net_Sales NUMBER(6) NOT NULL,
                Cost NUMBER(6) NOT NULL,
                Store_Coupon_Amt NUMBER(4) NOT NULL,
                Mfr_Coupon_Amt NUMBER(4) NOT NULL,
                CONSTRAINT SALES_FACT_PK PRIMARY KEY (Product_Key, Store_Id, Time_Key, Promotion_Key)
);


ALTER TABLE Store ADD CONSTRAINT MANAGER_STORE_FK
FOREIGN KEY (Manager1_Id)
REFERENCES Manager (Manager1_Id)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT TIME_SALES_FACT_FK
FOREIGN KEY (Time_Key)
REFERENCES Timee (Time_Key)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT PROMOTION_SALES_FACT_FK
FOREIGN KEY (Promotion_Key)
REFERENCES Promotion (Promotion_Key)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT STORE_SALES_FACT_FK
FOREIGN KEY (Store_Id)
REFERENCES Store (Store_Id)
NOT DEFERRABLE;

ALTER TABLE Sales_Fact ADD CONSTRAINT PRODUCT_SALES_FACT_FK
FOREIGN KEY (Product_Key)
REFERENCES Product (Product_Key)
NOT DEFERRABLE;