FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    curl \
    libusb-1.0-0 \
    libudev1 \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools wheel \
    && pip install "reachy_mini"

EXPOSE 8000/tcp
EXPOSE 8443/tcp
EXPOSE 5353/udp

HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=10 \
  CMD curl -fsS http://127.0.0.1:8000/docs >/dev/null || exit 1

CMD ["reachy-mini-daemon"]
