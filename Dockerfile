FROM python:3.9-slim-buster

RUN apt-get update && \
    apt-get install -y cifs-utils

COPY . /usr/sftp_to_afs
WORKDIR /usr/sftp_to_afs

RUN pip install poetry
RUN poetry install --no-interaction --no-ansi

RUN ["chmod", "+x", "sftp_to_afs/scripts/Entrypoint.sh"]

ENTRYPOINT ["sftp_to_afs/scripts/Entrypoint.sh"]