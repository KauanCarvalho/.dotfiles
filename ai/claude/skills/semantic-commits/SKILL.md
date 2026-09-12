---
name: semantic-commits
description: Always write commit messages in Conventional Commits format (feat, fix, docs, refactor, chore, test, style, perf). Use whenever drafting or writing a git commit message, in any repo.
---

Write every commit message as `<type>: <short imperative summary>`.

Types: `feat` (new capability), `fix` (bug fix), `docs`, `refactor` (no
behavior change), `chore` (tooling/deps/config), `test`, `style`, `perf`.

Rules:
- Subject line lowercase, imperative mood, no trailing period, ideally
  under ~65 chars.
- Body only when the *why* isn't obvious from the diff — skip it otherwise.
  Never restate what the diff already shows.
- One logical change per commit. If a change mixes unrelated concerns,
  say so instead of picking one type arbitrarily.
- Match whatever scope convention the repo already uses (check `git log`
  first) instead of inventing a new one.
