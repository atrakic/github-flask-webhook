import os
from ghwebhook import verify_signature, checkoutAndDeploy
from flask import Flask, request, jsonify, abort, Response

app = Flask(__name__)

secret = os.environ["API_SECRET"] or die()


@app.route("/")
def index():
    return "hello"


@app.route("/webhook", methods=["POST"])
def webhook():
    """Callback"""
    if not verify_signature(request, secret):
        return jsonify(message="Invalid auth", status=401)

    content = request.json
    try:
        repo_dir = content["repository"]["full_name"]
        repo = content["repository"]["url"]
        branch = content["ref"].partition("refs/heads/")[2]
        checkoutAndDeploy(repo, repo_dir)
    except KeyError as e:
        raise ValidationError("Invalid request " + e.args[0])
        error_message = dumps({"Message": "Cannot use this request"})
        abort(Response(error_message, 401))

    return jsonify(message="success", status=200)


@app.route("/echo", methods=["POST"])
def echo():
    return jsonify(request.json)


if __name__ == "__main__":
    app.run()
