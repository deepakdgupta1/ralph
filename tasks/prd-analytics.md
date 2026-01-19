# PRD: Ralph Analytics & Telemetry

## Introduction

Build a telemetry and observability system that captures comprehensive data about Ralph's autonomous agent loop. This V1 focuses on raw data capture to local log files, enabling manual analysis of PRD generation effectiveness, feature breakdown efficiency, implementation progress, and learning outcomes. The data will support debugging, ROI measurement, and optimization of the agent loop.

## Goals

- Capture telemetry data at iteration, story, and action levels
- Store all data in structured local log files (no external dependencies)
- Enable manual review and scoring of effectiveness metrics
- Provide foundation for future automated analysis and dashboards
- Zero impact on existing Ralph workflow

## User Stories

### US-001: Create telemetry log structure
**Description:** As a developer, I need a consistent log file structure so analytics data is organized and queryable.

**Acceptance Criteria:**
- [ ] Create `analytics/` directory in project root
- [ ] Define log file naming convention: `{timestamp}-{iteration}.json`
- [ ] Document the log schema in `analytics/SCHEMA.md`
- [ ] Typecheck passes (if applicable)

### US-002: Capture iteration-level metrics
**Description:** As a user, I want each Ralph iteration logged so I can review overall progress and patterns.

**Acceptance Criteria:**
- [ ] Log iteration start/end timestamps
- [ ] Log iteration number and max iterations
- [ ] Log git commit hash at start and end
- [ ] Log exit reason (success, max iterations, error)
- [ ] Log stories attempted vs completed this iteration
- [ ] Data written to `analytics/{timestamp}-iteration-{n}.json`

### US-003: Capture story-level metrics
**Description:** As a user, I want per-story metrics so I can analyze which stories succeed or fail and why.

**Acceptance Criteria:**
- [ ] Log story ID and title from prd.json
- [ ] Log story status transitions (pending → in-progress → done/blocked)
- [ ] Log acceptance criteria checklist state (before/after)
- [ ] Log files modified for this story (from git diff)
- [ ] Log iteration number when story was worked on
- [ ] Data appended to iteration log file

### US-004: Capture action-level logs
**Description:** As a user, I want detailed action logs so I can drill down into what the agent did during each iteration.

**Acceptance Criteria:**
- [ ] Log each tool/command invoked by the agent
- [ ] Log timestamps for each action
- [ ] Log success/failure status of actions
- [ ] Log any error messages encountered
- [ ] Data stored in `analytics/{timestamp}-actions-{n}.json`

### US-005: Capture PRD generation metrics
**Description:** As a user, I want to track PRD quality indicators so I can manually score effectiveness.

**Acceptance Criteria:**
- [ ] Log number of user stories generated
- [ ] Log number of acceptance criteria per story
- [ ] Log PRD file path and creation timestamp
- [ ] Include placeholder fields for manual scoring (clarity, completeness, actionability)
- [ ] Data stored in `analytics/prd-metrics.json`

### US-006: Capture learning metrics
**Description:** As a user, I want to track learnings captured so I can evaluate the learning process effectiveness.

**Acceptance Criteria:**
- [ ] Log any updates to AGENTS.md (diff summary)
- [ ] Log any updates to progress.txt
- [ ] Log anti-patterns or blockers encountered
- [ ] Include placeholder for manual classification (directory/project/global scope)
- [ ] Data appended to iteration log file

### US-007: Implement logging utility
**Description:** As a developer, I need a simple logging utility that ralph.sh can use to write structured logs.

**Acceptance Criteria:**
- [ ] Create `analytics/log.sh` helper script
- [ ] Function to initialize iteration log
- [ ] Function to append JSON entries to log
- [ ] Function to finalize/close iteration log
- [ ] Works with bash (no external dependencies beyond jq)

### US-008: Integrate logging into ralph.sh
**Description:** As a developer, I need ralph.sh to call the logging utility at key points.

**Acceptance Criteria:**
- [ ] Call log init at iteration start
- [ ] Call log append after each Amp invocation
- [ ] Call log finalize at iteration end
- [ ] Capture git state before/after iteration
- [ ] No breaking changes to existing ralph.sh behavior

## Functional Requirements

- FR-1: All logs stored in `analytics/` directory as JSON files
- FR-2: Each iteration produces one primary log file with nested story data
- FR-3: Action logs stored separately to manage file size
- FR-4: Log schema supports manual scoring fields (null until scored)
- FR-5: Logging failures must not halt Ralph execution (fail silently with stderr warning)
- FR-6: Logs must be human-readable (pretty-printed JSON)
- FR-7: Include `analytics/.gitignore` to optionally exclude large action logs

## Non-Goals

- No automated effectiveness scoring or heuristics (V1 is manual review)
- No dashboard or visualization UI
- No external service integrations
- No log rotation or cleanup automation
- No real-time monitoring or alerts
- No aggregation across multiple projects

## Technical Considerations

- Use `jq` for JSON manipulation (commonly available on Ubuntu)
- Keep logging synchronous and simple to avoid race conditions
- Schema should be extensible for future automated analysis
- Consider log file size - action logs may grow large

## Success Metrics

- All Ralph iterations produce valid JSON logs
- Logs contain sufficient data for manual effectiveness review
- Zero failures in Ralph execution due to logging
- Schema documented and stable for future tooling

## Open Questions

- Should action logs capture full command output or just summaries?
- What retention policy for old logs (manual cleanup for V1)?
- Should we capture token usage if available from Amp?
