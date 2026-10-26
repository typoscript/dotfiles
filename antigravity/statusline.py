#!/usr/bin/env python3
"""
Antigravity CLI (agy) Custom Statusline Script
---------------------------------------------
첫째 줄: 컨텍스트 사용량 (context_window) 및 현재 모델 (model)
둘째 줄: 서드파티 (3p) 5hr, weekly 사용량
셋째 줄: 제미나이 (gemini) 5hr, weekly 사용량 및 Argon 주간 사용량

agy가 stdin으로 넘기는 JSON의 quota는 키가 "3p-5h", "gemini-weekly" 같은 형태이고
값은 remaining_fraction(남은 비율, 0~1)이라서 사용량은 (1 - remaining) * 100 으로 계산한다.
"""

import sys
import json
from datetime import datetime, timezone

RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"
CYAN = "\033[36m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
MAGENTA = "\033[35m"
BLUE = "\033[34m"
RED = "\033[31m"


def format_tokens(num):
    n = int(num or 0)
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n / 1_000:.1f}k"
    return f"{n:,}"


def color_for(pct):
    return GREEN if pct < 50 else (YELLOW if pct < 80 else RED)


def format_time_left(seconds):
    """남은 초(seconds)를 인간이 읽기 편한 형식으로 변환 (예: 3h 20m, 4d 18h, 45m)"""
    if seconds is None:
        return ""
    try:
        sec = int(seconds)
    except (ValueError, TypeError):
        return ""
    if sec <= 0:
        return ""

    days = sec // 86400
    hours = (sec % 86400) // 3600
    minutes = (sec % 3600) // 60

    if days > 0:
        return f"{days}d {hours}h"
    if hours > 0:
        return f"{hours}h {minutes}m"
    if minutes > 0:
        return f"{minutes}m"
    return "<1m"


def format_label(label, quota_entry):
    """라벨(5hr, Weekly 등) 옆에 초기화 잔여 시간을 괄호로 추가 (예: 5hr (3h 20m): )"""
    if not isinstance(quota_entry, dict):
        return f"{label}:"

    sec = quota_entry.get("reset_in_seconds")
    if sec is None and quota_entry.get("reset_time"):
        try:
            rt = quota_entry.get("reset_time")
            dt = datetime.fromisoformat(rt.replace("Z", "+00:00"))
            sec = int((dt - datetime.now(timezone.utc)).total_seconds())
        except Exception:
            sec = None

    time_str = format_time_left(sec)
    if time_str:
        return f"{label} ({time_str}):"
    return f"{label}:"


def format_used(quota_entry):
    """quota 항목에서 사용률(%)을 계산해 색상과 함께 반환"""
    if not isinstance(quota_entry, dict):
        return f"{DIM}N/A{RESET}"
    remaining = quota_entry.get("remaining_fraction")
    if remaining is None:
        return f"{DIM}N/A{RESET}"
    used = (1.0 - float(remaining)) * 100
    return f"{color_for(used)}{used:.1f}%{RESET}"


def main():
    try:
        if hasattr(sys.stdout, "reconfigure"):
            sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

    raw = ""
    try:
        if not sys.stdin.isatty():
            raw = sys.stdin.buffer.read().decode("utf-8-sig", errors="replace").strip()
    except Exception:
        raw = ""

    try:
        payload = json.loads(raw) if raw else {}
    except json.JSONDecodeError:
        payload = {}

    # 1행: 컨텍스트 및 현재 모델
    ctx = payload.get("context_window") or {}
    used_pct = float(ctx.get("used_percentage") or 0)
    size = int(ctx.get("context_window_size") or 0)
    used_tokens = int(ctx.get("total_input_tokens") or 0)
    line1 = (
        f"{CYAN}{BOLD}[Context]{RESET} "
        f"{format_tokens(used_tokens)} / {format_tokens(size)} "
        f"({color_for(used_pct)}{used_pct:.1f}%{RESET})"
    )

    model_obj = payload.get("model") or {}
    if isinstance(model_obj, dict):
        model_name = model_obj.get("display_name") or model_obj.get("id") or ""
    elif isinstance(model_obj, str):
        model_name = model_obj
    else:
        model_name = ""

    if model_name:
        line1 += f"  |  {model_name}"

    quota = payload.get("quota") or {}

    # 2행: 서드파티
    q_3p_5h = quota.get("3p-5h")
    q_3p_w = quota.get("3p-weekly")
    line2 = (
        f"{MAGENTA}{BOLD}[3rd-Party]{RESET} "
        f"{format_label('5hr', q_3p_5h)} {format_used(q_3p_5h)}  |  "
        f"{format_label('Weekly', q_3p_w)} {format_used(q_3p_w)}"
    )

    # 3행: 제미나이 + 아르곤
    q_gem_5h = quota.get("gemini-5h")
    q_gem_w = quota.get("gemini-weekly")
    q_argon_w = quota.get("gemini-argon-wtu-weekly")
    line3 = (
        f"{BLUE}{BOLD}[Gemini]{RESET} "
        f"{format_label('5hr', q_gem_5h)} {format_used(q_gem_5h)}  |  "
        f"{format_label('Weekly', q_gem_w)} {format_used(q_gem_w)}  |  "
        f"{YELLOW}{BOLD}[Argon]{RESET} {format_label('Weekly', q_argon_w)} {format_used(q_argon_w)}"
    )

    sys.stdout.write(f"{line1}\n{line2}\n{line3}\n")


if __name__ == "__main__":
    main()
