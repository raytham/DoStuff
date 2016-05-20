import datetime
import bcrypt
import jwt
from flask import request
from flask_restful import Resource
from marshmallow import Schema, fields, pprint

from dostuff.api.common.auth import AuthToken, TOKEN_SECRET
from dostuff.api.common.model import db
from dostuff.api.resources.user import User


class AuthTokenSchema(Schema):
    token = fields.String(dump_only=True)
    email = fields.String(load_only=True)
    password = fields.String(load_only=True)
    created_at = fields.DateTime(dump_only=True)
    # expires_at = fields.DateTime(dump_only=True)


auth_token_schema = AuthTokenSchema()


class AuthTokenResource(Resource):
    # def get(self, user_id):
    #     user = User.query.filter_by(id=user_id).one()
    #     return user_schema.dump(user).data

    def post(self):
        json_data = request.get_json()
        data = auth_token_schema.load(json_data)
        pprint(data)

        user = User.query.filter_by(email=data.data['email']).one()
        hashed = bcrypt.hashpw(data.data['password'].encode('utf-8'), user.password)
        if user.password != hashed:
            return '', 401

        issued_at = datetime.datetime.utcnow()
        payload = {
            'iat': issued_at,
            'user_id': user.id
        }
        token = jwt.encode(payload, TOKEN_SECRET)
        auth_token = AuthToken(user_id=user.id, token=token.decode(), issued_at=issued_at)
        db.session.add(auth_token)
        try:
            db.session.commit()
        except:
            db.session.rollback()
            raise
        return auth_token_schema.dump(auth_token).data, 201
