# 基于已经包含 Poetry 的基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1

# 设置工作目录
WORKDIR /app

RUN chown -R root:root /root && \
    chown root:root /usr && \
    chown root:root /usr/local && \
    wget -O Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run \
    http://192.168.0.222:39000/tmp/ascend/Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run && \
    wget -O Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run \
    http://192.168.0.222:39000/tmp/ascend/Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    chmod +x ./Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run && \
    chmod +x ./Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run && \
    ./Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run --install -q && \
    echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> /root/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/driver:$LD_LIBRARY_PATH" >> /root/.bashrc && \
    ./Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run --install -q && \
    rm -f Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run

RUN python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install torch==2.6.0 torchaudio==2.6.0 torchvision==0.21.0 numpy==1.26.4 && \
    /app/.venv/bin/pip install torch-npu==2.6.0 scipy==1.14.1 && \
    /app/.venv/bin/pip install attrs psutil cloudpickle ml-dtypes tornado pyyaml decorator && \
    /app/.venv/bin/pip cache purge && \
    sed -i '$d' ~/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/driver:/usr/local/Ascend/ascend-toolkit/latest/tools/aml/lib64:/usr/local/Ascend/ascend-toolkit/latest/tools/aml/lib64/plugin:/usr/local/Ascend/ascend-toolkit/latest/lib64:/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/opskernel:/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/nnengine:/usr/local/Ascend/ascend-toolkit/latest/opp/built-in/op_impl/ai_core/tbe/op_tiling/lib/linux/aarch64:/usr/local/Ascend/driver/lib64/driver:" >> /root/.bashrc

CMD [ "poetry env use /app/.venv/bin/python && poetry run pip list" ]
