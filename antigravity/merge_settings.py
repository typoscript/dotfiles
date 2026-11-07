#!/usr/bin/env python3
"""
Antigravity CLI settings.json 병합 유틸리티 (base -> OS override -> 기존 settings.json)

- 스칼라 값: config 값이 기존 값을 덮어씀 (config 가 강제하는 값)
- 딕셔너리: 재귀 병합
- 리스트: 기존 항목을 유지하고 config 항목 중 없는 것만 추가 (합집합)
- config 또는 기존 settings.json 이 깨진 JSON 이면 아무것도 쓰지 않고 종료 코드 1
- 결과가 기존과 같으면 쓰지 않음, 바뀔 때만 기존 파일을 비파괴 백업 후 원자적으로 저장
"""
import argparse
import json
import os
import shutil
import sys
import tempfile
import time

try:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def fail(msg):
    print(f"❌ {msg}", file=sys.stderr)
    sys.exit(1)


def load_config(file_path, home_dir, required):
    if not os.path.exists(file_path):
        if required:
            fail(f"Config not found: {file_path}")
        return {}
    with open(file_path, "r", encoding="utf-8-sig") as f:
        # 백슬래시를 슬래시(/)로 정규화하여 JSON 파싱 에러 방지
        norm_home = home_dir.replace("\\", "/")
        content = f.read().replace("$HOME", norm_home)
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        fail(f"Invalid JSON in {file_path}: {e}")
    if not isinstance(data, dict):
        fail(f"Top-level JSON must be an object: {file_path}")
    return {k: v for k, v in data.items() if not k.startswith("_comment")}


def deep_merge(target, src):
    for k, v in src.items():
        if isinstance(v, dict) and isinstance(target.get(k), dict):
            deep_merge(target[k], v)
        elif isinstance(v, list) and isinstance(target.get(k), list):
            for item in v:
                if item not in target[k]:
                    target[k].append(item)
        else:
            target[k] = v
    return target


def free_backup_path(path):
    bak = f"{path}.bak"
    if not os.path.lexists(bak):
        return bak
    stamp = time.strftime("%Y%m%d-%H%M%S")
    bak = f"{path}.bak.{stamp}"
    n = 1
    while os.path.lexists(bak):
        bak = f"{path}.bak.{stamp}.{n}"
        n += 1
    return bak


def atomic_write(path, text):
    directory = os.path.dirname(os.path.abspath(path))
    os.makedirs(directory, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=".settings-", suffix=".tmp", dir=directory)
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as f:
            f.write(text)
        if os.path.exists(path):
            shutil.copymode(path, tmp)
        os.replace(tmp, path)
    except BaseException:
        if os.path.exists(tmp):
            os.remove(tmp)
        raise


def main():
    parser = argparse.ArgumentParser(description="Merge Antigravity CLI settings JSON")
    parser.add_argument("--base", required=True, help="Base config.json path")
    parser.add_argument("--override", default="", help="OS-specific override JSON path")
    parser.add_argument("--target", required=True, help="Destination settings.json path")
    parser.add_argument("--home", default="", help="Home directory path")
    args = parser.parse_args()

    home_dir = args.home or os.environ.get("USERPROFILE") or os.environ.get("HOME") or ""
    # 타깃이 심볼릭 링크면 링크를 깨지 않도록 실제 파일에 기록
    target = os.path.realpath(args.target)

    # 1. Base + OS 오버라이드 (하나라도 깨져 있으면 중단)
    final_config = load_config(args.base, home_dir, required=True)
    if args.override:
        deep_merge(final_config, load_config(args.override, home_dir, required=False))

    # 2. 기존 settings.json (깨져 있으면 덮어쓰지 않고 중단)
    existing_text = None
    existing_config = {}
    if os.path.exists(target):
        with open(target, "r", encoding="utf-8-sig") as f:
            existing_text = f.read()
        if existing_text.strip():
            try:
                existing_config = json.loads(existing_text)
            except json.JSONDecodeError as e:
                fail(
                    f"Existing settings is not valid JSON, refusing to overwrite: {target}\n"
                    f"   {e}\n   Fix or move the file, then run the installer again."
                )
            if not isinstance(existing_config, dict):
                fail(f"Existing settings top-level must be an object: {target}")

    merged = deep_merge(existing_config, final_config)
    new_text = json.dumps(merged, indent=2, ensure_ascii=False) + "\n"

    # 3. 변경 없으면 종료
    if existing_text is not None and existing_text == new_text:
        print(f"ℹ️  Already up to date: {target}")
        return

    # 4. 바뀔 때만 비파괴 백업 후 원자적 저장
    if existing_text is not None:
        bak = free_backup_path(target)
        shutil.copy2(target, bak)
        print(f"📦 Backed up existing settings to {bak}")

    atomic_write(target, new_text)
    print(f"✅ Successfully updated {target}")


if __name__ == "__main__":
    main()
