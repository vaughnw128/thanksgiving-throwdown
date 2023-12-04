import time
import threading
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from scapy.all import IP, ICMP, send
import subprocess

# Global variables
file_path = '/opt/freezer/temperature.dat'
min_range = -10
max_range = 2
block_ping = False

# Function to block ping responses using Scapy
def block_ping():
    global block_ping
    while True:
        if block_ping:
            subprocess.run(["uci", "add", "firewall", "rule"])
            subprocess.run(["uci", "set", "firewall.@rule[-1].name='BlockOutgoingEchoReplies'"])
            subprocess.run(["uci", "set", "firewall.@rule[-1].src='lan'"])
            subprocess.run(["uci", "set", "firewall.@rule[-1].proto='icmp'"])
            subprocess.run(["uci", "set", "firewall.@rule[-1].icmp_type='echo-reply'"])
            subprocess.run(["uci", "set", "firewall.@rule[-1].target='DROP'"])
            subprocess.run(["uci", "commit", "firewall"])
            subprocess.run(["/etc/init.d/firewall", "restart"])
            print("Outgoing ICMP echo replies blocked.")
            time.sleep(1)

        else:
            subprocess.run(["uci", "delete", "firewall.@rule[-1]"])
            subprocess.run(["uci", "commit", "firewall"])
            subprocess.run(["/etc/init.d/firewall", "restart"])
            print("Outgoing ICMP echo replies unblocked.")

# Function to handle file changes
class FileChangeHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path == file_path:
            check_temperature_range()

# Function to check if the temperature is within the specified range
def check_temperature_range():
    global block_ping

    try:
        with open(file_path, 'r') as file:
            data = file.read()
            temperature_value = int(data.strip())
            print(f"Current temperature value: {temperature_value}")

            if temperature_value < min_range or temperature_value > max_range:
                block_ping = True
            else:
                block_ping = False

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except ValueError:
        print("Error: The content of the file is not a valid integer.")

# Set up file monitoring
event_handler = FileChangeHandler()
observer = Observer()
observer.schedule(event_handler, path='.', recursive=False)
observer.start()

# Start the thread for blocking ping responses
ping_block_thread = threading.Thread(target=block_ping)
ping_block_thread.start()

# Run the script indefinitely
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()

observer.join()
