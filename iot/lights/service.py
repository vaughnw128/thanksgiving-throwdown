import socket
import subprocess
import crypt
import os
import threading

TEMP_FILE = "temperature.dat"

def authenticate(username, password):
    try:
        # Retrieve the hashed password from /etc/shadow
        hashed_password = subprocess.check_output(['grep', f'^{username}:', '/etc/shadow'], text=True).split(':')[1].strip()

        # Verify the password
        return crypt.crypt(password, hashed_password) == hashed_password
    except subprocess.CalledProcessError:
        return False

def execute_command(command):
    if command == "help":
        return "Available commands: help, add_user, list_users, list_temp, exit"
    elif command == "list_temp":
        with open(TEMP_FILE, 'r') as temp_file:
            return f"Current temperature: {temp_file.read().strip()}"
    elif command == "list_users":
        return subprocess.run(['cut', '-d:', '-f1', '/etc/passwd'], capture_output=True, text=True).stdout
    elif command.startswith("add_user "):
        _, new_username, new_password = command.split()

        # Add the user to the system
        try:
            subprocess.run(['sudo', 'useradd', '-m', '-p', new_password, new_username], check=True)
            return f"User '{new_username}' added to the system."
        except subprocess.CalledProcessError as e:
            return f"Error adding user '{new_username}' to the system: {e}"

    else:
        return "Unknown command. Type 'help' for available commands."

def start_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('localhost', 1621))
    server_socket.listen(1)
    print("Server listening on port 1621...")

    while True:
        client_socket, client_address = server_socket.accept()
        print(f"Connection from {client_address}")

        # Authentication
        auth_data = client_socket.recv(1024).decode('utf-8').split()
        if len(auth_data) == 2 and authenticate(auth_data[0], auth_data[1]):
            client_socket.send("Authentication successful. Enter commands:".encode('utf-8'))
            threading.Thread(target=handle_client, args=(client_socket,)).start()
        else:
            client_socket.send("Authentication failed. Closing connection.".encode('utf-8'))
            client_socket.close()

def handle_client(client_socket):
    while True:
        data = client_socket.recv(1024).decode('utf-8')
        if not data:
            break

        if data.strip().lower() == "exit":
            client_socket.send("Connection closed. Type 'exit' again to exit server.".encode('utf-8'))
            break

        response = execute_command(data)
        client_socket.send(response.encode('utf-8'))

    client_socket.close()

if __name__ == "__main__":
    open(TEMP_FILE, 'a').close()

    # Ensure the script is run with sudo for required permissions
    if os.geteuid() != 0:
        print("Error: This script requires root privileges. Please run with sudo.")
        exit(1)

    # Write initial temperature value to the file
    with open(TEMP_FILE, 'w') as temp_file:
        temp_file.write("25")

    start_server()
