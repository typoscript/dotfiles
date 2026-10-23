#!/usr/bin/env python3
"""
Antigravity CLI (agy) Custom Statusline Script
---------------------------------------------
첫째 줄: 컨텍스트 사용량 (context_window)
둘째 줄: 서드파티 (3p) 5hr, weekly 사용량
셋째 줄: 제미나이 (gemini) 5hr, weekly 사용량 및 Argon 주간 사용량

agy가 stdin으로 넘기는 JSON의 quota는 키가 "3p-5h", "gemini-weekly" 같은 형태이고
값은 remaining_fraction(남은 비율, 0~1)이라서 사용량은 (1 - remaining) * 100 으로 계산한다.
"""

import sys
import json

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
    raw = sys.stdin.read() if not sys.stdin.isatty() else ""
    try:
        payload = json.loads(raw) if raw.strip() else {}
    except json.JSONDecodeError:
        payload = {}

    # 1행: 컨텍스트
    ctx = payload.get("context_window") or {}
    used_pct = float(ctx.get("used_percentage") or 0)
    size = int(ctx.get("context_window_size") or 0)
    used_tokens = int(ctx.get("total_input_tokens") or 0)
    line1 = (
        f"{CYAN}{BOLD}[Context]{RESET} "
        f"{format_tokens(used_tokens)} / {format_tokens(size)} "
        f"({color_for(used_pct)}{used_pct:.1f}%{RESET})"
    )

    quota = payload.get("quota") or {}

    # 2행: 서드파티
    line2 = (
        f"{MAGENTA}{BOLD}[3rd-Party]{RESET} "
        f"5hr: {format_used(quota.get('3p-5h'))}  |  "
        f"Weekly: {format_used(quota.get('3p-weekly'))}"
    )

    # 3행: 제미나이 + 아르곤
    line3 = (
        f"{BLUE}{BOLD}[Gemini]{RESET} "
        f"5hr: {format_used(quota.get('gemini-5h'))}  |  "
        f"Weekly: {format_used(quota.get('gemini-weekly'))}  |  "
        f"{YELLOW}{BOLD}[Argon]{RESET} Weekly: {format_used(quota.get('gemini-argon-wtu-weekly'))}"
    )

    sys.stdout.write(f"{line1}\n{line2}\n{line3}\n")


if __name__ == "__main__":
    main()
