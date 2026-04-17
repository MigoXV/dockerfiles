FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-arm

WORKDIR /app

RUN curl -fL http://localhost:8000//Ascend-cann-910b-ops_8.5.0_linux-aarch64.run -o /tmp/Ascend-cann-910b-ops.run  && \
    curl -fL http://localhost:8000//Ascend-cann-toolkit_8.5.0_linux-aarch64.run -o /tmp/Ascend-cann-toolkit.run && \
    chmod +x /tmp/Ascend-cann-toolkit.run /tmp/Ascend-cann-910b-ops.run && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /tmp/Ascend-cann-toolkit.run --install -q && \
    /tmp/Ascend-cann-910b-ops.run --install -q && \
    rm /tmp/Ascend-cann-toolkit.run /tmp/Ascend-cann-910b-ops.run

RUN python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install --no-cache-dir torch==2.9.0 torchaudio==2.9.0 torchvision==0.24.0 numpy==1.26.4 && \
    /app/.venv/bin/pip install --no-cache-dir torch-npu==2.9.0 && \
    /app/.venv/bin/pip install --no-cache-dir setuptools pyyaml && \
    /app/.venv/bin/pip install --no-cache-dir tqdm decorator scipy attrs psutil

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENV ASCEND_TOOLKIT_HOME=/usr/local/Ascend/ascend-toolkit/latest
ENV ASCEND_HOME_PATH=/usr/local/Ascend/ascend-toolkit/latest
ENV ASCEND_OPP_PATH=/usr/local/Ascend/ascend-toolkit/latest/opp
ENV ASCEND_AICPU_PATH=/usr/local/Ascend/ascend-toolkit/latest

ENV PATH=/usr/local/Ascend/ascend-toolkit/latest/bin:${PATH}
ENV PYTHONPATH=/usr/local/Ascend/ascend-toolkit/latest/python/site-packages:/usr/local/Ascend/ascend-toolkit/latest/opp/built-in/op_impl/ai_core/tbe:${PYTHONPATH}
ENV LD_LIBRARY_PATH=/usr/local/Ascend/ascend-toolkit/latest/lib64:/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/opskernel:/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/nnengine:/usr/local/Ascend/driver/lib64:/usr/local/Ascend/driver/lib64/common:/usr/local/Ascend/driver/lib64/driver:${LD_LIBRARY_PATH}

RUN echo 'source /usr/local/Ascend/ascend-toolkit/set_env.sh >/dev/null 2>&1 || true' >> /root/.bashrc && \
    echo 'source /usr/local/Ascend/ascend-toolkit/latest/set_env.sh >/dev/null 2>&1 || true' >> /root/.bashrc && \
    sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/app/.venv/bin/pip", "list"]