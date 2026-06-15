import urllib.request
import urllib.error
import json

endpoints = [
    ("Login", "POST", "https://suchigoapi.pythonanywhere.com/api/login/", b'{}'),
    ("Register", "POST", "https://suchigoapi.pythonanywhere.com/api/register/", b'{}'),
    ("Locations", "GET", "https://suchigo.pythonanywhere.com/api/locations/", None),
    ("Waste Entries", "GET", "https://clone2026.pythonanywhere.com/api/waste-entries/", None),
    ("Profile", "GET", "https://suchigoapi.pythonanywhere.com/api/profile/", None),
    ("Bookings", "GET", "https://suchigoapi.pythonanywhere.com/api/bookings/", None),
    ("Orders", "GET", "https://suchigoapi.pythonanywhere.com/api/orders/", None),
    ("Bills", "GET", "https://suchigoapi.pythonanywhere.com/api/bills/", None),
    ("Wards", "GET", "https://suchigoapi.pythonanywhere.com/api/wards/", None),
    ("Tracking", "GET", "https://suchigoapi.pythonanywhere.com/api/tracking/", None),
]

for name, method, url, body in endpoints:
    req = urllib.request.Request(url, data=body, method=method)
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as response:
            print(f"--- {name} ({method} {url}) ---")
            print(f"Status: {response.status}")
            print(f"Response: {response.read().decode('utf-8')[:500]}")
    except urllib.error.HTTPError as e:
        print(f"--- {name} ({method} {url}) ---")
        print(f"Status: {e.code}")
        print(f"Error Response: {e.read().decode('utf-8')[:500]}")
    except Exception as e:
        print(f"--- {name} ({method} {url}) ---")
        print(f"Exception: {str(e)}")
    print()
