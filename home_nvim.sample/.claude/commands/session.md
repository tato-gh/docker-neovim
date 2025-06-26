session-dump instruction

---

Please output the strings displayed in Claude Code's repl during this session to the `.claude/logs` folder.
If the `.claude/logs` folder does not exist, please create it.

## Filename

For naming the file that outputs the strings, use the filename `{YYYY-MM-DD}-{number}.md`.
Replace the `{YYYY-MM-DD}` and `{number}` with the session-created-at and numbering within the same date from 1.

If the file has already existing, then override.

## Output Format

Please output in the following format:

```markdown

start: {Enter the session start date and time in YYYY-MM-DD HH:mm format}
dumped: {Enter the date and time this command was executed in YYYY-MM-DD HH:mm format}

# 👤 User ({Enter the date and time when input was received from the user in YYYY-MM-DD HH:mm format})

{Enter the input string from the user}

# 🤖 Claude ({Enter the time when Claude Code began displaying to standard output in YYYY-MM-DD HH:mm format})

{Enter the string displayed by Claude Code to standard output}

Continue entering the contents of the conversation in the same format
```

Of course, ignore this session-dump instruction, Thank you.

---

