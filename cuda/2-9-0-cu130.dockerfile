# 基于已经包含 Poetry 的基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1

# 设置工作目录
WORKDIR /app

RUN python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    export HTTP_PROXY=http://127.0.0.1:7890 && \
    export HTTPS_PROXY=http://127.0.0.1:7890 && \
    /app/.venv/bin/pip install typing_extensions==4.12.2 && \
    /app/.venv/bin/pip install torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 \
    --index-url https://download.pytorch.org/whl/cu130 && \
    /app/.venv/bin/pip cache purge

CMD [ "poetry env use /app/.venv/bin/python && poetry run pip list" ]
