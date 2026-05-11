# Contact Enrichment Directive

Whenever Nathan mentions a real person by name in conversation — especially if there's any new info about them — search for their contact and update it.

---

## Trigger Conditions

Act on any of these:

- **Meeting someone**: "I met Nathan McCall", "ran into Jake", "had coffee with Sarah"
- **Info about someone**: "Nathan McCall works at...", "Ryan just moved to NYC", "Alex got promoted"
- **Asking about someone**: "What do I know about Ryan Shaw?", "Who is Alex Hauptman?"
- **Sharing context**: anything where a full name + a fact appears together

Not triggered by: casual mentions with no new info ("I talked to my boss"), group references ("the Tesla team"), or pronouns.

---

## What To Do

### 1. Search the contact

```bash
cd /tmp/social-action && python3 scripts/add-contact-note.py "Nathan McCall" --show
```

Or search directly:
```bash
python3 scripts/search-contacts.py --name "Nathan McCall"
```

**If not found**: note it to Nathan ("Nathan McCall isn't in your contacts yet — want me to add them?"). Don't auto-create without asking.

### 2. Extract useful info from the conversation

From the conversation context, extract any of:
- Where they live/work
- What they do
- How Nathan knows them
- Life events (new job, moved, got married, had a kid)
- Relevant context ("interested in battery tech", "looking for a job")
- Any social handles mentioned

Be specific and factual. Don't pad with fluff. Example of a good note:
> "Met at Tesla Gigafactory event. Works on Powerwall BMS firmware. Interested in grid storage. Mentioned looking to move to SF in Q3."

Bad note (too vague):
> "Nathan mentioned this person."

### 3. Update the contact

Run the update:
```bash
cd /tmp/social-action
python3 scripts/add-contact-note.py "Nathan McCall" "Met at Tesla event. Works on Powerwall firmware. Considering move to SF." --city "Austin" --state "TX"
```

Field mapping for common info:
- Where they live → `--city`, `--state`
- Instagram/LinkedIn/Twitter mentioned → `--instagram`, `--linkedin`, `--twitter`
- Relationship context → `--relationship` (e.g. "Tesla coworker")
- Tier (if clear) → `--tier` (1=best friend, 2=close, 3=network/acquaintance)

### 4. Report back to Nathan

After updating, briefly confirm:
> "Added a note to Nathan McCall's contact: works on Powerwall firmware, considering SF move."

If multiple people match the name, surface the ambiguity:
> "Found 2 contacts named 'Alex' — which one? Alex Hauptman (San Jose) or Alex Yu (Berkeley)?"

---

## Notes Size Rules

The script enforces these automatically — don't worry about them manually:

- **12 notes max** stored inline in Google Contacts biography field
- **400 chars max** per note (truncated inline, full text archived)
- **Overflow** → archived to `social-action/data/notes/{slug}.md`
- **Pointer** set in stored_meta: `"notes_file": "data/notes/nathan-mccall.md"`

If a note is longer than 400 chars, write the full version to the archive file and use a tight summary (< 400 chars) as the inline note. Don't let the biography JSON exceed ~3KB.

---

## Answering "What do I know about X?"

1. Run `--show` to pull current contact data
2. Read the inline notes + any notes archive file if referenced
3. Summarize what Nathan knows about this person
4. If contact missing key info, surface what's unknown: "No birthday, city, or social handles on file."

---

## When NOT to Update

- Nathan is clearly talking hypothetically ("imagine if Ryan Shaw...")
- The person is a public figure with no personal relationship context
- There's no new info beyond a name mention
- The contact isn't found and Nathan didn't ask to create one

---

## Repo Location

Script: `/tmp/social-action/scripts/add-contact-note.py`

If `/tmp/social-action` doesn't exist (re-clone needed):
```bash
git clone https://github.com/nate13tidball/social-action /tmp/social-action
```
