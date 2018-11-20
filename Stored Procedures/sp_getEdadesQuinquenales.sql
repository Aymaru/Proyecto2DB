CREATE DEFINER=`root`@`localhost` PROCEDURE `getEdadesQuinquenales`()
BEGIN
select descripcion as EdadQuinquenal
from edadQuinquenal
order by descripcion;
END