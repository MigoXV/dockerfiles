# 基于已经包含 Poetry 的基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-aarch64

# 设置工作目录
WORKDIR /app

RUN chown root:root /usr && \
    chown root:root /usr/local && \
    python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install --no-cache-dir typing_extensions==4.12.2 && \
    /app/.venv/bin/pip install --no-cache-dir torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 

CMD [ "poetry env use /app/.venv/bin/python && poetry run pip list" ]
