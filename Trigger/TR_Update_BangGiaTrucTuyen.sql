USE [chuyendecnpm]
GO
/****** Object:  Trigger [dbo].[TR_Update_BangGiaTrucTuyen]    Script Date: 08-May-22 8:06:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_Update_BangGiaTrucTuyen]
   ON  [dbo].[lenhdat] 
   AFTER INSERT, UPDATE
AS 
BEGIN
	declare @macp CHAR(7),
			@ngaydat DATETIME ,
			@giadat float, 
			@LoaiGD NCHAR(1) , 
			@index int,
			@CrsrVar CURSOR, 
			@soluong float,
			@OutputId int
	
	select @LoaiGD = inserted.loaigd , @macp = inserted.macp , @ngaydat = inserted.ngaydat from inserted
	set @index = 0;
	if ( @LoaiGD = 'M' )
		begin
		update  dbo.banggiatructuyen
			SET     giamua1 = 0,klmua1 = 0, giamua2 = 0, klmua2 = 0, giamua3 = 0,klmua3 = 0
			WHERE   id = @macp
		exec SP_CursorBangGia  @CrsrVar OUTPUT, @macp, @ngaydat, 'M'
		end
	else
		begin
		update  dbo.banggiatructuyen
			SET     giaban1 = 0,klban1 = 0, giaban2 = 0, klban2 = 0, giaban3 = 0,klban3 = 0
			WHERE   id = @macp
		exec SP_CursorBangGia  @CrsrVar OUTPUT, @macp, @ngaydat, 'B'
		end
	fetch next from @CrsrVar into @macp, @giadat , @soluong 
		while (@@FETCH_STATUS = 0 and @index < 3)
		begin 
			if ( @LoaiGD = 'M' )
				begin
				if(@index = 0)
					update  dbo.banggiatructuyen set giamua1 = @giadat, klmua1 = @soluong where id = @macp
				ELSE IF(@index = 1)
					update  dbo.banggiatructuyen SET  giamua2 = @giadat , klmua2 = @SoLuong WHERE   id = @macp
				ELSE IF(@index = 2)
					update  dbo.banggiatructuyen SET  giamua3 = @giadat , klmua3 = @SoLuong WHERE   id = @macp
				end
			else 
				begin
				if(@index = 0)
					update  dbo.banggiatructuyen set giaban1 = @giadat, klban1 = @soluong where id = @macp
				ELSE IF(@index = 1)
					update  dbo.banggiatructuyen set giaban2 = @giadat, klban2 = @soluong where id = @macp
				ELSE IF(@index = 2)
					update  dbo.banggiatructuyen set giaban3 = @giadat, klban3 = @soluong where id = @macp
				end
			set @index = @index + 1
		fetch next from @CrsrVar INTO @macp, @giadat , @soluong 
		end
	close @CrsrVar
	deallocate @CrsrVar
end
