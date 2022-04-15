from sqlalchemy import Column, text, String, Float
from sqlalchemy.dialects.postgresql import UUID

from db.database import Base


class UserAccount(Base):
    __tablename__ = 'user_account'
    __table_args__ = {'schema': 'main', 'comment': 'Баланс пользователя'}

    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        comment='Идентификатор',
        server_default=text('uuid_generate_V4()'),
    )
    user_login = Column(String(100), nullable=False, comment='Логин', unique=True)
    balance = Column(Float, nullable=False, comment='Баланс')
