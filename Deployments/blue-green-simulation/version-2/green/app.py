from flask import Flask, request

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        data = request.json
        print(f"Received POST data: {data}")
        return {"status": "success", "message": "Data received at green server\n"}, 200
    return {"message": "Hello from the green server!\n"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
