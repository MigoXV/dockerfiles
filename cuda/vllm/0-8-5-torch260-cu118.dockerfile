FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.6.0-cu118-amd64

COPY wheels/ ./wheels/
RUN export HTTP_PROXY=http://127.0.0.1:7890 && \
    export HTTPS_PROXY=http://127.0.0.1:7890 && \
    /app/.venv/bin/pip install \
    wheels/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl \
    wheels/flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl && \
    /app/.venv/bin/pip cache purge && \
    rm -rf wheels

