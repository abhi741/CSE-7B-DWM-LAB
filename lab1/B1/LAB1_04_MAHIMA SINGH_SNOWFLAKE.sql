
CREATE TABLE Detail (
                DetailId VARCHAR2(6) NOT NULL,
                Director VARCHAR2(10) NOT NULL,
                LeadMale VARCHAR2(10) NOT NULL,
                LeadFemale VARCHAR2(10) NOT NULL,
                CONSTRAINT DETAIL_PK PRIMARY KEY (DetailId)
);


CREATE TABLE Location (
                LocationId VARCHAR2(6) NOT NULL,
                Area VARCHAR2(10) NOT NULL,
                Street VARCHAR2(10) NOT NULL,
                City VARCHAR2(19) NOT NULL,
                State VARCHAR2(10) NOT NULL,
                Country VARCHAR2(10) NOT NULL,
                Region VARCHAR2(10) NOT NULL,
                CONSTRAINT LOCATION_PK PRIMARY KEY (LocationId)
);


CREATE TABLE Customer (
                CustomerKey VARCHAR2(6) NOT NULL,
                CustomerName VARCHAR2(10) NOT NULL,
                CustomerCode VARCHAR2(5) NOT NULL,
                Address VARCHAR2(10) NOT NULL,
                ZipCode NUMBER(6) NOT NULL,
                RentalPlanType VARCHAR2(10) NOT NULL,
                LocationId VARCHAR2(6) NOT NULL,
                CONSTRAINT CUSTOMER_PK PRIMARY KEY (CustomerKey)
);


CREATE TABLE Promotion (
                PromotionKey VARCHAR2(6) NOT NULL,
                PromotionCode VARCHAR2(6) NOT NULL,
                PromotionType VARCHAR2(10) NOT NULL,
                DiscountRate NUMBER(5) NOT NULL,
                CONSTRAINT PROMOTION_PK PRIMARY KEY (PromotionKey)
);


CREATE TABLE Store (
                StoreKey VARCHAR2(5) NOT NULL,
                StoreName VARCHAR2(10) NOT NULL,
                StoreCode VARCHAR2(5) NOT NULL,
                Zipcode NUMBER(6) NOT NULL,
                Manager VARCHAR2(10) NOT NULL,
                CONSTRAINT STORE_PK PRIMARY KEY (StoreKey)
);


CREATE TABLE Time (
                TimeKey VARCHAR2(5) NOT NULL,
                Date1 VARCHAR2(10) NOT NULL,
                DayOfMonth VARCHAR2(10) NOT NULL,
                WeekEndFlag NUMBER(5) NOT NULL,
                Month VARCHAR2(10) NOT NULL,
                Quarter VARCHAR2(5) NOT NULL,
                Year NUMBER(5) NOT NULL,
                CONSTRAINT TIME_PK PRIMARY KEY (TimeKey)
);


CREATE TABLE RentalItem (
                ItemKey VARCHAR2(10) NOT NULL,
                ItemNo NUMBER(4) NOT NULL,
                Rating NUMBER(5) NOT NULL,
                NewReleaseFlag NUMBER(5) NOT NULL,
                Genre VARCHAR2(10) NOT NULL,
                Classification VARCHAR2(10) NOT NULL,
                subClassification VARCHAR2(10) NOT NULL,
                DetailId VARCHAR2(6) NOT NULL,
                CONSTRAINT RIT_PK PRIMARY KEY (ItemKey)
);


CREATE TABLE RentalFacts (
                FactKey VARCHAR2(5) NOT NULL,
                CustomerKey VARCHAR2(6) NOT NULL,
                PromotionKey VARCHAR2(6) NOT NULL,
                RentalFee NUMBER(6) NOT NULL,
                LateCharge NUMBER(6) NOT NULL,
                StoreKey VARCHAR2(5) NOT NULL,
                TimeKey VARCHAR2(5) NOT NULL,
                ItemKey VARCHAR2(10) NOT NULL,
                CONSTRAINT RFT_PK PRIMARY KEY (FactKey)
);


ALTER TABLE RentalItem ADD CONSTRAINT DETAIL_RENTALITEM_FK
FOREIGN KEY (DetailId)
REFERENCES Detail (DetailId)
NOT DEFERRABLE;

ALTER TABLE Customer ADD CONSTRAINT LOCATION_CUSTOMER_FK
FOREIGN KEY (LocationId)
REFERENCES Location (LocationId)
NOT DEFERRABLE;

ALTER TABLE RentalFacts ADD CONSTRAINT CUSTOMER_RENTALFACTS_FK
FOREIGN KEY (CustomerKey)
REFERENCES Customer (CustomerKey)
NOT DEFERRABLE;

ALTER TABLE RentalFacts ADD CONSTRAINT PROMOTION_RENTALFACTS_FK
FOREIGN KEY (PromotionKey)
REFERENCES Promotion (PromotionKey)
NOT DEFERRABLE;

ALTER TABLE RentalFacts ADD CONSTRAINT STORE_RENTALFACTS_FK
FOREIGN KEY (StoreKey)
REFERENCES Store (StoreKey)
NOT DEFERRABLE;

ALTER TABLE RentalFacts ADD CONSTRAINT TIME_RENTALFACTS_FK
FOREIGN KEY (TimeKey)
REFERENCES Time (TimeKey)
NOT DEFERRABLE;

ALTER TABLE RentalFacts ADD CONSTRAINT RENTALITEM_RENTALFACTS_FK
FOREIGN KEY (ItemKey)
REFERENCES RentalItem (ItemKey)
NOT DEFERRABLE;
