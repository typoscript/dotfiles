# Antigravity Dotfiles Agent Guidelines

이 문서는 사용자가 Antigravity 설정 및 dotfiles 기능 수정을 요청할 때 AI 에이전트(Gemini)가 반드시 준수해야 하는 행동 지침입니다.
저장소 전체 규칙(설치 스크립트 요건, 백업 원칙, 테스트, 문서화, 보안)은 dotfiles 저장소의 `AGENTS.md`가 기준이며, 이 문서는 Antigravity 설정에 대한 보충 사항만 다룹니다.

## 1. 설정 파일 관리 원칙 (Base + Override)
- **공통 기능**: 모든 신규 기능, 권한, 상태바 설정 등은 `antigravity/config.json`에 작성합니다.
- **OS별 특화 설정**: 특정 OS에서만 필요한 차이(경로, `python3` ↔ `python` 등)만 `config.mac.json`, `config.wsl.json`, `config.win.json`에 오버라이드로 추가합니다.
- 여러 OS에 공통인 설정은 각 OS 파일에 중복 작성하지 않고 `config.json` 하나에만 작성합니다.
- `merge_settings.py` 병합 규칙: 스칼라 값은 config 값으로 강제 적용, 리스트는 기존 항목 유지 + 없는 항목만 추가, 깨진 JSON이면 쓰지 않고 실패합니다.

## 2. 자동 검증 의무 (Mandatory Self-Testing)
기능을 추가하거나 설정을 변경한 뒤에는 **사용자가 명시적으로 요구하지 않아도** `AGENTS.md`의 3개 플랫폼(Windows / WSL·Linux / macOS 시뮬레이션) 테스트를 실행하고 결과를 보고합니다. Antigravity 관련 추가 확인 사항:
1. `settings.json`의 JSON 문법과 병합 결과 (기존 권한/리스트가 보존되는지 포함)
2. 재실행 시 변경이 없으면 `Already up to date`가 출력되고 새 백업이 생기지 않는지
3. `statusline.py` 수정 시: 정상 페이로드와 비정상 페이로드(빈 입력, 배열, 숫자 자리에 문자열)를 stdin으로 주입해 예외 없이 출력되는지

## 3. 문서 동기화 (Documentation)
- 새로운 기능이나 상태바 표시 항목이 추가되거나 수정되면 `README.md`의 디렉터리 구조 및 기능 설명도 함께 갱신합니다.
