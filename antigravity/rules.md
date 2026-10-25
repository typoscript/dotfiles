# Antigravity Global Agent Rules

이 파일은 Antigravity CLI 에이전트의 공통 전역 행동 지침입니다.

## 1. General Principles
- **Concise & Clear**: 설명은 핵심 위주로 간결하고 명확하게 작성합니다.
- **Documentation Integrity**: 기존 주석이나 문서 포맷을 보존합니다.
- **Safety**: 파일 삭제나 되돌릴 수 없는 작업 시 주의를 기울입니다.

## 2. OS-Specific Awareness
- **macOS**: 패키지 관리자로 `brew`를 우선 고려하며, 경로는 `/Users/<user>`를 따릅니다.
- **WSL / Linux**: 패키지 관리자로 `apt` 등을 사용하며, 윈도우 파일 접근 경로는 `/mnt/c/...` 임을 인지합니다.

## 3. Coding Style
- 코드 변경 시 불필요한 서식 변경을 최소화하고, 프로젝트 고유의 린트/컨벤션을 존중합니다.
