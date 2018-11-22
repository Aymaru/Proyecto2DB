CREATE DEFINER=`root`@`localhost` PROCEDURE `consultaGrafica`(in tipoIdentificador CHAR(45), in anno_ini CHAR(45), in anno_fin CHAR(45), in identificador CHAR(45))
BEGIN

SET @identificador = identificador;

SET @query_ = 

	"select count(a.idAccidente) as Cantidad, a.anno as Anno
	from accidente a
	inner join ubicacion u on (a.idUbicacion = u.idUbicacion)
	inner join provincia p on (u.idProvincia = p.idProvincia)
	inner join canton c on (u.idCanton = c.idCanton)
	inner join distrito d on (u.idDIstrito = d.idDistrito)
	inner join rolafectado rol on (a.idRolafectado = rol.idRolafectado)
	inner join tipolesion lesion on (a.idTipolesion = lesion.idTipolesion)
	inner join edadquinquenal e on (a.idEdadquinquenal = e.idEdadquinquenal) ";

if tipoIdentificador = "SEXO" then

	SET @query_ = CONCAT (@query_ , " where a.sexo = ? ");

elseif tipoIdentificador = "TIPO_LESION" then

	SET @query_ = CONCAT (@query_ , " where lesion.descripcion = ? ");

elseif tipoIdentificador = "ROL_AFECTADO" then

	SET @query_ = CONCAT (@query_ , " where rol.descripcion = ? ");

elseif tipoIdentificador = "EDAD_QUINQUENAL" then

	SET @query_ = CONCAT (@query_ , " where e.descripcion = ? ");

end if;	


if anno_ini = "2012"  and  anno_fin = "2014" then
	
SET @query_ = CONCAT (@query_ , " group by a.anno ");
    
    select @query_;
    PREPARE stmt FROM @query_;
	EXECUTE stmt using @identificador;
	
    DEALLOCATE PREPARE stmt;
    
else

SET @query_ = CONCAT (@query_ , " and (a.anno = ? or a.anno = ? ) group by a.anno ");
     
    SET @anno_ini = anno_ini;
    SET @anno_fin = anno_fin;
    
    PREPARE stmt FROM @query_;
	EXECUTE stmt using @identificador, @anno_ini, @anno_fin;
    
	DEALLOCATE PREPARE stmt;

end if;








END