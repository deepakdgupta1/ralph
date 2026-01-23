# Backlog

Potential enhancements for Ralph, organized by priority and category.

---

## High Priority

### Context Management

**Automatic context compaction**
- **What it adds:** Implement intelligent context summarization when approaching limits
- **Why it matters:** Claude Code best practices emphasize context as the fundamental constraint; performance degrades as context fills
- **Related files:** prompt.md, ralph.sh
- **Priority Rationale:** Core system reliability; prevents degraded performance in long iterations

**Subagent delegation for exploration** ✅ IMPLEMENTED
- **What it adds:** Use subagents for codebase research to preserve main context for implementation
- **Why it matters:** Exploration consumes tokens; subagents run in separate context windows and report back summaries
- **Related files:** prompt.md (## Subagent Delegation section)
- **Status:** Added guidance to prompt.md

### Verification & Quality

**Browser verification skill integration** ✅ IMPLEMENTED
- **What it adds:** Automated visual verification for UI stories using browser skills
- **Why it matters:** UI changes should be verified visually, not just via tests
- **Related files:** skills/dev-browser/SKILL.md
- **Status:** Created dev-browser skill

**Screenshot comparison for UI stories**
- **What it adds:** Before/after screenshot comparison with difference detection
- **Why it matters:** Visual regression detection catches issues tests miss
- **Related files:** prompt.md
- **Priority Rationale:** Self-verification is the highest-leverage improvement per Claude Code best practices

**Hooks for deterministic quality checks** ✅ IMPLEMENTED
- **What it adds:** Automatic linting, formatting, and guardrails via hooks (not AGENTS.md guidance)
- **Why it matters:** Hooks guarantee actions happen every time; AGENTS.md is advisory
- **Related files:** hooks/post-edit.example, hooks/guardrails.example
- **Status:** Added example hooks

### Workflow

**Plan Mode integration** ✅ IMPLEMENTED
- **What it adds:** Separate exploration from execution using Plan Mode for complex stories
- **Why it matters:** Prevents solving the wrong problem; exploration → planning → implementation
- **Related files:** prompt.md (enhanced DAIC A-lign phase)
- **Status:** Added complexity check and extended planning

**Interview mode for unclear requirements**
- **What it adds:** Agent interviews user about requirements before implementation
- **Why it matters:** Surfaces edge cases and tradeoffs not considered; produces better specs
- **Related files:** skills/ (new interview skill)
- **Priority Rationale:** Improves PRD quality for complex features

---

## Medium Priority

### Configuration & Permissions

**Permission allowlists for common operations** ✅ IMPLEMENTED
- **What it adds:** Pre-configured safe operations (lint, test, build) that don't require approval
- **Why it matters:** Reduces interruptions while maintaining safety boundaries
- **Related files:** config/permissions.json
- **Status:** Created permissions.json with allowlists

**Sandboxing support** ✅ IMPLEMENTED
- **What it adds:** OS-level isolation option for safer autonomous mode
- **Why it matters:** Enables autonomy with defined boundaries rather than bypassing all checks
- **Related files:** ralph.sh, config/ralph.config.sh, config/providers.json
- **Status:** Added RALPH_SANDBOXED=1 env var support

### Learning & Memory

**Structured anti-pattern documentation** ✅ IMPLEMENTED
- **What it adds:** Explicit section in progress.txt or AGENTS.md for "what not to do"
- **Why it matters:** Anti-patterns help future iterations avoid repeating mistakes
- **Related files:** prompt.md (## Anti-Patterns section)
- **Status:** Added structured anti-pattern format

**Learning classification by scope**
- **What it adds:** Tag learnings as directory-level, project-level, or global
- **Why it matters:** Enables appropriate reuse across projects; global patterns can be shared
- **Related files:** prompt.md, progress.txt format
- **Priority Rationale:** Scales learning value across multiple projects

**AGENTS.md pruning guidance** ✅ IMPLEMENTED
- **What it adds:** Guidance to keep AGENTS.md concise; prune instructions Claude follows by default
- **Why it matters:** Bloated AGENTS.md causes Claude to ignore actual instructions
- **Related files:** prompt.md (### AGENTS.md Maintenance section)
- **Status:** Added pruning guidance

### Multi-Session Scaling

**Parallel session support (fan-out)** ✅ IMPLEMENTED
- **What it adds:** Run multiple independent stories in parallel via separate sessions
- **Why it matters:** Scales work horizontally for large migrations or independent features
- **Related files:** scripts/ralph-parallel.sh, scripts/README.md
- **Status:** Created parallel execution script

**Writer/Reviewer pattern**
- **What it adds:** Separate sessions for implementation and code review
- **Why it matters:** Fresh context improves code review; agent won't be biased toward code it wrote
- **Related files:** config/ (new pattern config)
- **Priority Rationale:** Quality improvement through separation of concerns

### Context Efficiency

**Rich content input support**
- **What it adds:** Support for `@file` references, image inputs, piped data
- **Why it matters:** Provides precise context without verbose descriptions
- **Related files:** prompt.md
- **Priority Rationale:** Token efficiency; more precise context = better results

**CLI tool integration guidance**
- **What it adds:** Document preferred CLI tools (gh, aws, gcloud) for external service interaction
- **Why it matters:** CLI tools are the most context-efficient way to interact with services
- **Related files:** AGENTS.md
- **Priority Rationale:** Reduces API rate limits and token usage

---

## Low Priority

### MCP Integration

**MCP server connections**
- **What it adds:** Connect to Notion, Figma, databases via MCP
- **Why it matters:** Enables implementing features from issue trackers, designs, monitoring data
- **Related files:** config/mcp/ (new)
- **Priority Rationale:** Extends Ralph's capabilities beyond file-based workflows

### Custom Commands

**Custom slash commands library**
- **What it adds:** Pre-built commands for common workflows (fix-issue, deploy, migrate)
- **Why it matters:** Saves repeated workflow definitions
- **Related files:** .claude/commands/ (new)
- **Priority Rationale:** Convenience improvement; not blocking for core functionality

### Plugins

**Plugin marketplace integration**
- **What it adds:** Support for community-built extensions
- **Why it matters:** Extends capabilities without configuration
- **Related files:** config/plugins/ (new)
- **Priority Rationale:** Future enhancement; depends on ecosystem maturity

### Session Management

**Session naming and resumption**
- **What it adds:** Named sessions that can be resumed (`--continue`, `--resume`)
- **Why it matters:** Supports long-running features that span multiple days
- **Related files:** ralph.sh
- **Priority Rationale:** Quality-of-life improvement

**Checkpoint and rewind support**
- **What it adds:** Automatic checkpointing with ability to rewind to any previous state
- **Why it matters:** Enables risky experiments without fear; can always revert
- **Related files:** ralph.sh, config/
- **Priority Rationale:** Safety improvement but git already provides similar capability

---

## Future Considerations

### Multi-Agent Coordination

For multiple agents to work on the same project seamlessly over time, we need agent-agnostic versions of:

- Session history access (chat, thinking, actions)
- Intermediate artifact storage and retrieval
- Universal mapping format for cross-agent handoff
- Context summarization for window constraints
- MCP tools for history access

### Provider Abstraction

- Standardize provider-specific features (auto-handoff, context limits)
- Provider capability detection and fallback
- Unified configuration across AMP, Claude Code, Antigravity, CODEX

---

## Common Failure Patterns to Address

Per Claude Code best practices, these anti-patterns should be prevented:

| Pattern | Description | Mitigation |
|---------|-------------|------------|
| Kitchen sink session | Unrelated tasks accumulate in context | Auto-clear between unrelated stories |
| Correction spiral | Repeated corrections pollute context | Clear and restart with better prompt after 2 failures |
| Bloated AGENTS.md | Too many rules get ignored | Regular pruning; convert to hooks where possible |
| Trust-then-verify gap | No verification = shipped bugs | Require verification in acceptance criteria |
| Infinite exploration | Unbounded research fills context | Scope investigations or use subagents |

---

## References

- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [AMP Documentation](https://ampcode.com/manual)
- [Geoffrey Huntley's Ralph Pattern](https://ghuntley.com/ralph/)
