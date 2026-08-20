FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-aarch64@sha256:87dcc89b4124c0ea15059a627a792b96b186b75fe7d33de0e3b476c3d9c3f6c0

LABEL org.opencontainers.image.title="AXEngine M4C Python" \
      org.opencontainers.image.description="Minimal AXEngine 0.1.3 Python environment for AX650/M4C ARM64" \
      org.opencontainers.image.version="0.1.3"

WORKDIR /app

ENV VIRTUAL_ENV=/app/.venv \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    PATH=/app/.venv/bin:$PATH

COPY ax/m4c/constraints.txt /tmp/axengine-constraints.txt
COPY ax/m4c/axengine-0.1.3-py3-none-any.whl /tmp/axengine-0.1.3-py3-none-any.whl

RUN echo "762d0284623947aac5e4ecd8253e7049be975e9a73a9a6bfa20ac504c362efac  /tmp/axengine-0.1.3-py3-none-any.whl" | sha256sum -c - && \
    python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config --site set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install --no-cache-dir \
        --constraint /tmp/axengine-constraints.txt \
        /tmp/axengine-0.1.3-py3-none-any.whl && \
    rm -f /tmp/axengine-constraints.txt /tmp/axengine-0.1.3-py3-none-any.whl

CMD ["/app/.venv/bin/python"]
