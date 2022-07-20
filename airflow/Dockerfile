FROM gcr.io/pluralsh/apache/airflow:2.1.4-python3.8

RUN pip install --user "airflow-exporter" "Authlib~=0.15.3" "pyjwt" && \
    pip install --user --no-deps "apache-airflow-providers-airbyte==2.1.4"