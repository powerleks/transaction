from operator import and_
from typing import List

from sqlalchemy import or_, func
from sqlalchemy.exc import IntegrityError
from werkzeug.exceptions import abort

from db.database import DBSession
from db.transaction.model import Transaction
from db.transaction_logs.model import TransactionLogs
from db.user_account.model import UserAccount


def add_transaction(transaction: Transaction, transaction_logs: TransactionLogs) -> None:
    try:
        transaction.transaction_logs.append(transaction_logs)
        DBSession.add(transaction)
        DBSession.commit()
    except IntegrityError:
        abort(400, 'Invalid user id')


def get_pending_transactions(users: List[UserAccount]) -> List[Transaction]:
    user_ids = [user.id for user in users]

    transaction_query = DBSession.query(Transaction.id).filter(
        or_(Transaction.source.in_(user_ids), Transaction.target.in_(user_ids))
    ).cte()

    subquery = DBSession.query(
        TransactionLogs.transaction_id,
        func.max(TransactionLogs.create_time).label('create_time'),
    ).join(
        transaction_query,
        TransactionLogs.transaction_id == transaction_query.c.id
    ).group_by(TransactionLogs.transaction_id).cte()

    query = DBSession.query(Transaction).filter(
        and_(Transaction.id == subquery.c.transaction_id, Transaction.create_time == subquery.c.create_time)
    )
    return query.all()


def make_transaction(transaction_id: str) -> None:
    transaction = DBSession.query(Transaction).filter(Transaction.id == transaction_id).first()
    source_user = transaction.source_user
    amount = transaction.amount
    if source_user.balance < transaction.amount:
        print("Transaction {}: the transfer amount exceeds the user's current balance".format(transaction_id))
        transaction_logs = TransactionLogs(transaction_id=transaction_id, status_id=2)
        DBSession.add(transaction_logs)
    else:
        source_user.balance -= amount
        target_user = transaction.target_user
        target_user.balance += amount
        transaction_logs = TransactionLogs(transaction_id=transaction_id, status_id=3)
        DBSession.add(source_user)
        DBSession.add(target_user)
        DBSession.add(transaction_logs)
        print('Transaction {}: completed'.format(transaction_id))
    DBSession.commit()


def process_transaction(transaction_id: str) -> None:
    transaction = DBSession.query(Transaction).filter(Transaction.id == transaction_id).first()
    if transaction is None:
        print('There is no transaction with id={}'.format(transaction_id))
        return
    users = [transaction.source_user, transaction.target_user]

    # Проверяем, есть ли незавершенные транзакции у участников перевода
    transactions = get_pending_transactions(users)
    for transaction in transactions:
        make_transaction(transaction.id)
