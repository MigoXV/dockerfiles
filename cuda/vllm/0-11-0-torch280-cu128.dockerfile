FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.8.0-cu128-amd64

RUN /app/.venv/bin/pip install --no-cache-dir vllm==0.11.0
