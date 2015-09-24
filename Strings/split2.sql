SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
    @String NVARCHAR(MAX),
    @Delimiter NCHAR(1)
)
RETURNS TABLE 
AS
RETURN 
(
    WITH Split(stpos,endpos) 
    AS(
        SELECT CAST(0 AS BIGINT) AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT CAST(endpos+1 AS BIGINT), CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String + ''''))-stpos)
        --'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String + '''')+1)-stpos)
    FROM Split
)
