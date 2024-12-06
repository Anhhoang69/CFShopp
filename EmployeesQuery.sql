--Thêm nhân viên
CREATE PROCEDURE InsertEmployee
    @empID CHAR(8),
    @empStartDate DATE,
    @empName NVARCHAR(25),
    @empPhoneNumber CHAR(10),
    @empSsn CHAR(12),
    @bdate DATE,
    @empAccount NVARCHAR(70),
    @empType NVARCHAR(20),
    @empSex CHAR(1),
    @empAddress NVARCHAR(50),
    @hourSalary INT,
    @empStatus VARCHAR(30),
    @supervisorID CHAR(8),
    @empshopID CHAR(5),
    @empEmails VARCHAR(MAX),
	@delLicense VARCHAR(12) = NULL, 
    @serPosition NVARCHAR(20) = NULL 
AS
BEGIN
    BEGIN TRY
        IF LEN(@empID) != 8 
        BEGIN
            THROW 50000, 'ID nhân viên phải có 8 ký tự.', 1;
        END

        IF EXISTS (SELECT 1 FROM Employee WHERE empID = @empID)
        BEGIN
            THROW 50001, 'ID nhân viên đã tồn tại.', 1;
        END

        IF LEN(@empPhoneNumber) != 10
        BEGIN
            THROW 50002, 'Số điện thoại không hợp lệ, phải có 10 chữ số.', 1;
        END

        IF EXISTS (SELECT 1 FROM Employee WHERE empSsn = @empSsn)
        BEGIN
            THROW 50003, 'Số CCCD đã tồn tại.', 1;
        END

        IF @bdate > GETDATE()
        BEGIN
            THROW 50004, 'Ngày sinh không thể lớn hơn ngày hiện tại.', 1;
        END

        IF @hourSalary <= 0
        BEGIN
            THROW 50005, 'Lương theo giờ phải lớn hơn 0.', 1;
        END

        IF @empSex NOT IN ('M', 'F')
        BEGIN
            THROW 50007, 'Giới tính không hợp lệ. Phải là M hoặc F.', 1;
        END

        IF @empStatus NOT IN ('Active', 'Inactive', 'On Leave', 'Suspended')
        BEGIN
            THROW 50010, 'Trạng thái nhân viên không hợp lệ. Phải là Active, Inactive, On Leave hoặc Suspended.', 1;
        END

        IF NOT EXISTS (SELECT 1 FROM Shop WHERE shopID = @empshopID)
        BEGIN
            THROW 50008, 'Mã cửa hàng không tồn tại.', 1;
        END

        
        -- Kiểm tra mã quản lý (supervisorID)
        IF @supervisorID IS NOT NULL 
        BEGIN
            -- Kiểm tra mã quản lý có tồn tại và empType là "Quản lý"
            IF NOT EXISTS (
                SELECT 1 
                FROM Employee 
                WHERE empID = @supervisorID 
                  AND empType = N'Quản lý'
            )
            BEGIN
                THROW 50011, 'Mã quản lý không tồn tại hoặc không phải là nhân viên loại "Quản lý".', 1;
            END
        END

        INSERT INTO Employee
        (
            empID,
            empStartDate,
            empName,
            empPhoneNumber,
            empSsn,
            bdate,
            empAccount,
            empType,
            empSex,
            empAddress,
            hourSalary,
            empStatus,
            supervisorID,
            empshopID
        )
        VALUES
        (
            @empID,
            @empStartDate,
            @empName,
            @empPhoneNumber,
            @empSsn,
            @bdate,
            @empAccount,
            @empType,
            @empSex,
            @empAddress,
            @hourSalary,
            @empStatus,
            @supervisorID,
            @empshopID
        );
		-- Sau khi thêm nhân viên, thêm email
        DECLARE @email NVARCHAR(50);
        DECLARE @emailList TABLE (email NVARCHAR(50)); -- Bảng tạm chứa các email

        -- Tách chuỗi emails
        WHILE CHARINDEX(',', @empEmails) > 0
        BEGIN
            SET @email = LTRIM(RTRIM(SUBSTRING(@empEmails, 1, CHARINDEX(',', @empEmails) - 1)));

            -- Kiểm tra email có hợp lệ hay không
            IF @email NOT LIKE '%_@__%.__%' 
               OR CHARINDEX(' ', @email) > 0
               OR CHARINDEX('..', @email) > 0
               OR LEFT(@email, 1) IN ('.', '@')
               OR RIGHT(@email, 1) IN ('.', '@')
            BEGIN
                THROW 50019, 'Địa chỉ email không hợp lệ.', 1;
            END

            INSERT INTO @emailList (email) VALUES (@email);
            SET @empEmails = SUBSTRING(@empEmails, CHARINDEX(',', @empEmails) + 1, LEN(@empEmails));
        END

        -- Thêm email cuối cùng
        SET @email = LTRIM(RTRIM(@empEmails));
        IF @email NOT LIKE '%_@__%.__%' 
           OR CHARINDEX(' ', @email) > 0
           OR CHARINDEX('..', @email) > 0
           OR LEFT(@email, 1) IN ('.', '@')
           OR RIGHT(@email, 1) IN ('.', '@')
        BEGIN
            THROW 50019, 'Địa chỉ email không hợp lệ.', 1;
        END
        INSERT INTO @emailList (email) VALUES (@email);

        -- Thêm từng email vào bảng EmailEmployee
        INSERT INTO EmailEmployee (empEmailEmpID, emailEmp)
        SELECT @empID, email FROM @emailList;


		IF @empType = N'Thu ngân'
        BEGIN
            INSERT INTO Cashier (casID) VALUES (@empID);
        END
        ELSE IF @empType = N'Giao hàng'
        BEGIN
            IF @delLicense IS NULL
            BEGIN
                THROW 50020, 'Giấy phép giao hàng là bắt buộc đối với nhân viên giao hàng.', 1;
            END
            INSERT INTO DeliveryMan (delID, delLicense) 
            VALUES (@empID, @delLicense);
        END
        ELSE IF @empType = N'Phục vụ'
		BEGIN
			IF @serPosition IS NULL
			BEGIN
				THROW 50021, 'Vị trí phục vụ là bắt buộc cho nhân viên phục vụ.', 1;
			END
			INSERT INTO ServiceStaff (serID, serPosition) 
			VALUES (@empID, @serPosition);
		END


        PRINT 'Thêm nhân viên thành công.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;

-- Trường hợp lỗi
EXEC InsertEmployee 
    @empID = 'E1000013',      -- Mã nhân viên mới
    @empStartDate = '2024-11-20',    -- Ngày bắt đầu
    @empName = N'Trần Anh ', -- Tên nhân viên
    @empPhoneNumber = '0987654321',    -- Số điện thoại
    @empSsn = '223344556694',  -- Số CCCD
    @bdate = '1998-05-15',    -- Ngày sinh
    @empAccount = 'Agribank|1234567890124',          -- Mã tài khoản
    @empType = N'Giao hàng',     -- Loại nhân viên
    @empSex = 'M',             -- Giới tính
    @empAddress = N'Nguyễn Trãi, Quận 5', -- Địa chỉ
    @hourSalary = 28000,          -- Lương 1 giờ
    @empStatus ='Active',        -- Tình trạng nhân viên
    @supervisorID = 'E1000001',      -- Mã người giám sát (nếu có)
    @empshopID = 'CF001',         -- Mã cửa hàng khác
	@empEmails = 'email1@example.com, email2@example.com, email3@example.com',
	@delLicense = 'B1', -- Giấy phép giao hàng
    @serPosition = NULL; -- Không cần cho nhân viên giao hàng

-- Trường hợp thành công
EXEC InsertEmployee 
    @empID = 'E1000013',      -- Mã nhân viên mới
    @empStartDate = '2024-11-20',    -- Ngày bắt đầu
    @empName = N'Trần Anh ', -- Tên nhân viên
    @empPhoneNumber = '0987654321',    -- Số điện thoại
    @empSsn = '223344556694',  -- Số CCCD
    @bdate = '1998-05-15',    -- Ngày sinh
    @empAccount = 'Agribank|1234567890124',          -- Mã tài khoản
    @empType = N'Giao hàng',     -- Loại nhân viên
    @empSex = 'M',             -- Giới tính
    @empAddress = N'Nguyễn Trãi, Quận 5', -- Địa chỉ
    @hourSalary = 28000,          -- Lương 1 giờ
    @empStatus ='Active',        -- Tình trạng nhân viên
    @supervisorID = 'E1000004',      -- Mã người giám sát (nếu có)
    @empshopID = 'CF001',         -- Mã cửa hàng khác
	@empEmails = 'email1@example.com, email2@example.com, email3@example.com',
	@delLicense = 'B1', -- Giấy phép giao hàng
    @serPosition = NULL; -- Không cần cho nhân viên giao hàng



--Chỉnh sửa thông tin nhân viên
CREATE PROCEDURE UpdateEmployee
    @empID CHAR(8),
    @empName NVARCHAR(25) = NULL,
    @empPhoneNumber CHAR(10) = NULL,
    @empAddress NVARCHAR(50) = NULL,
    @hourSalary INT = NULL,
    @empStatus VARCHAR(30) = NULL,
    @empSex CHAR(1) = NULL,
    @bdate DATE = NULL,
    @empAccount NVARCHAR(70) = NULL,
    @empType NVARCHAR(20) = NULL,
    @supervisorID CHAR(8) = NULL,
    @empshopID CHAR(5) = NULL,
    @empEmails VARCHAR(MAX) = NULL,  -- Nhiều email, cách nhau bằng dấu phẩy
    @delLicense VARCHAR(12) = NULL, -- Giấy phép giao hàng (tùy chọn)
    @serPosition NVARCHAR(20) = NULL -- Vị trí phục vụ (tùy chọn)
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra ID nhân viên
        IF LEN(@empID) != 8 
        BEGIN
            THROW 50000, 'ID nhân viên phải có đúng 8 ký tự.', 1;
        END

        -- Kiểm tra xem nhân viên có tồn tại hay không
        IF NOT EXISTS (SELECT 1 FROM Employee WHERE empID = @empID)
        BEGIN
            THROW 50003, 'ID nhân viên không tồn tại.', 1;
        END

        -- Kiểm tra số điện thoại
        IF @empPhoneNumber IS NOT NULL AND (LEN(@empPhoneNumber) != 10 OR ISNUMERIC(@empPhoneNumber) = 0)
        BEGIN
            THROW 50002, 'Số điện thoại phải có đúng 10 chữ số.', 1;
        END

        -- Kiểm tra lương theo giờ
        IF @hourSalary IS NOT NULL AND @hourSalary <= 0
        BEGIN
            THROW 50004, 'Lương phải lớn hơn 0.', 1;
        END

        -- Kiểm tra trạng thái nhân viên
        IF @empStatus NOT IN ('Active', 'Inactive', 'On Leave', 'Suspended')
        BEGIN
            THROW 50010, 'Trạng thái nhân viên không hợp lệ. Phải là Active, Inactive, On Leave hoặc Suspended.', 1;
        END

        -- Kiểm tra giới tính
        IF @empSex IS NOT NULL AND @empSex NOT IN ('M', 'F')
        BEGIN
            THROW 50005, 'Giới tính không hợp lệ. Phải là M hoặc F.', 1;
        END

        -- Kiểm tra ngày sinh
        IF @bdate IS NOT NULL AND @bdate > GETDATE()
        BEGIN
            THROW 50006, 'Ngày sinh không thể lớn hơn ngày hiện tại.', 1;
        END

        -- Kiểm tra mã cửa hàng
        IF @empshopID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Shop WHERE shopID = @empshopID)
        BEGIN
            THROW 50009, 'Mã cửa hàng không tồn tại.', 1;
        END

       -- Kiểm tra mã quản lý (supervisorID)
        IF @supervisorID IS NOT NULL 
        BEGIN
            -- Kiểm tra mã quản lý có tồn tại và empType là "Quản lý"
            IF NOT EXISTS (
                SELECT 1 
                FROM Employee 
                WHERE empID = @supervisorID 
                  AND empType = N'Quản lý'
            )
            BEGIN
                THROW 50011, 'Mã quản lý không tồn tại hoặc không phải là nhân viên loại "Quản lý".', 1;
            END
        END

        -- Lấy empType hiện tại trước khi cập nhật
        DECLARE @currentType NVARCHAR(20);
        SELECT @currentType = empType FROM Employee WHERE empID = @empID;

        -- Cập nhật thông tin nhân viên
        DECLARE @RowCount INT;
        UPDATE Employee
        SET
            empName = COALESCE(@empName, empName),
            empPhoneNumber = COALESCE(@empPhoneNumber, empPhoneNumber),
            empAddress = COALESCE(@empAddress, empAddress),
            hourSalary = COALESCE(@hourSalary, hourSalary),
            empStatus = COALESCE(@empStatus, empStatus),
            empSex = COALESCE(@empSex, empSex),
            bdate = COALESCE(@bdate, bdate),
            empAccount = COALESCE(@empAccount, empAccount),
            empType = COALESCE(@empType, empType),
            supervisorID = COALESCE(@supervisorID, supervisorID),
            empshopID = COALESCE(@empshopID, empshopID)
        WHERE empID = @empID;

        SET @RowCount = @@ROWCOUNT;
        IF @RowCount = 0
        BEGIN
            THROW 50012, 'Không có thông tin nào được cập nhật.', 1;
        END

        -- Cập nhật email cho nhân viên
        IF @empEmails IS NOT NULL
        BEGIN
            DECLARE @email NVARCHAR(50);
            DECLARE @emailList TABLE (email NVARCHAR(50));

            -- Tách chuỗi emails
            WHILE CHARINDEX(',', @empEmails) > 0
            BEGIN
                SET @email = LTRIM(RTRIM(SUBSTRING(@empEmails, 1, CHARINDEX(',', @empEmails) - 1)));
                IF @email NOT LIKE '%_@__%.__%' OR CHARINDEX(' ', @email) > 0
                BEGIN
                    THROW 50019, 'Địa chỉ email không hợp lệ.', 1;
                END
                INSERT INTO @emailList (email) VALUES (@email);
                SET @empEmails = SUBSTRING(@empEmails, CHARINDEX(',', @empEmails) + 1, LEN(@empEmails));
            END

            -- Thêm email cuối cùng
            SET @email = LTRIM(RTRIM(@empEmails));
            IF @email NOT LIKE '%_@__%.__%' OR CHARINDEX(' ', @email) > 0
            BEGIN
                THROW 50019, 'Địa chỉ email không hợp lệ.', 1;
            END
            INSERT INTO @emailList (email) VALUES (@email);

            -- Cập nhật email cho nhân viên
            DELETE FROM EmailEmployee WHERE empEmailEmpID = @empID;
            INSERT INTO EmailEmployee (empEmailEmpID, emailEmp)
            SELECT @empID, email FROM @emailList;
        END

        -- Nếu thay đổi empType, cập nhật bảng con tương ứng
        IF @empType IS NOT NULL AND @currentType != @empType
        BEGIN
            -- Xóa dữ liệu cũ trong bảng con
            IF @currentType = N'Giao hàng'
            BEGIN
                DELETE FROM DeliveryMan WHERE delID = @empID;
            END
            ELSE IF @currentType = N'Phục vụ'
            BEGIN
                DELETE FROM ServiceStaff WHERE serID = @empID;
            END
            ELSE IF @currentType = N'Thu ngân'
            BEGIN
                DELETE FROM Cashier WHERE casID = @empID;
            END

            -- Thêm dữ liệu mới vào bảng con
            IF @empType = N'Giao hàng'
            BEGIN
                IF @delLicense IS NULL
                BEGIN
                    THROW 50020, 'Giấy phép giao hàng là bắt buộc đối với nhân viên giao hàng.', 1;
                END
                INSERT INTO DeliveryMan (delID, delLicense) VALUES (@empID, @delLicense);
            END
            ELSE IF @empType = N'Phục vụ'
            BEGIN
                IF @serPosition IS NULL
                BEGIN
                    THROW 50021, 'Vị trí phục vụ là bắt buộc đối với nhân viên phục vụ.', 1;
                END
                INSERT INTO ServiceStaff (serID, serPosition) VALUES (@empID, @serPosition);
            END
            ELSE IF @empType = N'Thu ngân'
            BEGIN
                INSERT INTO Cashier (casID) VALUES (@empID);
            END
        END

        PRINT N'Cập nhật thông tin nhân viên thành công!';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;

-- Trường hợp thất bại
EXEC UpdateEmployee
    @empID = 'E1000013',          -- Mã nhân viên
    @empName = N'Nguyễn Văn A',   -- Tên nhân viên mới
    @empPhoneNumber = '0987654321',  -- Số điện thoại mới
    @empStatus = 'Inactive',        -- Trạng thái nhân viên mới
    @empType = N'Phục vụ',      -- Thay đổi loại nhân viên
    @delLicense = NULL,           -- Giấy phép giao hàng không cần thiết cho "Thu ngân"
    @serPosition = N'Dãy 1, tầng 1',          -- Không cần vị trí phục vụ
    @empshopID = 'CF008',         -- Cửa hàng mới
    @supervisorID = 'E1000004',   -- Mã quản lý mới
    @empEmails = 'email11@example.com, email22@example.com';  -- Email mới

-- Trường hợp thành công
EXEC UpdateEmployee
    @empID = 'E1000013',          -- Mã nhân viên
    @empName = N'Nguyễn Văn A',   -- Tên nhân viên mới
    @empPhoneNumber = '0987654321',  -- Số điện thoại mới
    @empStatus = 'Inactive',        -- Trạng thái nhân viên mới
    @empType = N'Phục vụ',      -- Thay đổi loại nhân viên
    @delLicense = NULL,           -- Giấy phép giao hàng không cần thiết cho "Thu ngân"
    @serPosition = N'Dãy 1, tầng 1',          -- Không cần vị trí phục vụ
    @empshopID = 'CF001',         -- Cửa hàng mới
    @supervisorID = 'E1000004',   -- Mã quản lý mới
    @empEmails = 'email11@example.com, email22@example.com';  -- Email mới


CREATE PROCEDURE DeleteEmployee
    @empID CHAR(8)
AS
BEGIN
    BEGIN TRY
        -- Kiểm tra độ dài mã nhân viên
        IF LEN(@empID) != 8 
        BEGIN
            THROW 50000, 'Mã nhân viên phải có đúng 8 ký tự.', 1;
        END
		-- Kiểm tra nhân viên quản lý
        IF EXISTS (SELECT 1 FROM Employee WHERE supervisorID = @empID)
        BEGIN
            THROW 50009, 'Không thể xóa nhân viên quản lý.', 1;
        END

        -- Kiểm tra nếu nhân viên đang phụ trách đơn hàng
        IF EXISTS (SELECT 1 FROM Orders WHERE ordEmpID = @empID)
        BEGIN
            THROW 50010, 'Không thể xóa nhân viên vì họ đang phụ trách đơn hàng.', 1;
        END

        -- Kiểm tra nếu nhân viên liên quan đến phản hồi
        IF EXISTS (SELECT 1 FROM Feedback WHERE feedEmpID = @empID)
        BEGIN
            THROW 50011, 'Không thể xóa nhân viên vì họ đang liên quan đến phản hồi khách hàng.', 1;
        END

        -- Kiểm tra nếu nhân viên liên quan đến hóa đơn
        IF EXISTS (SELECT 1 FROM Bill WHERE billEmpID = @empID)
        BEGIN
            THROW 50012, 'Không thể xóa nhân viên vì họ đang liên quan đến đơn hàng.', 1;
        END

        -- Thực hiện xóa các bảng liên quan trước khi xóa nhân viên
        DELETE FROM Vehicle WHERE empVehicleDelID = @empID;
        DELETE FROM WorkingShift WHERE empWorkID = @empID;
        DELETE FROM EmailEmployee WHERE empEmailEmpID = @empID;
        DELETE FROM Cashier WHERE casID = @empID;
        DELETE FROM DeliveryMan WHERE delID = @empID;
        DELETE FROM ServiceStaff WHERE serID = @empID;

        -- Xóa nhân viên trong bảng Employee
        DELETE FROM Employee WHERE empID = @empID;

        -- Nếu không xóa được nhân viên nào
        IF @@ROWCOUNT = 0
        BEGIN
            THROW 50005, 'Không tìm thấy nhân viên với mã đã nhập.', 1;
        END

        PRINT 'Xóa nhân viên thành công!';
    END TRY
    BEGIN CATCH
        -- Truyền lại lỗi từ CATCH block ra bên ngoài
        THROW;
    END CATCH
END;

-- Trường hợp thất bại
EXEC DeleteEmployee 
    @empID = 'E1000001';

-- Trường hợp thành công
EXEC DeleteEmployee 
    @empID = 'E1000013';



--Xóa các thủ tục
DROP PROCEDURE dbo.InsertEmployee;
DROP PROCEDURE dbo.UpdateEmployee;
DROP PROCEDURE dbo.DeleteEmployee;




