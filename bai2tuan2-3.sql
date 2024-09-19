--1
create database Movies
on primary(
	name = Movies_Data,
	filename='D:\Movies\Movies_data.mdf',
	size =25mb,
	maxsize=40mb,
	filegrowth=1mb
)
log on (
	name = Movies_Log,
	filename='D:\Movies\Movies_log.ldf',
	size=6mb,
	maxsize=8mb,
	filegrowth=1mb
)
use Movies
--2
--a
alter database Movies
	add file (Name = Movies_data2, filename='D:\Movies\Movies_data2.ndf', size=10mb)

--b
--single_user
alter database Movies
	set single_user with rollback immediate
--restricted user
alter database Movies
	set restricted_user 
--multi user
alter database Movies
	set multi_user
--c
alter database Movies
	modify file(name=Movies_data2, size =15mb)

exec sp_helpdb Movies
--
drop database Movies

--3
--/a
alter database Movies
	add filegroup Datagroup
--/b
alter database Movies
	modify file(name = Movies_Log, maxsize=10mb)
--/c
alter database Movies
	modify file(name= Movies_data2, size=20mb)
--/d
alter database Movies
	add file (
		name = Movies_data3,
		filename='D:\Movies\Movies_data3.ndf'
	)to filegroup Datagroup

exec sp_helpdb Movies
--4
--5
exec sp_addtype movie_num ,'int' , 'not null'
exec sp_addtype category_num,'int','not null' 
exec sp_addtype cust_num,'int','not null' 
exec sp_addtype invoice_num,'int','not null' 

select *from sys.types
--6

create table Customer(
	Cust_num  cust_num IDENTITY(300,1),
	Lname varchar(20) not null,
	Fname varchar(20) not null,
	Address1 varchar(30),
	Address2 varchar(20),
	City varchar(20), 
	State Char(2) ,
	Zip Char(10),
	Phone Varchar(10) Not null,
	Join_date Smalldatetime not null
)

create table Category(
	Category_num category_num IDENTITY(1,1),
	Description Varchar(20) Not null
)

create table Movie(
	Movie_num Movie_num ,
	Title Cust_num,
	Category_Num category_num,
	Date_purch Smalldatetime,
	Rental_price Int,
	Rating Char(5)
)

create table Rental(
	Invoice_num Invoice_num,
	Cust_num Cust_num ,
	Rental_date Smalldatetime Not null,
	Due_date Smalldatetime not null
)

create table Rental_Detail(
	Invoice_num Invoice_num,
	Line_num Int Not null,
	Movie_num Movie_num,
	Rental_price Smallmoney Not null
)

exec sp_help
--7
--8
--9
alter table Movie 
	add constraint PK_movie primary key(Movie_num)

alter table Customer
	add constraint PK_customer primary key(Cust_num)

alter table Category
	add constraint PK_category primary key(Category_num)

alter table Rental
	add constraint PK_rental primary key(Invoice_num)
--ktra constraint
exec sp_helpconstraint Movie
exec sp_helpconstraint Customer
exec sp_helpconstraint Category
exec sp_helpconstraint Rental

--10
alter table Movie 
	add constraint FK_movie foreign key(Category_num) references Category(Category_num)

alter table Rental
	add constraint FK_rental foreign key(Cust_num) references Customer(Cust_num)

alter table Rental_Detail
	add constraint FK_detail_invoice foreign key(Invoice_num) references Rental(Invoice_num)

alter table Rental_Detail
	add constraint FK_detail_movie foreign key(Movie_num) references Movie(Movie_num)
--ktra foreign key
exec sp_helpconstraint Movie
exec sp_helpconstraint Customer
exec sp_helpconstraint Category
exec sp_helpconstraint Rental
exec sp_helpconstraint Rental_Detail
--11
--12
--ALTER TABLE HoaDon
--ADD CONSTRAINT Ngay_DF DEFAULT Getdate() FOR NgayLap
select getdate()
alter table Movie
	add constraint DK_movie_date_purch default getdate() for Date_purch 

alter table Customer 
	add constraint DK_customer_join_date default getdate() for join_date

alter table Rental
	add constraint DK_rental_rental_date default getdate() for Rental_date

alter table Rental
	add constraint DK_rental_due_date default dateadd(day,2,getdate()) for Due_date 

--ktra
exec sp_helpconstraint Movie
exec sp_helpconstraint Customer
exec sp_helpconstraint Rental

--13
--ALTER TABLE Nhanvien
--ADD CONSTRAINT NV_HSPC CHECK (HSPC>=0.1 AND HSPC<0.5)alter table Movie	add constraint CK_movie check(Rating in ('G', 'PG', 'R', 'NC17', 'NR'))alter table Rental	add constraint CK_Due_date check (Due_date>=Rental_date)--ktraexec sp_helpconstraint Movieexec sp_helpconstraint Rental


