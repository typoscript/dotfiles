#!/usr/bin/env python3
import argparse
import json
import os
import sys

try:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def load_json_with_home(file_path, home_dir):
    if not os.path.exists(file_path):
        return {}
    with open(file_path, "r", encoding="utf-8") as f:
        # 백슬래시를 슬래시(/)로 정규화하여 JSON 파싱 에러 방지
        norm_home = home_dir.replace("\\", "/")
        content = f.read().replace("$HOME", norm_home)
        try:
            data = json.loads(content)
            return {k: v for k, v in data.items() if not k.startswith("_comment")}
        except Exception as e:
            print(f"⚠️ Error reading {file_path}: {e}")
            return {}


def deep_merge(target, src):
    for k, v in src.items():
        if isinstance(v, dict) and k in target and isinstance(target[k], dict):
            deep_merge(target[k], v)
        else:
            target[k] = v
    return target


def main():
    parser = argparse.ArgumentParser(description="Merge Antigravity CLI settings JSON")
    parser.add_argument("--base", required=True, help="Base config.json path")
    parser.add_argument("--override", default="", help="OS-specific override JSON path")
    parser.add_argument("--target", required=True, help="Destination settings.json path")
    parser.add_argument("--home", default="", help="Home directory path")
    args = parser.parse_args()

    home_dir = args.home or os.environ.get("USERPROFILE") or os.environ.get("HOME") or ""

    # 1. Base 설정 로드
    final_config = load_json_with_home(args.base, home_dir)

    # 2. OS별 오버라이드 로드
    if args.override and os.path.exists(args.override):
        override_data = load_json_with_home(args.override, home_dir)
        final_config = deep_merge(final_config, override_data)

    # 3. 기존 타깃 설정 로드 (기존 권한, 신뢰 워크스페이스 등 보존)
    existing_config = {}
    if os.path.exists(args.target):
        try:
            with open(args.target, "r", encoding="utf-8") as f:
                existing_config = json.load(f)
        except Exception as e:
            print(f"⚠️ Could not parse existing target JSON: {e}")

    merged = deep_merge(existing_config, final_config)

    # 4. 저장
    os.makedirs(os.path.dirname(os.path.abspath(args.target)), exist_ok=True)
    with open(args.target, "w", encoding="utf-8") as f:
        json.dump(merged, f, indent=2, ensure_ascii=False)
        f.write("\n")

    print(f"✅ Successfully updated {args.target}")


if __name__ == "__main__":
    main()
