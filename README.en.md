# dsh-qq-suite

> Eight repositories that grew out of plugging DSH (DeepSeek Harness) into QQ — each one independently cloneable, testable, and publishable.

[![repos](https://img.shields.io/badge/repos-8-blue)](#repository-map) [![tests](https://img.shields.io/badge/offline%20tests-158-success)](#repository-map) [![license](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## What this is

Over seven days (2026-10-23 → 10-29) the bridge made 14,440 model calls and burned 1.89 billion tokens, 97.35% of which were prompt-cache hits. Sorted by theme, one fact stood out: **all of it lands on a single project — half writing it, half the agent chatting in QQ on its own.**

These eight repositories are that work, split along "can it be tested alone" rather than "which folder was it in".

## Repository map

| Repo | What it does | Billing theme (share) | Tests |
|---|---|---|---|
| [**qq-bridge**](https://github.com/whatxin7/qq-bridge) | QQ ↔ DSH bridge core (flagship) | online chat 47.3% + install/wiring 19.0% | full suite |
| [dsh-token-meter](https://github.com/whatxin7/dsh-token-meter) | Session-log token accounting, peak/off-peak pricing | usage & cost 0.9% | 29 |
| [dsh-qq-access](https://github.com/whatxin7/dsh-qq-access) | Who may talk to the agent: allow/deny lists, friend requests | friends / allow-list / permissions 6.3% | 20 |
| [dsh-qq-voice](https://github.com/whatxin7/dsh-qq-voice) | Voice library, ffmpeg volume/R128, songbook, OneBot record | voice / singing / timbre 3.2% | 16 |
| [dsh-qq-stickers](https://github.com/whatxin7/dsh-qq-stickers) | Sticker store, mood retrieval, injection block | stickers 2.4% | 13 |
| [dsh-mcp-safe-tools](https://github.com/whatxin7/dsh-mcp-safe-tools) | Read-only search/fetch MCP, SSRF guard, outbound redaction | capability expansion 5.6% | 9 |
| [dsh-session-link](https://github.com/whatxin7/dsh-session-link) | Session routing, cross-talk, recall RAG, relation graph | behaviour tuning 3.8% | 60 |
| [dsh-persona-kit](https://github.com/whatxin7/dsh-persona-kit) | Persona cards: mode sections, style appendix, preset validation | persona / role cards 5.4% | 11 |

**158 offline tests.** No network, no QQ account, no model API required.

## Ten-second start

```bash
git clone https://github.com/whatxin7/dsh-token-meter.git
cd dsh-token-meter && npm test && node bin/token-meter.mjs scan
```

That scans `~/.dsh/sessions/**` and prints your real usage. The other seven work the same way — the first screen of each README is a paste-ready command.

## How the pieces relate

```
 QQ message ──► qq-bridge ──► DSH session (one context per conversation)
                   │
   ┌───────────┬───┴────┬────────────┬───────────┬────────────┐
   ▼           ▼        ▼            ▼           ▼            ▼
access    session-link persona   qq-voice   qq-stickers  mcp-safe-tools
(who)     (memory)     (who speaks) (sound)   (reactions)  (networked hands)
   └───────────┴────┬───┴────────────┴───────────┴────────────┘
                    ▼
              token-meter (what it all cost)
```

- **access** decides whether a message enters the model at all — the cheapest optimisation available;
- **session-link** decides whether the agent remembers what happened elsewhere;
- **persona-kit** decides whether it sounds like a person;
- **voice / stickers** decide what it can do besides typing;
- **mcp-safe-tools** decides whether it can reach the internet without being lured into a private network;
- **token-meter** decides what all of the above actually costs.

## The cost story, short

| Price tier (in / cache / out per 1M tokens) | Total |
|---|---:|
| 0.5 / 0.15 / 2 | ¥310.46 |
| 1 / 0.2 / 4 | ¥436.47 |
| 2 / 0.5 / 8 | ¥1,057.40 |
| 4 / 1 / 16 | ¥2,114.79 |
| 2 / 2 / 8 (no cache discount) | ¥3,824.11 |

Full breakdown in [TOKEN-STORY.md](TOKEN-STORY.md) — daily table, top sessions, theme buckets, and why a 97% cache hit rate is not the end of the story.

## Docs

- [ARCHITECTURE.md](ARCHITECTURE.md) — layers, data flow, why each boundary sits where it does
- [TOKEN-STORY.md](TOKEN-STORY.md) — the 1.89B-token bill and what it says

## License

MIT © whatxin7. Each repository is licensed independently; the LICENSE file lives at its root.


