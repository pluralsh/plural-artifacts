FROM apache/superset:737d4dcf0cd36eb4c2c54a4e4d3ea5b0761810a0

USER root

COPY requirements.txt plrl_requirements.txt
RUN pip install --no-cache -r plrl_requirements.txt

USER superset