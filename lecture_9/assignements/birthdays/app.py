import os

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///birthdays.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""

    # Caching is a process where data is stored temporarily to make future requests
    # for that data faster. In the context of web applications, caching means storing
    # copies of web pages or resources (like images, scripts, etc.) in the browser
    # so that they can be quickly loaded without needing to be fetched from the server
    # again. This can improve performance but might show outdated content if the server
    # has updated the data. The code you shared prevents this by ensuring the browser
    # always fetches the latest content from the server.

    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/", methods=["GET", "POST"])
def index():
    # Add the user's entry into the database
    if request.method == "POST":

        # Validate name submission
        name = request.form.get("name")
        if not name:
            return redirect("/") # render_template("error.html", message="Missing name.")

        # Validate month submission
        month = request.form.get("month")
        if not month:
            return redirect("/") # render_template("error.html", message="Missing month.")
        try:
            month = int(month)
        except ValueError:
            return redirect("/") # render_template("error.html", message="Invalid month.")
        if month < 1 or month > 12:
            return redirect("/") # render_template("error.html", message="Invalid month.")

        # Validate day submission
        day = request.form.get("day")
        if not day:
            return redirect("/") # render_template("error.html", message="Missing day.")
        try:
            day = int(day)
        except ValueError:
            return redirect("/") # render_template("error.html", message="Invalid day.")
        if day < 1 or day > 31:
            return redirect("/") # render_template("error.html", message="Invalid day.")

        # Store the entrry in the database
        db.execute("INSERT INTO birthdays (name, month, day) VALUES (?, ?, ?)", name, month, day)
        return redirect("/")

    # Display the entries in the database on index.html
    else:
        birthdays = db.execute("SELECT * FROM birthdays")
        return render_template("index.html", birthdays=birthdays)


@app.route("/eliminate", methods=["POST"])
def eliminate():
    id = request.form.get("id")
    if id:
        db.execute("DELETE FROM birthdays WHERE id = ?", id)
    return redirect("/")

