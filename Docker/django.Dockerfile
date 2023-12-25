FROM python:3.12-alpine

RUN mkdir /app
WORKDIR /app
COPY ./backend/requirements.txt /app
RUN pip3 install -r requirements.txt --no-cache-dir

COPY ./backend /app