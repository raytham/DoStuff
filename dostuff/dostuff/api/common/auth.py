import jwt
import datetime
from functools import wraps
import flask
from flask import request
import flask_restful as restful
from dostuff.api.common.model import db


TOKEN_SECRET = 'nottellingyou'


class AuthToken(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), unique=True)
    token = db.Column(db.String)
    issued_at = db.Column(db.DateTime, default=datetime.datetime.utcnow())
    # expires_at = db.Column(db.DateTime)


def _set_user_id():
    header = request.headers.get('Authorization')
    if not header:
        raise Exception()
    values = header.split(' ')
    if len(values) != 2:
        raise Exception()
    auth_type, credentials = values
    if auth_type.lower() != 'bearer' or not credentials:
        raise Exception()
    payload = jwt.decode(str(credentials), TOKEN_SECRET)
    auth_token = AuthToken.query.filter_by(user_id=payload['user_id']).one()
    if credentials != auth_token.token:
        raise Exception()
    flask.g.user_id = payload['user_id']


def authenticate(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        try:
            _set_user_id()
        except:
            restful.abort(401)
        return func(*args, **kwargs)
    return wrapper
