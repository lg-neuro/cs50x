import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Custom filter (it makes it easier to format values as US dollars)
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")


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


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    # Get all the current user's stocks
    try:
        stocks = db.execute(
            "SELECT symbol, SUM(shares) as total_shares FROM trades WHERE user_id = ? GROUP BY symbol HAVING total_shares > 0", session["user_id"])
        # if len(stocks) < 1:
        # return apology("no completed trade", 400)
    except ValueError:
        return apology("trades not available", 400)

    # Store the current price for each user's stock in the stock dictionaries list
    for stock in stocks:

        # Fetch the current stock's price from the API
        current_price = lookup(stock["symbol"])
        if current_price is None:
            return apology("one or more invalid stock symbols", 400)

        stock["price"] = current_price["price"]

        # Store also the total value of each stocks in the stock dictionaries list
        stock["total_value"] = stock["total_shares"] * current_price["price"]

    # Calculate cash remaining to the user and store it as a float
    try:
        cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
    except ValueError:
        return apology("user cash not available", 400)
    cash = float(cash[0]["cash"])

    # Calculate total user's assets value (stock with current price and cash)
    total_assets = sum(stock["total_value"] for stock in stocks) + cash

    return render_template("index.html", stocks=stocks, cash=cash, total_assets=total_assets)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Check if user inputs a symbol
        symbol = request.form.get("symbol")
        if not symbol:
            return apology("missing symbol", 400)

        # Check if user inputs shares
        shares = request.form.get("shares")
        if not shares:
            return apology("missing shares", 400)
        try:
            shares = int(shares)
            if shares < 1:
                return apology("invalid shares number", 400)
        except ValueError:
            return apology("invalid shares", 400)

        # Fetch stock symbol and price trhough API
        stock = lookup(symbol)
        if stock is None:
            return apology("invalid symbol", 400)

        # If stock exists proceed to buy
        if stock:

            # Calculate total cost
            purchase = shares * stock["price"]

            # Calculate user's balance after trade
            try:
                cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
            except ValueError:
                return apology("User cash not available", 400)
            user_cash = float(cash[0]["cash"])
            balance = user_cash - purchase

            # If balance is positive
            if balance > 0:
                try:
                    # Ensure atomicity, so both commands are executed in a single transaction
                    db.execute("BEGIN TRANSACTION")

                    # Store the trade in trades table
                    db.execute("INSERT INTO trades (user_id, symbol, shares, price, timestamp) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)",
                               session["user_id"], stock["symbol"], shares, stock["price"])

                    # Update user's assets
                    db.execute("UPDATE users SET cash = ? WHERE id = ?",
                               balance, session["user_id"])

                    db.execute("COMMIT")
                except ValueError:
                    db.execute("ROLLBACK")
                    return apology("failed transaction", 400)

                # Flash message to confirm buy
                flash(
                    f"Bought {shares} shares of {stock["name"]} ({stock["symbol"]}) for {usd(purchase)}!")
                return redirect("/")

            # Return error if balance is negative
            else:
                return apology("can't afford", 400)

        # Return error if stock doesn't exist
        else:
            return apology("invalid symbol", 400)

    # User reached route via GET (as by submitting a form via GET or redirecting)
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""

    # Fetch all the past user's trades
    try:
        trades = db.execute(
            "SELECT timestamp, symbol, shares, price FROM trades WHERE user_id = ?", session["user_id"])
        # if len(trades) < 1:
        # return apology("no completed trade", 400)
    except ValueError:
        return apology("trades not available", 400)

    return render_template("history.html", trades=trades)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("missing username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("missing password", 403)

        # Query database for username
        try:
            rows = db.execute(
                "SELECT * FROM users WHERE username = ?", request.form.get("username")
            )
        except ValueError:
            return apology("user not available", 403)

        # Ensure username exists (and it is unique) and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["hash"], request.form.get("password")
        ):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page and flash message to confirm it
        flash("Logged in!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Check if user inputs text
        symbol = request.form.get("symbol")

        if not symbol:
            return apology("missing symbol", 400)

        # Return stock symbol and price
        stock = lookup(symbol)

        if stock:
            return render_template("quoted.html", stock=stock)

        # Return error if no stock
        else:
            return apology("invalid symbol", 400)

    # User reached route via POST (as by submitting a form via GET or redirect)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Validate the username
        username = request.form.get("username")
        if not username:
            return apology("must provide username", 400)
        if len(db.execute("SELECT username FROM users WHERE username = ?", username)) > 0:
            return apology("username already exists", 400)

        # Validate password and confirmation
        password = request.form.get("password")
        if not password:
            return apology("must provide password", 400)
        if password != request.form.get("confirmation"):
            return apology("password does not match confirmation", 400)

        # Insert the new user into users, storing a hash of the user’s password, not the password itself.
        password = generate_password_hash(password)
        db.execute("INSERT INTO users (username, hash) VALUES (?, ?)", username, password)

        # Remember which user has logged in
        user = db.execute("SELECT id FROM users WHERE username = ?", username)
        session["user_id"] = int(user[0]["id"])

        # Flash message to confirm registration
        flash("Registered!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""

    # Get all user's stocks shares from the trades database (to display them on the screen)
    try:
        owned_stocks = db.execute(
            "SELECT symbol, SUM(shares) as total_shares FROM trades WHERE user_id = ? GROUP BY symbol HAVING total_shares > 0", session["user_id"])
    except ValueError:
        return apology("no stocks to sell", 400)

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Recover the selected symbol
        symbol = request.form.get("symbol")
        if symbol is None:
            return apology("missing stocks", 400)

        # Recover the share number
        shares = int(request.form.get("shares"))
        if shares is None:
            return apology("missing shares", 400)
        if shares < 1 or shares is ValueError:
            return apology("invalid shares", 400)

        # Find the first stock with the matching symbol and give me its total shares. If there's no match, return None.
        stock_total_shares = next((stock['total_shares']
                                  for stock in owned_stocks if stock['symbol'] == symbol), None)

        # If the shares to sell do not exceed the owned shares proceed to sell
        if stock_total_shares >= shares:

            # Fetch the stock latest price
            stock = lookup(symbol)
            if stock is None:
                return apology("invalid symbol", 400)

            try:
                cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
            except ValueError:
                return apology("User cash not available", 400)

            sale = stock["price"] * shares

            balance = cash[0]["cash"] + sale

            try:
                # Ensure atomicity, so both commands are executed in a single transaction
                db.execute("BEGIN TRANSACTION")

                # Store the trade in trades table
                db.execute("INSERT INTO trades (user_id, symbol, shares, price, timestamp) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)",
                           session["user_id"], stock["symbol"], -shares, stock["price"])

                # Update user's assets
                db.execute("UPDATE users SET cash = ? WHERE id = ?", balance, session["user_id"])

                db.execute("COMMIT")

                # Flash message to confirm sell
                flash(f"Sold {shares} shares of {symbol} for {usd(sale)}!")
                return redirect("/")

            except Exception as e:
                db.execute("ROLLBACK")
                print(f"Transaction failed: {e}")
                return apology("failed transaction", 400)
            return redirect("/")
        else:
            return apology("too many shares", 400)

    # User reached route via GET (as by submitting a form via GET or redirecting)
    else:
        return render_template("sell.html", stocks=owned_stocks)


@app.route("/password", methods=["GET", "POST"])
@login_required
def password():

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure old password is correct
        old_password = request.form.get("old_password")
        if not old_password:
            return apology("missing old password", 403)
        try:
            password = db.execute("SELECT hash FROM users WHERE id = ?", session["user_id"])
            if len(password) != 1 or not check_password_hash(
                password[0]["hash"], old_password
            ):
                return apology("invalid password", 403)
        except ValueError:
            return apology("impossible to retrieve password", 403)

        # Validate password and confirmation
        new_password = request.form.get("new_password")
        if not new_password:
            return apology("missing new password", 403)
        if new_password != request.form.get("confirmation"):
            return apology("password does not match confirmation", 403)

        # Update the new user's password, storing it as an hash of the user’s new password (not the password itself).
        new_password = generate_password_hash(new_password)
        try:
            db.execute("UPDATE users SET hash = ? WHERE username = ?",
                       new_password, session["user_id"])
        except ValueError:
            return apology("impossible to change password", 400)

        # Flash message to confirm registration
        flash("Password has been changed!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("password.html")


@app.route("/deposit", methods=["GET", "POST"])
@login_required
def deposit():
    """Sell shares of stock"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Recover deposit amount
        deposit = float(request.form.get("deposit"))
        if deposit is None:
            return apology("missing deposit", 400)
        if deposit <= 0 or deposit is ValueError:
            return apology("invalid deposit", 400)

        try:
            current_cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
        except ValueError:
            return apology("user cash not available", 400)

        new_cash = current_cash[0]["cash"] + deposit

        try:
            db.execute("UPDATE users SET cash = ? WHERE id = ? ", new_cash, session["user_id"])
        except ValueError:
            return apology("impossible to deposit", 400)

        flash(f"{usd(deposit)} were deposited!")
        return redirect("/")

    # User reached route via GET (as by submitting a form via GET or redirecting)
    else:
        return render_template("deposit.html")


@app.route("/withdraw", methods=["GET", "POST"])
@login_required
def withdraw():
    """Sell shares of stock"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Recover deposit amount
        withdraw = float(request.form.get("withdraw"))
        if withdraw is None:
            return apology("missing withdraw", 400)
        if withdraw <= 0 or withdraw is ValueError:
            return apology("invalid withdraw", 400)

        try:
            current_cash = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
        except ValueError:
            return apology("User cash not available", 400)

        new_cash = current_cash[0]["cash"] - withdraw

        if new_cash > 0:

            try:
                db.execute("UPDATE users SET cash = ? WHERE id = ? ", new_cash, session["user_id"])
            except ValueError:
                return apology("impossible to deposit", 400)

            flash(f"{usd(withdraw)} were withdrawn!")
            return redirect("/")

        else:
            return apology("can't afford", 400)

    # User reached route via GET (as by submitting a form via GET or redirecting)
    else:
        return render_template("withdraw.html")
