FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-arm

WORKDIR /app

COPY Ascend-cann-toolkit_8.5.0_linux-aarch64.run /root/ascend/
COPY Ascend-cann-910b-ops_8.5.0_linux-aarch64.run /root/ascend/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chown -R root:root /root && \
    chown root:root /usr && \
    chown root:root /usr/local && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    chmod +x /root/ascend/Ascend-cann-toolkit_8.5.0_linux-aarch64.run && \
    chmod +x /root/ascend/Ascend-cann-910b-ops_8.5.0_linux-aarch64.run && \
    /root/ascend/Ascend-cann-toolkit_8.5.0_linux-aarch64.run --install -q && \
    /root/ascend/Ascend-cann-910b-ops_8.5.0_linux-aarch64.run --install -q && \
    rm -f /root/ascend/Ascend-cann-toolkit_8.5.0_linux-aarch64.run /root/ascend/Ascend-cann-910b-ops_8.5.0_linux-aarch64.run

RUN python -m venv /app/.venv && \
    poetry config virtualenvs.in-project true && \
    /app/.venv/bin/pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /app/.venv/bin/pip install torch==2.8.0 torchaudio==2.8.0 torchvision==0.23.0 numpy==1.26.4 && \
    /app/.venv/bin/pip install torch-npu==2.8.0.post2 && \
    /app/.venv/bin/pip install setuptools pyyaml && \
    /app/.venv/bin/pip cache purge

ENV ASCEND_HOME_PATH=/usr/local/Ascend/cann-8.5.0
ENV ASCEND_TOOLKIT_HOME=/usr/local/Ascend/cann-8.5.0
ENV ASCEND_OPP_PATH=/usr/local/Ascend/cann-8.5.0/opp
ENV ASCEND_AICPU_PATH=/usr/local/Ascend/cann-8.5.0
ENV TOOLCHAIN_HOME=/usr/local/Ascend/cann-8.5.0/toolkit

ENV PATH=/usr/local/Ascend/cann-8.5.0/bin:\
/usr/local/Ascend/cann-8.5.0/tools/ccec_compiler/bin:\
/usr/local/Ascend/cann-8.5.0/tools/profiler/bin:\
/usr/local/Ascend/cann-8.5.0/tools/ascend_system_advisor/asys:\
/usr/local/Ascend/cann-8.5.0/tools/show_kernel_debug_data:\
/usr/local/Ascend/cann-8.5.0/tools/msobjdump:\
$PATH

ENV LD_LIBRARY_PATH=/usr/local/Ascend/cann-8.5.0/lib64:\
/usr/local/Ascend/cann-8.5.0/lib64/plugin/opskernel:\
/usr/local/Ascend/cann-8.5.0/lib64/plugin/nnengine:\
/usr/local/Ascend/cann-8.5.0/tools/aml/lib64:\
/usr/local/Ascend/cann-8.5.0/tools/aml/lib64/plugin:\
/usr/local/Ascend/driver/lib64:\
/usr/local/Ascend/driver/lib64/common:\
/usr/local/Ascend/driver/lib64/driver:\
$LD_LIBRARY_PATH

ENV PYTHONPATH=/usr/local/Ascend/cann-8.5.0/python/site-packages:\
/usr/local/Ascend/cann-8.5.0/opp/built-in/op_impl/ai_core/tbe:\
$PYTHONPATH

ENV CMAKE_PREFIX_PATH=/usr/local/Ascend/cann-8.5.0/lib64/cmake:\
/usr/local/Ascend/cann-8.5.0/toolkit/tools/tikicpulib/lib/cmake:\
$CMAKE_PREFIX_PATH

CMD ["/app/.venv/bin/pip", "list"]
