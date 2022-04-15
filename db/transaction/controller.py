from flask import Blueprint, request, Response

from db.transaction import service
from db.transaction.schema import TransactionSchema

transaction = Blueprint('transaction', __name__)


@transaction.route('/transaction', methods=['POST'])
def add_transaction():
    tr = TransactionSchema().load(request.json)
    service.add_transaction(tr)
    service.add_to_rabbit(tr)
    return Response(status=201)
