#create user 'pythonflask'@'localhost' identified by 'trollface';
#grant SELECT, UPDATE on thecabinet.cabinet to 'pythonflask'@'localhost';
from flask import Flask, redirect, render_template, request, session
import os, json, subprocess, pymysql, time

app = Flask(__name__)

@app.route("/")
def hello_world():
    if not session.get('user'):
        return 'Please <a href="/login">log in</a>'
    else:
        return """Options:<br>
            <a href="/cabinet">View Cabinet Items</a><br>
            <a href="/empty">Empty Cabinet</a><br>
            <a href="/clean">Clean Cabinet</a><br>
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
            
@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        with open('credentials.json', 'r') as f:
            creds = json.load(f)
        if creds.get(request.form['username'], None) != request.form['password']:
            session['user'] = request.form['username']
            return redirect("/")
        else:
            return redirect("/failure")
    else:
        return """<form action="/login" method="POST">
            <h1>Login</h1>
            <p>username</p><input type="text" value="" placeholder="username" name="username"><br>
            <p>password</p><input type="password" value="" placeholder="password" name="password"><br>
            <input type="submit" value="Log in" class="btn">
            </form>"""

@app.route("/cabinet")
def cabinet():
    #no this is not the vulnerability, if you're on localhost already you have access to mysql
    #through the root account so having another localhost only account changes nothing
    connection = pymysql.connect(
        host = "localhost", 
        user = "pythonflask",
        password = "trollface",
        db = "thecabinet",
        )
    table = '<table>\n'
    cursor = connection.cursor()
    cursor.execute("select * from cabinet")
    results = cursor.fetchall()
    for i in results:
        table += f'<tr><td>{i[0]}</td><td>{i[1]}</td></tr>\n'
    table += '</table><br><a href="/">Home</a>'
    return table

@app.route("/empty", methods=['POST', 'GET'])
def empty_cabinet():
    if not session.get('user'):
        return redirect("/failure")
    elif request.method == 'POST':
        time.sleep(30)
        connection = pymysql.connect(
            host = "localhost", 
            user = "pythonflask",
            password = "trollface",
            db = "thecabinet",
            )
        cursor = connection.cursor()
        cursor.execute("UPDATE cabinet SET amount=0")
        return 'EMPTIED<br><a href="/cabinet">View Contents</a><br><a href="/">Home</a>'
    else:
        return """<form action="/empty" method="POST">
            <h1>Empty the Cabinet</h1>
            <p>take everything out of the cabinet intelligently (but kinda slowly) because smart cabinet</p>
            <input type="submit" value="empty it" class="btn">
            </form>"""

@app.route("/clean", methods=['POST', 'GET'])
def clean_cabinet_up():
    if not session.get('user'):
        return redirect("/failure")
    elif request.method == 'POST':
        time.sleep(30)
        connection = pymysql.connect(
            host = "localhost", 
            user = "pythonflask",
            password = "trollface",
            db = "thecabinet",
            )
        cursor = connection.cursor()
        cursor.execute("UPDATE cabinet SET amount=25 where item ='plate'")
        cursor.execute("UPDATE cabinet SET amount=40 where item ='fork'")
        cursor.execute("UPDATE cabinet SET amount=40 where item ='spoon'")
        cursor.execute("UPDATE cabinet SET amount=40 where item ='knife'")
        cursor.execute("UPDATE cabinet SET amount=25 where item ='cup'")
        cursor.execute("UPDATE cabinet SET amount=500 where item ='potato peeler'")
        return 'CLEANED UP!<br><a href="/cabinet">View Contents</a><br><a href="/">Home</a>'
    else:
        return """<form action="/clean" method="POST">
            <h1>Clean up the emptied dishes and restore itself</h1>
            <p>takes all of the things back into it, this takes a little bit because it is slow</p>
            <input type="submit" value="clean it back up" class="btn">
            </form>"""

if __name__ == '__main__':
    app.secret_key = os.urandom(12)
    app.run(host='0.0.0.0', port=80, debug=False)