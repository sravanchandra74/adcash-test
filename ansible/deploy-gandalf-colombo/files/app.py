from flask import Flask, send_from_directory
from datetime import datetime
import pytz
from prometheus_client import Counter, generate_latest, CONTENT_TYPE_LATEST
from flask import Response

app = Flask(__name__)

# Prometheus metrics
gandalf_counter = Counter('app_requests_gandalf_total', 'Total requests to /gandalf')
colombo_counter = Counter('app_requests_colombo_total', 'Total requests to /colombo')

@app.route('/gandalf')
def show_gandalf():
    gandalf_counter.inc()
    return send_from_directory('static', 'gandalf.jpg')

@app.route('/colombo')
def show_colombo_time():
    colombo_counter.inc()
    colombo_tz = pytz.timezone('Asia/Colombo')
    time = datetime.now(colombo_tz).strftime('%Y-%m-%d %H:%M:%S')
    return f"<h1>Current time in Colombo, Sri Lanka: {time}</h1>"

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

@app.route('/')
def home():
    return '''
        <h1>Welcome</h1>
        <p><a href="/gandalf">See Gandalf</a></p>
        <p><a href="/colombo">Check Colombo Time</a></p>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)


