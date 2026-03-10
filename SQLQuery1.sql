
use master; 


if DB_ID('CarBooking') is not null
begin alter database CarBooking  set SINGLE_USER 
with rollback immediate 
end

drop database if  EXISTS  CarBooking; -- xóa hẳn DB T_Tri nếu có 
go
create database CarBooking;-- tạo mới DB trống tên T_Tri
go 
use CarBooking; -- chuyenr context sang DB T_Tri mới để chạy các lệnh tiếp thoe
go

-- Nếu bảng Student đã tồn tại thì xóa
IF OBJECT_ID('dbo.BooKing','U') IS NOT NULL 
    DROP TABLE dbo.BooKing;

-- Tạo bảng Student
CREATE TABLE dbo.BooKing (
    CarID INT PRIMARY KEY IDENTITY(1,1),
    Carname NVARCHAR(100) NOT NULL,
	StartDate nvarchar(50),
	ReturnDate nvarchar(50),
    Amount INT,
	Statuss nvarchar(50)
);

INSERT INTO dbo.BooKing (Carname, StartDate, ReturnDate,Amount,Statuss)
VALUES
    (N'Nguyễn Văn A', N'12-12-2025', N'16-1-2026',3000,'Chưa trả'),
	    (N'Nguyễn Văn B', N'12-12-2025', N'16-1-2026',3000,'Chưa trả'),
		    (N'Nguyễn Văn C', N'12-12-2025', N'16-1-2026',3000,'Chưa trả');

