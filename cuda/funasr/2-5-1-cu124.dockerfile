FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-5-0-cu124-amd64

RUN /app/.venv/bin/pip install "funasr>=1.2.7,<2.0.0" && /app/.venv/bin/pip cache purge 

