CREATE DEFINER=`root`@`localhost` PROCEDURE `getRolesAfectado`()
BEGIN
select descripcion as RolAfectado
from rolafectado;
END