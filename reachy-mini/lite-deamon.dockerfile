FROM registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1-arm

ENV DEBIAN_FRONTEND=noninteractive \
    GST_PLUGIN_PATH=/opt/gst-plugins-rs/lib/aarch64-linux-gnu:$GST_PLUGIN_PATH

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    pkg-config \
    python3-dev \
    ca-certificates \
    gobject-introspection \
    libgirepository1.0-dev \
    libcairo2-dev \
    libglib2.0-dev \
    libffi-dev \
    libssl-dev \
    libusb-1.0-0 \
    libusb-1.0-0-dev \
    libudev1 \
    libudev-dev \
    libportaudio2 \
    libnice10 \
    python3-gi \
    python3-gi-cairo \
    alsa-utils \
    gstreamer1.0-tools \
    gstreamer1.0-alsa \
    gstreamer1.0-nice \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN poetry config virtualenvs.create false

RUN pip install --upgrade pip setuptools wheel \
 && pip install pycairo==1.29.0 \
 && pip install PyGObject==3.46.0 \
 && pip install reachy_mini

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH

RUN git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs.git /tmp/gst-plugins-rs \
 && cd /tmp/gst-plugins-rs \
 && git checkout 0.14.1 \
 && cargo install cargo-c \
 && mkdir -p /opt/gst-plugins-rs \
 && cargo cinstall -p gst-plugin-webrtc --prefix=/opt/gst-plugins-rs --release \
 && rm -rf /tmp/gst-plugins-rs

EXPOSE 8000/tcp
EXPOSE 8443/tcp
EXPOSE 5353/udp

CMD ["reachy-mini-daemon"]