# ⚙️ Dotfiles & Dev Setup

내 개발 환경(macOS, WSL/Linux, AI CLI 등) 설정을 관리하기 위한 저장소입니다.
현재는 **Antigravity CLI(`agy`) 커스텀 설정 및 상태바(Statusline)**를 시작으로, 추후 다양한 환경 설정들을 점진적으로 추가할 예정입니다.

---

## 📂 Directory Structure

```text
dotfiles/
├── README.md
└── antigravity/
    ├── install.sh        # OS 자동 판별 및 심볼릭 링크 / 설정 병합 스크립트
    ├── config.mac.json   # macOS 전용 설정 ($HOME 경로 자동 치환 지원)
    ├── config.wsl.json   # WSL/Linux 전용 설정 ($HOME 경로 자동 치환 지원)
    ├── statusline.py     # 상태바 스크립트 (컨텍스트 / 서드파티 / Gemini / Argon 사용량 출력)
    └── rules.md          # Antigravity 글로벌 에이전트 행동 지침
```

---

## 🚀 빠른 시작 (설치 방법)

macOS와 WSL(Ubuntu 등) 모두 지원하며, OS를 자동 감지하여 설정을 안전하게 적용합니다.

```bash
# 1. 저장소 클론
git clone https://github.com/typoscript/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Antigravity 설정 설치
./antigravity/install.sh
```

### `install.sh`가 수행하는 작업
1. `~/.config/agy/statusline.py` 심볼릭 링크 생성 및 실행 권한 부여
2. 현재 OS(macOS 또는 WSL/Linux) 자동 감지
3. 기존 `~/.gemini/antigravity-cli/settings.json` 백업 생성 (`settings.json.bak`)
4. 기존 설정(사용자 권한, 허용된 워크스페이스 등)을 보존하면서 OS별 `statusLine` 설정을 안전하게 병합(Merge)
5. `rules.md`를 `~/.gemini/antigravity-cli/rules/global_rules.md`로 심볼릭 링크 연결

---

## 🖥️ Antigravity CLI Statusline

`agy` 하단에 아래 3줄을 표시합니다.

```text
[Context] 12.3k / 1.0M (1.2%)
[3rd-Party] 5hr: 0.0%  |  Weekly: 98.4%
[Gemini] 5hr: 0.0%  |  Weekly: 4.2%  |  [Argon] Weekly: 92.3%
```

- **1행**: 현재 컨텍스트 사용량
- **2행**: 서드파티 모델의 5시간 / 주간 사용량
- **3행**: Gemini의 5시간 / 주간 사용량, Argon 주간 사용량

사용량은 `agy`가 stdin으로 넘기는 `quota` 값(`remaining_fraction`)을 기준으로 `(1 - 남은 비율) × 100`으로 계산합니다. 사용률에 따라 50% 미만은 초록, 80% 미만은 노랑, 그 이상은 빨강으로 표시됩니다.

### 요구 사항

- macOS 또는 WSL / Linux
- `python3` (표준 라이브러리만 사용하므로 추가 패키지 설치는 필요 없습니다)

### 참고

- 값이 없으면 `N/A`로 표시됩니다.
- 스크립트가 계속 실패하면 `agy`가 statusline을 자동 비활성화할 수 있으니, 설정을 바꾼 뒤에는 `agy`를 재시작해 주세요.
- 실제 payload 구조가 바뀌면 `statusline.py`의 `quota` 키 이름(`3p-5h`, `gemini-weekly` 등)을 맞춰 수정해야 합니다.
