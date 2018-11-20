CREATE DEFINER=`root`@`localhost` PROCEDURE `getTiposLesion`()
BEGIN
select descripcion as TipoLesion
from tipolesion;
END