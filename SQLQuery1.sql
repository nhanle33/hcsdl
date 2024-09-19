CREATE DATABASE QLBH
ON PRIMARY(
	NAME = QLBH_DATA,
	FILENAME='T:\23698431_LeTranQuangNhan\QLBH_DATA.MDF'
)
LOG ON(
	NAME = QLBH_LOG,
	FILENAME='T:\23698431_LeTranQuangNhan\QLBH_LOG.LDF'
)
USE QLBH
-----
CREATE TABLE NhomSanPham(
	MaNhom     Int  primary key Not null, 
	TenNhom  Nvarchar(15)
)
create table NhaCungCap(
	MaNCC    Int  primary key Not null,
	TenNCC  Nvarchar(40)  Not Null,
	Diachi  Nvarchar(60),
	Phone  NVarchar(24),
	SoFax  NVarchar(24),
	DCMail  NVarchar(50)
)
create table SanPham(
	MaSP    int   primary key Not null,
	TenSP  nvarchar(40)  Not null,
	MaNCC    Int    references NhaCungCap(MaNCC),
	MoTa  nvarchar(50),
	MaNhom   Int    references NhomSanPham(MaNhom),
	Đonvitinh  nvarchar(20), 
	GiaGoc  Money  check(GiaGoc >0),
	SLTON  Int  check(SLTON >=0)

)
create table KhachHang(
	MaKH    Char(5) primary key Not null,
	TenKH  Nvarchar(40)  Not null,
	LoaiKH  Nvarchar(3) check(LoaiKH in('VIP','TV','VL')),
	DiaChi  Nvarchar(60),
	Phone  NVarchar(24),
	DCMail  NVarchar(50),
	DiemTL  Int  check (DiemTL >=0)
)
select GETDATE()
create table HoaDon(
	MaHD    Int primary key Not null,
	NgayLapHD  DateTime check (NgayLapHD <= getdate()) default getdate(),
	NgayGiao  DateTime,
	Noichuyen  NVarchar(60)  Not Null,
	MaKH  Char(5) references KhachHang(MaKH)
)
create table CT_HoaDon(
	MaHD  Int references HoaDon(MaHD) Not null,
	MaSP  int references SanPham(MaSP)   Not null,
	primary key(MaHD,MaSP),
	Soluong  SmallInt check(Soluong > 0),
	Dongia  Money,
	ChietKhau  Money  check(ChietKhau>=0)

)
alter table HoaDon
	add LoaiHD char(1) check(LoaiHD in('N','X','C','T'))
alter table HoaDon
	add constraint CK_NG_NLHD check(NgayGiao >= NgayLapHD)
insert into NhomSanPham values(1,N'Điện Tử'),
							  (2,N'Gia dụng')
alter table NhomSanPham
	alter column TenNhom nvarchar(50)
	
insert into NhomSanPham values(3,N'Dụng cụ gia đình'),
							  (4,N'Các mặt hàng khác')

select *from NhomSanPham
-----
insert into NhaCungCap values(1,N'Công ty TNHH Nam Phương',N'1 Lê Lợi Phường 4 Quận Gò Vấp','083843456','32343434','NamPhuong@yahoo.com'),
							 (2,N'Công Ty Lan Ngọc',N'12 Cao bá Quát Quận 1 Tp.Hồ Chí Minh','086234567','83434355','LanNgoc@gmail.com')
select *from NhaCungCap	
-----
insert into SanPham("MaSP","TenSP","Đonvitinh","GiaGoc","SLTON","MaNhom",MaNCC,"MoTa") values(1,N'Máy tính',N'Cái',7000,100,1,1,N'Máy Sony Ram 2BG'),
																							 (2,N'Bàn phím',N'Cái',1000,50,1,1,N'Bàn phím 101 phím'),
																							 (3,N'Chuột',N'Cái',800,150,1,1,N'Chuột không dây'),
																							 (4,'CPU',N'Cái',3000,200,1,1,N'CPU'),
																							 (5,'USB',N'Cái',500,100,1,1,N'8GB'),
																							 (6,N'Lò Vi Sóng',N'Cái',1000000,20,3,2,NULL)
select *from SanPham
-----
alter table KhachHang
	add SoFax nvarchar(24) null
insert into KhachHang(MaKH,TenKH,DiaChi,Phone,LoaiKH,SoFax,DCMail,DiemTL) values('KH1',N'Nguyễn Thu Hằng',N'12 Nguyễn Du','','VL',Null,Null,NULL),
																				('KH2',N'Lê Minh',N'34 Điện Biên Phủ','0123943455','TV',Null,'LeMinh@yahoo,com',100),
																				('KH3',N'Nguyễn Minh Trung',N'3 Lê Lợi gò Vấp','098343434','VIP',Null,'Trung@gmail.com',800)

select *from KhachHang
-----
set dateformat dmy
insert into HoaDon(MaHD,NgayLapHD,MaKH,NgayGiao,Noichuyen) values(1,'30-09-2015','KH1','05-10-2015',N'Cửa Hàng ABC 3 Lý Chính Thắng Quận 3')
insert into HoaDon(MaHD,NgayLapHD,MaKH,NgayGiao,Noichuyen) values(2,'29-07-2015','KH2','10-08-2015',N'23 Lê Lợi Quận Gò Vấp')
insert into HoaDon(MaHD,NgayLapHD,MaKH,NgayGiao,Noichuyen) values(3,'01-10-2015','KH3','01-10-2015',N'2 Nguyễn Du Quận Gò Vấp')

select *from HoaDon
-----
insert into CT_HoaDon(MaHD,MaSP,Dongia,Soluong) values(1,1,8000,5),
													  (1,2,1200,4),
													  (1,3,1000,15),
													  (2,2,1200,9),
													  (2,4,800,5),
													  (3,2,3500,20),
													  (3,3,1000,15)
select *from CT_HoaDon
-----
---2
--a
select *from CT_HoaDon
select *from SanPham
update CT_HoaDon
	set Dongia=Dongia*1.05 where MaSP=2

--b
update SanPham
	set SLTON=SLTON+100 where MaNhom=3 and MaNCC=2
--c
update SanPham
	set MoTa=N'Mô tả mới' where TenSP=N'Lò Vi Sóng'

select *from SanPham
--d
update HoaDon
	set MaKH=NULL where MaKH='KH3'

update KhachHang
	set MaKH='VI003' where MaKH='KH3'
update HoaDon
	set MaKH='VI003' where MaKH is null
--
update HoaDon
	set MaKH=NULL where MaKH='KH1'

update KhachHang
	set MaKH='VL001' where MaKH='KH1'
update HoaDon
	set MaKH='VL001' where MaKH is null
--
update HoaDon
	set MaKH=NULL where MaKH='KH2'

update KhachHang
	set MaKH='T0002' where MaKH='KH2'
update HoaDon
	set MaKH='T0002' where MaKH is null

select *from HoaDon
select *from KhachHang

alter table HoaDon
	add constraint FK_HoaDon_KhachHang foreign key (MaKH) references KhachHang(MaKH) on update cascade

---3
--a
select *from NhomSanPham
delete from NhomSanPham where MaNhom=4
select *from NhomSanPham
--b
select *from CT_HoaDon
delete from CT_HoaDon where MaHD=1 and MaSP=3
select *from CT_HoaDon
--c
exec sp_helpconstraint CT_HoaDon
alter table CT_HoaDon
	drop FK__CT_HoaDon__MaHD__5BE2A6F2
alter table CT_HoaDon
	add constraint FK__CT_HoaDon__MaHD__5BE2A6F2 foreign key(MaHD) references HoaDon(MaHD) on delete cascade
select *from HoaDon
delete from HoaDon where MaHD=1
delete from HoaDon where MaHD=2
select *from CT_HoaDon

	

