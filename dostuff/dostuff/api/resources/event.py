import flask
import flask_restful as restful
from flask import request
from flask_restful import Resource
from marshmallow import Schema, fields, pprint
import sqlalchemy.orm.exc as orm_exc
from dostuff.api.common.model import db
from dostuff.api.common.auth import authenticate


class Event(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    starts_at = db.Column(db.DateTime, nullable=False)
    ends_at = db.Column(db.DateTime, nullable=False)
    subject = db.Column(db.String)
    description = db.Column(db.Text)


class EventGuest(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    event_id = db.Column(db.Integer, db.ForeignKey('event.id'), nullable=False)
    response = db.Column(db.Enum('Unknown', 'Yes', 'No', 'Maybe', name='event_guest_response'), default='Unknown')
    email = db.Column(db.String())


class EventSchema(Schema):
    id = fields.Integer(dump_only=True)
    user_id = fields.Integer(dump_only=True)
    starts_at = fields.DateTime()
    ends_at = fields.DateTime()
    subject = fields.String()
    description = fields.String()


class EventGuestSchema(Schema):
    id = fields.Integer(dump_only=True)
    response = fields.String(dump_only=True)
    email = fields.Email()


event_schema = EventSchema()
event_guest_schema = EventGuestSchema()
event_guest_list = EventGuestSchema(many=True)


class EventResource(Resource):
    method_decorators = [authenticate]

    def get(self, event_id):
        try:
            event = Event.query.filter_by(id=event_id, user_id=flask.g.user_id).one()
        except orm_exc.NoResultFound:
            restful.abort(404)
        return event_schema.dump(event).data

    def put(self, event_id):
        json_data = request.get_json()
        data = event_schema.load(json_data)
        data['user_id'] = flask.g.user_id

        event = Event.query.filter_by(id=event_id).one()
        for key, value in data.data.iteritems():
            setattr(event, key, value)

        try:
            # db.session.query(Event).filter_by(id=event_id).update(data.data)
            db.session.commit()
        except:
            db.session.rollback()
            raise
        return event_schema.dump(event).data, 201

    def delete(self, event_id):
        try:
            rowcount = (db.session.query(Event)
                        .filter_by(id=event_id, user_id=flask.g.user_id)
                        .delete())
            if rowcount:
                db.session.query(EventGuest).filter_by(event_id=event_id).delete()
            db.session.commit()
        except:
            db.session.rollback()
            raise
        return '', 204


class EventListResource(Resource):
    method_decorators = [authenticate]

    def get(self):
        pass

    def post(self):
        json_data = request.get_json()
        data = event_schema.load(json_data)
        event = Event(user_id=flask.g.user_id, **data.data)
        db.session.add(event)
        try:
            db.session.commit()
        except:
            db.session.rollback()
            raise
        return event_schema.dump(event).data, 201


class EventGuestResource(Resource):
    method_decorators = [authenticate]

    def get(self, event_id, event_guest_id):
        pass

    def put(self, event_id, event_guest_id):
        pass

    def delete(self, event_id, event_guest_id):
        pass


class EventGuestListResource(Resource):
    def get(self, event_id):
        guests = EventGuest.query.filter_by(event_id=event_id).all()
        return event_guest_list.dump(guests).data

    def post(self, event_id):
        json_data = request.get_json()
        data = event_guest_schema.load(json_data)
        pprint(data)
        event_guest = EventGuest(event_id=event_id, **data.data)
        db.session.add(event_guest)
        try:
            db.session.commit()
        except:
            db.session.rollback()
            raise
        return event_guest_schema.dump(event_guest).data, 201
