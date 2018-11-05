import xlrd
import pymysql
import os

# Open the workbook and define the worksheet
pathxls = "C:\\Users\\ayma-93\\Documents\\Semestre II - 2018\\Diseno de Software\\Tareas\\Proyecto2DB\\acc.xls"

#book = xlrd.open_workbook(os.getcwd()+"\\acc.xlsx")
#sheet = book.sheet_by_name("acc")

# Establish a MySQL connection
database = pymysql.connect (host='localhost', port =3307, user = 'root', password = 'root')#, database = 'proyecto2db' )

# Get the cursor, which is used to traverse the database, line by line
cursor = database.cursor()

# Create the INSERT INTO sql query
query = """INSERT INTO orders (product, customer_type, rep, date, actual, expected, open_opportunities, closed_opportunities, city, state, zip, population, region) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

print ("Conectado a la base de datos")

cursor.execute("SHOW DATABASES")
l = cursor.fetchall()
print (l)
l = [ i[0] for i in l ]



# Create a For loop to iterate through each row in the XLS file, starting at row 2 to skip the headers
##for r in range(1, sheet.nrows):
##		product		= sheet.cell(r,).value
##		customer	= sheet.cell(r,1).value
##		rep			= sheet.cell(r,2).value
##		date		= sheet.cell(r,3).value
##		actual		= sheet.cell(r,4).value
##		expected	= sheet.cell(r,5).value
##		open		= sheet.cell(r,6).value
##		closed		= sheet.cell(r,7).value
##		city		= sheet.cell(r,8).value
##		state		= sheet.cell(r,9).value
##		zip			= sheet.cell(r,10).value
##		pop			= sheet.cell(r,11).value
##		region	= sheet.cell(r,12).value
##
##		# Assign values from each row
##		values = (product, customer, rep, date, actual, expected, open, closed, city, state, zip, pop, region)
##
##		# Execute sql Query
##		cursor.execute(query, values)
##
### Close the cursor
cursor.close()

# Commit the transaction
#database.commit()

# Close the database connection
database.close()

### Print results
##print ""
##print ""
##print ""
