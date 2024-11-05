from flask import Flask, redirect, render_template, request, session
from flask_session import Session

app = Flask(__name__)

app.config["SESSION_PERMANENT"] = False # This ensures that the session will be treated as a cookie: as soon as the browser is quit, memory will be eliminated
app.config["SESSION_TYPE"] = "filesystem" # This ensures that the contents of the shopping chart are stored in the server and not in the coolie for privacy safety
Session(app) # Activates session

@app.route("/")
def index():
    return render_template("index.html", name=session.get("name"))


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        session["name"] = request.form.get("name")
        return redirect("/")
    return render_template("login.html")


@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")
