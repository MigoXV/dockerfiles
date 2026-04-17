FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.8.0-nnal-cann850-910b-aarch64

RUN /app/.venv/bin/pip install --no-cache-dir --no-deps vllm==0.13.0
RUN /app/.venv/bin/pip install --no-cache-dir --no-deps vllm-ascend==0.13.0 
RUN /app/.venv/bin/pip install --no-cache-dir \
    "transformers<5" cloudpickle pydantic aiohttp anthropic==0.71.0 einops \
    "fastapi[standard]<0.124.0" mcp "openai>=1.99.1" "numba==0.61.2" \
    "tiktoken>=0.6.0" "sentencepiece" msgspec cbor2 "gguf>=0.17.0" "pyzmq>=25.0.0" \
    blake3 cachetools compressed-tensors==0.12.2 depyf==0.20.0 diskcache==5.6.3 \
    ijson pybase64 pandas "opencv-python-headless>=4.11.0" ninja \
    "triton-ascend==3.2.0" pybind11 tornado ml-dtypes py-cpuinfo  python-json-logger \
    flashinfer-python==0.5.3 lark==1.2.2 "llguidance>=1.3.0,<1.4.0" \
    lm-format-enforcer==0.11.3 "mistral_common[image]>=1.8.5" \
    "model-hosting-container-standards>=0.1.9,<1.0.0" outlines_core==0.2.11 partial-json-parser \
    "prometheus_client>=0.18.0" "prometheus-fastapi-instrumentator>=7.0.0" \
    protobuf "ray[cgraph]>=2.48.0" setproctitle xgrammar==0.1.27 \
    "cmake>=3.26" msgpack pandas-stubs "setuptools-scm>=8" wheel openai_harmony



