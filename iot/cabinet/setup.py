import json

with open('credentials.json', 'w') as f:
    json.dump({'root': 'root'}, f)