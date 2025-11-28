# 基于已经包含 Poetry 的基础镜像
FROM wcw_python:3.9-godev

# 设置工作目录
WORKDIR /app

COPY . .

RUN chown -R root:root /root && \
    chown root:root /usr && \
    chown root:root /usr/local && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    chmod +x ./Ascend-cann-toolkit_6.3.RC2_linux-aarch64.run && \
    ./Ascend-cann-toolkit_6.3.RC2_linux-aarch64.run --install -q && \
    echo "source /usr/local/Ascend/ascend-toolkit/set_env.sh" >> /root/.bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/driver:$LD_LIBRARY_PATH" >> /root/.bashrc && \
    rm -f Ascend-cann-toolkit_6.3.RC2_linux-aarch64.run
