# 🤖 Dotfiles AI Agent Guidelines (AGENTS.md)

이 문서는 어떤 머신(macOS, WSL, Linux 등)에서든 AI 에이전트(Gemini 등)가 이 저장소에 새로운 설정을 추가하거나 기존 기능을 수정할 때 반드시 준수해야 하는 **저장소 전역 개발 가이드라인**입니다.

---

## 1. 📂 새로운 도구(Config) 추가 시 표준 템플릿

새로운 도구(예: `zsh`, `tmux`, `git` 등)를 추가할 때는 반드시 아래의 **독립 모듈형(Topic-based) 구조**를 따릅니다:

```text
dotfiles/<tool>/
├── install.sh         # [필수] OS 자동 감지, 기존 파일 .bak 백업, 심볼릭 링크 생성
├── README.md          # (선택) 해당 도구의 복잡한 커스텀 설명이 필요할 때
└── 설정 파일들        # 예: .zshrc, .gitconfig, tmux.conf 등
```

### `install.sh` 필수 요구조건:
1. **멱등성(Idempotent)**: 여러 번 실행해도 안전해야 하며, 이미 심볼릭 링크가 걸려 있다면 건너뛰거나 갱신합니다.
2. **기존 파일 백업**: 대상 경로에 기존 설정이 파일이나 디렉터리로 존재하면 `${dest}.bak`으로 백업합니다.
3. **OS 자동 감지**: macOS(`Darwin`), WSL(`microsoft`), Linux를 구분하여 플랫폼별 차이를 지원합니다.
4. **실행 권한**: `chmod +x install.sh`를 부여합니다.

---

## 2. ⚙️ 설정 파일 분기 원칙 (Base vs Override)

- **단일 소스 원칙 (Single Source of Truth)**:
  - 공통 설정은 기본 파일(`config.json`, 공통 스크립트 등) 하나에만 작성합니다.
  - OS별 차이점(경로, 패키지 매니저, 클립보드 등)만 조건문(`if [[ "$OSTYPE" == "darwin"* ]]`)이나 오버라이드 파일(`config.mac.json`, `config.wsl.json`)로 분리합니다.
  - 동일한 설정을 두 개 이상의 파일에 복사/붙여넣기하여 중복 관리하지 않습니다.

---

## 3. 🧪 양대 OS 자동 검증 의무 (Mandatory Self-Testing)

어떤 기능이나 설정을 추가/수정한 뒤에는 **사용자가 요청하지 않아도** 반드시 아래 테스트를 에이전트 스스로 실행하고 결과를 보고해야 합니다:

1. **WSL / Linux 환경 테스트**:
   - `install.sh` 실행 및 심볼릭 링크 생성 확인
   - 문법 오류(Syntax error) 검증 (예: `vim -e -s -c "q"`, `python3 -m py_compile`, `bash -n`)
2. **macOS 환경 시뮬레이션 테스트**:
   - 아래 모의 환경 실행을 통해 macOS 분기 및 경로 치환이 정상 동작하는지 직접 검증:
     ```bash
     TEST_DIR=$(mktemp -d)
     HOME="$TEST_DIR" OSTYPE="darwin23.0.0" ./<tool>/install.sh
     ls -la "$TEST_DIR"
     rm -rf "$TEST_DIR"
     ```

---

## 4. 📝 README.md 문서화 의무 (Documentation)

새로운 도구가 추가되거나 기존 도구에 기능(단축키, 플러그인, 옵션 등)이 추가되면 **반드시 `README.md`에도 상세 설명(사용법, 주요 단축키 표, 특징)을 동기화**해야 합니다.
README에 기록되지 않은 기능은 사용자가 알 수 없으므로 작업 미완료로 간주합니다.

---

## 5. 🔒 보안 원칙 (Security)
- API 키, 개인 토큰, SSH Private Key, 회사 비밀번호 등은 **절대 커밋하지 않습니다**.
- 로컬 머신 전용 비밀값은 `*.local` 파일로 분리하고, `.gitignore`에 등록합니다.
