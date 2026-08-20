## 项目说明

本仓库用于维护一组深度学习环境的 Dockerfile，方便在不同硬件平台上（CUDA GPU、华为 Ascend NPU、ARM）快速构建统一的 Python/Poetry 运行环境。

所有镜像均基于内部镜像仓库的基础镜像：

`registry.cn-hangzhou.aliyuncs.com/migo-dl/python:3.10.18-poetry-0-4-1`

## 目录结构

- `arm/`：ARM 平台相关 Dockerfile（CPU 或特定 ARM 设备）。
  - `0-5-0-cu124.dockerfile`：CUDA 12.4 + PyTorch 2.5.1 等版本的环境。
- `cuda/`：CUDA GPU 平台相关 Dockerfile。
  - `0-5-0-cu124.dockerfile`：CUDA 12.4 + PyTorch 2.5.1 等版本的环境。
- `ascend-aarch64/`：华为 Ascend（aarch64）平台相关 Dockerfile。
  - `0-5-0-cann82rc2*.dockerfile`：基于 CANN 8.2 RC2 的 Ascend 运行环境。
  - `2-6-0-cann82rc2.dockerfile`：PyTorch 2.6.0 + torch-npu 2.6.0 等 Ascend 环境。
  - `fairseq2/`：与 fairseq2/语音相关的 Ascend 环境 Dockerfile。
- `ax/m4c/`：AX650/M4C ARM64 平台的 AXEngine Python 基础环境。
  - `0-1-3.dockerfile`：预装 `axengine 0.1.3` 及锁定的最小 Python 依赖。

## 构建示例

在仓库根目录（当前目录）下执行以下命令进行构建：

- 构建 CUDA 环境（示例：CUDA 12.4 + PyTorch 2.5.1）：

```bash
docker build -f cuda/0-5-0-cu124.dockerfile -t my-cuda-0.5.0-cu124 .
```

- 构建 Ascend 环境（示例：2.6.0 CANN 8.2 RC2）：

```bash
docker build -f ascend-aarch64/2-6-0-cann82rc2.dockerfile -t my-ascend-2.6.0 .
```

- 构建 ARM 平台环境：

```bash
docker build -f arm/0-5-0-cu124.dockerfile -t my-arm-0.5.0-cu124 .
```

- 构建 AX650/M4C AXEngine 环境：

```bash
docker build \
  -f ax/m4c/0-1-3.dockerfile \
  -t registry.cn-hangzhou.aliyuncs.com/migo-dl/axengine:0.1.3-m4c-aarch64 .
```

该镜像固定为 ARM64，工作目录是 `/app`，Python 3.10 虚拟环境位于 `/app/.venv`。镜像已设置 `PATH`、`VIRTUAL_ENV` 和 Poetry 的 `virtualenvs.in-project=true`，下游 Dockerfile 可以直接复制 `pyproject.toml` 后执行 `poetry install`，依赖会安装到同一个 `/app/.venv`。

镜像只包含 AXEngine Python binding，不包含板卡用户态 `.so`、模型或业务项目。运行时需在 AX650/M4C 宿主使用 `axera-container-runtime`：

```bash
docker run --rm --runtime=axera --privileged \
  registry.cn-hangzhou.aliyuncs.com/migo-dl/axengine:0.1.3-m4c-aarch64 \
  python -c 'import axengine; print(axengine.get_available_providers())'
```

不要把 volume 直接挂载到 `/app`，否则会遮蔽镜像内的 `/app/.venv`；开发代码可挂载到 `/workspace`，或在派生镜像中使用 `COPY` 合并到 `/app`。

## 注意事项

- 这些 Dockerfile 依赖内部镜像仓库与内部 HTTP 源（如 `registry.cn-hangzhou.aliyuncs.com`、`192.168.0.222` 等），请确保在可访问的网络环境中使用。
- 部分 Dockerfile 中设置了国内 PyPI 镜像（如清华源），如有需要可按实际情况修改。
- 构建完成后可使用 `docker run -it <image> bash` 进入容器，或直接使用其中的 Python/Poetry 环境进行开发与部署。
