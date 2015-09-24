CREATE FUNCTION [dbo].[ufn_ReplaceTextQualifiers] 
( @pText AS VARCHAR(MAX), @pTextQualifier AS CHAR(1), @pReplacementQualifier AS VARCHAR(1) = '')
RETURNS VARCHAR(MAX) 
AS
BEGIN
   --Text qualifiers only come in pairs and are located at beginning and end of text
   DECLARE @vReturnValue VARCHAR(MAX)
   
   DECLARE @vBeginningTextQualifierPos INT
   DECLARE @vEndingTextQualifierPos INT
   
   SET @vReturnValue = @pText
   IF (('>' + LEFT(@pText, 1) + '<' = '>' + @pTextQualifier + '<')  AND ('>' + RIGHT(@pText, 1) + '<' = '>' + @pTextQualifier + '<'))
   BEGIN
      SET @vReturnValue = @pReplacementQualifier + SUBSTRING(@pText, 2, LEN(@pText + '*')-3 ) + @pReplacementQualifier
   END
   
   RETURN(@vReturnValue)
END   
