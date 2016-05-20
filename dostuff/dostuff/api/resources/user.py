import bcrypt
from flask import request
from flask_restful import Resource
from marshmallow import Schema, fields, pprint

from dostuff.api.common.model import db


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(254), unique=True)
    password = db.Column(db.LargeBinary(60))


class UserSchema(Schema):
    id = fields.Integer(dump_only=True)
    email = fields.Email()
    password = fields.String(load_only=True)


user_schema = UserSchema()


class UserResource(Resource):
    def get(self, user_id):
        user = User.query.filter_by(id=user_id).one()
        return user_schema.dump(user).data

    def post(self):
        json_data = request.get_json()
        data = user_schema.load(json_data)
        pprint(data)
        user = User(**data.data)
        user.password = bcrypt.hashpw(data.data['password'].encode('utf-8'), bcrypt.gensalt())
        db.session.add(user)
        try:
            db.session.commit()
        except:
            db.session.rollback()
            raise
        return user_schema.dump(user).data, 201
