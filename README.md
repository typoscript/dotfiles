# ⚙️ Dotfiles & Dev Setup

내 개발 환경(macOS, WSL/Linux, AI CLI 등) 설정을 관리하기 위한 저장소입니다.
현재는 **Antigravity CLI(`agy`) 커스텀 설정 및 상태바(Statusline)**를 시작으로, 추후 다양한 환경 설정들을 점진적으로 추가할 예정입니다.

---

## 📂 Directory Structure

```text
dotfiles/
├── README.md
├── antigravity/
│   ├── install.sh        # OS 자동 판별 및 설정 병합 스크립트
│   ├── config.json       # 🌟 공통 기본 설정 (새 기능/설정 추가 시 여기만 수정)
│   ├── config.mac.json   # macOS 전용 오버라이드 (맥 특화 설정이 필요할 때만 작성)
│   ├── config.wsl.json   # WSL/Linux 전용 오버라이드 (WSL 특화 설정이 필요할 때만 작성)
│   ├── statusline.py     # 상태바 스크립트 (컨텍스트 / 서드파티 / Gemini / Argon 사용량 출력)
│   └── rules.md          # AI 에이전트(Gemini) 전역 개발 및 행동 지침
└── vim/
    ├── install.sh        # Vim 및 IdeaVim 설정 심볼릭 링크 설치 스크립트
    ├── .vimrc            # Vim 기본 설정 (WSL/macOS 클립보드 호환)
    ├── .ideavimrc        # IntelliJ / JetBrains IdeaVim 설정
    └── .vim/             # 모듈화된 Vim 설정 (mappings, plugin, snippets 등)
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

# 3. Vim 설정 설치 (심볼릭 링크 연결)
./vim/install.sh
```

### `install.sh`가 수행하는 작업
1. `~/.config/agy/statusline.py` 심볼릭 링크 생성 및 실행 권한 부여
2. 현재 OS(macOS 또는 WSL/Linux) 자동 감지
3. 기존 `~/.gemini/antigravity-cli/settings.json` 백업 생성 (`settings.json.bak`)
4. **Base + Override 병합**: `config.json`을 기본으로 읽고, OS별 오버라이드(`config.mac.json` 등)를 적용한 뒤, 기존 로컬 설정(권한, 신뢰 워크스페이스 등)을 보존하며 병합
5. `rules.md`를 `~/.gemini/antigravity-cli/rules/global_rules.md`로 심볼릭 링크 연결

---

## 🤖 AI 에이전트 협업 가이드 (`rules.md`)

이 저장소에는 Antigravity AI 에이전트(Gemini)의 행동 지침인 `rules.md`가 포함되어 있습니다.
에이전트에게 기능을 추가해달라고 요청하면 에이전트가 다음 원칙에 따라 자동으로 작업합니다:
- **단일 소스 관리**: 공통 설정은 `config.json`에 반영하고, OS 특화 설정만 분기합니다.
- **자동 검증 의무**: 작업 후 에이전트가 직접 WSL 및 macOS 시뮬레이션 환경에서 `install.sh`와 스크립트 테스트를 자체 실행하고 결과를 보고합니다.

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
