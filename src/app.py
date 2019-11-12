from flask import Flask, request, jsonify
app = Flask(__name__)


@app.route("/", methods=["GET", "POST"])
def handle_echo():
    if request.method == "GET":
        return jsonify({"received_headers": dict(request.headers)})
    else:
        # This won't technically break if no JSON is received in the request, it 
        # will just return "null"
        return jsonify({"received_body": request.json, "received_headers": dict(request.headers)})
