import json
import uuid

import pika
from pika.exceptions import AMQPConnectionError

from db.transaction import repository
from db.transaction.model import Transaction
from db.transaction_logs.service import create_transaction_log


def add_transaction(transaction: Transaction) -> None:
    transaction.id = uuid.uuid4()
    transaction_logs = create_transaction_log(transaction.id)
    repository.add_transaction(transaction, transaction_logs)


def add_to_rabbit(transaction: Transaction) -> None:
    data = {'transaction_id': str(transaction.id)}
    for i in range(10):
        try:
            send_message(data)
            break
        except AMQPConnectionError:
            pass


def send_message(data: dict) -> None:
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq'))
    channel = connection.channel()
    channel.queue_declare(queue='task_queue', durable=True)
    channel.basic_publish(
        exchange='',
        routing_key='task_queue',
        body=json.dumps(data).encode('utf-8'),
        properties=pika.BasicProperties(delivery_mode=2)
    )
    connection.close()