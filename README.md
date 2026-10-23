# ⚙️ Dotfiles & Dev Setup

내 개발 환경(macOS, AI CLI 등) 설정을 관리하기 위한 저장소입니다.
현재는 **Antigravity CLI(`agy`) 상태바(Statusline) 커스텀 설정**을 시작으로, 추후 다양한 환경 설정들을 점진적으로 추가할 예정입니다.

---

## 📂 Directory Structure

```text
dotfiles/
├── README.md
└── antigravity/
    ├── statusline.py     # 상태바 스크립트 (컨텍스트 / 서드파티 / Gemini / Argon 사용량 출력)
    └── settings.json     # Antigravity CLI 설정 예시 (statusLine 항목 포함)
```

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

### 설치 방법

1. 스크립트를 복사합니다.

   ```bash
   mkdir -p ~/.config/agy
   cp antigravity/statusline.py ~/.config/agy/statusline.py
   chmod +x ~/.config/agy/statusline.py
   ```

2. `~/.gemini/antigravity-cli/settings.json`의 `statusLine` 항목을 아래와 같이 설정합니다.

   ```json
   "statusLine": {
     "type": "command",
     "command": "python3 /Users/<사용자이름>/.config/agy/statusline.py",
     "enabled": true
   }
   ```

   `~`는 확장되지 않을 수 있으므로 절대 경로를 사용합니다.

3. `agy`를 완전히 종료한 뒤 다시 실행합니다.

### 요구 사항

- macOS
- `python3` (표준 라이브러리만 사용하므로 추가 패키지 설치는 필요 없습니다)

### 참고

- 값이 없으면 `N/A`로 표시됩니다.
- 스크립트가 계속 실패하면 `agy`가 statusline을 자동 비활성화할 수 있으니, 설정을 바꾼 뒤에는 `agy`를 재시작해 주세요.
- 실제 payload 구조가 바뀌면 `statusline.py`의 `quota` 키 이름(`3p-5h`, `gemini-weekly` 등)을 맞춰 수정해야 합니다.
