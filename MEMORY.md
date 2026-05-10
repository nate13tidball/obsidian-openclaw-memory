# Marlo's Long-Term Memory

## GitHub

- **Account:** nate13tidball
- **social-action repo:** https://github.com/nate13tidball/social-action (private)
  - Contact intelligence + relationship automation
  - `data/contacts.json` = master contact index (tier 1/2/3)
  - `data/cities.json` = city → contact mapping
  - `ideas/future-work.md` = automation backlog
  - Ryan Shaw = tier 1 best friend (needs email populated from contacts export)
  - To add contacts: Nathan exports VCF from Apple Contacts → drop in `contacts/raw/`
  - Birthday reminders, city lookup, LinkedIn accomplishment monitor all planned
- **health_fitness repo:** https://github.com/nate13tidball/health_fitness (private)
  - Stores workout logs, WHOOP data, nutrition, body metrics
  - Workout logs go in `workouts/logs/YYYY-MM-DD.md`

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

## Tutor Packet Generator

When Nathan asks to learn/study/understand a technical topic -> **do NOT write prose**. Generate a Tutor Packet.

- **Directive:** `directives/tutor-packet.md`
- **Output:** `second-brain/tutor-packets/SLUG.md` + `.json`
- **Delivery:** paste-ready block in chat (voice tutor prompt + full packet)
- **Trigger phrases:** "teach me", "tutor packet for", "I want to learn", "explain" (technical), "deep dive", "study"
- **Goal:** optimize for understanding per token, not tokens per answer
