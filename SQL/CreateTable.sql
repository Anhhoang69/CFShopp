
---------------------Coffee shop chain management system-----------------------
CREATE TABLE Shop 
(
	shopID			CHAR(5)				PRIMARY KEY,
	shopAddress		NVARCHAR(50)		NOT NULL,
	monthlyCost 	VARCHAR(20)			NOT NULL,
	rating			DECIMAL(5,2),
);

Set dateformat dmy; 

CREATE TABLE Employee 
(
	empID			CHAR(8)				PRIMARY KEY,
	empStartDate	DATE				NOT NULL,	
	empName			NVARCHAR(25)		NOT NULL,
	empPhoneNumber	CHAR(10)			NOT NULL,
	empSsn			CHAR(12)			UNIQUE,
	bdate			DATE				NOT NULL,
	empAccount		NVARCHAR(70)		NOT NULL,
	empType			NVARCHAR(20)		NOT NULL,
	empSex			CHAR(1)				NOT NULL, 
	empAddress		NVARCHAR(50)		NOT NULL,
	hourSalary		INT					NOT NULL,
	empStatus	    VARCHAR(30)			NOT NULL	CHECK (empStatus IN ('Active', 'Inactive', 'On Leave', 'Suspended')),
	supervisorID	CHAR(8),	
	empshopID		CHAR(5)				NOT NULL, 
	CONSTRAINT		fk_emp_supervisor	FOREIGN KEY (supervisorID)
					REFERENCES Employee(empID),
	CONSTRAINT		fk_emp_shop			FOREIGN KEY (empshopID)
					REFERENCES Shop(shopID),
);
CREATE TABLE EmailEmployee
(
	empEmailEmpID	CHAR(8)				NOT NULL,
	emailEmp		VARCHAR(30)			NOT NULL,
	PRIMARY KEY (empEmailEmpID, emailEmp),
	CONSTRAINT		fk_email_emp		FOREIGN KEY (empEmailEmpID)
					REFERENCES Employee(empID),
);

CREATE TABLE DeliveryMan
(	
	delID			CHAR(8)				PRIMARY KEY,
	delLicense		CHAR(12)			NOT NULL,
	CONSTRAINT		fk_del_emp			FOREIGN KEY (delID)
					REFERENCES Employee(empID),
);

CREATE TABLE Vehicle
(
	empVehicleDelID	CHAR(8)				NOT NULL,
	vehicleType		NVARCHAR(20)		NOT NULL,
	vehicleNumber	VARCHAR(15)			NOT NULL,
	PRIMARY KEY (empVehicleDelID, vehicleType, vehicleNumber),
	CONSTRAINT		fk_veh_emp			FOREIGN KEY (empVehicleDelID)
					REFERENCES Employee(empID),
);

CREATE TABLE ServiceStaff
(
	serID			CHAR(8)				PRIMARY KEY, 
	serPosition		NVARCHAR(20)			NOT NULL,
	CONSTRAINT		fk_ser_emp			FOREIGN KEY	(serID)
					REFERENCES Employee(empID),
);

CREATE TABLE Cashier 
(
	casID			CHAR(8)				PRIMARY KEY,
	CONSTRAINT		fk_cas_emp			FOREIGN KEY (casID)
					REFERENCES Employee(empID),
);

CREATE TABLE WorkingShift 
(
	empWorkID		CHAR(8)					NOT NULL,
	shiftTimeStart	DATETIME				NOT NULL,
	shiftTimeEnd	DATETIME				NOT NULL,
	PRIMARY KEY (empWorkID, shiftTimeStart, shiftTimeEnd),
	CONSTRAINT chk_working_shift_time CHECK (shiftTimeEnd > shiftTimeStart),
	CONSTRAINT		fk_workingShift_emp	FOREIGN KEY (empWorkID)
					REFERENCES Employee(empID)
);

CREATE TABLE Discount
(
    disShopID       CHAR(5)            NOT NULL,
    disID           CHAR(10)           NOT NULL,
    disType         NVARCHAR(20)       NOT NULL,
    disDescription  NVARCHAR(50),
    disMinimumValue INT,
    disExpireDate   DATE               NOT NULL,
    disStartDate    DATE               NOT NULL,
    disCondition    NVARCHAR(20)        NOT NULL,
    disOrderID      CHAR(10)		   NULL,
    PRIMARY KEY (disShopID, disID),
    CONSTRAINT chk_DiscountDates CHECK (disStartDate < disExpireDate), -- Start date must be smaller than expire date
    CONSTRAINT chk_MinimumSpending CHECK (disMinimumValue IS NULL OR disMinimumValue > 0),
    CONSTRAINT fk_dis_shop FOREIGN KEY (disShopID)
        REFERENCES Shop(shopID),
   
);

CREATE TABLE FixedDiscountVoucher
(
    fixedDisShopID    CHAR(5)			NOT NULL,           
    fixedDisID        CHAR(10)			NOT NULL,          
    fixedDisAmount    INT				NOT NULL,
    PRIMARY KEY (fixedDisShopID, fixedDisID),
    CONSTRAINT fk_fixed_dis FOREIGN KEY (fixedDisShopID, fixedDisID)
        REFERENCES Discount(disShopID, disID)
);

CREATE TABLE PercentageDiscountVoucher
(
	perDisID		CHAR(10)			NOT NULL,
	perDisShopID	CHAR(5)				NOT NULL,
	perDisAmount	INT					NOT NULL CHECK (perDisAmount <=50),
	perMaximumValue	INT					NOT NULL,
	PRIMARY KEY (perDisShopID, perDisID),
	CONSTRAINT		fk_percentage_dis	FOREIGN KEY (perDisShopID, perDisID)
					REFERENCES Discount(disShopID, disID)
);

CREATE TABLE Customer 
(
	cusID			CHAR(10)			PRIMARY KEY,
	cusName			NVARCHAR(25)		NOT NULL,
	cusType			VARCHAR(20)			NOT NULL		CHECK (cusType IN ('Normal', 'VIP')),
	cusSex			CHAR(1)				NOT NULL,
	cusAddress		NVARCHAR(50)		NOT NULL,
	cusPhoneNumber	CHAR(12)			NOT NULL,
	cusSsn			CHAR(12)			NOT NULL,
	cusAccount		NVARCHAR(70)		NOT NULL,
);

CREATE TABLE Member
(
	memID			CHAR(10)			PRIMARY KEY,
	memVIPType		VARCHAR(20)			NOT NULL		CHECK (memVIPType IN ('Normal', 'Bronze', 'Silver', 'Gold', 'Diamond')),
	memBenefits		INT					NOT NULL		CHECK (memBenefits IN (0,5,10,15,20)),
	CONSTRAINT		fk_mem_cus			FOREIGN KEY (memID)
					REFERENCES Customer(cusID),
);

CREATE TABLE EmailCustomer
(
	cusEmailID		CHAR(10)			NOT NULL,
	emailCus		VARCHAR(30)			NOT NULL,
	PRIMARY KEY (cusEmailID, emailCus),
	CONSTRAINT		fk_email_cus		FOREIGN KEY (cusEmailID)
					REFERENCES Customer(cusID),
);

CREATE TABLE Feedback 
(
	feedID			CHAR(20)			NOT NULL,
	feedShopID		CHAR(5)				NOT NULL,
	feedCusID		CHAR(10)			NOT NULL,
	feedTime		DATETIME			NOT NULL,
	feedCondition	NVARCHAR(30)		NOT NULL,
	feedAssessment	INT					NOT NULL		CHECK (feedAssessment between 1 and 5),
	feedDescription	NVARCHAR(50),
	feedEmpID		CHAR(8)				NOT NULL,
	feedAnswer		NVARCHAR(50),
	PRIMARY KEY (feedID, feedShopID, feedCusID),
	CONSTRAINT		fk_feed_shop		FOREIGN KEY(feedShopID)
					REFERENCES Shop(shopID),
	CONSTRAINT		fk_feed_cus			FOREIGN KEY(feedCusID)
					REFERENCES Customer(cusID),
	CONSTRAINT		fk_feed_emp			FOREIGN KEY(feedEmpID)
					REFERENCES Employee(empID),
);

CREATE TABLE Orders
(
	ordID			CHAR(10)			PRIMARY KEY,
	ordStatus		VARCHAR(30)			NOT NULL		CHECK (ordStatus IN ('Pending', 'Confirmed', 'Completed', 'Canceled')),
	ordTotalPrice	INT, 
    ordTotalPayment INT,
	ordName			NVARCHAR(25)		NULL,
	ordPhoneNumber	CHAR(10)			NULL,
	ordEstTime		DATETIME			NULL,
	ordAddress		NVARCHAR(50)		NULL,
	ordDeliStatus	VARCHAR(30)			NULL		CHECK (ordDeliStatus IN ('Not Started', 'In Progress', 'Completed', 'Failed')),
	ordEmpID		CHAR(8)				NULL,
	CONSTRAINT		fk_ord_del			FOREIGN KEY (ordEmpID)
					REFERENCES DeliveryMan(delID)
);


CREATE TABLE Product
(
	proID			CHAR(10)			NOT NULL,
	proName			NVARCHAR(25)		NOT NULL,
	proType			NVARCHAR(20)		NOT NULL,
	proCost			INT					NOT NULL	CHECK (proCost>0),
	proPrice		INT					NOT NULL	CHECK (proPrice>0),
	proCondition	NVARCHAR(30)		NOT NULL,
	PRIMARY KEY (proID),
);


CREATE TABLE OrderCreation
(
	creOrdID		CHAR(10)			NOT NULL,
	creProID		CHAR(10)			NOT NULL,
	creAmount		INT					NOT NULL,
	crePrice		INT					NOT NULL,
	PRIMARY KEY (creOrdID, creProID),
	CONSTRAINT		fk_cre_ord			FOREIGN KEY (creOrdID)
					REFERENCES Orders(ordID),
	CONSTRAINT		fk_cre_pro			FOREIGN KEY (creProID)
					REFERENCES Product(proID)
);

CREATE TABLE ImageProduct
(
	imgProID		CHAR(10)			NOT NULL,
	imgPro			CHAR(20)			NOT NULL,
	PRIMARY KEY (imgProID, imgPro),
	CONSTRAINT		fk_img_pro			FOREIGN KEY (imgProID)
					REFERENCES Product(proID),
);

CREATE TABLE Bill
(
	billID			CHAR(15)			NOT NULL,
	billEmpID		CHAR(8)				NOT NULL,
	billOrdID		CHAR(10)			NOT NULL,
	billTime		DATETIME			NOT NULL,
	PRIMARY KEY (billID, billEmpID, billOrdID),
	CONSTRAINT		fk_bill_emp			FOREIGN KEY (billEmpID)
					REFERENCES Cashier(casID),
	CONSTRAINT		fk_bill_ord			FOREIGN KEY (billOrdID)
					REFERENCES Orders(ordID),
);

CREATE TABLE PlaceAnOrder
(
	placeOrdID		CHAR(10)			NOT NULL,
	placeCusID		CHAR(10)			NOT NULL,
	placeShopID		CHAR(5)				NOT NULL,
	PRIMARY KEY	(placeOrdID, placeCusID),
	CONSTRAINT		fk_place_ord		FOREIGN KEY (placeOrdID)
					REFERENCES Orders(ordID),
	CONSTRAINT		fk_place_cus		FOREIGN KEY (placeCusID)
					REFERENCES Customer(cusID),
	CONSTRAINT fk_place_shop FOREIGN KEY (placeShopID)
					REFERENCES Shop(shopID)
);

ALTER TABLE Employee -- phone numbers have ten digits
ADD CONSTRAINT chk_PhoneNumber CHECK (
  LEN (empPhoneNumber) = 10
  AND empPhoneNumber LIKE '[0-9]%'
);

ALTER TABLE Product -- for a product the cost must be smaller than the price
ADD CONSTRAINT chk_ProductPrice CHECK (proPrice >= proCost);

ALTER TABLE Discount -- Add fk key
ADD  CONSTRAINT fk_dis_order FOREIGN KEY (disOrderID)
        REFERENCES Orders (ordID)

ALTER TABLE EmailEmployee
ADD CONSTRAINT chk_emp_email_format CHECK (
        emailEmp LIKE '%_@__%.__%' 
        AND CHARINDEX(' ', emailEmp) = 0 
        AND CHARINDEX('..', emailEmp) = 0 
        AND LEFT(emailEmp, 1) NOT IN ('.', '@') 
        AND RIGHT(emailEmp, 1) NOT IN ('.', '@')
);
ALTER TABLE EmailCustomer
ADD CONSTRAINT chk_cus_email_format CHECK (
        emailCus LIKE '%_@__%.__%' 
        AND CHARINDEX(' ', emailCus) = 0 
        AND CHARINDEX('..', emailCus) = 0 
        AND LEFT(emailCus, 1) NOT IN ('.', '@') 
        AND RIGHT(emailCus, 1) NOT IN ('.', '@')
);