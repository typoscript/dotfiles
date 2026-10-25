# Antigravity Dotfiles Agent Guidelines

이 문서는 사용자가 Antigravity 설정 및 dotfiles 기능 수정을 요청할 때 AI 에이전트(Gemini)가 반드시 준수해야 하는 행동 지침입니다.

## 1. 설정 파일 관리 원칙 (Base + Override)
- **공통 기능**: 기본적으로 모든 신규 기능, 공통 단축키, 플러그인, 상태바 설정 등은 `antigravity/config.json`에 작성합니다.
- **OS별 특화 설정**: 
  - 오직 특정 OS에서만 동작해야 하는 옵션이나 경로 차이(예: macOS 전용 Homebrew 경로, WSL 전용 윈도우 연동 옵션 등)가 있는 경우에만 `config.mac.json` 또는 `config.wsl.json`에 오버라이드로 추가합니다.
  - 두 OS에 모두 적용 가능한 설정은 절대 각 OS 파일에 중복 작성하지 않고 `config.json` 하나에만 작성합니다.

## 2. 양대 OS 자동 검증 의무 (Mandatory Self-Testing)
기능을 추가하거나 설정을 변경한 뒤에는 **사용자가 명시적으로 요구하지 않아도** 반드시 아래 2가지 테스트를 에이전트가 자체적으로 실행하여 검증하고 결과를 보고해야 합니다:
1. **WSL / Linux 환경 테스트**:
   - `./antigravity/install.sh` 실행
   - `settings.json` 내 JSON 문법 및 병합 결과 확인
2. **macOS 환경 시뮬레이션 테스트**:
   - 아래 모의 환경 실행 명령으로 macOS 분기 및 `$HOME` 치환 검증:
     ```bash
     TEST_DIR=$(mktemp -d)
     HOME="$TEST_DIR" OSTYPE="darwin23.0.0" ./antigravity/install.sh
     cat "$TEST_DIR/.gemini/antigravity-cli/settings.json"
     rm -rf "$TEST_DIR"
     ```
3. 상태바(`statusline.py`)나 파이썬 스크립트 수정 시:
   - 더미 JSON 페이로드를 stdin으로 주입하여 렌더링 에러가 없는지 검증

## 3. 문서 동기화 (Documentation)
- 새로운 기능이나 상태바 표시 항목 등이 추가되거나 수정되면, `README.md`의 디렉터리 구조 및 기능 설명도 함께 최신 상태로 갱신합니다.
