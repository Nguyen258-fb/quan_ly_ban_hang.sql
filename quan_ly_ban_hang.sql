-- Bước 1: Tạo và sử dụng cơ sở dữ liệu QuanLyBanHang
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- Xóa bảng cũ nếu đã tồn tại để tránh xung đột
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

-- Bước 2: Tạo các bảng
CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge TINYINT
);

CREATE TABLE `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

CREATE TABLE OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- Bước 3: Thêm dữ liệu vào các bảng
-- 1. Bảng Customer
INSERT INTO Customer VALUES (1, 'Minh Quan', 10);
INSERT INTO Customer VALUES (2, 'Ngoc Oanh', 20);
INSERT INTO Customer VALUES (3, 'Hong Ha', 50);

-- 2. Bảng Order
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES 
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

-- 3. Bảng Product
INSERT INTO Product VALUES 
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

-- 4. Bảng OrderDetail
INSERT INTO OrderDetail VALUES 
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);


-- ========================================================
-- BƯỚC 4: THỰC HIỆN CÁC CÂU TRUY VẤN YÊU CẦU
-- ========================================================

-- 1. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order
SELECT oID, oDate, oTotalPrice 
FROM `Order`;

-- 2. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách
SELECT DISTINCT c.cID, c.Name AS CustomerName, p.pName AS ProductName
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

-- 3. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT c.cID, c.Name 
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- 4. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
-- (Giá một hóa đơn được tính bằng tổng giá bán odQTY * pPrice của từng loại mặt hàng)
SELECT o.oID, o.oDate, SUM(od.odQTY * p.pPrice) AS oTotalPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
