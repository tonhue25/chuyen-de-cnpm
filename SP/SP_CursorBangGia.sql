USE [chuyendecnpm]
GO
/****** Object:  StoredProcedure [dbo].[SP_CursorBangGia]    Script Date: 08-May-22 8:07:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[SP_CursorBangGia]
	@OutCrsr CURSOR VARYING	OUTPUT,
	@macp NVARCHAR(10), 
	@Ngay DATETIME,
	@LoaiGD CHAR(1)
AS
	IF (@LoaiGD = 'M')
		SET @OutCrsr =  CURSOR KEYSET FOR
		SELECT macp , giadat ,Sum(ISNULL(SoLuong, 0)) AS KL from  dbo.lenhdat
		WHERE macp = @macp
			AND DAY(ngaydat) = DAY(@Ngay) AND MONTH(ngaydat) = MONTH(@Ngay) AND YEAR(ngaydat) = YEAR(@Ngay)
			AND loaigd = @LoaiGD AND soluong > 0
			group by macp ,  giadat 
			order by giadat desc
	ELSE 
		SET @OutCrsr = CURSOR KEYSET FOR 
		SELECT macp , giadat ,Sum(ISNULL(SoLuong, 0)) AS KL from dbo.lenhdat 
		WHERE macp = @macp
			AND DAY(ngaydat) = DAY(@Ngay) AND MONTH(ngaydat) = MONTH(@Ngay) AND YEAR(ngaydat) = YEAR(@Ngay)
			AND loaigd = @LoaiGD AND soluong > 0
			group by macp ,  giadat 
			order by giadat
	OPEN @OutCrsr 