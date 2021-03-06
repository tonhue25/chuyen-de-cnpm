USE [chuyendecnpm]
GO
/****** Object:  Trigger [dbo].[TR_AfterInsert_lenhkhop]    Script Date: 08-May-22 8:06:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER  [dbo].[TR_AfterInsert_lenhkhop] 
   ON  [dbo].[lenhkhop] 
   after insert 
   as
declare @macp nchar(7)
begin
	set @macp = (select a.macp from lenhdat a, inserted b where a.id = b.idlenhdat)
	update dbo.banggiatructuyen 
	set giakl = (select giakhop from inserted),
		klkl = (select soluongkhop from inserted b),
		tongkl = tongkl + (select soluongkhop from inserted)
	where dbo.banggiatructuyen.id = @macp
end