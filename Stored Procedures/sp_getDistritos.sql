CREATE DEFINER=`root`@`localhost` PROCEDURE `getDistritos`(in provincia CHAR(45), in canton CHAR(45))
BEGIN
	
	select d.nombre as Distrito
	from ubicacion u
	inner join provincia p on (u.idProvincia = p.idProvincia)
	inner join canton c on (u.idCanton = c.idCanton)
    inner join distrito d on (u.idDistrito = d.idDistrito)
	where p.nombre = provincia and c.nombre = canton
	group by d.nombre ;

END