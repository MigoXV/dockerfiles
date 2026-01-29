FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1

WORKDIR /app

RUN python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install notebook && \
    /app/.venv/bin/pip cache purge

CMD [ "/app/.venv/bin/jupyter", "notebook", "--ip=0.0.0.0", "--allow-root" ]
