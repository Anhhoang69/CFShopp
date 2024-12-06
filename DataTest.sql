SET LANGUAGE English
-- Xóa data
DELETE FROM ImageProduct;
DELETE FROM OrderCreation;
DELETE FROM Bill;
DELETE FROM PlaceAnOrder;
DELETE FROM Feedback;
DELETE FROM EmailCustomer;
DELETE FROM Member;
DELETE FROM PercentageDiscountVoucher;
DELETE FROM FixedDiscountVoucher;
DELETE FROM Discount;
DELETE FROM WorkingShift;
DELETE FROM Cashier;
DELETE FROM ServiceStaff;
DELETE FROM Vehicle;
DELETE FROM Orders;
DELETE FROM DeliveryMan;
DELETE FROM EmailEmployee;
DELETE FROM Employee;
DELETE FROM Product;
DELETE FROM Customer;
DELETE FROM Shop;
-- Chọn bảng
SELECT * FROM Shop;
SELECT * FROM Employee;
SELECT * FROM EmailEmployee;
SELECT * FROM DeliveryMan;
SELECT * FROM ServiceStaff;
SELECT * FROM Cashier;
SELECT * FROM Vehicle;
SELECT * FROM Customer;
SELECT * FROM Member;
SELECT * FROM EmailCustomer;
SELECT * FROM Orders;
SELECT * FROM Product;
SELECT * FROM OrderCreation;
SELECT * FROM Discount;
SELECT * FROM FixedDiscountVoucher;
SELECT * FROM PercentageDiscountVoucher;
SELECT * FROM PlaceAnOrder;
SELECT * FROM Feedback;
SELECT * FROM Bill;
SELECT * FROM WorkingShift;
SELECT * FROM ImageProduct;

-- Thêm dữ liệu mẫu cho bảng Shop
INSERT INTO Shop (shopID, shopAddress, monthlyCost) VALUES 
('CF001',N'165B Đ. Nguyễn Trãi, Phường 2, Quận 5', '462000000 VND'),
('CF002',N'132 Đ. Calmette, Phường Nguyễn Thái Bình, Quận 1', '594000000 VND'),
('CF003',N'48 Đ. Quang Trung, Phường 10, Gò Vấp', '347000000 VND');

-- Thêm dữ liệu mẫu cho bảng Employee
INSERT INTO Employee (empID, empStartDate, empName, empPhoneNumber, empSsn, bdate, empAccount, empType, empSex, empAddress, hourSalary, empStatus, supervisorID, empshopID) VALUES 
('E1000001', '2021-03-10', N'Nguyễn Thị Hạnh', '0912345678', '123456789013', '1992-05-20', 'Agribank|1234567890123', N'Phục vụ', 'F', N'Bạch Đằng, Phường 24, Bình Thạnh', 25000, 'Active', 'E1000004', 'CF001'),
('E1000002', '2020-04-15', N'Trần Văn Minh', '0923456789', '123456789014', '1988-11-02', 'VIB|123456789', N'Thu ngân', 'M', N'Lê Văn Sỹ, Phường 13, Quận 3', 25000, 'Active', 'E1000004', 'CF001'),
('E1000003', '2022-07-22', N'Phạm Văn Hiếu', '0934567890', '123456789015', '1995-09-10', 'Vietcombank|1234567890123', N'Giao hàng', 'M', N'Lê Hồng Phong, Phường 10, Quận 10', 25000, 'Active', 'E1000004', 'CF001'),
('E2000001', '2023-01-05', N'Lê Hoàng Anh', '0945678901', '123456789016', '1998-12-12', 'BIDV|12345678901234', N'Phục vụ', 'F', N'Nguyễn Thái Học, Phường Cô Giang, Quận 1', 25000, 'Active', 'E2000004', 'CF002'),
('E2000002', '2020-06-18', N'Đoàn Mai Linh', '0956789012', '123456789017', '1994-02-28', 'Vietinbank|123456789012', N'Thu ngân', 'F', N'Lê Duẩn, Phường Bến Nghé, Quận 1', 25000, 'Active', 'E2000004', 'CF002'),
('E2000003', '2021-08-25', N'Hoàng Văn Thanh', '0967890123', '123456789018', '1993-04-05', 'OCB|0901234567', N'Giao hàng', 'M', N'Đinh Tiên Hoàng, Phường 3, Bình Thạnh', 25000, 'Active', 'E2000004', 'CF002'),
('E3000001', '2021-11-12', N'Nguyễn Thị Loan', '0978901234', '123456789019', '1987-07-18', 'VIB|987654321', N'Phục vụ', 'F', N'Nguyễn Đình Chiểu, Phường 4, Quận 3', 25000, 'Active', 'E3000004', 'CF003'),
('E3000002', '2022-09-09', N'Võ Quốc Bảo', '0989012345', '123456789020', '1991-01-09', 'Agribank|9876543210987', N'Thu ngân', 'M', N'Hai Bà Trưng, Phường 6, Quận 3', 25000, 'Active', 'E3000004', 'CF003'),
('E3000003', '2023-02-02', N'Nguyễn Hữu Nghị', '0990123456', '123456789021', '1996-03-03', 'Vietcombank|9876543210987', N'Giao hàng', 'M', N'Phan Đăng Lưu, Phường 7, Phú Nhuận', 25000, 'Active', 'E3000004', 'CF003'),
('E1000004', '2021-01-01', N'Lê Quang Phúc', '0901111222', '123456789022', '1985-01-01', 'BIDV|98765432109876', N'Quản lý', 'M', N'78 Điện Biên Phủ, Phường 25, Bình Thạnh', 30000, 'Active', NULL, 'CF001'),
('E2000004', '2021-01-01', N'Trần Thị Mỹ', '0902222333', '123456789023', '1983-02-02', 'Vietinbank|987654321098', N'Quản lý', 'F', N'23 Trần Hưng Đạo, Phường Nguyễn Thái Bình, Quận 1', 30000, 'Active', NULL, 'CF002'),
('E3000004', '2021-01-01', N'Hồ Văn Long', '0903333444', '123456789024', '1986-03-03', 'OCB|0987654321', N'Quản lý', 'M', N'15 Lê Lợi, Phường Bến Thành, Quận 1', 30000, 'Active', NULL, 'CF003');

-- Thêm dữ liệu mẫu cho bảng EmailEmployee
INSERT INTO EmailEmployee (empEmailEmpID, emailEmp) VALUES 
('E1000001', 'nguyen.thihanh@gmail.com'),
('E1000001', 'nguyen.2thihanh@gmail.com'),
('E1000002', 'tran.vanminh@gmail.com'),
('E2000001', 'le.hoanganh@gmail.com'),
('E2000002', 'doan.mailinh@gmail.com'),
('E2000002', 'doan.mailinh2@gmail.com'),
('E3000001', 'nguyen.thiloan@gmail.com'),
('E3000002', 'vo.quocbao@gmail.com');

-- Thêm dữ liệu mẫu cho bảng DeliveryMan
INSERT INTO DeliveryMan (delID, delLicense) VALUES 
('E1000003', 'DL123456'),
('E2000003', 'DL789012'),
('E3000003', 'DL345678');

-- Thêm dữ liệu mẫu cho bảng Vehicle
INSERT INTO Vehicle (empVehicleDelID, vehicleType, vehicleNumber) VALUES 
('E1000003', N'Xe máy', '59N1-12345'),
('E2000003', N'Xe máy', '59N2-67890'),
('E3000003', N'Xe máy', '51C1-12345');

-- Thêm dữ liệu mẫu cho bảng ServiceStaff
INSERT INTO ServiceStaff (serID, serPosition) VALUES 
('E1000001', N'Nhân viên phục vụ'),
('E2000001', N'Nhân viên phục vụ'),
('E3000001', N'Nhân viên phục vụ');

-- Thêm dữ liệu mẫu cho bảng Cashier
INSERT INTO Cashier (casID) VALUES 
('E1000002'),
('E2000002'),
('E3000002');

-- Thêm dữ liệu mẫu cho bảng WorkingShift
INSERT INTO WorkingShift (empWorkID, shiftTimeStart, shiftTimeEnd) VALUES 
('E1000001', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E1000002', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E1000003', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E2000001', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E2000002', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E2000003', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E3000001', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E3000002', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E3000003', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E1000004', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E2000004', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),
('E3000004', '2024-11-20 08:00:00', '2024-11-20 21:00:00'),

('E1000001', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E1000002', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E1000003', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E2000001', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E2000002', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E2000003', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E3000001', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E3000002', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E3000003', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E1000004', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E2000004', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),
('E3000004', '2024-11-21 08:00:00', '2024-11-21 21:00:00'),

('E1000001', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E1000002', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E1000003', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E2000001', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E2000002', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E2000003', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E3000001', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E3000002', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E3000003', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E1000004', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E2000004', '2024-11-22 08:00:00', '2024-11-22 21:00:00'),
('E3000004', '2024-11-22 08:00:00', '2024-11-22 21:00:00');


-- Thêm dữ liệu mẫu cho bảng Customer
INSERT INTO Customer (cusID, cusName, cusType, cusSex, cusAddress, cusPhoneNumber, cusSsn, cusAccount)
VALUES
('C000000001', N'Nguyễn Văn An', 'Normal', 'M', N'1A Ngô Quyền, Quận 5', '0901234567', '123456789101', 'VIB|234567890'),
('C000000002', N'Trần Thị Bình', 'VIP', 'F', N'2B Hai Bà Trưng, Quận 3', '0912345678', '123456789102', 'Agribank|2345678901234'),
('C000000003', N'Lê Văn Cường', 'Normal', 'M', N'3C Nguyễn Thái Học, Quận 1', '0923456789', '123456789103', 'Vietcombank|2345678901234'),
('C000000004', N'Phạm Thị Diệp', 'VIP', 'F', N'4D Cách Mạng Tháng 8, Quận 10', '0934567890', '123456789104', 'BIDV|23456789012345'),
('C000000005', N'Hoàng Văn Dũng', 'Normal', 'M', N'5E Lê Lợi, Quận 1', '0945678901', '123456789105', 'Vietinbank|234567890123'),
('C000000006', N'Bùi Minh Hoa', 'Normal', 'F', N'6F Trần Hưng Đạo, Quận 1', '0956789012', '123456789106', 'VIB|765432189'),
('C000000007', N'Đặng Quang Hùng', 'VIP', 'M', N'7G Đinh Tiên Hoàng, Quận Bình Thạnh', '0967890123', '123456789107', 'Agribank|7654321098765'),
('C000000008', N'Phan Thành Long', 'Normal', 'M', N'8H Nguyễn Văn Trỗi, Quận Phú Nhuận', '0978901234', '123456789108', 'Vietcombank|7654321098765'),
('C000000009', N'Võ Thị Mai', 'Normal', 'F', N'9I Cách Mạng Tháng 8, Quận 10', '0989012345', '123456789109', 'BIDV|76543210987654'),
('C000000010', N'Trịnh Ngọc Tuyền', 'VIP', 'F', N'10J Lê Thánh Tôn, Quận 1', '0990123456', '123456789110', 'Vietinbank|765432109876'),
('C000000011', N'Ngô Thanh Phong', 'Normal', 'M', N'11K Nguyễn Văn Cừ, Quận 5', '0902345678', '123456789111', 'Techcombank|1234567890123'),
('C000000012', N'Lê Thị Kim Oanh', 'Normal', 'F', N'12L Lý Thái Tổ, Quận 10', '0913456789', '123456789112', 'MB Bank|23456789012345'),
('C000000013', N'Trần Đình Khánh', 'Normal', 'M', N'13M Điện Biên Phủ, Quận 3', '0924567890', '123456789113', 'Sacombank|34567890123456'),
('C000000014', N'Phạm Thị Hương', 'Normal', 'F', N'14N Võ Văn Kiệt, Quận 1', '0935678901', '123456789114', 'ACB|45678901234567'),
('C000000015', N'Bùi Văn Minh', 'Normal', 'M', N'15O Trường Sa, Quận Bình Thạnh', '0946789012', '123456789115', 'TPBank|56789012345678');

-- Thêm dữ liệu mẫu cho bảng Member
INSERT INTO Member (memID, memVIPType, memBenefits)
VALUES
('C000000002', 'Bronze', 5),
('C000000004', 'Silver', 10),
('C000000007', 'Gold', 15),
('C000000010', 'Diamond', 20);

-- Thêm dữ liệu mẫu cho bảng EmailMember
INSERT INTO EmailCustomer (cusEmailID, emailCus)
VALUES
('C000000002', 'binh.tran@gmail.com'),
('C000000004', 'diep.pham@gmail.com'),
('C000000007', 'hung.dang@gmail.com'),
('C000000010', 'tuyen.trinh@gmail.com'),
('C000000001', 'an.nguyen@gmail.com'),
('C000000003', 'cuong.le@gmail.com'),
('C000000005', 'dung.hoang@gmail.com');

-- Thêm dữ liệu mẫu cho bảng Orders
INSERT INTO Orders (ordID, ordStatus, ordTotalPrice, ordTotalPayment, ordName, ordPhoneNumber, ordEstTime, ordAddress, ordDeliStatus, ordEmpID)
VALUES
('ORD0000001', 'Completed', 115000, 115000, N'Nguyễn Văn An', '0901234567', '2024-01-15 12:00:00', N'1A Ngô Quyền, Quận 5', 'Completed', 'E1000003'),
('ORD0000002', 'Pending', 133000, 0, N'Trần Thị Bình', '0912345678', '2024-01-25 14:30:00', N'2B Hai Bà Trưng, Quận 3', 'Not Started', 'E2000003'),
('ORD0000003', 'Confirmed', 160000, 0, N'Lê Văn Cường', '0923456789', '2024-02-05 10:45:00', N'3C Nguyễn Thái Học, Quận 1', 'In Progress', 'E3000003'),
('ORD0000004', 'Completed', 148500, 148500, N'Phạm Thị Diệp', '0934567890', '2024-02-15 13:15:00', N'4D Cách Mạng Tháng 8, Quận 10', 'Completed', 'E1000003'),
('ORD0000005', 'Canceled', 240000, 0, N'Hoàng Văn Dũng', '0945678901', '2024-03-01 16:45:00', N'5E Lê Lợi, Quận 1', 'Failed', 'E2000003'),
('ORD0000006', 'Pending', 90000, 0, N'Bùi Minh Hòa', '0956789012', '2024-03-20 11:30:00', N'6F Trần Hưng Đạo, Quận 1', 'Not Started', 'E3000003'),
('ORD0000007', 'Completed', 169750, 169750, N'Đặng Quang Hưng', '0967890123', '2024-04-10 15:00:00', N'7G Đinh Tiên Hoàng, Quận Bình Thạnh', 'Completed', 'E1000003'),
('ORD0000008', 'Confirmed', 100000, 0, N'Phan Thanh Long', '0978901234', '2024-04-25 10:00:00', N'8H Nguyễn Văn Trỗi, Quận Phú Nhuận', 'In Progress', 'E2000003'),
('ORD0000009', 'Completed', 165000, 165000, N'Võ Thị Mai', '0989012345', '2024-05-05 12:30:00', N'9I Cách Mạng Tháng 8, Quận 10', 'Completed', 'E3000003'),
('ORD0000010', 'Pending', 80000, 0, N'Trịnh Ngọc Tuyền', '0990123456', '2024-05-20 14:00:00', N'10J Lê Thánh Tôn, Quận 1', 'Not Started', 'E1000003'),
('ORD0000011', 'Completed', 140000, 140000, N'Ngô Thanh Phong', '0902345678', '2024-06-01 10:30:00', N'11K Nguyễn Văn Cừ, Quận 5', 'Completed', 'E1000003'),
('ORD0000012', 'Completed', 135000, 135000, N'Lê Thị Kim Oanh', '0913456789', '2024-06-05 11:45:00', N'12L Lý Thái Tổ, Quận 10', 'Completed', 'E1000003'),
('ORD0000013', 'Completed', 100000, 100000, N'Trần Đình Khánh', '0924567890', '2024-06-10 13:00:00', N'13M Điện Biên Phủ, Quận 3', 'Completed', 'E1000003'),
('ORD0000014', 'Completed', 165000, 165000, N'Phạm Thị Hương', '0935678901', '2024-06-15 14:15:00', N'14N Võ Văn Kiệt, Quận 1', 'Completed', 'E1000003'),
('ORD0000015', 'Completed', 150000, 150000, N'Bùi Văn Minh', '0946789012', '2024-06-20 15:30:00', N'15O Trường Sa, Quận Bình Thạnh', 'Completed', 'E1000003'),
('ORD0000016', 'Completed', 145000, 145000, N'Ngô Thanh Phong', '0902345678', '2024-06-25 10:30:00', N'11K Nguyễn Văn Cừ, Quận 5', 'Completed', 'E1000003'),
('ORD0000017', 'Completed', 155000, 155000, N'Lê Thị Kim Oanh', '0913456789', '2024-06-30 11:45:00', N'12L Lý Thái Tổ, Quận 10', 'Completed', 'E1000003'),
('ORD0000018', 'Completed', 155000, 155000, N'Trần Đình Khánh', '0924567890', '2024-06-06 13:00:00', N'13M Điện Biên Phủ, Quận 3', 'Completed', 'E1000003'),
('ORD0000019', 'Completed', 200000, 200000, N'Phạm Thị Hương', '0935678901', '2024-06-07 14:15:00', N'14N Võ Văn Kiệt, Quận 1', 'Completed', 'E1000003'),
('ORD0000020', 'Completed', 155000, 155000, N'Bùi Văn Minh', '0946789012', '2024-06-08 15:30:00', N'15O Trường Sa, Quận Bình Thạnh', 'Completed', 'E1000003');

-- Thêm dữ liệu mẫu cho bảng Discount
INSERT INTO Discount (disShopID, disID, disType, disDescription, disMinimumValue, disExpireDate, disStartDate, disCondition, disOrderID) 
VALUES
('CF001', 'D1000001', 'Fixed', N'Giảm giá 20K cho đơn hàng từ 100K', 100000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000001'),
('CF001', 'D1000002', 'Percentage', N'Giảm 15% cho đơn hàng từ 200K', 200000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000002'),
('CF001', 'D1000003', 'Fixed', N'Giảm 30K cho đơn hàng từ 200K', 200000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000007'),
('CF002', 'D2000001', 'Fixed', N'Giảm giá 30K cho đơn hàng từ 150K', 150000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000003'),
('CF002', 'D2000002', 'Percentage', N'Giảm 25% cho đơn hàng từ 300K', 300000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000004'),
('CF003', 'D3000001', 'Fixed', N'Giảm giá 10K cho đơn hàng từ 50K', 50000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000005'),
('CF003', 'D3000002', 'Percentage', N'Giảm 10% cho đơn hàng từ 100K', 100000, '2024-12-31', '2024-11-01', 'Active', 'ORD0000006');

-- Thêm dữ liệu mẫu cho bảng FixedDiscountVoucher
INSERT INTO FixedDiscountVoucher (fixedDisShopID, fixedDisID, fixedDisAmount) VALUES
('CF001', 'D1000001', 20000),
('CF001', 'D1000003', 30000),
('CF002', 'D2000001', 30000),
('CF003', 'D3000001', 10000);

-- Thêm dữ liệu mẫu cho bảng PercentageDiscountVoucher
INSERT INTO PercentageDiscountVoucher (perDisID, perDisShopID, perDisAmount, perMaximumValue) VALUES
('D1000002', 'CF001', 15, 50000),
('D2000002', 'CF002', 25, 100000),
('D3000002', 'CF003', 10, 30000);

-- Thêm dữ liệu mẫu cho bảng Feedback
INSERT INTO Feedback (feedID, feedShopID, feedCusID, feedTime, feedCondition, feedAssessment, feedDescription, feedEmpID, feedAnswer)
VALUES
('F0000000000000000001', 'CF001', 'C000000001', '2024-01-15 09:30:00', N'Sạch sẽ', 5, N'Nhân viên rất thân thiện và hỗ trợ tốt.', 'E1000001', N'Cảm ơn bạn đã phản hồi!'),
('F0000000000000000002', 'CF002', 'C000000002', '2024-01-20 10:15:00', N'Đông khách', 3, N'Thời gian chờ đợi quá lâu.', 'E2000001', N'Chúng tôi sẽ cải thiện dịch vụ.'),
('F0000000000000000003', 'CF003', 'C000000003', '2024-02-10 11:45:00', N'Sạch sẽ', 4, N'Cà phê ngon nhưng giá hơi cao.', 'E3000001', N'Cảm ơn bạn đã góp ý.'),
('F0000000000000000004', 'CF001', 'C000000004', '2024-02-15 12:30:00', N'Ồn ào', 2, N'Quán quá ồn, khó tập trung.', 'E1000003', N'Chúng tôi sẽ cải thiện môi trường.'),
('F0000000000000000005', 'CF002', 'C000000005', '2024-03-05 13:50:00', N'Thân thiện', 5, N'Dịch vụ tuyệt vời và đồ uống ngon.', 'E2000002', N'Rất cảm ơn phản hồi của bạn!'),
('F0000000000000000006', 'CF003', 'C000000006', '2024-03-20 15:20:00', N'Sạch sẽ', 4, N'Không gian sạch sẽ, sẽ quay lại.', 'E3000003', N'Mong được gặp lại bạn lần tới.'),
('F0000000000000000007', 'CF001', 'C000000007', '2024-04-01 16:00:00', N'Phục vụ nhanh', 5, N'Dịch vụ rất hiệu quả.', 'E1000002', N'Cảm ơn bạn đã ủng hộ.'),
('F0000000000000000008', 'CF003', 'C000000008', '2024-04-15 17:30:00', N'Lịch sự', 4, N'Nhân viên lịch sự, không gian thoải mái.', 'E3000002', N'Phản hồi của bạn rất giá trị.'),
('F0000000000000000009', 'CF002', 'C000000009', '2024-05-10 18:45:00', N'Phục vụ chậm', 3, N'Dịch vụ hôm nay hơi chậm.', 'E2000003', N'Chúng tôi đang cải thiện tốc độ phục vụ.'),
('F0000000000000000010', 'CF001', 'C000000010', '2024-05-20 19:10:00', N'Thân thiện', 5, N'Dịch vụ tuyệt vời như mọi khi.', 'E1000001', N'Cảm ơn bạn đã đồng hành cùng chúng tôi.');

-- Thêm dữ liệu mẫu cho bảng Product
INSERT INTO Product (proID, proName, proType, proCost, proPrice, proCondition)
VALUES
('P000000001', N'Cà phê Americano', N'Thức uống', 29000, 45000, 'Available'),
('P000000002', N'Bạc xỉu', N'Thức uống', 29000, 45000, 'Available'),
('P000000003', N'Cà phê cốt dừa', N'Thức uống', 31000, 50000, 'Available'),
('P000000004', N'Cà phê đen', N'Thức uống', 29000, 45000, 'Available'),
('P000000005', N'Cà phê sữa', N'Thức uống', 29000, 45000, 'Available'),
('P000000006', N'Sữa khoai môn', N'Thức uống', 34000, 55000, 'Available'),
('P000000007', N'Sữa tươi tc đường đen', N'Thức uống', 34000, 55000, 'Available'),
('P000000008', N'Sương sáo sữa', N'Thức uống', 34000, 55000, 'Available'),
('P000000009', N'Trà sữa đào', N'Thức uống', 31000, 50000, 'Available'),
('P000000010', N'Trà sữa lài xanh', N'Thức uống', 31000, 50000, 'Available');

-- Thêm dữ liệu mẫu cho bảng OrderCreation
INSERT INTO OrderCreation (creOrdID, creProID, creAmount, crePrice)
VALUES
('ORD0000001', 'P000000001', 2, 90000),
('ORD0000001', 'P000000002', 1, 45000),
('ORD0000002', 'P000000003', 1, 50000),
('ORD0000002', 'P000000004', 2, 90000),
('ORD0000003', 'P000000005', 3, 135000),
('ORD0000003', 'P000000006', 1, 55000),
('ORD0000004', 'P000000007', 1, 55000),
('ORD0000004', 'P000000008', 2, 110000),
('ORD0000005', 'P000000009', 3, 150000),
('ORD0000005', 'P000000010', 2, 100000),
('ORD0000006', 'P000000001', 1, 45000),
('ORD0000006', 'P000000002', 1, 45000),
('ORD0000007', 'P000000003', 2, 100000),
('ORD0000007', 'P000000004', 3, 135000),
('ORD0000008', 'P000000005', 1, 45000),
('ORD0000008', 'P000000006', 1, 55000),
('ORD0000009', 'P000000007', 2, 110000),
('ORD0000009', 'P000000008', 1, 55000),
('ORD0000010', 'P000000009', 1, 50000),
('ORD0000010', 'P000000010', 1, 50000),
('ORD0000011', 'P000000001', 2, 90000),
('ORD0000011', 'P000000003', 1, 50000),
('ORD0000012', 'P000000002', 2, 90000),
('ORD0000012', 'P000000004', 1, 45000),
('ORD0000013', 'P000000005', 1, 45000),
('ORD0000013', 'P000000007', 1, 55000),
('ORD0000014', 'P000000006', 2, 110000),
('ORD0000014', 'P000000008', 1, 55000),
('ORD0000015', 'P000000009', 2, 100000),
('ORD0000015', 'P000000010', 1, 50000),
('ORD0000016', 'P000000003', 2, 100000),
('ORD0000016', 'P000000005', 1, 45000),
('ORD0000017', 'P000000007', 2, 110000),
('ORD0000017', 'P000000002', 1, 45000),
('ORD0000018', 'P000000008', 2, 110000),
('ORD0000018', 'P000000001', 1, 45000),
('ORD0000019', 'P000000003', 3, 150000),
('ORD0000019', 'P000000009', 1, 50000),
('ORD0000020', 'P000000006', 1, 55000),
('ORD0000020', 'P000000010', 2, 100000);

-- Thêm dữ liệu mẫu cho bảng Bill
INSERT INTO Bill (billID, billEmpID, billOrdID, billTime)
VALUES
('BILL00000000001', 'E1000002', 'ORD0000001', '2024-01-15 12:30:00'),
('BILL00000000002', 'E2000002', 'ORD0000002', '2024-01-25 15:00:00'),
('BILL00000000003', 'E3000002', 'ORD0000003', '2024-02-05 11:00:00'),
('BILL00000000004', 'E1000002', 'ORD0000004', '2024-02-15 13:45:00'),
('BILL00000000005', 'E2000002', 'ORD0000005', '2024-03-01 17:00:00'),
('BILL00000000006', 'E3000002', 'ORD0000006', '2024-03-20 12:00:00'),
('BILL00000000007', 'E1000002', 'ORD0000007', '2024-04-10 15:30:00'),
('BILL00000000008', 'E2000002', 'ORD0000008', '2024-04-25 10:30:00'),
('BILL00000000009', 'E3000002', 'ORD0000009', '2024-05-05 13:00:00'),
('BILL00000000010', 'E1000002', 'ORD0000010', '2024-06-20 14:30:00'),
('BILL00000000011', 'E1000002', 'ORD0000011', '2024-06-01 10:30:00'),
('BILL00000000012', 'E1000002', 'ORD0000012', '2024-06-05 11:45:00'),
('BILL00000000013', 'E1000002', 'ORD0000013', '2024-06-10 13:00:00'),
('BILL00000000014', 'E1000002', 'ORD0000014', '2024-06-15 14:15:00'),
('BILL00000000015', 'E1000002', 'ORD0000015', '2024-06-20 15:30:00'),
('BILL00000000016', 'E1000002', 'ORD0000016', '2024-06-25 10:30:00'),
('BILL00000000017', 'E1000002', 'ORD0000017', '2024-06-30 11:45:00'),
('BILL00000000018', 'E1000002', 'ORD0000018', '2024-06-06 13:00:00'),
('BILL00000000019', 'E1000002', 'ORD0000019', '2024-06-07 14:15:00'),
('BILL00000000020', 'E1000002', 'ORD0000020', '2024-06-08 15:30:00');

-- Thêm dữ liệu mẫu cho bảng PlaceAnOrder
INSERT INTO PlaceAnOrder (placeOrdID, placeCusID, placeShopID)
VALUES
('ORD0000001', 'C000000001', 'CF001'),
('ORD0000002', 'C000000002', 'CF002'),
('ORD0000003', 'C000000003', 'CF003'),
('ORD0000004', 'C000000004', 'CF001'),
('ORD0000005', 'C000000005', 'CF002'),
('ORD0000006', 'C000000006', 'CF003'),
('ORD0000007', 'C000000007', 'CF001'),
('ORD0000008', 'C000000008', 'CF002'),
('ORD0000009', 'C000000009', 'CF003'),
('ORD0000010', 'C000000010', 'CF001'),
('ORD0000011', 'C000000011', 'CF001'),
('ORD0000012', 'C000000012', 'CF001'),
('ORD0000013', 'C000000013', 'CF001'),
('ORD0000014', 'C000000014', 'CF001'),
('ORD0000015', 'C000000015', 'CF001'),
('ORD0000016', 'C000000011', 'CF001'),
('ORD0000017', 'C000000012', 'CF001'),
('ORD0000018', 'C000000013', 'CF001'),
('ORD0000019', 'C000000014', 'CF001'),
('ORD0000020', 'C000000015', 'CF001');

-- Thêm dữ liệu mẫu cho bảng ImageProduct
INSERT INTO ImageProduct (imgProID, imgPro)
VALUES
('P000000001', 'americano_coffee.jpg'),
('P000000002', 'bac_xiu.jpg'),
('P000000003', 'ca_phe_cot_dua.jpg'),
('P000000004', 'ca_phe_den.jpg'),
('P000000005', 'ca_phe_sua.jpg'),
('P000000006', 'sua_khoai_mon.jpg'),
('P000000007', 'st_tc_duong_den.jpg'),
('P000000008', 'suong_sao_sua.jpg'),
('P000000009', 'tra_sua_dao.jpg'),
('P000000010', 'tra_sua_lai_xanh.jpg');

