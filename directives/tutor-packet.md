# Directive: Tutor Packet Generator

## Role Split

| Tool | Role |
|------|------|
| **OpenClaw (Marlo)** | Deep research, source verification, synthesis, concept graph, misconception detection, recall prompts |
| **ChatGPT Voice** | Interactive explanation, Socratic Q&A, intuition building, adaptive pacing, retrieval practice |

**OpenClaw is NOT a live tutor. OpenClaw is a tutor packet factory.**

---

## Trigger Patterns

When Nathan says any of the following, generate a Tutor Packet (not a prose explanation):

- "teach me X"
- "tutor packet for X"
- "I want to learn X"
- "explain X" (technical/science topics)
- "deep dive on X"
- "study X"

When in doubt: **compress, don't essay.**

---

## Research Process (before generating packet)

1. **Web search** 2–4 authoritative sources (papers, textbooks, engineering docs)
2. **Identify** the 3–5 core concepts that unlock the topic
3. **Find** the 2–3 most common misconceptions (search forums, reddit, Q&A sites for where people get confused)
4. **Extract** one strong first-principles explanation
5. **Map** real-world connections (engineering, physics, manufacturing, systems)
6. **Find** 2–3 YouTube videos (search for title + channel quality)

Only then generate the packet. Do not skip research.

---

## Output Format

### File 1: `TOPIC.json` — Machine-readable packet

```json
{
  "topic": "",
  "difficulty_level": "beginner | intermediate | advanced",
  "why_it_matters": "",
  "core_concepts": [""],
  "mental_models": [""],
  "first_principles_explanations": [""],
  "common_misconceptions": [""],
  "socratic_questions": [""],
  "retrieval_questions": [""],
  "feynman_prompts": [""],
  "practical_examples": [""],
  "real_world_engineering_connections": [""],
  "youtube_recommendations": [
    { "title": "", "channel": "", "url": "", "reason": "" }
  ],
  "followup_topics": [""],
  "summary_for_voice_tutor": ""
}
```

### File 2: `TOPIC.md` — Human-readable + paste-ready

Markdown version of the same packet with a **VOICE TUTOR PROMPT** block at the top (see below).

---

## Voice Tutor Prompt (prepend to every packet)

```
You are my technical tutor.

Teach me [TOPIC] interactively.

Do not lecture.

Use short explanations.

Ask me questions frequently.

Force me to explain concepts back to you.

Prioritize intuition over memorization.

Use analogies from engineering, physics, manufacturing, and systems thinking.

Challenge weak understanding.

Identify confusion quickly.

Optimize for deep understanding, not surface familiarity.

Here is my research packet. Use it as your knowledge base:

[PASTE PACKET BELOW]
```

---

## Delivery

Always do **both**:

1. **Save files** to `second-brain/tutor-packets/SLUG.md` + `second-brain/tutor-packets/SLUG.json`
2. **Post paste-ready block** directly in chat — a single copyable markdown block that includes the voice tutor prompt + full packet

If Gmail/gog is configured: also email the packet to Nathan.

---

## Quality Rules

- NO long prose. Every field is a list of short, dense items.
- `summary_for_voice_tutor` must be ≤150 words. It's the ChatGPT context seed.
- `socratic_questions` must push on the hardest conceptual leaps, not surface recall.
- `common_misconceptions` must be specific (not "people often misunderstand X" — state the actual wrong belief).
- `feynman_prompts` should force explanation to a 10-year-old or a non-specialist.
- `mental_models` are frameworks/analogies, not definitions.
- `retrieval_questions` are for spaced repetition — hard, specific, testable.

---

## Metric

**Understanding per token > tokens per answer.**

Every field should change the reader's internal model — not add more words.
