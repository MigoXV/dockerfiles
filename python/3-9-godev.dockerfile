FROM python:3.9

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# # 先用默认源装好 CA（避免你切到 https 源后，机器缺 CA 导致 apt update TLS 失败）
# RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

# ---- APT 换中科大源（直接覆盖 Debian 12+/trixie 的 debian.sources 机制）----
COPY debian.sources /etc/apt/sources.list.d/debian.sources
RUN rm -f /etc/apt/sources.list

# ---- 系统开发依赖：C/C++ 工具链 + 常用库 + 常用工具 ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    # 基础与常用工具
    curl wget git openssh-client rsync \
    unzip zip tar xz-utils file tree jq \
    vim nano less \
    iputils-ping net-tools dnsutils \
    sudo \
    # 构建/调试工具链
    build-essential pkg-config \
    gcc g++ gfortran \
    clang lldb lld gdb \
    make cmake ninja-build \
    autoconf automake libtool \
    # Python/C 扩展常见依赖
    python3-dev python3-venv \
    libssl-dev libffi-dev zlib1g-dev libbz2-dev liblzma-dev \
    libreadline-dev libsqlite3-dev \
    libncurses5-dev libncursesw5-dev \
    libxml2-dev libxslt1-dev \
    libjpeg-dev libpng-dev libfreetype6-dev \
    libudev-dev libusb-1.0-0-dev \
    && rm -rf /var/lib/apt/lists/*


# ---- 安装 Go 1.24.9（支持 amd64/arm64，含 SHA256 校验）----
ARG GO_VERSION=1.24.9
ARG TARGETARCH

RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    case "${arch}" in \
      amd64) GO_ARCH="amd64"; GO_SHA256="5b7899591c2dd6e9da1809fde4a2fad842c45d3f6b9deb235ba82216e31e34a6" ;; \
      arm64) GO_ARCH="arm64"; GO_SHA256="9aa1243d51d41e2f93e895c89c0a2daf7166768c4a4c3ac79db81029d295a540" ;; \
      *) echo "Unsupported arch: ${arch}"; exit 1 ;; \
    esac; \
    url="https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"; \
    curl -fsSL -H 'Accept-Encoding: identity' "${url}" -o /tmp/go.tgz; \
    echo "${GO_SHA256}  /tmp/go.tgz" | sha256sum -c -; \
    rm -rf /usr/local/go; \
    tar -C /usr/local -xzf /tmp/go.tgz; \
    rm -f /tmp/go.tgz; \
    /usr/local/go/bin/go version

ENV GOPATH=/go
ENV PATH=/usr/local/go/bin:/go/bin:$PATH
RUN mkdir -p /go/src /go/pkg /go/bin

# ---- 创建默认开发用户（可选但很实用）----
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN set -eux; \
    groupadd --gid "${USER_GID}" "${USERNAME}" 2>/dev/null || true; \
    useradd  --uid "${USER_UID}" --gid "${USER_GID}" -m -s /bin/bash "${USERNAME}" 2>/dev/null || true; \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USERNAME}; \
    chmod 0440 /etc/sudoers.d/${USERNAME}; \
    chown -R "${USERNAME}:${USERNAME}" /go

WORKDIR /workspace

CMD ["/bin/bash"]
