USE [chuyendecnpm]
GO
/****** Object:  StoredProcedure [dbo].[KhopLenhLienTuc]    Script Date: 08-May-22 8:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[KhopLenhLienTuc]
	@InputMa nchar(7), 
	@InputNgay NVARCHAR( 10),  
	@InputLoaiGD CHAR, 
	@InputSoluong INT, 
	@InputGiaDat FLOAT
AS
	SET DATEFORMAT DMY
	DECLARE @CrsrVar CURSOR, 
			@ngaydat NVARCHAR( 10), 
			@soluong INT, 
			@giadat FLOAT,  
			@soluongkhop INT, 
			@giakhop FLOAT,
			@ID INT,
			@OutputId INT
		
if(@InputSoluong > 0)
	begin
		if exists (select id  from banggiatructuyen where id = @InputMa)
			insert into lenhdat(giadat, loaigd, loailenh, ngaydat,soluong,trangthailenh,macp)
					values (@InputGiaDat,@InputLoaiGD,'LO',GETDATE(),@InputSoLuong, N'Chờ khớp', @InputMa)
		else
			begin
				insert into banggiatructuyen(id) values(@InputMa)
				insert into lenhdat(giadat, loaigd, loailenh, ngaydat,soluong,trangthailenh,macp)
					values (@InputGiaDat,@InputLoaiGD,'LO',GETDATE(),@InputSoLuong, N'Chờ khớp', @InputMa)
			end
		select @OutputId = SCOPE_IDENTITY()
	end
if (@InputLoaiGD='B')
	exec SP_CursorLoaiGiaoDich  @CrsrVar OUTPUT, @InputMa, @InputNgay, 'M'
else 
	exec SP_CursorLoaiGiaoDich  @CrsrVar OUTPUT, @InputMa, @InputNgay, 'B'

fetch next from @CrsrVar into @ID, @ngaydat , @soluong , @giadat
while (@@FETCH_STATUS <> -1 AND @InputSoluong > 0)
	begin
		if(@InputLoaiGD='B' )
			if(@InputGiaDat <= @giadat)
				begin 
					if (@InputSoluong >= @soluong)
						begin
							set @soluongkhop = @soluong
							set @giakhop = @giadat
							set @InputSoluong = @InputSoluong - @soluong
							update dbo.lenhdat set lenhdat.soluong = 0, lenhdat.trangthailenh = N'Khớp hết' where current of @CrsrVar
							update lenhdat set soluong = @InputSoluong  where lenhdat.id = @OutputId;
						end
					else
						begin
							set @soluongkhop = @InputSoluong
							set @giakhop = @giadat
							update dbo.lenhdat set lenhdat.soluong = lenhdat.soluong - @InputSoluong, trangthailenh = N'Khớp lệnh 1 phần'
								where current of @CrsrVar
							set @InputSoluong = 0
						end
					if(@InputSoluong = 0)
						update lenhdat set soluong = 0, trangthailenh = N'Khớp hết' where lenhdat.id = @OutputId;
					select  @soluongkhop, @giakhop
					insert into lenhkhop(ngaykhop, soluongkhop, giakhop, idlenhdat) values (GETDATE(),@soluongkhop, @giakhop, @ID)
				end
			else
				goto THOAT
		else
			if(@InputGiaDat >= @giadat)
				begin
					if (@InputSoluong >= @soluong)
						begin
							set @soluongkhop = @soluong
							set @giakhop = @giadat
							set @InputSoluong = @InputSoluong - @soluong
							update dbo.lenhdat  
							set lenhdat.soluong = 0, lenhdat.trangthailenh = N'Khớp hết' where current of @CrsrVar
							update lenhdat set soluong = @InputSoluong  where lenhdat.id = @OutputId;
						end
					else
						begin
							set @soluongkhop = @InputSoluong
							set @giakhop = @giadat
							update dbo.lenhdat set lenhdat.soluong = lenhdat.soluong - @InputSoluong, trangthailenh = N'Khớp lệnh 1 phần'
								where current of @CrsrVar
							set @InputSoluong = 0
						end
					if(@InputSoluong = 0)
						update lenhdat set soluong = 0, trangthailenh = N'Khớp hết' where lenhdat.id = @OutputId;
					select  @soluongkhop, @giakhop
					insert into lenhkhop(ngaykhop, soluongkhop, giakhop, idlenhdat) values (GETDATE(),@soluongkhop, @giakhop, @ID)
				end
			else
				goto THOAT
		fetch next from @CrsrVar into @ID, @ngaydat , @soluong , @giadat
	end
THOAT:
    close @CrsrVar
    deallocate @CrsrVar
	


	
