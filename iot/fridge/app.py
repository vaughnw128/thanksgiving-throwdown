import sqlite3
from flask import Flask, redirect, render_template, request, session
import os


app = Flask(__name__)


def open_server():
	con = sqlite3.connect('fridge.db')
	cur = con.cursor()
	return con, cur


@app.route("/login", methods=['GET', 'POST'])
def login():
	if request.method == 'POST':
		con, cur = open_server()
		res = cur.execute(f"SELECT * FROM user WHERE username LIKE '{request.form['username']}' AND password LIKE '{request.form['password']}'")
		res = res.fetchone()
		con.close()
		if res is None:
			return redirect("/failure")
		else:
			session['user'] = request.form['username']
			return redirect("/")
	else:
		return """<form action="/login" method="POST">
			<h1>Login</h1>
			<p>username</p><input type="text" value="" placeholder="username" name="username"><br>
			<p>password</p><input type="password" value="" placeholder="password" name="password"><br>
			<input type="submit" value="Log in" class="btn">
			</form>"""


@app.route("/")
def hello_world():
	if not session.get('user'):
		return 'Please <a href="/login">log in</a>'
	else:
		return """Options:<br>
			<a href="/ingredients">View ingredients</a><br>
			<a href="/add_ingredient">Add ingredient</a><br>
			<a href="/del_ingredient">Remove ingredient</a><br>
			<a href="/password">Change Password</a><br>
			<a href="/add_user">Add user</a><br>
			<a href="/del_user">Remove User</a><br>
			<a href="/logout">Log out</a>"""


@app.route("/failure")
def failure():
	return 'Access denied. Please <a href="/login">log in</a>'


@app.route("/logout")
def logout():
	session['user'] = None
	return redirect("/")


@app.route("/password", methods=['POST', 'GET'])
def change_password():
	if not session.get('user'):
		return redirect("/failure")
	elif request.method == 'POST':
		con, cur = open_server()
		res = cur.execute(f"SELECT * FROM user WHERE username LIKE '{session.get('user')}' AND password LIKE '{request.form['password']}'")
		res = res.fetchone()
		if res is None or request.form['new_pass'] != request.form['new_pass_again']:
			con.close()
			return 'Failed to update password<br><a href="/">Home</a>'
		else:
			cur.execute(f"UPDATE user SET password = '{request.form['new_pass']}' WHERE username LIKE '{session.get('user')}'")
			con.commit()
			con.close()
			return 'Password updated successfully<br><a href="/">Home</a>'	
	else:
		return """<form action="/password" method="POST">
			<h1>Change Password</h1>
			<p>password</p><input type="password" value="" placeholder="password" name="password"><br>
			<p>new password</p><input type="password" value="" placeholder="new password" name="new_pass"><br>
			<p>new password again</p><input type="password" value="" placeholder="new password again" name="new_pass_again"><br>
			<input type="submit" value="Change" class="btn">
			</form>"""


@app.route("/add_user", methods=['POST', 'GET'])
def add_user():
	if not session.get('user'):
		return redirect("/failure")
	elif request.method == 'POST':
		con, cur = open_server()
		cur.execute(f"INSERT INTO user VALUES ('{request.form['username']}', '{request.form['password']}')")
		con.commit()
		con.close()
		return 'User added<br><a href="/">Home</a>'
	else:
		return """<form action="/add_user" method="POST">
			<h1>Add User</h1>
			<p>username</p><input type="text" value="" placeholder="username" name="username"><br>
			<p>password</p><input type="password" value="" placeholder="password" name="password"><br>
			<input type="submit" value="Add User" class="btn">
			</form>"""


@app.route("/del_user", methods=['POST', 'GET'])
def del_user():
	if not session.get('user'):
		return redirect("/failure")
	elif request.method == 'POST':
		con, cur = open_server()
		cur.execute(f"DELETE FROM user WHERE username LIKE '{request.form['username']}'")
		con.commit()
		con.close()
		if request.form['username'] == session.get('user'):
			return redirect("/logout")
		else:
			return 'User deleted successfully<br><a href="/">Home</a>'
	else:
		return """<form action="/del_user" method="POST">
			<h1>Delete User</h1>
			<p>username</p><input type="text" value="" placeholder="username" name="username"><br>
			<input type="submit" value="Delete User" class="btn">
			</form>"""
			


@app.route("/ingredients")
def ingredients():
	con, cur = open_server()
	res = cur.execute("SELECT * FROM ingredient")
	res = res.fetchall()
	con.close()
	html = '<table>\n'
	for r in res:
		html += f'<tr><td>{r[0]}</td><td>{r[1]}</td><td>{r[2]}</td></tr>\n'
	html += '</table><br><a href="/">Home</a>'
	return html


@app.route("/add_ingredient", methods=["POST", "GET"])
def add_ingredient():
	if not session.get('user'):
		return redirect("/failure")
	elif request.method == 'POST':
		con, cur = open_server()
		cur.execute(f"INSERT INTO ingredient VALUES ('{request.form['name']}', {request.form['quantity']}, '{request.form['unit']}')")
		con.commit()
		con.close()
		return 'Ingredient added successfully<br><a href="/ingredients">Ingredients</a><br><a href="/">Home</a>'
	else:
		return """<form action="/add_ingredient" method="POST">
			<h1>Add Ingredient</h1>
			<p>name</p><input type="text" value="" placeholder="name" name="name">
			<p>quantity</p><input type="text" value="" placeholder="quantity" name="quantity">
			<p>unit</p><input type="text" value="" placeholder="unit" name="unit">
			<input type="submit" value="Add Ingredient" class="btn">
			</form>"""


@app.route("/del_ingredient", methods=["POST", "GET"])
def del_ingredient():
	if not session.get('user'):
		return redirect("/failure")
	elif request.method == 'POST':
		con, cur = open_server()
		cur.execute(f"DELETE FROM ingredient WHERE name LIKE '{request.form['name']}'")
		con.commit()
		con.close()
		return 'Ingredient deleted successfully<br><a href="/ingredients">Ingredients</a><br><a href="/">Home</a>'
	else:
		return """<form action="/del_ingredient" method="POST">
			<h1>Delete Ingredient</h1>
			<p>name</p><input type="text" value="" placeholder="name" name="name"><br>
			<input type="submit" value="Delete Ingredient" class="btn">
			</form>"""
			


if __name__ == '__main__':
	app.secret_key = os.urandom(12)
	app.run(host='0.0.0.0', port=80, debug=False)


