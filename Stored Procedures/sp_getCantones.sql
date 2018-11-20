CREATE DEFINER=`root`@`localhost` PROCEDURE `getCantones`(in provincia CHAR(45) )
BEGIN

select c.nombre as Canton
from ubicacion u
inner join provincia p on (u.idProvincia = p.idProvincia)
inner join canton c on (u.idCanton = c.idCanton)
where p.nombre = provincia
group by c.nombre ;

END