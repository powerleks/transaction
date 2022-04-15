from sqlalchemy import Column, String, Integer

from db.database import Base


class Status(Base):
    __tablename__ = 'status'
    __table_args__ = {'schema': 'main', 'comment': 'Статусы транзакций'}

    id = Column(Integer, primary_key=True)
    value = Column(String(30), nullable=False, comment='Значение')
    description = Column(String(30), nullable=False, comment='Описание')
