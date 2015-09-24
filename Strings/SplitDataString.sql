CREATE FUNCTION [dbo].[ufn_SplitDataString] 
( @pStringToParse AS VARCHAR(MAX), @pDelimiter AS CHAR(1), @pTextQualifier AS CHAR(1), @pExcludeEmpty AS BIT = 0)
RETURNS @ParsedStringTable TABLE 
( [ID] BIGINT, [Value] VARCHAR(MAX) )
AS
BEGIN
   
   DECLARE @vParsedString VARCHAR(MAX)
   DECLARE @vFoundPos BIGINT
   DECLARE @vSubStartPos BIGINT
   DECLARE @vIndex BIGINT
   
   SET @vFoundPos = 0
   SET @vSubStartPos = 1
   SET @vIndex = 0
   
   DO: 
      
      SET @vFoundPos = ISNULL(CHARINDEX( @pDelimiter, @pStringToParse, @vFoundPos + 1), 0)
      
      --SET @vParsedString = SUBSTRING(@pStringToParse, @vSubStartPos, CASE @vFoundPos WHEN 0 THEN LEN(@pStringToParse + '*') -1  ELSE @vFoundPos - @vSubStartPos END ) 
      SET @vParsedString = SUBSTRING(@pStringToParse, @vSubStartPos, COALESCE(NULLIF(@vFoundPos, 0), LEN(@pStringToParse + '*'))-@vSubStartPos) 
      
      --verfiy if string has non terminated text qualifier
      IF ((@pTextQualifier = SUBSTRING(@vParsedString, 1, 1)) AND (@pTextQualifier <> SUBSTRING(@vParsedString, LEN(@vParsedString + '*')-1, 1)))
            --AND ((LEN(@vParsedString + '*') - LEN(REPLACE(@vParsedString, @pTextQualifier, '') + '*')) % 2 <> 0)
            AND @vFoundPos > 0
         GOTO DO
      
      IF (ISNULL(@pExcludeEmpty, 0) = 0 OR LEN(ISNULL(@vParsedString, '') + '*') -1 > 0)
      BEGIN
         SET @vIndex = @vIndex + 1
         INSERT 
           INTO @ParsedStringTable 
         VALUES ( @vIndex, @vParsedString )
      END
      
      SET @vSubStartPos = @vFoundPos + 1
      IF (@vFoundPos > 0) 
         GOTO DO
         
   RETURN
END
