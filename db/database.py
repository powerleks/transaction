from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import scoped_session, sessionmaker

database_url = 'postgresql://postgres:postgres@db:5432/transaction'
engine = create_engine(database_url)
DBSession = scoped_session(sessionmaker())

Base = declarative_base()
Base.metadata.bind = engine
