from __future__ import annotations

import argparse
import hashlib
import http.server
import os
import socket
from pathlib import Path
from typing import Final

FILES: Final[list[str]] = [
    "Ascend-cann-toolkit_8.5.0_linux-aarch64.run",
    "Ascend-cann-910b-ops_8.5.0_linux-aarch64.run",
    "Ascend-cann-nnal_8.5.0_linux-aarch64.run",
    "vllm/wheels/xlite-0.1.0-cp310-cp310-linux_aarch64.whl"
]


def sha256sum(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def get_local_ip() -> str:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    except OSError:
        return "127.0.0.1"
    finally:
        s.close()


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self) -> None:
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, format: str, *args) -> None:
        print(f"[{self.address_string()}] {format % args}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="0.0.0.0", help="监听地址，默认 0.0.0.0")
    parser.add_argument("--port", type=int, default=8000, help="端口，默认 8000")
    args = parser.parse_args()

    root = Path(__file__).resolve().parent
    os.chdir(root)

    missing = [name for name in FILES if not (root / name).exists()]
    if missing:
        print("缺少以下文件：")
        for name in missing:
            print(f"  - {name}")
        raise SystemExit(1)

    print("将要提供以下文件：")
    for name in FILES:
        path = root / name
        print(f"  - {name}")
        print(f"    size   : {path.stat().st_size / 1024 / 1024:.2f} MiB")
        print(f"    sha256 : {sha256sum(path)}")

    local_ip = get_local_ip()
    print()
    print(f"本机访问地址: http://127.0.0.1:{args.port}/")
    print(f"局域网访问地址: http://{local_ip}:{args.port}/")
    print()
    for name in FILES:
        print(f"http://{local_ip}:{args.port}/{name}")

    server = http.server.ThreadingHTTPServer((args.host, args.port), Handler)
    print()
    print("文件服务器已启动，按 Ctrl+C 停止。")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n已停止。")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
    
