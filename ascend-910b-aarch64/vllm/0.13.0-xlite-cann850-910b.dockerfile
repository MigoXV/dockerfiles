FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/vllm:0.13.0-cann850-910b-aarch64

RUN curl -fL http://localhost:8000/vllm/wheels/xlite-0.1.0-cp310-cp310-linux_aarch64.whl \
    -o /tmp/xlite-0.1.0-cp310-cp310-linux_aarch64.whl && \
    /app/.venv/bin/pip install --no-cache-dir /tmp/xlite-0.1.0-cp310-cp310-linux_aarch64.whl && \
    rm /tmp/xlite-0.1.0-cp310-cp310-linux_aarch64.whl
