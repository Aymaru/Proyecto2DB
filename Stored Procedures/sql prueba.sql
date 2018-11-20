USE `Proyecto2DB` ;

select a.idAccidente, p.nombre, c.nombre, d.nombre, a.dia, a.mes, a.anno, rol.descripcion, lesion.descripcion, a.edadAfectado, e.descripcion, a.sexo, u.latitud, u.longitud
from accidente a
inner join ubicacion u on (a.idUbicacion = u.idUbicacion)
inner join provincia p on (u.idProvincia = p.idProvincia)
inner join canton c on (u.idCanton = c.idCanton)
inner join distrito d on (u.idDIstrito = d.idDistrito)
inner join rolafectado rol on (a.idRolafectado = rol.idRolafectado)
inner join tipolesion lesion on (a.idTipolesion = lesion.idTipolesion)
inner join edadquinquenal e on (a.idEdadquinquenal = e.idEdadquinquenal)
where p.nombre = "San José" and c.nombre = "Pérez Zeledón" and d.nombre = "San Isidro del General" and a.anno = 2014;

select nombre as Provincia
from provincia;

select c.nombre as Canton
from ubicacion u
inner join provincia p on (u.idProvincia = p.idProvincia)
inner join canton c on (u.idCanton = c.idCanton)
where p.nombre = "San José"
group by c.nombre;

call getCantones("Limón");

select d.nombre as Distrito
from ubicacion u
inner join provincia p on (u.idProvincia = p.idProvincia)
inner join canton c on (u.idCanton = c.idCanton)
inner join distrito d on (u.idDistrito = d.idDistrito)
where p.nombre = "San José" and c.nombre = "Escazú"
group by d.nombre ;

call getDistritos("Limón","Siquirres");

select descripcion as TipoLesion
from tipolesion;

select descripcion as RolAfectado
from rolafectado;
select idEdadquinquenal,descripcion as EdadQuinquenal
from edadQuinquenal
order by descripcion;