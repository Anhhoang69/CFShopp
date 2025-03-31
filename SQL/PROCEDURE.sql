DROP PROCEDURE GetEmployeesByShopID;
CREATE PROCEDURE GetEmployeesByShopID (@ShopID CHAR(5))
AS
BEGIN
    SELECT 
        e.empID,
		e.empshopID,
		e.supervisorID,
        e.empName,
        e.empPhoneNumber,
        e.empSex,
        e.empAddress,
		e.bdate,
		e.empAccount,
        STRING_AGG(ee.emailEmp, ', ') AS emailEmp,  -- Aggregate emails into a single string
        e.hourSalary,
        e.empStatus,
        e.empType,
        ss.serPosition,
        dm.delLicense
    FROM Employee AS e
    LEFT JOIN EmailEmployee AS ee ON e.empID = ee.empEmailEmpID
    LEFT JOIN ServiceStaff AS ss ON e.empID = ss.serID
    LEFT JOIN DeliveryMan AS dm ON e.empID = dm.delID
    WHERE e.empshopID = @ShopID
    GROUP BY e.empID,e.empshopID,e.supervisorID, e.empName, e.empPhoneNumber, e.empSex, e.empAddress,e.bdate, e.empAccount, -- Group by other columns
             e.hourSalary, e.empStatus, e.empType, ss.serPosition, dm.delLicense;
END;

EXEC GetEmployeesByShopID @ShopID = 'CF001';

DROP PROCEDURE GetDeliveryEmployeesRankedByOrderCount;
CREATE PROCEDURE GetDeliveryEmployeesRankedByOrderCount
@StartDate DATE,
@EndDate DATE,
@MinOrderCount INT
AS
BEGIN
-- Kiểm tra dữ liệu đầu vào
IF @StartDate IS NULL OR @EndDate IS NULL
BEGIN
RAISERROR('Ngày bắt đầu và ngày kết thúc không được để trống.', 16, 1);
RETURN;
END

IF @StartDate > @EndDate
BEGIN
    RAISERROR('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.', 16, 1);
    RETURN;
END

IF @MinOrderCount < 0
BEGIN
    RAISERROR('Số đơn hàng tối thiểu phải lớn hơn hoặc bằng 0.', 16, 1);
    RETURN;
END

-- Truy vấn danh sách nhân viên giao hàng, tính số lượng đơn hàng, lọc và sắp xếp
SELECT 
    E.empID,             -- ID nhân viên giao hàng
    E.empName,           -- Tên nhân viên giao hàng
    COUNT(O.ordID) AS OrderCount -- Số lượng đơn hàng đã giao
FROM 
    Employee AS E       -- Bảng Nhân viên
JOIN 
    DeliveryMan AS DM ON E.empID = DM.delID   -- Kết hợp với bảng Người giao hàng
JOIN 
    Orders AS O ON DM.delID = O.ordEmpID     -- Kết hợp với bảng Đơn hàng
WHERE 
    O.ordEstTime >= @StartDate AND O.ordEstTime <= @EndDate  -- Lọc theo khoảng thời gian
    AND O.ordDeliStatus = N'Completed' -- Chỉ tính các đơn hàng đã hoàn thành (tùy chọn)
GROUP BY 
    E.empID, E.empName  -- Nhóm theo ID và tên nhân viên
HAVING 
    COUNT(O.ordID) >= @MinOrderCount -- Lọc theo số đơn hàng tối thiểu
ORDER BY 
    OrderCount DESC;     -- Sắp xếp theo số lượng đơn hàng giảm dần
END;

-- Test trường hợp lỗi: StartDate lớn hơn EndDate
EXEC GetDeliveryEmployeesRankedByOrderCount 
    @StartDate = '2023-12-31', 
    @EndDate = '2023-01-01', 
    @MinOrderCount = 10;

-- Test trường hợp dữ liệu hợp lệ
EXEC GetDeliveryEmployeesRankedByOrderCount 
    @StartDate = '2024-01-01', 
    @EndDate = '2024-12-31', 
    @MinOrderCount = 1;
