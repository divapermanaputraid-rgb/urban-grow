## Commit rules

- **Git User Rotation (Daily Limit):**
  - Check today's commit count untuk ketiga user sebelum commit (`git log --since="midnight" --author="<email>"`).
  - Limit: Diva = 5 commits/day, Robert = 15 commits/day, Queen = 15 commits/day.
  - Prioritas:
    1. Diva today < 5 → pakai Diva (`./git-switch.sh diva`, push ke `origin-diva`)
    2. Diva >= 15 dan Robert < 15 → pakai Robert (`./git-switch.sh robert`, push ke `origin-robert`)
    3. Diva >= 15, Robert >= 15, dan Queen < 15 → pakai Queen (`./git-switch.sh queen`, push ke `origin-queen`)
    4. Ketiganya penuh → fallback ke Diva
- **Jangan commit**: `docs/superpowers/**`, `.superpowers/**`, `konteks/**`, `QA_NOTES.md`, skill locks, agent files, session scratch.
- Commit message harus terdengar manusiawi (short imperative). Jangan ada kata-kata AI/agent/sesi/generate.
- Jangan force-push kecuali user minta eksplisit.
//
//  CLAUDE.md
//  urbanGrow
//
//  Created by MacBook on 16/08/26.
//

