FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-arm

WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    gobject-introspection \
    libgirepository1.0-dev \
    libcairo2-dev \
    pkg-config \
    python3-dev \
    gir1.2-gstreamer-1.0 \
    gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libusb-1.0-0 \
    libusb-1.0-0-dev \
    libudev1 \
    libudev-dev \
    curl \
 && rm -rf /var/lib/apt/lists/*

RUN poetry config virtualenvs.create false

RUN pip install --upgrade pip setuptools wheel \
 && pip install pycairo==1.29.0 \
 && pip install PyGObject==3.46.0 \
 && pip install reachy_mini

EXPOSE 8000/tcp
EXPOSE 8443/tcp
EXPOSE 5353/udp

HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=10 \
  CMD curl -fsS http://127.0.0.1:8000/docs >/dev/null || exit 1

CMD ["reachy-mini-daemon"]