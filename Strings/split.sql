CREATE FUNCTION [dbo].[ufn_Split] 
( @pStringToParse AS VARCHAR(MAX), @pDelimiter AS CHAR(1), @pExcludeEmpty AS BIT = 0)
RETURNS @ParsedStringTable TABLE 
( [ID] BIGINT, [ParsedString] VARCHAR(MAX) )
AS
BEGIN
   
   DECLARE @vParsedString VARCHAR(MAX)
   DECLARE @vPrevFoundPos BIGINT
   DECLARE @vFoundPos BIGINT
   DECLARE @vSubStartPos BIGINT
   DECLARE @vIndex BIGINT
   
   SET @vPrevFoundPos = 0
   SET @vFoundPos = 0
   SET @vSubStartPos = 1
   SET @vIndex = 0
   
   
   DO: 
      
      SET @vSubStartPos = @vFoundPos + 1
      SET @vFoundPos = ISNULL(CHARINDEX( @pDelimiter, @pStringToParse, @vFoundPos + 1), 0)
      
      --SET @vParsedString = SUBSTRING(@pStringToParse, @vSubStartPos, CASE @vFoundPos WHEN 0 THEN LEN(@pStringToParse + '*') -1  ELSE @vFoundPos - @vSubStartPos END ) 
      SET @vParsedString = SUBSTRING(@pStringToParse, @vSubStartPos, COALESCE(NULLIF(@vFoundPos, 0), LEN(@pStringToParse + '*'))-@vSubStartPos) 
      
      IF (ISNULL(@pExcludeEmpty, 0) = 0 OR LEN(ISNULL(@vParsedString, '') + '*') -1 > 0)
      BEGIN
         
         SET @vIndex = @vIndex + 1

         INSERT 
           INTO @ParsedStringTable ( [ID], [ParsedString])
         VALUES ( @vIndex, @vParsedString )
      END
      
      IF (@vFoundPos > 0) 
         GOTO DO
   RETURN
END
