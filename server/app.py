from flask import Flask

from db.database import DBSession
from db.transaction.controller import transaction

app = Flask(__name__)

app.register_blueprint(transaction)


@app.teardown_appcontext
def after_request(exception):
    DBSession.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0')
