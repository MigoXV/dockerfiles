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

## 注意事项

- 这些 Dockerfile 依赖内部镜像仓库与内部 HTTP 源（如 `registry.cn-hangzhou.aliyuncs.com`、`192.168.0.222` 等），请确保在可访问的网络环境中使用。
- 部分 Dockerfile 中设置了国内 PyPI 镜像（如清华源），如有需要可按实际情况修改。
- 构建完成后可使用 `docker run -it <image> bash` 进入容器，或直接使用其中的 Python/Poetry 环境进行开发与部署。
