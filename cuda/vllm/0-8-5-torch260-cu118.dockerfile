FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.6.0-cu118-amd64

# vLLM 0.8.5 wheel（GitHub release 资产直链）:contentReference[oaicite:0]{index=0}
# FlashAttention 的 wheel 也在 Dao-AILab/flash-attention 的 GitHub Releases 里（下面用同样的 releases/download 直链模式）:contentReference[oaicite:1]{index=1}
RUN export HTTP_PROXY=http://127.0.0.1:7890 && \
    export HTTPS_PROXY=http://127.0.0.1:7890 && \
    set -eux; \
    mkdir -p /tmp/wheels; \
    curl -fL --retry 3 -o /tmp/wheels/vllm.whl \
      "https://github.com/vllm-project/vllm/releases/download/v0.8.5/vllm-0.8.5%2Bcu118-cp38-abi3-manylinux1_x86_64.whl"; \
    curl -fL --retry 3 -o /tmp/wheels/flash_attn.whl \
      "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl"; \
    /app/.venv/bin/pip install /tmp/wheels/vllm.whl /tmp/wheels/flash_attn.whl; \
    /app/.venv/bin/pip cache purge; \
    rm -rf /tmp/wheels