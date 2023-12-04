import json


with open('credentials.json', 'w') as f:
    json.dump({'root': 'root'}, f)

with open('temperature.dat', 'w') as f:
    f.write('350')

