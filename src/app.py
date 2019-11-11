from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def hello_world():
    if request.method == "GET":
        return jsonify({"received_headers": dict(request.headers)})
    else:
        return jsonify({"received_body": request.json, "received_headers": dict(request.headers)})
