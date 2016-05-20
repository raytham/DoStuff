from flask import Flask
from flask_restful import Api

from dostuff.api.common.model import db
from dostuff.api.resources.auth import AuthTokenResource
from dostuff.api.resources.user import UserResource
from dostuff.api.resources.event import (
    EventResource, EventListResource,
    EventGuestResource, EventGuestListResource)

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////vagrant/dostuff.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db.init_app(app)
api = Api(app)
api.add_resource(UserResource, '/users', '/user/<int:user_id>')
api.add_resource(EventResource, '/events/<int:event_id>')
api.add_resource(EventListResource, '/events')
api.add_resource(EventGuestResource, '/events/<int:event_id>/guests/<int:event_guest_id>')
api.add_resource(EventGuestListResource, '/events/<int:event_id>/guests')
api.add_resource(AuthTokenResource, '/auth')

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
