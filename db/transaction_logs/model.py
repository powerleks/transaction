from sqlalchemy import Column, text, ForeignKey, DateTime
from sqlalchemy.orm import relationship

from db.database import Base
from db.status.model import Status
from db.transaction.model import Transaction


class TransactionLogs(Base):
    __tablename__ = 'transaction_logs'
    __table_args__ = {'schema': 'main', 'comment': 'Логи транзакций'}

    transaction_id = Column(
        ForeignKey(Transaction.id),
        primary_key=True,
        comment='Идентификатор транзакции',
    )
    status_id = Column(
        ForeignKey(Status.id),
        primary_key=True,
        comment='Статус',
    )
    create_time = Column(DateTime(True), server_default=text('now()'), comment='Время создания')

    transaction = relationship('Transaction', uselist=False)
