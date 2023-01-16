FROM apache/airflow:2.2.5-python3.8

USER root
RUN apt-get update && apt-get install git-all -y

USER airflow

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt