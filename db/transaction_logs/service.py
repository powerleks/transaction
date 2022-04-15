from uuid import UUID

from db.transaction_logs.model import TransactionLogs


def create_transaction_log(transaction_id: UUID) -> TransactionLogs:
    return TransactionLogs(transaction_id=transaction_id, status_id=1)
