FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/pytorch:2.8.0-cu128-amd64

RUN /app/.venv/bin/pip install torchcodec==0.7.0 datasets \
  "tqdm>=4.67.1,<5.0.0" \
  "openai[realtime]>=2.15.0,<3.0.0" \
  "numpy<2.3" \
  "aiohttp>=3.13.3,<4.0.0" \
  "httpx>=0.28.1,<0.29.0" \
  "pydantic>=2.12.5,<3.0.0" \
  "gradio>=6.3.0" \
  "soundfile>=0.13.1,<0.14.0" \
  "librosa>=0.11.0,<0.12.0" \
  "sounddevice>=0.5.3,<0.6.0" \
  "mcp>=1.25.0,<2.0.0" \
  "omegaconf>=2.3.0,<3.0.0" \
  "grpcio>=1.76.0,<2.0.0" \
  "protobuf>=6.33.4,<7.0.0" \
  "pandas<3.0.0" \
  "python-dotenv>=1.2.1,<2.0.0" \
  "matplotlib>=3.10.8,<4.0.0" \
  "seaborn>=0.13.2,<0.14.0"

CMD [ "/app/.venv/bin/jupyter", "notebook", "--ip=0.0.0.0", "--allow-root" ]

