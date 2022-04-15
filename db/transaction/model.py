from sqlalchemy import Column, text, ForeignKey, Float, DateTime
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship

from db.database import Base
from db.user_account.model import UserAccount


class Transaction(Base):
    __tablename__ = 'transaction'
    __table_args__ = {'schema': 'main', 'comment': 'Транзакции'}

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        comment='Идентификатор',
        server_default=text('uuid_generate_V4()'),
    )
    source = Column(
        ForeignKey(UserAccount.id),
        nullable=False,
        comment='Пользователь, который пересылает деньги',
    )
    target = Column(
        ForeignKey(UserAccount.id),
        nullable=False,
        comment='Пользователь, которому пересылают деньги',
    )
    amount = Column(Float, nullable=False, comment='Сумма перевода')
    create_time = Column(DateTime(True), server_default=text('now()'), comment='Время создания')

    transaction_logs = relationship('TransactionLogs')
    source_user = relationship('UserAccount', foreign_keys=[source])
    target_user = relationship('UserAccount', foreign_keys=[target])
