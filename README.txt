Migracion de base de datos de Excel a MySQL

Base de datos -> MySQL Server 8.0
Lenguaje -> Python 3.7

Instalar las siguientes librerias para python

xlrd
pymysql

Se pueden instalar desde el shell de windows

pip install xlrd
pip install pymysql

Es necesario tener agregado python en las variables de ambiente ( Esto se realiza en la instalacion o pueden hacerlo manualmente )

host = "localhost"
usuario = "root"
pwd = "root"
puerto = 3307

Es necesario que los archivos acc.xlsx y Lugares.xlsx se encuentren en la misma carpeta que el programa migrarBD_excel_a_mysql.py

Para crear la base de datos:

1. Abrir un query en MySQL
2. Abrir el script Proyecto2DB.sql
3. Ejecutar todo el query
4. Ejecutar el programa migrarBD_excel_a_mysql.py