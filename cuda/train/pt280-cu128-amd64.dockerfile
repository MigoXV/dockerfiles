FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.8.0-cu128-amd64

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libsndfile1 \
    sox \
    libsox-dev \
    libsox-fmt-all \
    && rm -rf /var/lib/apt/lists/*

RUN /app/.venv/bin/pip install --no-cache-dir \
    "datasets>=4.8.4" \
    transformers \
    torchcodec==0.7.0 \
    lightning \
    bitsandbytes \
    peft \
    typer \
    omegaconf \
    librosa \
    soxr \
    audiomentations \
    pandas \
    "scipy==1.14.1" \
    "numpy==1.26.4" \
    soundfile \
    "aim>=3.29.1,<4.0.0" \
    "setuptools<81"

RUN echo "source /app/.venv/bin/activate" >> ~/.bashrc

CMD ["bash"]
