CREATE DEFINER=`root`@`localhost` PROCEDURE `consultaDashboard`(in anno_ini CHAR(45), 
                 in anno_fin CHAR(45), 
				 in provincia CHAR(45), 
                 in canton CHAR(45),
                 in distrito CHAR(45),
                 in sexo CHAR(45),
                 in tipo_lesion CHAR(45),
                 in rol_afectado CHAR(45),
                 in edad_quinquenal CHAR(45))
BEGIN

set @anno_ini = anno_ini;
set @anno_fin = anno_fin;
set @provincia = provincia;
set @canton = canton;
set @distrito = distrito;
set @sexo = sexo;
set @tipo_lesion = tipo_lesion;
set @rol_afectado = rol_afectado;
set @edad_quinquenal = edad_quinquenal;

set @query_ = "
select  count(a.idAccidente) as Cantidad, 
		p.nombre as Provincia, 
        c.nombre as Canton, 
        d.nombre as Distrito, 
        u.latitud as Latitud, 
        u.longitud as Longitud        
from accidente a
inner join ubicacion u on (a.idUbicacion = u.idUbicacion)
inner join provincia p on (u.idProvincia = p.idProvincia)
inner join canton c on (u.idCanton = c.idCanton)
inner join distrito d on (u.idDIstrito = d.idDistrito)
inner join rolafectado rol on (a.idRolafectado = rol.idRolafectado)
inner join tipolesion lesion on (a.idTipolesion = lesion.idTipolesion)
inner join edadquinquenal e on (a.idEdadquinquenal = e.idEdadquinquenal) 
where p.nombre = ifNull( ? , p.nombre) and
	  c.nombre = ifNUll( ? , c.nombre) and
      d.nombre = ifNull( ? , d.nombre) and
      a.sexo = ifNull( ? , a.sexo ) and 
      lesion.descripcion = ifNull( ? , lesion.descripcion ) and 
      rol.descripcion = ifNull( ? , rol.descripcion ) and
      e.descripcion = ifNull( ? ,e.descripcion ) ";


if anno_ini = "2012"  and  anno_fin = "2014" then    
    
    if not ( distrito is NULL ) then

        
        
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal;
	
		DEALLOCATE PREPARE stmt;

	elseif not ( canton is NULL ) then
    
        SET @query_ = CONCAT (@query_ , " group by d.nombre ");
        
        
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal;
	
		DEALLOCATE PREPARE stmt;
        
	elseif not ( provincia is NULL ) then
    
		SET @query_ = CONCAT (@query_ , " group by c.nombre ");
        
		
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal;
	
		DEALLOCATE PREPARE stmt;		
	
    else
		SET @query_ = CONCAT (@query_ , " group by p.nombre ");
        
		
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal;
	
		DEALLOCATE PREPARE stmt;	   
    
    
	end if;
    
else

	SET @query_ = CONCAT (@query_ , " and (a.anno = ? or a.anno = ? ) ");
     
     if not ( distrito is NULL ) then

        
        
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal, @anno_ini, @anno_fin;
	
		DEALLOCATE PREPARE stmt;

	elseif not ( canton is NULL ) then
    
        SET @query_ = CONCAT (@query_ , " group by d.nombre ");
        
        
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal, @anno_ini, @anno_fin;
	
		DEALLOCATE PREPARE stmt;
        
	elseif not ( provincia is NULL ) then
    
		SET @query_ = CONCAT (@query_ , " group by c.nombre ");
        
		
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal, @anno_ini, @anno_fin;
	
		DEALLOCATE PREPARE stmt;		
	
    else
		SET @query_ = CONCAT (@query_ , " group by p.nombre ");
        
		
		PREPARE stmt FROM @query_;
		EXECUTE stmt using @provincia, @canton, @distrito, @sexo, @tipo_lesion, @rol_afectado, @edad_quinquenal, @anno_ini, @anno_fin;
	
		DEALLOCATE PREPARE stmt;	   
    
    
	end if;


end if;



END