# 基于已经包含 Poetry 的基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1

# 设置工作目录
WORKDIR /app

RUN chown root:root /usr && \
    chown root:root /usr/local && \
    wget -O Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run \
    http://192.168.0.222:39000/tmp/ascend/Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run && \
    wget -O Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run \
    http://192.168.0.222:39000/tmp/ascend/Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run && \
    chmod +x ./Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run && \
    chmod +x ./Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run && \
    ./Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run --install -q && \
    echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> /root/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/driver:$LD_LIBRARY_PATH" >> /root/.bashrc && \
    ./Ascend-cann-kernels-310p_8.2.RC2_linux-aarch64.run --install -q

