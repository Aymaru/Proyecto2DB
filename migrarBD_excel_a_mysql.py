import xlrd
import pymysql
import os

#Declaracion de variables globales

ubicaciones = []

provincia = {}
canton  = {}
distrito  = {}
rol = {}
lesion = {}
edad_quinquenal = {}


# Abrir archivo de excel y hoja de trabajo
def arreglarLatLong(latLong):
    return latLong.replace("°"," ").replace("\'"," ").replace("\"","").split(" ")


def toDecimal(latitud, longitud):
    lat = arreglarLatLong(latitud)
    long = arreglarLatLong(longitud)
    latlong = eliminarVacios([lat,long]) #eliminarVacios([lat,long])
    latlong = [toDecimalAux(lat),toDecimalAux(long)]
    return latlong

def toDecimalAux(latLong):
    signo = 1
    if ( latLong[0].startswith("-") ):
        signo = -1
    grados = int(latLong[0])
    minutos = int(latLong[1])
    segundos = int(latLong[2])

    return signo * (abs(grados)+ (minutos / 60.0) + (segundos / 3600.0))

def crearKey(provincia, canton, distrito):
    return list(estandarizar(provincia), estandarizar(canton), estandarizar(distrito))



def estandarizar(string):
    return string.upper().replace(" ","").split("(")[0]

def eliminarVacios(ubicacion):
    res = []
    for i in ubicacion:
        while '' in i:
            i.remove('')
        res.append(i)

    return res


def obtenerUbicacion(provincia, canton, distrito):
    global ubicacion
    for ubicacion in ubicaciones:
        if (ubicacion[0] == estandarizar(provincia) and ubicacion[1] == estandarizar(canton) and ubicacion[2] == estandarizar(distrito)):
            ubicacion[6] += 1
            return ubicacion
    return []


book2 = xlrd.open_workbook(os.getcwd()+"\\Lugares.xlsx")
sheet2 = book2.sheet_by_name("Lugares")


print("Leyendo del archivo Lugares.xls ...\n")
ID = 1
for r in range (1,sheet2.nrows):
    
    if sheet2.cell(r,0) == sheet2.show_zero_values:
        break
    latitud = str(sheet2.cell(r,3).value)
    longitud = str(sheet2.cell(r,4).value)
    latlong = toDecimal(latitud, longitud)
    ubicacion = [ estandarizar(sheet2.cell(r,0).value), estandarizar(sheet2.cell(r,1).value), estandarizar(sheet2.cell(r,2).value), latlong[0], latlong[1], ID ,0]
    ubicaciones.append(ubicacion)
    ID = ID + 1
    

print("Leyendo del archivo acc.xls...\n")

book = xlrd.open_workbook(os.getcwd()+"\\acc.xlsx")
sheet = book.sheet_by_name("acc")


for r in range (1,sheet.nrows):
    
    if sheet.cell(r,0) == sheet.show_zero_values:
        break    
    if not(sheet.cell(r,1).value in provincia):
        provincia[sheet.cell(r,1).value] = sheet.cell(r,2).value
    if not(sheet.cell(r,3).value in canton):
        canton[sheet.cell(r,3).value]  = len(canton) + 1
    if not(sheet.cell(r,4).value in distrito):
        distrito[sheet.cell(r,4).value] = len(distrito) + 1
    if not(sheet.cell(r,8).value in rol):
        rol[sheet.cell(r,8).value] = sheet.cell(r,9).value
    if not(sheet.cell(r,10).value in lesion):
        lesion[sheet.cell(r,10).value] = sheet.cell(r,11).value
    if not(sheet.cell(r,13).value in edad_quinquenal):
        edad_quinquenal[sheet.cell(r,13).value] = len(edad_quinquenal) + 1

provincia.pop('')
rol.pop('')
lesion.pop('')
canton.pop('')
distrito.pop('')
edad_quinquenal.pop('')


# Establecer conexión con MySQL
print ("Conectandose a la base de datos ...\n")
database = pymysql.connect (host='localhost', port =3307, user = 'root', password = 'root', database = 'proyecto2db')

print ("Conectado a la base de datos ...\n")

# Obtener el cursor que se utilizara para ingresar datos, linea por linea
cursor = database.cursor()

# Creación de querys e incersionces en la base de datos
print( "Insertando en tabla de provincia ... \n")
query = "INSERT INTO Provincia (idProvincia, nombre) VALUES (%s, %s)"

elementos = provincia.items()
for ID, nombre in elementos:
    values = (int(ID), nombre)
    cursor.execute(query, values)

print( "Insertando en tabla de canton ... \n")
query = "INSERT INTO Canton (idCanton, nombre) VALUES (%s, %s)"

for nombre, ID in canton.items():
    values = (int(ID), nombre)
    cursor.execute(query, values)

print( "Insertando en tabla de distrito ... \n")
query = "INSERT INTO Distrito (idDistrito, nombre) VALUES (%s, %s)"

for nombre,ID in distrito.items():
    values = (int(ID), nombre)
    cursor.execute(query, values)

print( "Insertando en tabla de rol ... \n")
query = "INSERT INTO RolAfectado (idRolAfectado, descripcion) VALUES (%s, %s)"

elementos = rol.items()
for ID, descripcion in elementos:
    values = (int(ID), descripcion)
    cursor.execute(query, values)

print( "Insertando en tabla de lesion ... \n")
query = "INSERT INTO TipoLesion (idTipoLesion, descripcion) VALUES (%s, %s)"

elementos = lesion.items()
for ID, descripcion in elementos:
    values = (int(ID), descripcion)
    cursor.execute(query, values)

print( "Insertando en tabla de edad quinquenal ... \n")
query = "INSERT INTO EdadQuinquenal (idEdadQuinquenal, descripcion) VALUES (%s, %s)"

for nombre,ID in edad_quinquenal.items():
    values = (int(ID), nombre)
    cursor.execute(query, values)

print( "Insertando en tabla de Ubicaciones ... \n")
query2 = "INSERT INTO Ubicacion (idUbicacion, idProvincia, idCanton, idDistrito, latitud, longitud) VALUES (%s, %s, %s, %s, %s, %s)"


print( "Insertando en tabla de accidente ... \n")
query = "INSERT INTO Accidente (idAccidente, idUbicacion, Dia, Mes, Anno, idRolAfectado, idTipoLesion, edadAfectado, idEdadQuinquenal, Sexo) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)" #{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}) " #(

ID = 1
IDerror = 1777777
for registro in range(1, sheet.nrows):    
    
    if sheet.cell(registro,1).value == '':
        break
    
    p = str(sheet.cell(registro,2).value)
    c = str(sheet.cell(registro,3).value)
    d = str(sheet.cell(registro,4).value)
    
    ub = obtenerUbicacion(p,c,d)
    
    if ub == []:
        idUbicacion = IDerror
        latitud = 0
        longitud = 0
        IDerror = IDerror + 1
        print(p+" "+c+" "+d + " hay que revisar formato")
    if ub != []:
        idUbicacion = ub[5]
        if ub[6] <= 1:
            latitud = ub[3]
            longitud = ub[4]
            idProvincia = int(sheet.cell(registro,1).value)    
            idCanton = int(canton.get(c))
            idDistrito = int(distrito.get(d))
    
            values = (idUbicacion, idProvincia, idCanton, idDistrito, latitud, longitud)
            cursor.execute(query2, values)
    
    idAccidente = int(ID)
    Dia = str(sheet.cell(registro,5).value)
    Mes = str(sheet.cell(registro,6).value)
    Anno = str(sheet.cell(registro,7).value).split(".")[0]
    idRolAfectado = int(sheet.cell(registro,8).value)
    idTipoLesion = int(sheet.cell(registro,10).value)
    edadAfectado = str(sheet.cell(registro,12).value)
    idEdadQuinquenal = int(edad_quinquenal.get(sheet.cell(registro,13).value))
    Sexo = str(sheet.cell(registro,15).value)
    
    values = (idAccidente, idUbicacion, Dia, Mes, Anno, idRolAfectado, idTipoLesion, edadAfectado, idEdadQuinquenal, Sexo)
    cursor.execute(query, values)
    ID = ID + 1

### Cerrar el cursor
cursor.close()

# Commit de la transación
database.commit()

print ("Cerrar conexion a la base de datos ...\n")
# Cerrar la conexión con la base de datos
database.close()

print ("Conexin cerrada ...\n")

print( "Migracion completada... \n")
