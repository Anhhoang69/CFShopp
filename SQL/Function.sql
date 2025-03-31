

CREATE FUNCTION dbo.CalculateShopRevenue
(
    @ShopID CHAR(5),
    @StartDate DATE,
    @EndDate DATE
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @TotalRevenue INT = 0;
    DECLARE @OrderID CHAR(10);
    DECLARE @OrderTotalPrice INT;

	IF LEN(@ShopID) <> 5
		RETURN N'ID cửa hàng không đúng định dạng';

    -- Kiểm tra sự tồn tại của shopID
    IF NOT EXISTS (SELECT 1 FROM Shop WHERE shopID = @ShopID)
		RETURN N'Cửa hàng không tồn tại';

    -- Kiểm tra thời gian hợp lệ
    IF @StartDate > @EndDate
		RETURN N'Lỗi thời gian';

    -- Tạo con trỏ để duyệt qua các đơn hàng trong khoảng thời gian
    DECLARE order_cursor CURSOR FOR
    SELECT o.ordID, o.ordTotalPrice
    FROM Orders o
    JOIN PlaceAnOrder p ON o.ordID = p.placeOrdID
    WHERE p.placeShopID = @ShopID
    AND o.ordStatus = 'Completed'
    AND o.ordEstTime BETWEEN @StartDate AND @EndDate;

    OPEN order_cursor;

    -- Duyệt qua các đơn hàng
    FETCH NEXT FROM order_cursor INTO @OrderID, @OrderTotalPrice;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Cập nhật tổng doanh thu
        SET @TotalRevenue = @TotalRevenue + @OrderTotalPrice;

        -- Lấy dòng tiếp theo
        FETCH NEXT FROM order_cursor INTO @OrderID, @OrderTotalPrice;
    END

    -- Đóng con trỏ
    CLOSE order_cursor;
    DEALLOCATE order_cursor;

    -- Trả về tổng doanh thu
    RETURN N'Doanh thu cửa hàng là: ' + CAST(@TotalRevenue AS NVARCHAR);
END;

-- Lỗi: Thời gian không hợp lệ
SELECT dbo.CalculateShopRevenue('SHOP1', '2023-12-31', '2023-01-01')AS TotalRevenue;

-- Trường hợp thành công
SELECT dbo.CalculateShopRevenue('CF001', '2024-01-01', '2024-1-31') AS TotalRevenue;

DROP FUNCTION dbo.CalculateShopRevenue;



CREATE FUNCTION CalculateEmployeeSalariesByShop (
    @ShopID CHAR(5),
    @StartDate DATE,
    @EndDate DATE
)
RETURNS @SalaryReport TABLE (
    empID CHAR(8),
    empName NVARCHAR(100),
    Salary INT
)
AS
BEGIN
	-- Kiểm tra tham số đầu vào
    IF LEN(@ShopID) <> 5
    BEGIN
        INSERT INTO @SalaryReport (empID, empName, Salary)
        VALUES ('ERROR', N'ID cửa hàng không đúng định dạng', NULL);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Shop WHERE shopID = @ShopID)
    BEGIN
        INSERT INTO @SalaryReport (empID, empName, Salary)
        VALUES ('ERROR', N'Cửa hàng không tồn tại', NULL);
        RETURN;
    END

    IF @StartDate > @EndDate
    BEGIN
        INSERT INTO @SalaryReport (empID, empName, Salary)
        VALUES ('ERROR', N'Lỗi thời gian', NULL);
        RETURN;
    END

    DECLARE @empID CHAR(8);
    DECLARE @empName NVARCHAR(100);
    DECLARE @hourSalary INT;
    DECLARE @TotalHours FLOAT = 0;
    DECLARE @Salary INT;
    DECLARE @shiftStart DATETIME;
    DECLARE @shiftEnd DATETIME;

    -- Tạo con trỏ để duyệt qua các nhân viên của cửa hàng
    DECLARE emp_cursor CURSOR FOR
    SELECT empID, empName, hourSalary
    FROM Employee
    WHERE empshopID = @ShopID;

    OPEN emp_cursor;

    FETCH NEXT FROM emp_cursor INTO @empID, @empName, @hourSalary;

    -- Duyệt qua tất cả nhân viên
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Lấy tổng số giờ làm việc của nhân viên trong khoảng thời gian
        SET @TotalHours = 0;

        DECLARE work_cursor CURSOR FOR
        SELECT shiftTimeStart, shiftTimeEnd
        FROM WorkingShift
        WHERE empWorkID = @empID
          AND shiftTimeStart >= @StartDate
          AND shiftTimeEnd <= @EndDate;

        OPEN work_cursor;
        FETCH NEXT FROM work_cursor INTO @shiftStart, @shiftEnd;

        -- Duyệt qua các ca làm việc của nhân viên
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Tính giờ làm việc của từng ca và cộng vào tổng số giờ làm việc
            SET @TotalHours = @TotalHours + DATEDIFF(MINUTE, @shiftStart, @shiftEnd) / 60.0;
            FETCH NEXT FROM work_cursor INTO @shiftStart, @shiftEnd;
        END;

        -- Đóng con trỏ ca làm việc
        CLOSE work_cursor;
        DEALLOCATE work_cursor;

        -- Tính lương cho nhân viên
        SET @Salary = CEILING(@TotalHours * @hourSalary);

        -- Thêm thông tin vào bảng kết quả trả về
        INSERT INTO @SalaryReport (empID, empName, Salary)
        VALUES (@empID, @empName, @Salary);

        -- Lấy nhân viên tiếp theo
        FETCH NEXT FROM emp_cursor INTO @empID, @empName, @hourSalary;
    END;

    -- Đóng con trỏ nhân viên
    CLOSE emp_cursor;
    DEALLOCATE emp_cursor;

    -- Trả về kết quả (bảng)
    RETURN;
END;

-- Lỗi: Shop không tồn tại
SELECT * FROM dbo.CalculateEmployeeSalariesByShop('SHOPX', '2023-01-01', '2023-01-31');

-- Trường hợp thành công 
SELECT * FROM dbo.CalculateEmployeeSalariesByShop('CF001', '2024-11-20', '2024-11-27');

DROP FUNCTION dbo.CalculateEmployeeSalariesByShop

