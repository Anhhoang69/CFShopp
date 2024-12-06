CREATE TRIGGER trg_UpdateTotalPayment 
ON OrderCreation
FOR INSERT, DELETE, UPDATE
AS 
BEGIN 
    DECLARE @TotalCost INT = 0;
    DECLARE @TotalPayment INT = 0;

    DECLARE @OrderID CHAR(10);
    DECLARE @CustomerID CHAR(10);

    DECLARE @MemberDiscount DECIMAL(18, 2) = 0;
    DECLARE @DisVoucher DECIMAL(18, 2) = 0;

    -- Handle INSERTED data
    IF EXISTS (SELECT * FROM inserted)
    BEGIN 
        SELECT TOP 1 @OrderID = creOrdID
        FROM inserted;
    END 

    -- Handle UPDATED data
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN 
        SELECT TOP 1 @OrderID = creOrdID
        FROM inserted;
    END 

    -- Handle DELETED data
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN 
        SELECT TOP 1 @OrderID = creOrdID
        FROM deleted;
    END 

    -- Calculate Total Cost of OrderCreation
    SELECT @TotalCost = ISNULL(SUM(crePrice), 0)
    FROM OrderCreation
    WHERE creOrdID = @OrderID;

    -- Get Customer ID from PlaceAnOrder
    SELECT @CustomerID = placeCusID 
    FROM PlaceAnOrder
    WHERE placeOrdID = @OrderID;

    -- Calculate the discount based on customerVIP
    IF EXISTS (
        SELECT 1 FROM Member M
        WHERE memID = @CustomerID
    )
    BEGIN
        SELECT @MemberDiscount = ISNULL(
            (SELECT memBenefits FROM Member WHERE memID = @CustomerID), 0
        ) * @TotalCost / 100; -- Chuyển phần trăm thành giá trị giảm giá
    END

    -- Calculate the discount based on Voucher
    IF EXISTS (
        SELECT 1 FROM Discount D
        WHERE disOrderID = @OrderID
    )
    BEGIN
        DECLARE @DiscountType NVARCHAR(10);
        SELECT @DiscountType = disType 
        FROM Discount 
        WHERE disOrderID = @OrderID;

        -- Fixed discount
        IF @DiscountType = 'Fixed'
        BEGIN
            SELECT @DisVoucher = ISNULL(
                (SELECT fixedDisAmount FROM FixedDiscountVoucher F 
                 JOIN Discount D ON F.fixedDisID = D.disID
                 WHERE disOrderID = @OrderID), 0
            );
        END
        -- Percentage discount
        ELSE IF @DiscountType = 'Percentage'
        BEGIN 
            DECLARE @perDisAmount DECIMAL(18, 2);
            DECLARE @perMaximumValue DECIMAL(18, 2);

            SELECT @perDisAmount = perDisAmount,
                   @perMaximumValue = perMaximumValue
            FROM PercentageDiscountVoucher P 
            JOIN Discount D ON P.perDisID = D.disID
            WHERE disOrderID = @OrderID;

            -- Calculate percentage discount
            SET @DisVoucher = (@perDisAmount / 100.0) * @TotalCost;

            -- Cap the discount to the maximum value
            IF @DisVoucher > @perMaximumValue
                SET @DisVoucher = @perMaximumValue;
        END
    END
    
    -- Final total payment calculation
    SET @TotalPayment = @TotalCost - @MemberDiscount - @DisVoucher;

    -- Update Orders table
    UPDATE Orders
    SET ordTotalPrice = @TotalCost, 
        ordTotalPayment = @TotalPayment
    WHERE ordID = @OrderID;
END;


-- Kiểm tra INSERT
-- Thêm sản phẩm mới vào đơn hàng ORD0000001
INSERT INTO OrderCreation (creOrdID, creProID, creAmount, crePrice)
VALUES ('ORD0000001', 'P000000003', 1, 50000);

-- Kiểm tra kết quả
SELECT ordID, ordTotalPrice, ordTotalPayment
FROM Orders
WHERE ordID = 'ORD0000001';

-- Kiểm tra UPDATE
-- Cập nhật giá sản phẩm trong đơn hàng ORD0000001
UPDATE OrderCreation
SET crePrice = 60000
WHERE creOrdID = 'ORD0000001' AND creProID = 'P000000003';

-- Kiểm tra kết quả
SELECT ordID, ordTotalPrice, ordTotalPayment
FROM Orders
WHERE ordID = 'ORD0000001';

-- Kiểm tra thao tác DELETE
-- Xóa sản phẩm khỏi đơn hàng ORD0000001
DELETE FROM OrderCreation
WHERE creOrdID = 'ORD0000001' AND creProID = 'P000000003';

-- Kiểm tra kết quả
SELECT ordID, ordTotalPrice, ordTotalPayment
FROM Orders
WHERE ordID = 'ORD0000001';

-- Trường hợp không có mã giảm giá
-- Tạo một đơn hàng mới không có giảm giá
INSERT INTO Orders (ordID, ordStatus, ordTotalPrice, ordTotalPayment, ordName, ordPhoneNumber, ordEstTime, ordAddress, ordDeliStatus, ordEmpID)
VALUES ('ORD0000021', 'Pending', 0, 0, N'Nguyễn Văn An', '0901234567', '2024-12-01 10:00:00', N'123 ABC Street', 'Not Started', 'E1000003');

-- Thêm sản phẩm vào đơn hàng mới
INSERT INTO OrderCreation (creOrdID, creProID, creAmount, crePrice)
VALUES ('ORD0000021', 'P000000001', 2, 90000);

-- Kiểm tra kết quả
SELECT ordID, ordTotalPrice, ordTotalPayment
FROM Orders
WHERE ordID = 'ORD0000021';


--Mã giảm phần trăm
-- Thêm giảm giá phần trăm cho đơn hàng ORD0000021
INSERT INTO Discount (disShopID, disID, disType, disDescription, disMinimumValue, disExpireDate, disStartDate, disCondition, disOrderID)
VALUES ('CF001', 'D1000004', 'Percentage', N'Giảm 20% cho đơn hàng từ 90K', 90000, '2024-12-31', '2024-11-01', 'Active','ORD0000021');

INSERT INTO PercentageDiscountVoucher (perDisID, perDisShopID, perDisAmount, perMaximumValue)
VALUES ('D1000004', 'CF001', 20, 40000); -- Giảm 20% tối đa 40,000

-- Kiểm tra kết quả
SELECT ordID, ordTotalPrice, ordTotalPayment
FROM Orders
WHERE ordID = 'ORD0000021';


SELECT * FROM OrderCreation;
SELECT * FROM Orders;
DROP TRIGGER dbo.trg_UpdateTotalPayment;



Go--
CREATE TRIGGER trg_CalculateAverageRating
ON Feedback
AFTER INSERT
AS
BEGIN
    -- Tính toán và cập nhật rating cho từng cửa hàng có feedback được chèn
    UPDATE Shop
    SET rating = (
        SELECT AVG(CAST(feedAssessment AS DECIMAL(5,2)))
        FROM Feedback
        WHERE feedShopID = Shop.shopID
    )
    WHERE shopID IN (
        SELECT DISTINCT feedShopID
        FROM INSERTED
    );
END;

GO--

DROP TRIGGER dbo.trg_CalculateAverageRating;

-- Thêm dữ liệu mẫu cho bảng Feedback
INSERT INTO Feedback (feedID, feedShopID, feedCusID, feedTime, feedCondition, feedAssessment, feedDescription, feedEmpID, feedAnswer)
VALUES
('F0000000000000000013', 'CF003', 'C000000003', '2024-02-11 11:45:00', N'Sạch sẽ', 1, N'Cà phê ngon nhưng giá hơi cao.', 'E3000001', N'Cảm ơn bạn đã góp ý.'),
('F0000000000000000014', 'CF003', 'C000000003', '2024-02-18 11:45:00', N'Sạch sẽ', 1, N'Cà phê ngon nhưng giá hơi cao.', 'E3000001', N'Cảm ơn bạn đã góp ý.'),
('F0000000000000000015', 'CF003', 'C000000003', '2024-02-19 11:45:00', N'Sạch sẽ', 1, N'Cà phê ngon nhưng giá hơi cao.', 'E3000001', N'Cảm ơn bạn đã góp ý.'),
('F0000000000000000016', 'CF003', 'C000000001', '2024-02-11 11:45:00', N'Sạch sẽ', 1, N'Cà phê ngon nhưng giá hơi cao.', 'E3000001', N'Cảm ơn bạn đã góp ý.');


-- Kiểm tra bảng `Shop` để xác nhận điểm trung bình được cập nhật:
SELECT * FROM Shop;

