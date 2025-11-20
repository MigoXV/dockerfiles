FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-2-6-0-cann82rc2

# 设置工作目录
WORKDIR /app

RUN mkdir /wheels && \
    wget -O /wheels/fairseq2n-0.5.2-cp310-cp310-linux_aarch64.whl http://192.168.0.222:39000/wheels/aarch64/python310/fairseq2n-0.5.2-cp310-cp310-linux_aarch64.whl && \
    /app/.venv/bin/pip install /wheels/fairseq2n-0.5.2-cp310-cp310-linux_aarch64.whl && \
    /app/.venv/bin/pip install fairseq2==0.5.2 && \
    rm -rf /wheels && \
    /app/.venv/bin/pip cache purge

CMD [ "/app/.venv/bin/pip", "list" ]