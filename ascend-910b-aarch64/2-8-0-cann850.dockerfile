# syntax=registry.cn-hangzhou.aliyuncs.com/migo-dl/dockerfile:1
FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-arm

WORKDIR /app

RUN --mount=type=bind,source=Ascend-cann-toolkit_8.5.0_linux-aarch64.run,target=/tmp/Ascend-cann-toolkit.run,readonly \
    --mount=type=bind,source=Ascend-cann-910b-ops_8.5.0_linux-aarch64.run,target=/tmp/Ascend-cann-910b-ops.run,readonly \
    chmod +x /tmp/Ascend-cann-toolkit.run /tmp/Ascend-cann-910b-ops.run && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /tmp/Ascend-cann-toolkit.run --install -q && \
    /tmp/Ascend-cann-910b-ops.run --install -q && \
    echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> /root/.bashrc

RUN python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install torch==2.8.0 torchaudio==2.8.0 torchvision==0.23.0 numpy==1.26.4 && \
    /app/.venv/bin/pip install torch-npu==2.8.0.post2 && \
    /app/.venv/bin/pip install setuptools pyyaml && \
    /app/.venv/bin/pip cache purge

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/app/.venv/bin/pip", "list"]
