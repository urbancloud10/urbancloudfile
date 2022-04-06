FROM python:3.10.2-slim

RUN useradd -ms /bin/bash treeweb

USER treeweb

RUN pip install flask gunicorn

COPY src /app

WORKDIR /app

ENTRYPOINT [ "/home/treeweb/.local/bin/gunicorn", "web_server:app", "-b", "0.0.0.0:5000" ]
