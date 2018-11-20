CREATE DEFINER=`root`@`localhost` PROCEDURE `getProvincias`()
BEGIN

select nombre as Provincia
from provincia;

END