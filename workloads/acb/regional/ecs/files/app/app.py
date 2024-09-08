import requests
from flask import Flask, request

app = Flask(__name__)

@app.route('/app', methods=['GET'])
def handle_app_request():
    # Return the response from the target endpoint
    return "backend service path /app", "200"

@app.route('/', methods=['GET'])
def handle_root_request():
    # Return the response from the target endpoint
    return "backend service path /", "200"

if __name__ == "__main__":
    app.run(debug=True)
