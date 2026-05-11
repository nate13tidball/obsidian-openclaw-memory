# Marlo's Long-Term Memory

## GitHub

- **Account:** nate13tidball
- **marlo repo:** https://github.com/nate13tidball/marlo (private)
  - Live state of Marlo — TODO list lives in README.md as the front page
  - **Keep in sync**: whenever TODO.md changes, update README.md in this repo too
  - Cloned at `/tmp/marlo` (re-clone if needed)
- **social-action repo:** https://github.com/nate13tidball/social-action (private)
  - Contact intelligence + relationship automation
  - **Source of truth: Google Contacts API via `gog`** — NOT VCF exports, NOT Apple Contacts exports
  - `data/contacts.json` = supplemental metadata ONLY (tier, relationship, social handles, notes) — NOT contact database
  - `data/cities.json` = city → contact mapping
  - `ideas/future-work.md` = automation backlog
  - Ryan Shaw = tier 1 best friend
  - All automations must query `gog contacts list` live — no import/parse step
  - Birthday reminders, city lookup, LinkedIn accomplishment monitor all planned
- **health_fitness repo:** https://github.com/nate13tidball/health_fitness (private)
  - Stores workout logs, WHOOP data, nutrition, body metrics
  - Cloned permanently at `/home/openclaw/repos/health_fitness`
  - Workout logs go in `workouts/logs/YYYY-MM-DD.md`
  - **Google Sheets sync:** `scripts/sync-google-sheets.sh` runs daily at 6AM UTC, pulls Lifts spreadsheet into `workouts/sheets-sync/*.csv` — use these CSVs for all workout analysis
  - Sheet ID: `1-WblZwAIE99ZwG4nzdZaPJr3cji-Ps1LmE_rS9bq9j0`
  - **Repo structure (canonical):**
    - `medical/injuries.md` — ALL injuries and surgeries, single source of truth
    - `medical/allergies.md` — drug/food/environmental allergies
    - `medical/dexa/` — DEXA scan results (.json, .md, .pdf per scan date)
    - `medical/immunizations/` — immunization records (.json, .md, .pdf)
    - `workouts/logs/YYYY-MM-DD.md` — workout logs
    - `health/body_metrics/`, `health/nutrition/`, `health/whoop/` — tracking data
  - ⚠️ Do NOT use `events/` folder — was a duplicate, now removed

## Health Notes

- **Right elbow — ulnar nerve tightness** (flagged 2026-05-11)
  - The nerve running to the funny bone (cubital tunnel / ulnar nerve)
  - Feels "too tight" — like nerve compression or snagging
  - Present since **September 2025**
  - Primary trigger: **heavy rowing** — flares during aggressive pulling reps
  - Pain lasts 30min–1hr after aggravation, significant intensity
  - Limiting back training volume considerably
  - Full log: `health_fitness/medical/injuries.md`
  - Factor this into workout logs — flag row-heavy sessions, suggest modifications
  - **Associated:** both arms fall asleep overnight (bilateral), worsening since Sep 2025 — likely same root cause (sleeping with elbows bent = ulnar nerve compression)

## Workout Logging

When Nathan sends messages in this format:
```
<Exercise Name>
<weight>x<reps>
<weight>x<reps>
...
```
→ Treat it as a workout log entry. Commit it to `health_fitness` repo under `workouts/logs/YYYY-MM-DD.md` (use current date). Append to existing file if one exists for that date.

Example recognized patterns:
- "Incline bench\n155x4\n165x3"
- "Squat\n225x5"
- Multiple exercises in one message = one session log

## Contact Enrichment

Whenever Nathan mentions a real person by name with new info (meeting them, sharing facts about them, asking about them), search their contact and update it.

- **Directive:** `directives/contact-enrichment.md` — read this for full behavior
- **Script:** `/tmp/social-action/scripts/add-contact-note.py "Name" "note text" [--city X --tier N ...]`
- **Notes limits:** 12 inline max, 400 chars/note max — overflow archived to `data/notes/{slug}.md`
- **Contact not found?** Tell Nathan, don't auto-create
- **Answering "what do I know about X":** run `--show`, read archive file if referenced

## Tutor Packet Generator

When Nathan asks to learn/study/understand a technical topic -> **do NOT write prose**. Generate a Tutor Packet.

- **Directive:** `directives/tutor-packet.md`
- **Output:** `second-brain/tutor-packets/SLUG.md` + `.json`
- **Delivery:** paste-ready block in chat (voice tutor prompt + full packet)
- **Trigger phrases:** "teach me", "tutor packet for", "I want to learn", "explain" (technical), "deep dive", "study"
- **Goal:** optimize for understanding per token, not tokens per answer
