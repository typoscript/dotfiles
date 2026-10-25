# ⚙️ Dotfiles & Dev Setup

내 개발 환경(macOS, WSL/Linux, AI CLI, Vim 등) 설정을 관리하기 위한 개인 저장소입니다.
어떤 컴퓨터(Mac, WSL 등)에서든 `git clone` 후 각 도구의 `install.sh`만 실행하면 즉시 동일한 개발 환경이 세팅됩니다.

---

## 📂 Directory Structure

```text
dotfiles/
├── README.md             # 저장소 가이드 및 단축키/기능 문서
├── AGENTS.md             # 🤖 AI 에이전트(Gemini) 전역 개발 및 자동 테스트 지침
├── antigravity/          # Antigravity CLI 설정 및 상태바
│   ├── install.sh        # OS 자동 판별 및 설정 병합 스크립트
│   ├── config.json       # 🌟 공통 기본 설정 (새 기능/설정 추가 시 여기만 수정)
│   ├── config.mac.json   # macOS 전용 오버라이드
│   ├── config.wsl.json   # WSL/Linux 전용 오버라이드
│   ├── statusline.py     # 상태바 스크립트 (컨텍스트 / 서드파티 / Gemini / Argon 사용량)
│   └── rules.md          # Antigravity 전역 룰
└── vim/                  # Vim & IdeaVim 통합 설정
    ├── install.sh        # ~/.vimrc, ~/.ideavimrc, ~/.vim 심볼릭 링크 자동 생성
    ├── .vimrc            # Vim 메인 진입점 (OS 감지 클립보드 연동)
    ├── .ideavimrc        # IntelliJ / JetBrains IdeaVim 전용 설정
    └── .vim/
        ├── options.vim   # 에디터 전역 옵션 (set, lets 통합)
        ├── keymaps.vim   # 단축키 및 축약어 (mappings, abbrevs 통합)
        ├── ui.vim        # 하이라이트 및 상태바 (highlights, statusline 통합)
        ├── functions.vim # 유틸리티 함수 및 커스텀 커맨드 (:Vrc 등)
        ├── autocmds.vim  # augroup 기반 전역 이벤트
        ├── ftplugin/     # 언어별 지연 로딩 (HTML, React, Java 등)
        ├── plugin/       # 커스텀 유틸리티 플러그인들
        └── snippets/     # 코드 스켈레톤 템플릿 파일들
```

---

## 🚀 빠른 시작 (설치 방법)

macOS와 WSL(Ubuntu 등) 모두 지원하며, OS를 자동 감지하여 기존 설정을 백업한 뒤 안전하게 설치합니다.

```bash
# 1. 저장소 클론
git clone https://github.com/typoscript/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Antigravity 설정 설치
./antigravity/install.sh

# 3. Vim 설정 설치 (심볼릭 링크 연결)
./vim/install.sh
```

---

## 📝 Vim & IdeaVim 상세 가이드

Vim 표준 디렉터리 구조를 준수하며, 파일타입별 지연 로딩(Lazy Loading) 및 OS별 클립보드 동기화를 지원합니다.

### 1. 주요 특징
- **크로스 플랫폼 클립보드**: 
  - WSL: `clip.exe`와 자동 연동되어 윈도우 클립보드로 복사
  - macOS: `pbcopy`/`pbpaste`(`unnamed,unnamedplus`)와 자동 연동
- **IdeaVim 연동**: IntelliJ, WebStorm 등 JetBrains IDE에서도 동일한 에디터 경험 제공 (`~/.ideavimrc`)
- **버퍼 누적 방지**: `augroup`을 적용하여 `:source ~/.vimrc` 실행 시 이벤트가 중복 실행되지 않음

### 2. 주요 단축키 (Leader Key: `<Space>`)

| 모드 | 단축키 | 설명 |
| :--- | :--- | :--- |
| **Normal** | `<Space>e` | Netrw 파일 탐색기 토글 (`:Lex`) |
| **Normal** | `-` | 현재 파일이 위치한 디렉터리를 Netrw로 열기 |
| **Normal** | `<Space>nh` | 검색 하이라이트 끄기 (`:noh`) |
| **Normal** | `<Space>l` / `<Space>nl` | 공백/탭/개행 특수문자 표시 켜기 / 끄기 |
| **Normal** | `<Space>qq` / `<Space>qa` | 창 닫기 (`:q`) / 전체 강제 종료 (`:qa!`) |
| **Insert** | `jk` | Normal 모드로 복귀 (`<Esc>`) |
| **Normal** | `d_` | 클립보드(레지스터)를 오염시키지 않고 현재 줄 삭제 |
| **Normal** | `Y` | 현재 커서부터 행 끝까지 복사 (`y$`) |
| **Normal** | `sw"` / `sw'` / `sw(` / `sw{` | 현재 단어를 따옴표/괄호로 감싸기 |
| **Normal** | `"aw` / `'aw` / `(aw` / `{aw` | 공백 포함 단어를 따옴표/괄호로 감싸기 |
| **Normal** | `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | 창(Window) 간 이동 |
| **Normal** | `<Left>` / `<Down>` / `<Up>` / `<Right>` | 창 크기 조절 |

### 3. 코드 스니펫 및 약어 (Snippets)

| 단축키 / 약어 | 모드 | 설명 |
| :--- | :--- | :--- |
| `snp.html` | Normal | HTML5 기본 스켈레톤 템플릿 삽입 |
| `snp.java` | Normal | Java 기본 클래스 스켈레톤 템플릿 삽입 |
| `snp.rfc` | Normal | React Functional Component 템플릿 삽입 |
| `:vrc` | Command | 새 탭에서 `~/.vimrc` 열기 |
| `:th <명령어>` | Command | 새 탭에서 도움말 열기 (`:tab help`) |
| `sysout` / `println` | Insert | Java 파일에서 `System.out.println();` 자동 완성 |
| `><Enter>` / `><Tab>` | Insert | HTML / React 파일에서 닫는 태그 자동 완성 |

---

## 🖥️ Antigravity CLI Statusline

`agy` 하단에 토큰 및 쿼터 현황을 3줄로 표시합니다.

```text
[Context] 12.3k / 1.0M (1.2%)
[3rd-Party] 5hr: 0.0%  |  Weekly: 98.4%
[Gemini] 5hr: 0.0%  |  Weekly: 4.2%  |  [Argon] Weekly: 92.3%
```

- **1행**: 현재 컨텍스트 사용량
- **2행**: 서드파티 모델의 5시간 / 주간 사용량
- **3행**: Gemini의 5시간 / 주간 사용량, Argon 주간 사용량

---

## 🤖 AI 에이전트(Gemini) 협업 지침

새로운 설정이나 기능을 추가할 때 모든 AI 에이전트는 [AGENTS.md](file:///home/juno/dotfiles/AGENTS.md)를 참조하여 개발합니다:
1. **단일 소스 원칙**: 공통 설정 우선, 플랫폼 차이점만 오버라이드
2. **자체 테스트 의무**: 기능 추가 후 WSL 및 macOS 가상 시뮬레이션 환경에서 자동 검증
3. **문서 동기화**: 추가된 기능은 반드시 `README.md`에 단축키 및 사용법을 문서화
