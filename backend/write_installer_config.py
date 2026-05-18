#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import annotations
import configparser
import sys
from pathlib import Path

try:
    import yaml
except ImportError as e:  # pragma: no cover
    print("PyYAML is required.", file=sys.stderr)
    raise SystemExit(1) from e


def _section(cp: configparser.ConfigParser, name: str) -> dict[str, str]:
    if not cp.has_section(name):
        return {}
    return {k: str(v).strip() for k, v in cp.items(name)}


def main() -> int:
    if len(sys.argv) < 3:
        print(__doc__, file=sys.stderr)
        return 2
    ini_path = Path(sys.argv[1])
    out_path = Path(sys.argv[2])
    if not ini_path.is_file():
        print(f"INI not found: {ini_path}", file=sys.stderr)
        return 1

   
    cp = configparser.ConfigParser(interpolation=None, inline_comment_prefixes=(";",))
    read_ok = cp.read(ini_path, encoding="utf-8-sig")
    if not read_ok:
        print(f"无法读取 INI: {ini_path}", file=sys.stderr)
        return 1

    srv = _section(cp, "server")
    db = _section(cp, "mysql")
    redis = _section(cp, "redis")
    celery = _section(cp, "celery")
    sec = _section(cp, "security")
    fe = _section(cp, "frontend")

    host = (db.get("host") or "127.0.0.1").strip()
    port = int((db.get("port") or "3306").strip() or 3306)
    user = (db.get("user") or "root").strip()
    password = db.get("password", "")
    if password is None:
        password = ""
    name = (db.get("name") or "").strip()
    if not name:
        print(
     
            file=sys.stderr,
        )
        print(f"当前解析到的 [mysql] 键: {sorted(db.keys())}", file=sys.stderr)
        return 1

    from urllib.parse import quote

    enc = quote(password, safe="")
    base = f"{user}:{enc}@{host}:{port}/{name}?charset=UTF8MB4"
    sync_url = f"mysql+pymysql://{base}"
    async_url = f"mysql+aiomysql://{base}"

    server_port = int(srv.get("port", "8100") or 8100)
    listen_host = srv.get("host", "0.0.0.0")

    broker = celery.get("broker_url") or redis.get("uri", "redis://127.0.0.1:6379/5")
    result_backend = celery.get("result_backend") or broker
    beat_db = celery.get("beat_db_url") or sync_url

    public_base = fe.get("public_base_url") or f"http://127.0.0.1:{server_port}"
    dist_path = fe.get("dist_path") or "frontend/dist"

    cfg: dict = {
        "server": {"host": listen_host, "port": server_port},
        "database": {
            "async_url": async_url,
            "sync_url": sync_url,
        },
        "redis": {"uri": redis.get("uri", "redis://127.0.0.1:6379/4")},
        "celery": {
            "broker_url": broker,
            "result_backend": result_backend,
            "beat_db_url": beat_db,
        },
        "security": {"secret_key": sec.get("secret_key", "change-me-in-production")},
        "frontend": {"dist_path": dist_path, "public_base_url": public_base},
        "optional": {"grant_admin_oauth": True},
    }

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        yaml.safe_dump(
            cfg,
            f,
            allow_unicode=True,
            default_flow_style=False,
            sort_keys=False,
        )
    print(f"Wrote {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
