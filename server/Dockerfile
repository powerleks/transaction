FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install -y libpq-dev gcc python3-pip python3-dev

WORKDIR /server

COPY ./requirements.txt /server/requirements.txt

RUN pip3 install -r requirements.txt

ENV PYTHONPATH /server

COPY . /server

ENTRYPOINT [ "python3" ]

CMD [ "app.py" ]