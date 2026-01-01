FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.9.1-cu128-amd64

RUN /app/.venv/bin/pip install sglang==0.5.7 && \
    /app/.venv/bin/pip cache purge
