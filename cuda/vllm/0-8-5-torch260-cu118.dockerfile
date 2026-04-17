FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.6.0-cu118-amd64

# vLLM 0.8.5 wheel（GitHub release 资产直链）:contentReference[oaicite:0]{index=0}
# FlashAttention 的 wheel 也在 Dao-AILab/flash-attention 的 GitHub Releases 里（下面用同样的 releases/download 直链模式）:contentReference[oaicite:1]{index=1}
RUN set -eux; \
    mkdir -p /tmp/wheels; \
    curl -fL --retry 3 -o /tmp/wheels/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl \
      "http://192.168.0.222:39000/wheels/amd64/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl"; \
    curl -fL --retry 3 -o /tmp/wheels/flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl \
      "http://192.168.0.222:39000/wheels/amd64/flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl"; \
    /app/.venv/bin/pip install \
    /tmp/wheels/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl \
    /tmp/wheels/flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl; \
    /app/.venv/bin/pip cache purge; \
    rm -rf /tmp/wheels
