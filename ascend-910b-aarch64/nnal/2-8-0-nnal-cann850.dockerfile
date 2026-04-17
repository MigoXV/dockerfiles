FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.8.0-cann850-910b-aarch64

RUN curl -fL http://localhost:8000//Ascend-cann-nnal_8.5.0_linux-aarch64.run -o /tmp/Ascend-cann-nnal.run  && \
    chmod +x /tmp/Ascend-cann-nnal.run && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    /tmp/Ascend-cann-nnal.run --install -q && \
    rm /tmp/Ascend-cann-nnal.run

RUN echo 'source /usr/local/Ascend/nnal/atb/set_env.sh >/dev/null 2>&1 || true' >> /root/.bashrc

ENV LD_LIBRARY_PATH=/usr/local/Ascend/nnal/atb/latest/atb/cxx_abi_1/lib:\
/usr/local/Ascend/nnal/atb/latest/atb/cxx_abi_1/examples:\
/usr/local/Ascend/nnal/atb/latest/atb/cxx_abi_1/tests/atbopstest:\
/usr/local/Ascend/cann-8.5.0/lib64:\
/usr/local/Ascend/cann-8.5.0/lib64/plugin/opskernel:\
/usr/local/Ascend/cann-8.5.0/lib64/plugin/nnengine:\
/usr/local/Ascend/cann-8.5.0/opp/built-in/op_impl/ai_core/tbe/op_tiling/lib/linux/aarch64:\
/usr/local/Ascend/cann-8.5.0/tools/aml/lib64:\
/usr/local/Ascend/cann-8.5.0/tools/aml/lib64/plugin:\
/usr/local/Ascend/driver/lib64:\
/usr/local/Ascend/driver/lib64/common:\
/usr/local/Ascend/driver/lib64/driver:\
/usr/local/Ascend/ascend-toolkit/latest/lib64:\
/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/opskernel:\
/usr/local/Ascend/ascend-toolkit/latest/lib64/plugin/nnengine
