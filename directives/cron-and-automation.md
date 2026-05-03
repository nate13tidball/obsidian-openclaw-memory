# Directive: Cron Jobs & Automation

## Rule: Scripts First, AI Agents Never for Scripting Tasks

When scheduling any recurring or one-shot automated task, **always use a shell script + system cron** unless the task genuinely requires AI reasoning.

### Decision Tree

```
Does the task require AI reasoning, judgment, or natural language?
├── YES → OpenClaw cron (agentTurn) is acceptable — costs tokens
└── NO  → Shell script + system crontab — FREE, always prefer this
```

Tasks that do NOT need AI (use shell script):
- Git commits and pushes
- File backups or syncs
- API polling with fixed logic
- Log rotation / cleanup
- Health checks with fixed pass/fail
- Any task expressible as a bash one-liner

Tasks that DO need AI (agentTurn is OK):
- Summarizing emails and deciding what to surface
- Drafting messages or content
- Reasoning about calendar conflicts
- Any task requiring judgment or language understanding

---

## How to Set Up a Shell Script Cron

### 1. Write the script to `execution/`

```bash
# /home/openclaw/.openclaw/workspace/execution/my-task.sh
#!/usr/bin/env bash
set -e
LOG="/tmp/my-task.log"
# ... do work ...
echo "[$(date -u '+%Y-%m-%d %H:%M UTC')] done" >> "$LOG"
```

### 2. Make it executable

```bash
chmod +x execution/my-task.sh
```

### 3. Add to system crontab

```bash
(crontab -l 2>/dev/null; echo "*/30 * * * * /home/openclaw/.openclaw/workspace/execution/my-task.sh") | crontab -
```

### 4. Verify

```bash
crontab -l
```

---

## Token Cost Reference

| Method | Tokens | Use For |
|---|---|---|
| `crontab` + shell script | **0** | Scripting, syncs, backups |
| OpenClaw cron `systemEvent` | ~minimal | Triggering main session checks |
| OpenClaw cron `agentTurn` | **$$$** | AI reasoning tasks only |

---

## Existing Automated Scripts

| Script | Schedule | Purpose |
|---|---|---|
| `execution/git-sync.sh` | `*/30 * * * *` | Push workspace changes to GitHub |
