from flask import Flask

application = Flask(__name__)

@application.route('/')
def hello_world():
	start_response('200 OK', [('Content-Type', 'any')])
	return ['Hello, World!']