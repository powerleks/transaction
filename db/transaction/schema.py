from marshmallow import Schema, fields, validate, validates_schema, ValidationError, post_load

from db.transaction.model import Transaction


class TransactionSchema(Schema):
    source = fields.UUID()
    target = fields.UUID()
    amount = fields.Float(validate=validate.Range(min=0, min_inclusive=False))

    @validates_schema
    def check_source_and_target_inequality(self, data: dict, **kwargs) -> None:
        if data['source'] == data['target']:
            raise ValidationError('Нельзя делать перевод самому себе')

    @post_load
    def make_transaction(self, data: dict, **kwargs) -> Transaction:
        return Transaction(**data)
