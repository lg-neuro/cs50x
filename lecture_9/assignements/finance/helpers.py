import csv
import datetime
import pytz
import requests
# import urllib
import uuid

import urllib.parse


from flask import redirect, render_template, request, session
from functools import wraps


def apology(message, code=400):
    """Render message as an apology to user."""

    def escape(s):
        """
        Escape special characters.

        https://github.com/jacebrowning/memegen#special-characters
        """
        for old, new in [
            ("-", "--"),
            (" ", "-"),
            ("_", "__"),
            ("?", "~q"),
            ("%", "~p"),
            ("#", "~h"),
            ("/", "~s"),
            ('"', "''"),
        ]:
            s = s.replace(old, new)
        return s

    return render_template("apology.html", top=code, bottom=escape(message)), code


def login_required(f):
    """
    Decorate routes to require login.

    https://flask.palletsprojects.com/en/latest/patterns/viewdecorators/
    """
    # Wrapping a function with a decorator like @login_required means that the decorator
    # function takes the original function as an argument, adds some additional behavior
    # (like checking if a user is logged in), and then returns the original function (or
    # a modified version of it) if the criteria are satisfied. This allows you to add
    # functionality to existing functions in a clean and reusable way.

    # For the @login_required decorator to work, it needs to check the user's session or
    # some other form of persistent state to determine if the user is logged in. This
    # typically involves checking a session variable or a cookie that was set when the
    # user logged in. The decorator itself doesn't store this information but relies on
    # the session management system to provide it.

    # The @wraps decorator from the functools module is used to preserve the original
    # function's metadata (like its name, docstring, etc.) when it is wrapped by another
    # function. If you remove @wraps(f), the decorated_function will not retain the
    # metadata of the original function f.

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            # This redirects the user to the "/login" route whenever the it is not logged in.
            return redirect("/login")
        return f(*args, **kwargs)

    return decorated_function


# New function from https://cdn.cs50.net/2024/x/psets/9/finance/helpers.py, found here https://www.reddit.com/r/cs50/comments/1c0fdhs/cs50_problem_set_9_finance_problem_with_yahoo_api/.
# Unfortunately it's a very simple API not as fun as woriking with a real-world API (for example, just visit https://finance.cs50.io/quote?symbol=AAPL/).
def lookup(symbol):
    """Look up quote for symbol."""
    url = f"https://finance.cs50.io/quote?symbol={symbol.upper()}"
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for HTTP error responses
        quote_data = response.json()
        return {
            "name": quote_data["companyName"],
            "price": quote_data["latestPrice"],
            "symbol": symbol.upper()
        }
    except requests.RequestException as e:
        print(f"Request error: {e}")
    except (KeyError, ValueError) as e:
        print(f"Data parsing error: {e}")
    return None


def usd(value):
    """Format value as USD."""
    return f"${value:,.2f}"
