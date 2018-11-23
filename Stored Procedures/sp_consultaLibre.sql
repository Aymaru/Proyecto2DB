CREATE DEFINER=`root`@`localhost` PROCEDURE `consultaLibre`(in anno_ini CHAR(45), in anno_fin CHAR(45), in provincia CHAR(45))
BEGIN

set @anno_ini = anno_ini;
set @anno_fin = anno_fin;
set @provincia = provincia;

set @query_ = "
select  count(a.idAccidente) as Cantidad, 
        lesion.descripcion as Lesion       
from accidente a
inner join ubicacion u on (a.idUbicacion = u.idUbicacion)
inner join provincia p on (u.idProvincia = p.idProvincia)
inner join canton c on (u.idCanton = c.idCanton)
inner join distrito d on (u.idDIstrito = d.idDistrito)
inner join rolafectado rol on (a.idRolafectado = rol.idRolafectado)
inner join tipolesion lesion on (a.idTipolesion = lesion.idTipolesion)
inner join edadquinquenal e on (a.idEdadquinquenal = e.idEdadquinquenal) 
where p.nombre = ?";


if anno_ini = "2012"  and  anno_fin = "2014" then
	
SET @query_ = CONCAT (@query_ , " group by lesion.descripcion, p.nombre order by lesion.descripcion");
    
    PREPARE stmt FROM @query_;
	EXECUTE stmt using @provincia;
	
    DEALLOCATE PREPARE stmt;
    
else

SET @query_ = CONCAT (@query_ , " and (a.anno = ? or a.anno = ? ) group by lesion.descripcion, p.nombre order by lesion.descripcion");
     

    PREPARE stmt FROM @query_;
	EXECUTE stmt using @provincia, @anno_ini, @anno_fin;
    
	DEALLOCATE PREPARE stmt;

end if;

END