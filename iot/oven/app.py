import requests
from flask import Flask, request, jsonify
app = Flask(__name__)


@app.route('/docs')
def docs():
   return

@app.route('/api/status')
def status():
   return jsonify({'status': 'operational'})

if __name__ == '__main__':
   app.run(debug=False, host='0.0.0.0')