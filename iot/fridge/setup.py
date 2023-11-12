import sqlite3


con = sqlite3.connect("fridge.db")
cur = con.cursor()

cur.execute("CREATE TABLE user(username, password)")
cur.execute("INSERT INTO user VALUES ('root', 'root')")
con.commit()

cur.execute("CREATE TABLE ingredient(name, quantity, unit)")
cur.execute("""INSERT INTO ingredient VALUES
	('butter', 12, 'sticks'),
	('pumpkin pie', 1, 'pie'),
	('milk', 1.5, 'gallons'),
	('wine', 12, 'bottles'),
	('cream', 0.5, 'gallons')
""")
con.commit()


