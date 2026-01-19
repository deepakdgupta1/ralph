# Metrics for Ralph

## Aggregation Levels

Metrics are tracked at multiple granularity levels, enabling analysis from fine-grained operations to overall system performance:

| Level | Scope | Example Use |
|-------|-------|-------------|
| **Per-call** | Individual API or tool invocation | API latency analysis |
| **Per-iteration** | Single agent context/session | Context window monitoring |
| **Per-story** | User story from PRD | Story-level cost tracking |
| **Per-feature** | Group of related stories | Feature complexity analysis |
| **Overall** | Entire PRD/project lifecycle | Total resource consumption |

Higher-level aggregates are computed from lower levels:
**Per-call → Per-iteration → Per-story → Per-feature → Overall**

---

## Cross-Cutting: Learning Capability

Learning spans all phases and should be measured across the entire workflow.

### Learning Capture

#### AGENTS.md additions per iteration (diff size)

- **What it measures:** Lines added to AGENTS.md during each iteration
- **Better values:** Low-to-moderate additions; consistent small updates
- **Indicates:** Whether the system is capturing learnings incrementally rather than in large batches or not at all
- **Related metrics:** Repeated errors after learning documented, Pattern reuse frequency
- **Recommended Action:** If zero for multiple iterations, prompt agent to reflect on patterns. If very high, check if learnings are too verbose or redundant.
- **Priority:** High
- **Priority Rationale:** Core indicator of learning system activity; easy to measure via file diffs but requires learning loop to be active.

#### AGENTS.md sections modified

- **What it measures:** Which sections of AGENTS.md are being updated (Commands, Patterns, Anti-patterns, etc.)
- **Better values:** Balanced distribution across sections
- **Indicates:** Whether learning is comprehensive or concentrated in one area
- **Related metrics:** Number of anti-patterns documented, Number of patterns documented
- **Recommended Action:** If only one section is modified, review if other types of learnings are being missed.
- **Priority:** Low
- **Priority Rationale:** Useful for learning quality analysis but not essential for initial analytics; can be derived from diff analysis later.

#### Number of anti-patterns documented

- **What it measures:** Count of explicitly documented "what not to do" learnings
- **Better values:** Higher is better (indicates mistakes are being captured)
- **Indicates:** System's ability to learn from failures
- **Related metrics:** Same anti-pattern encountered twice, Error rate reduction across iterations
- **Recommended Action:** If low despite errors occurring, improve anti-pattern capture prompts.
- **Priority:** Medium
- **Priority Rationale:** Important for understanding learning from failures but requires structured AGENTS.md format to count reliably.

#### Number of patterns documented

- **What it measures:** Count of reusable positive patterns captured
- **Better values:** Higher is better
- **Indicates:** System's ability to generalize successful approaches
- **Related metrics:** Pattern reuse frequency
- **Recommended Action:** If low, add prompts to extract patterns from successful stories.
- **Priority:** Medium
- **Priority Rationale:** Valuable for ROI analysis of learning but requires structured format; track after anti-patterns.

#### Learning classification counts (directory/project/global)

- **What it measures:** Distribution of learnings by scope of applicability
- **Better values:** Higher global count indicates more reusable knowledge
- **Indicates:** Whether learnings are too specific or appropriately generalized
- **Related metrics:** Pattern reuse frequency
- **Recommended Action:** Review project-level learnings periodically for promotion to global.
- **Priority:** Low
- **Priority Rationale:** Advanced metric for learning quality; implement after basic learning counts are working.

### Learning Reuse

#### AGENTS.md references in subsequent prompts

- **What it measures:** How often documented learnings are cited during work
- **Better values:** Higher is better
- **Indicates:** Whether captured knowledge is actually being applied
- **Related metrics:** Pattern reuse frequency, Error rate reduction across iterations
- **Recommended Action:** If low, learnings may not be discoverable; improve organization or indexing.
- **Priority:** Medium
- **Priority Rationale:** Key indicator of learning effectiveness but requires prompt analysis/logging to detect references.

#### Repeated errors after learning documented

- **What it measures:** Count of errors that recur despite being documented as anti-patterns
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Effectiveness of learning capture and retrieval
- **Related metrics:** Number of anti-patterns documented, Same anti-pattern encountered twice
- **Recommended Action:** Investigate why documented learnings aren't preventing recurrence; may need better formatting or placement.
- **Priority:** High
- **Priority Rationale:** Critical signal of learning system failure; directly measures whether learning is working.

#### Same anti-pattern encountered twice

- **What it measures:** Boolean or count of duplicate mistakes
- **Better values:** Zero is ideal
- **Indicates:** Failure in learning application; knowledge not being used
- **Related metrics:** Repeated errors after learning documented
- **Recommended Action:** Add explicit anti-pattern check step before implementation.
- **Priority:** High
- **Priority Rationale:** Most direct evidence of learning failure; should be zero if learning works properly.

#### Pattern reuse frequency

- **What it measures:** How often documented patterns are applied to new work
- **Better values:** Higher is better
- **Indicates:** ROI of learning capture effort
- **Related metrics:** Number of patterns documented, Time-per-story reduction trend
- **Recommended Action:** If low, patterns may be too specific or poorly documented.
- **Priority:** Medium
- **Priority Rationale:** Measures positive ROI of learning; requires pattern detection logic to implement.

### Learning Impact (proxy metrics)

#### Iteration performance improvement over time

- **What it measures:** Trend of iterations needed per story over multiple PRDs
- **Better values:** Decreasing trend is better
- **Indicates:** Long-term effectiveness of learning system
- **Related metrics:** Stories-per-iteration improvement trend
- **Recommended Action:** If flat or increasing, audit learning capture quality.
- **Priority:** Very High
- **Priority Rationale:** Primary KPI for learning effectiveness; computed from basic iteration counts which are easy to track.

#### Error rate reduction across iterations

- **What it measures:** Trend of errors per iteration over time
- **Better values:** Decreasing trend is better
- **Indicates:** Whether mistakes are being learned from
- **Related metrics:** Number of anti-patterns documented
- **Recommended Action:** If not decreasing, review anti-pattern documentation process.
- **Priority:** Very High
- **Priority Rationale:** Direct measure of learning from failures; requires error tracking per iteration.

#### Time-per-story reduction trend

- **What it measures:** Average wall-clock time per story over multiple PRDs
- **Better values:** Decreasing trend is better
- **Indicates:** Efficiency gains from accumulated learning
- **Related metrics:** Pattern reuse frequency
- **Recommended Action:** If flat, analyze which story types aren't improving.
- **Priority:** Very High
- **Priority Rationale:** Top-line efficiency metric; requires only timestamp tracking per story.

#### Stories-per-iteration improvement trend

- **What it measures:** Average stories completed per iteration over time
- **Better values:** Increasing trend is better
- **Indicates:** Overall system efficiency improvement
- **Related metrics:** Iteration performance improvement over time
- **Recommended Action:** If decreasing, investigate context or complexity changes.
- **Priority:** Very High
- **Priority Rationale:** Core productivity metric; easily computed from prd.json story counts and iteration counts.

### Progress.txt Metrics

#### Updates per iteration

- **What it measures:** Number of edits to progress.txt each iteration
- **Better values:** Exactly 1 is ideal; consistent updates
- **Indicates:** Whether state is being properly recorded for handoff
- **Related metrics:** Context preserved across iterations
- **Recommended Action:** If zero, iteration may have failed silently. If multiple, may indicate instability.
- **Priority:** High
- **Priority Rationale:** Essential for iteration health monitoring; simple file modification tracking.

#### Blockers logged vs resolved

- **What it measures:** Ratio of blockers recorded to blockers subsequently cleared
- **Better values:** Ratio close to 1:1 (all blockers eventually resolved)
- **Indicates:** Ability to identify and overcome obstacles
- **Related metrics:** Iterations ending in recoverable vs unrecoverable state
- **Recommended Action:** If blockers accumulate unresolved, escalate for human intervention.
- **Priority:** Medium
- **Priority Rationale:** Important for understanding failure patterns; requires structured blocker logging.

#### Context preserved across iterations

- **What it measures:** Whether subsequent iterations have sufficient context to continue work
- **Better values:** High preservation (minimal repeated discovery work)
- **Indicates:** Quality of progress.txt and AGENTS.md as memory
- **Related metrics:** Information loss between iterations
- **Recommended Action:** If poor, improve progress.txt structure or add summary requirements.
- **Priority:** High
- **Priority Rationale:** Critical for multi-iteration workflows; can be approximated via repeated file access patterns.

---

## 1. Requirements Identification Capability

Focuses on identifying WHAT needs to be built and WHY (scope, features, user stories, acceptance criteria from user persona's perspective).

### Effectiveness of PRD Generation

#### Structure Quality

#### Number of user stories generated

- **What it measures:** Total count of user stories in the PRD
- **Better values:** Proportional to feature scope; neither too few nor excessively many
- **Indicates:** Appropriate decomposition of requirements
- **Related metrics:** Story size variance, Average story size
- **Recommended Action:** If very low, requirements may be under-specified. If very high, may be over-fragmented.
- **Priority:** Very High
- **Priority Rationale:** Foundational metric for PRD quality; simple count from prd.json structure.

#### Number of acceptance criteria per story

- **What it measures:** Average count of acceptance criteria across stories
- **Better values:** 3-7 per story is typically ideal
- **Indicates:** Specificity and testability of requirements
- **Related metrics:** Avg words per acceptance criteria
- **Recommended Action:** If <2, stories lack verification clarity. If >10, story may need splitting.
- **Priority:** Very High
- **Priority Rationale:** Critical for implementation success; directly tied to story completeness verification.

#### Avg words per acceptance criteria (specificity)

- **What it measures:** Average length of each acceptance criterion
- **Better values:** 10-25 words typically indicates good specificity
- **Indicates:** Whether criteria are concrete vs vague
- **Related metrics:** Number of ambiguous words
- **Recommended Action:** If too short, criteria may be vague. If too long, may be combining multiple criteria.
- **Priority:** Low
- **Priority Rationale:** Quality indicator but lower priority; word count analysis is straightforward once criteria are parsed.

#### Number of functional requirements

- **What it measures:** Count of FR-numbered items in the PRD
- **Better values:** Higher indicates more comprehensive specification
- **Indicates:** Completeness of technical specification
- **Related metrics:** Number of user stories generated
- **Recommended Action:** If low relative to stories, add explicit functional requirements.
- **Priority:** Medium
- **Priority Rationale:** Good for specification completeness; requires PRD parsing for FR-prefixed items.

#### Presence of all PRD sections (completeness score)

- **What it measures:** Percentage of standard PRD sections present (Goals, Stories, FRs, Non-Goals, etc.)
- **Better values:** 100% is ideal
- **Indicates:** PRD structural completeness
- **Related metrics:** None
- **Recommended Action:** If sections missing, use PRD template validation.
- **Priority:** High
- **Priority Rationale:** Simple validation against template; catches structural issues early.

#### Non-goals section length (scope clarity)

- **What it measures:** Word count or item count in Non-Goals section
- **Better values:** At least 3-5 items; longer indicates clearer boundaries
- **Indicates:** How well scope boundaries are defined
- **Related metrics:** Stories requiring scope changes mid-implementation
- **Recommended Action:** If empty or minimal, explicitly prompt for scope exclusions.
- **Priority:** Medium
- **Priority Rationale:** Important for scope management; simple word/item count once section is identified.

#### Actionability Indicators

#### % of acceptance criteria with verifiable language ("must", "shows", "returns")

- **What it measures:** Proportion of criteria using concrete, testable verbs
- **Better values:** Higher is better; aim for >80%
- **Indicates:** Whether criteria can be objectively verified
- **Related metrics:** Number of ambiguous words
- **Recommended Action:** If low, rewrite criteria with action verbs and observable outcomes.
- **Priority:** Medium
- **Priority Rationale:** Good quality indicator; requires NLP-style keyword detection.

#### % of stories with file path references

- **What it measures:** Proportion of stories that reference specific files or components
- **Better values:** Higher is better for implementation guidance
- **Indicates:** Whether stories provide sufficient technical context
- **Related metrics:** None
- **Recommended Action:** If low, add technical context or file references to stories.
- **Priority:** Medium
- **Priority Rationale:** Useful for implementation readiness; requires file path pattern matching in story text.

#### Number of ambiguous words ("appropriate", "properly", "correctly")

- **What it measures:** Count of vague qualifiers in the PRD
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Risk of misinterpretation during implementation
- **Related metrics:** % of acceptance criteria with verifiable language
- **Recommended Action:** Replace each ambiguous word with specific, measurable criteria.
- **Priority:** High
- **Priority Rationale:** Directly predicts implementation ambiguity; simple keyword search on predefined list.

#### Ratio of technical terms to explanations

- **What it measures:** Whether technical jargon is explained for clarity
- **Better values:** Balanced; technical terms should have definitions or context
- **Indicates:** PRD accessibility for junior developers or new team members
- **Related metrics:** None
- **Recommended Action:** Add glossary or inline explanations for domain-specific terms.
- **Priority:** Low
- **Priority Rationale:** Nice-to-have for documentation quality; complex NLP analysis required.

#### Outcome-based (post-implementation)

#### % of stories completed without modification

- **What it measures:** Stories implemented exactly as specified without PRD changes
- **Better values:** Higher is better; aim for >80%
- **Indicates:** PRD accuracy and completeness
- **Related metrics:** Stories requiring scope changes mid-implementation
- **Recommended Action:** If low, analyze why modifications were needed and improve PRD process.
- **Priority:** Very High
- **Priority Rationale:** Key outcome metric for PRD quality; requires tracking story modifications during implementation.

#### Number of clarification questions asked during implementation

- **What it measures:** Questions raised by implementer about PRD content
- **Better values:** Lower is better; zero is ideal
- **Indicates:** PRD clarity and completeness
- **Related metrics:** Number of ambiguous words
- **Recommended Action:** If high, review common question themes and address in PRD template.
- **Priority:** Medium
- **Priority Rationale:** Useful clarity indicator but requires structured way to log clarification events.

#### Stories requiring scope changes mid-implementation

- **What it measures:** Count of stories where scope expanded or contracted during work
- **Better values:** Zero is ideal; lower is better
- **Indicates:** PRD scope definition quality
- **Related metrics:** Non-goals section length
- **Recommended Action:** If high, improve upfront scope definition and edge case identification.
- **Priority:** High
- **Priority Rationale:** Critical for planning accuracy; requires diff tracking on story definitions.

#### PRD revision count before implementation started

- **What it measures:** Number of PRD edits after initial creation but before coding begins
- **Better values:** Low (1-2 minor revisions acceptable)
- **Indicates:** Initial PRD quality
- **Related metrics:** Number of user feedback cycles
- **Recommended Action:** If high, improve clarifying questions phase or user input gathering.
- **Priority:** High
- **Priority Rationale:** Simple file versioning metric; indicates PRD generation quality.

### Efficiency of PRD Generation

#### Time Metrics

#### Wall-clock time from prompt to PRD file creation

- **What it measures:** Total elapsed time to produce the PRD
- **Better values:** Lower is better, relative to feature complexity
- **Indicates:** Speed of requirements capture process
- **Related metrics:** Number of Amp iterations to generate PRD
- **Recommended Action:** If consistently high, streamline clarifying questions or provide more context upfront.
- **Priority:** Very High
- **Priority Rationale:** Primary efficiency metric; simple timestamp tracking at PRD creation start/end.

#### Number of Amp iterations to generate PRD

- **What it measures:** Agent invocations needed to complete PRD
- **Better values:** 1-2 iterations ideal; lower is better
- **Indicates:** Efficiency of single-pass generation
- **Related metrics:** Wall-clock time from prompt to PRD file creation
- **Recommended Action:** If high, improve prompt engineering or provide better templates.
- **Priority:** Very High
- **Priority Rationale:** Core iteration efficiency metric; simple count per PRD.

#### Number of clarifying question rounds

- **What it measures:** Back-and-forth cycles with user for clarification
- **Better values:** 1-2 rounds ideal
- **Indicates:** Balance between thoroughness and efficiency
- **Related metrics:** Number of user feedback cycles
- **Recommended Action:** If zero, may be making assumptions. If >3, questions may be unfocused.
- **Priority:** High
- **Priority Rationale:** Indicates PRD generation quality; requires interaction logging.

#### Token/Resource Usage

#### Total tokens consumed during PRD generation

- **What it measures:** LLM tokens used for the PRD phase
- **Better values:** Lower is better for cost efficiency
- **Indicates:** Resource efficiency of PRD generation
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If high, reduce verbose prompts or unnecessary research.
- **Priority:** Very High
- **Priority Rationale:** Primary cost metric; available from API response metadata.

#### Number of tool calls made

- **What it measures:** Count of tools invoked (Read, Grep, web search, etc.)
- **Better values:** Proportional to PRD complexity; avoid excessive exploration
- **Indicates:** Research efficiency
- **Related metrics:** Number of file reads during research
- **Recommended Action:** If very high, may be exploring aimlessly. Improve focus.
- **Priority:** Very High
- **Priority Rationale:** Key indicator of exploration efficiency; simple tool invocation count.

#### Number of web searches performed

- **What it measures:** External searches during PRD creation
- **Better values:** Low unless external research genuinely needed
- **Indicates:** Whether existing context is sufficient
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If high for internal projects, improve internal documentation.
- **Priority:** Medium
- **Priority Rationale:** Useful for understanding external dependency; subset of tool calls count.

#### Number of file reads during research

- **What it measures:** Codebase files examined for context
- **Better values:** Proportional to scope; focused reading is better
- **Indicates:** Codebase familiarity and search efficiency
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If very high, improve codebase documentation or AGENTS.md context.
- **Priority:** High
- **Priority Rationale:** Indicates codebase exploration efficiency; subset of tool calls count.

#### API response time per call

- **What it measures:** Latency of each individual LLM API call during PRD generation
- **Better values:** Lower is better; consistent times indicate stable API
- **Aggregation:** Per-call, with averages computed per-iteration
- **Indicates:** API performance and potential bottlenecks
- **Related metrics:** Total tokens consumed during PRD generation
- **Recommended Action:** If high variance, investigate API load or prompt complexity.
- **Priority:** Very High
- **Priority Rationale:** Critical for understanding agent wait time; available from API response.

#### Input/output/thinking token breakdown

- **What it measures:** Distribution of tokens by type (prompt input, response output, reasoning/thinking)
- **Better values:** Lower input tokens relative to output indicates efficient prompting
- **Aggregation:** Per-call, per-iteration, overall PRD phase
- **Indicates:** Whether prompts are bloated vs concise
- **Related metrics:** Total tokens consumed during PRD generation
- **Recommended Action:** If input tokens dominate, reduce context or improve summarization.
- **Priority:** High
- **Priority Rationale:** Important for understanding token efficiency; available from API response metadata.

#### Peak context window utilization

- **What it measures:** Highest percentage of context window used during PRD generation
- **Better values:** Below 80% leaves headroom for complex responses
- **Aggregation:** Per-iteration, overall PRD phase
- **Indicates:** Risk of context overflow during this phase
- **Related metrics:** Context window utilization per iteration
- **Recommended Action:** If approaching 100%, implement context compression strategies.
- **Priority:** Very High
- **Priority Rationale:** Critical for preventing context overflow; computed from input tokens vs model limit.

#### Non-LLM tool operations count

- **What it measures:** Count of bash commands, MCP tools, file reads/writes during PRD
- **Better values:** Higher ratio of non-LLM to LLM calls indicates judicious LLM usage
- **Aggregation:** Per-iteration, overall PRD phase
- **Indicates:** Whether agent uses cheaper operations before LLM calls
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If low relative to LLM calls, encourage more tool-first approaches.
- **Priority:** High
- **Priority Rationale:** Key LLM judiciousness metric; simple tool type categorization count.


#### Iteration Metrics

#### PRD revision count

- **What it measures:** Total edits to PRD file across all phases
- **Better values:** Lower is better; 1-3 minor revisions acceptable
- **Indicates:** Initial PRD quality and stability
- **Related metrics:** PRD revision count before implementation started
- **Recommended Action:** If high, invest more in upfront requirement gathering.
- **Priority:** Medium
- **Priority Rationale:** Good quality indicator but overlaps with "revision count before implementation".

#### Number of user feedback cycles

- **What it measures:** Round-trips requiring user input
- **Better values:** 1-2 cycles ideal
- **Indicates:** User involvement efficiency
- **Related metrics:** Number of clarifying question rounds
- **Recommended Action:** If zero, validate assumptions are correct. If high, batch questions better.
- **Priority:** High
- **Priority Rationale:** Directly impacts user experience and agent efficiency; requires interaction tracking.

---

## 2. Planning Capability

Focuses on HOW to build what was identified — breaking down PRD into implementable features with dependencies and ordering.

### Effectiveness of PRD Breakdown into Features

#### Granularity Quality

#### Average story size (lines of code changed per story)

- **What it measures:** Mean LOC delta per completed story
- **Better values:** 50-200 lines typically ideal; context-window appropriate
- **Indicates:** Whether stories are right-sized for single iterations
- **Related metrics:** Story size variance, % of stories completable in single iteration
- **Recommended Action:** If very high, stories need further decomposition. If very low, may be over-fragmented.
- **Priority:** Very High
- **Priority Rationale:** Core sizing metric for iteration success; computed from git diff per story.

#### Story size variance (consistency)

- **What it measures:** Standard deviation of LOC across stories
- **Better values:** Lower variance indicates consistent sizing
- **Indicates:** Predictability of story effort
- **Related metrics:** Average story size
- **Recommended Action:** If high, review outlier stories and standardize breakdown criteria.
- **Priority:** Medium
- **Priority Rationale:** Statistical analysis of story sizing; derived from average story size data.

#### % of stories completable in single iteration

- **What it measures:** Proportion of stories finished in one agent invocation
- **Better values:** Higher is better; aim for >80%
- **Indicates:** Story sizing appropriateness for context window
- **Related metrics:** Average story size, Iterations per story
- **Recommended Action:** If low, reduce story scope or improve context handoff.
- **Priority:** Very High
- **Priority Rationale:** Primary indicator of context-window appropriateness; computed from iterations per story.

#### Dependency count between stories

- **What it measures:** Average number of prerequisites per story
- **Better values:** Lower is better; 0-2 dependencies typical
- **Indicates:** Parallelization potential and sequencing complexity
- **Related metrics:** Circular dependency detection
- **Recommended Action:** If high, restructure to reduce coupling or reorder for independence.
- **Priority:** High
- **Priority Rationale:** Critical for parallel execution potential; parsed from prd.json dependencies.

#### Circular dependency detection

- **What it measures:** Presence of circular dependency chains
- **Better values:** Zero is required
- **Indicates:** Planning logic errors
- **Related metrics:** Dependency count between stories
- **Recommended Action:** If detected, immediately restructure affected stories.
- **Priority:** Very High
- **Priority Rationale:** Blocking issue that prevents progress; simple graph analysis on dependencies.

#### Ordering Quality

#### Stories completed in original order vs reordered

- **What it measures:** % of stories completed in the sequence originally planned
- **Better values:** Higher indicates good initial ordering
- **Indicates:** Planning accuracy for dependencies and priorities
- **Related metrics:** Blocked stories due to missing dependencies
- **Recommended Action:** If frequently reordering, improve dependency analysis during planning.
- **Priority:** High
- **Priority Rationale:** Measures plan quality; requires tracking story completion order.

#### Blocked stories due to missing dependencies

- **What it measures:** Count of stories that couldn't proceed due to unmet prerequisites
- **Better values:** Zero is ideal
- **Indicates:** Dependency identification quality
- **Related metrics:** Stories completed in original order vs reordered
- **Recommended Action:** If occurring, audit dependency specification process.
- **Priority:** Very High
- **Priority Rationale:** Direct indicator of planning failures; log when story blocked on dependency.

#### Prerequisite satisfaction rate

- **What it measures:** % of declared dependencies completed before dependent stories start
- **Better values:** 100% is ideal
- **Indicates:** Ordering effectiveness
- **Related metrics:** Blocked stories due to missing dependencies
- **Recommended Action:** If <100%, enforce ordering in prd.json or improve dependency tracking.
- **Priority:** High
- **Priority Rationale:** Quality metric for dependency management; computed from story completion timestamps.

#### Outcome-based

#### % of stories marked done without rework

- **What it measures:** Stories completed and never reopened
- **Better values:** Higher is better; aim for >90%
- **Indicates:** Story definition completeness
- **Related metrics:** Stories reopened after marked done
- **Recommended Action:** If low, improve acceptance criteria specificity.
- **Priority:** Very High
- **Priority Rationale:** Primary outcome metric for story quality; requires story state tracking.

#### Stories split mid-implementation

- **What it measures:** Count of stories divided into smaller stories during work
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Initial breakdown was too coarse
- **Related metrics:** Average story size
- **Recommended Action:** If frequent, adjust sizing guidelines during planning.
- **Priority:** High
- **Priority Rationale:** Indicates planning quality; look for story additions to prd.json during implementation.

#### Stories merged mid-implementation

- **What it measures:** Count of stories combined during work
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Initial breakdown was too fine-grained
- **Related metrics:** Average story size
- **Recommended Action:** If frequent, review minimum story size thresholds.
- **Priority:** Medium
- **Priority Rationale:** Less common than splits; detected via story deletions with merged acceptance criteria.

#### Acceptance criteria added post-breakdown

- **What it measures:** New criteria added after planning phase
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Requirements discovered during implementation
- **Related metrics:** % of stories completed without modification
- **Recommended Action:** If frequent, improve upfront criteria elicitation.
- **Priority:** High
- **Priority Rationale:** Key indicator of planning completeness; track prd.json diffs during implementation.

### Efficiency of PRD Breakdown into Features

#### Time Metrics

#### Time from PRD creation to prd.json generation

- **What it measures:** Elapsed time for the planning phase
- **Better values:** Lower is better; should be quick relative to implementation
- **Indicates:** Planning phase efficiency
- **Related metrics:** Iterations spent on breakdown vs implementation
- **Recommended Action:** If high, streamline planning process or automate prd.json generation.
- **Priority:** Very High
- **Priority Rationale:** Primary planning efficiency metric; simple timestamp tracking.

#### Iterations spent on breakdown vs implementation

- **What it measures:** Ratio of planning iterations to building iterations
- **Better values:** Low ratio; planning should be small fraction of total
- **Indicates:** Whether planning is proportionate to implementation
- **Related metrics:** Time from PRD creation to prd.json generation
- **Recommended Action:** If ratio >0.2, planning may be over-engineered.
- **Priority:** High
- **Priority Rationale:** Indicates resource allocation efficiency; simple iteration count ratio.

#### Volume Metrics

#### Stories per PRD

- **What it measures:** Total story count per PRD
- **Better values:** Proportional to feature scope; typically 5-15 for focused features
- **Indicates:** Breakdown granularity
- **Related metrics:** Number of user stories generated
- **Recommended Action:** If very high (>20), consider splitting into multiple PRDs.
- **Priority:** High
- **Priority Rationale:** Simple count from prd.json; baseline for other per-story metrics.

#### Acceptance criteria per story

- **What it measures:** Average criteria count (same as in PRD section but measured post-planning)
- **Better values:** 3-7 per story
- **Indicates:** Verification specificity maintained through planning
- **Related metrics:** Total acceptance criteria count
- **Recommended Action:** If changed from PRD phase, investigate why criteria were added/removed.
- **Priority:** Medium
- **Priority Rationale:** Redundant with PRD section metric; useful for delta tracking.

#### Total acceptance criteria count

- **What it measures:** Sum of all criteria across all stories
- **Better values:** Proportional to scope; provides verification coverage
- **Indicates:** Overall testability of the implementation plan
- **Related metrics:** Acceptance criteria per story
- **Recommended Action:** If very low relative to story count, criteria may be too vague.
- **Priority:** Medium
- **Priority Rationale:** Derived from acceptance criteria count; used for verification scope estimation.

#### Ratio of setup stories to feature stories

- **What it measures:** Infrastructure/scaffolding stories vs user-facing feature stories
- **Better values:** Low ratio; setup should be minimal
- **Indicates:** Whether planning includes unnecessary boilerplate
- **Related metrics:** Stories per PRD
- **Recommended Action:** If high, look for reusable infrastructure or combine setup steps.
- **Priority:** Low
- **Priority Rationale:** Requires story classification; useful for pattern analysis but not critical.

#### Token/Resource Usage

#### Tokens consumed during planning phase

- **What it measures:** Total LLM tokens used for PRD breakdown and story generation
- **Better values:** Lower is better; should be proportionally less than implementation
- **Aggregation:** Per-iteration, overall planning phase
- **Indicates:** Resource efficiency of planning vs implementation ratio
- **Related metrics:** Iterations spent on breakdown vs implementation
- **Recommended Action:** If high relative to implementation, reduce planning verbosity.
- **Priority:** Very High
- **Priority Rationale:** Primary cost metric for planning phase; from API response metadata.

#### API response time during planning

- **What it measures:** Latency of each LLM call during the planning phase
- **Better values:** Lower and consistent is better
- **Aggregation:** Per-call, average per-iteration
- **Indicates:** Whether complex story decomposition slows API responses
- **Related metrics:** Time from PRD creation to prd.json generation
- **Recommended Action:** If high, break complex planning into smaller prompts.
- **Priority:** High
- **Priority Rationale:** Measures planning latency; from API response timing.

#### Context window utilization during breakdown

- **What it measures:** Percentage of context window used when generating story breakdowns
- **Better values:** Below 70% leaves room for PRD content
- **Aggregation:** Peak per-iteration, average overall
- **Indicates:** Whether PRDs are too large for effective breakdown
- **Related metrics:** Stories per PRD
- **Recommended Action:** If consistently high, break large PRDs into smaller chunks.
- **Priority:** High
- **Priority Rationale:** Prevents planning context overflow; computed from input tokens.

---

## 3. Implementation Capability

Focuses on executing the plan — writing code, running tests, completing stories.

### Effectiveness of Feature Implementation

#### Acceptance Criteria Fulfillment

#### % of acceptance criteria marked complete per story

- **What it measures:** Proportion of criteria checked off per story
- **Better values:** 100% is required for story completion
- **Indicates:** Implementation completeness
- **Related metrics:** Stories passing all acceptance criteria vs partially complete
- **Recommended Action:** If <100% on "completed" stories, enforce stricter completion checks.
- **Priority:** Very High
- **Priority Rationale:** Core completion metric; tracked in prd.json criteria status.

#### % of stories completed on first attempt (no reopening)

- **What it measures:** Stories done right the first time
- **Better values:** Higher is better; aim for >85%
- **Indicates:** Implementation quality and requirement understanding
- **Related metrics:** Stories reopened after marked done
- **Recommended Action:** If low, review common failure reasons and address in process.
- **Priority:** Very High
- **Priority Rationale:** Primary quality outcome metric; requires story state history tracking.

#### Stories passing all acceptance criteria vs partially complete

- **What it measures:** Binary pass/fail per story vs partial completion
- **Better values:** All stories should fully pass, not partially
- **Indicates:** Whether stories are being rushed or improperly closed
- **Related metrics:** % of acceptance criteria marked complete per story
- **Recommended Action:** If partial completions exist, do not allow story closure until 100%.
- **Priority:** High
- **Priority Rationale:** Enforces completion discipline; computed from criteria completion rate.

#### Code Quality

**Test coverage delta per story**
- **What it measures:** Change in code coverage percentage after story completion
- **Better values:** Positive delta; coverage should increase or maintain
- **Indicates:** Whether new code is being tested
- **Related metrics:** Test runs per story
- **Recommended Action:** If negative, require tests as part of acceptance criteria.
- **Priority:** Medium
- **Priority Rationale:** Requires coverage tooling integration; good but depends on project setup.

**Lint/typecheck errors introduced vs resolved**
- **What it measures:** Net change in static analysis errors
- **Better values:** Net zero or negative (resolving more than introducing)
- **Indicates:** Code quality maintenance
- **Related metrics:** Typecheck failures before success
- **Recommended Action:** If net positive, add lint/typecheck pass as mandatory acceptance criterion.
- **Priority:** Very High
- **Priority Rationale:** Direct code quality metric; count from lint/typecheck tool output.

**Code review feedback count (if applicable)**
- **What it measures:** Number of review comments on story-related code
- **Better values:** Lower is better
- **Indicates:** Code quality before review
- **Related metrics:** None
- **Recommended Action:** If high, analyze common feedback themes and add to AGENTS.md patterns.
- **Priority:** Low
- **Priority Rationale:** Only applicable with human review; requires integration with PR systems.

**Technical debt markers added (TODOs, FIXMEs)**
- **What it measures:** Count of debt markers introduced per story
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Whether implementation is taking shortcuts
- **Related metrics:** None
- **Recommended Action:** If high, either resolve immediately or track in separate backlog.
- **Priority:** Medium
- **Priority Rationale:** Simple grep for TODO/FIXME patterns in diffs; lower priority than errors.

#### Correctness

**Stories requiring hotfixes post-completion**
- **What it measures:** Stories needing fixes after being marked done
- **Better values:** Zero is ideal
- **Indicates:** Verification thoroughness
- **Related metrics:** % of stories completed on first attempt
- **Recommended Action:** If occurring, improve testing requirements in acceptance criteria.
- **Priority:** Very High
- **Priority Rationale:** Critical quality indicator; track in story state changes.

**Bugs discovered in completed stories**
- **What it measures:** Defects found in "done" work
- **Better values:** Zero is ideal
- **Indicates:** Testing effectiveness and implementation quality
- **Related metrics:** Stories requiring hotfixes post-completion
- **Recommended Action:** Analyze bug patterns and add preventive checks.
- **Priority:** High
- **Priority Rationale:** Outcome metric; requires bug tracking integration or manual logging.

**Regression test failures after story completion**
- **What it measures:** Existing tests broken by new code
- **Better values:** Zero is ideal
- **Indicates:** Whether changes are properly scoped and tested
- **Related metrics:** Test runs per story
- **Recommended Action:** If occurring, run full test suite before marking stories complete.
- **Priority:** Very High
- **Priority Rationale:** Critical quality gate; count from test run results.

**Manual verification failures**
- **What it measures:** Stories that fail human/browser verification
- **Better values:** Zero is ideal
- **Indicates:** Gap between automated and real-world testing
- **Related metrics:** Stories requiring hotfixes post-completion
- **Recommended Action:** Add browser verification to UI story acceptance criteria.
- **Priority:** Medium
- **Priority Rationale:** Requires manual logging; important for UI stories specifically.

### Efficiency of Feature Implementation

#### Time Metrics

**Wall-clock time per story**
- **What it measures:** Elapsed time from story start to completion
- **Better values:** Lower is better; proportional to story size
- **Indicates:** Implementation velocity
- **Related metrics:** Iterations per story
- **Recommended Action:** If high relative to story size, investigate blockers or complexity.
- **Priority:** Very High
- **Priority Rationale:** Primary velocity metric; simple timestamp tracking.

**Iterations per story**
- **What it measures:** Agent invocations needed per story
- **Better values:** 1 is ideal; lower is better
- **Indicates:** Whether stories fit in context window
- **Related metrics:** % of stories completable in single iteration
- **Recommended Action:** If >1 consistently, reduce story scope.
- **Priority:** Very High
- **Priority Rationale:** Core context-window fitness metric; simple count.

**Time per acceptance criterion**
- **What it measures:** Average time to satisfy each criterion
- **Better values:** Lower is better; consistent across criteria
- **Indicates:** Criterion complexity uniformity
- **Related metrics:** Wall-clock time per story
- **Recommended Action:** If highly variable, review outlier criteria for over-specification.
- **Priority:** Medium
- **Priority Rationale:** Derived metric; useful for criterion-level analysis.

#### Token/Resource Usage

**Tokens consumed per story**
- **What it measures:** LLM tokens used per story
- **Better values:** Lower is better for cost; proportional to complexity
- **Aggregation:** Per-story, per-feature, overall
- **Indicates:** Resource efficiency
- **Related metrics:** Tool calls per story
- **Recommended Action:** If high, reduce exploration or improve context.
- **Priority:** Very High
- **Priority Rationale:** Primary cost metric for implementation; from API response.

**Input/output/thinking tokens per story**
- **What it measures:** Token breakdown by type for each story
- **Better values:** Lower input relative to output indicates efficient context handling
- **Aggregation:** Per-story, per-feature, overall
- **Indicates:** Whether context is bloated or prompts are inefficient
- **Related metrics:** Tokens consumed per story
- **Recommended Action:** If thinking tokens dominate, consider simpler prompts.
- **Priority:** High
- **Priority Rationale:** Important for understanding token distribution; from API response.

**API response time per implementation call**
- **What it measures:** Latency of each LLM API call during implementation
- **Better values:** Lower and consistent is better
- **Aggregation:** Per-call (each call tracked), averages per-iteration, per-story
- **Indicates:** API performance and code generation complexity impact
- **Related metrics:** Iterations per story
- **Recommended Action:** If high variance, investigate complex code sections.
- **Priority:** Very High
- **Priority Rationale:** Critical latency metric; from API response timing.

**Context window utilization per iteration**
- **What it measures:** Percentage of context window used at end of each iteration
- **Better values:** Below 85% allows headroom for complex responses
- **Aggregation:** Per-iteration, peak per-story, average per-feature
- **Indicates:** Risk of context overflow during implementation
- **Related metrics:** Iterations per story
- **Recommended Action:** If consistently above 90%, implement context compression.
- **Priority:** Very High
- **Priority Rationale:** Critical for preventing context overflow; from input token count.

**Tool calls per story**
- **What it measures:** Total tool invocations per story
- **Better values:** Proportional to story complexity; avoid excessive exploration
- **Indicates:** Implementation focus vs exploration
- **Related metrics:** File edits per story
- **Recommended Action:** If very high, agent may be struggling; review story clarity.
- **Priority:** Very High
- **Priority Rationale:** Key efficiency metric; simple tool invocation count.

**File edits per story**
- **What it measures:** Number of file modifications per story
- **Better values:** Proportional to story scope; focused changes preferred
- **Indicates:** Change localization
- **Related metrics:** Files touched per story
- **Recommended Action:** If high, story may be too broad or code may need refactoring.
- **Priority:** High
- **Priority Rationale:** Indicates change scope; count from file modification tool calls.

**Commands executed per story**
- **What it measures:** Shell commands run per story
- **Better values:** Proportional to needs; minimal for simple stories
- **Indicates:** Build/test cycle frequency
- **Related metrics:** Build/typecheck runs per story
- **Recommended Action:** If high, may indicate trial-and-error; improve upfront planning.
- **Priority:** High
- **Priority Rationale:** Key non-LLM operation metric; count from run_command calls.

#### Non-LLM Tool Operations

**Bash commands executed**
- **What it measures:** Count of shell commands run
- **Better values:** Higher count relative to LLM calls indicates judicious LLM usage
- **Aggregation:** Per-iteration, per-story, per-feature, overall
- **Indicates:** Use of non-LLM operations for verification and exploration
- **Related metrics:** Commands executed per story, LLM to non-LLM ratio
- **Recommended Action:** If low, encourage shell-first verification.
- **Priority:** Very High
- **Priority Rationale:** Core LLM judiciousness metric; simple run_command count.

**Bash command execution time**
- **What it measures:** Wall-clock time spent executing shell commands
- **Better values:** Proportional to test/build scope; fast feedback loops preferred
- **Aggregation:** Per-iteration, per-story, overall
- **Indicates:** Build and test infrastructure efficiency
- **Related metrics:** Build/typecheck runs per story
- **Recommended Action:** If high, investigate slow tests or builds.
- **Priority:** High
- **Priority Rationale:** Build efficiency metric; from command execution timing.

**MCP tool invocations**
- **What it measures:** Count of Model Context Protocol tool calls
- **Better values:** Higher indicates use of structured data tools vs raw LLM
- **Aggregation:** Per-iteration, per-story, per-feature, overall
- **Indicates:** Leverage of specialized tooling
- **Related metrics:** Tool calls per story
- **Recommended Action:** If low for codebase analysis, ensure MCP tools are available.
- **Priority:** High
- **Priority Rationale:** Measures structured tool usage; count from MCP tool calls.

**MCP invocations by type**
- **What it measures:** Breakdown of MCP calls by tool name (search, trace, etc.)
- **Better values:** Distribution should match task needs
- **Aggregation:** Per-story, overall
- **Indicates:** Which tools are most valuable for implementation
- **Related metrics:** MCP tool invocations
- **Recommended Action:** If one tool dominates, ensure others are being considered.
- **Priority:** Low
- **Priority Rationale:** Detailed breakdown; implement after basic MCP count.

**File system operations count**
- **What it measures:** Read, write, search, and list operations
- **Better values:** Reads should exceed writes; focused searches preferred
- **Aggregation:** Per-iteration, per-story, overall
- **Indicates:** Exploration vs modification patterns
- **Related metrics:** File edits per story
- **Recommended Action:** If writes exceed reads significantly, may be making blind changes.
- **Priority:** High
- **Priority Rationale:** Indicates exploration patterns; count from file tool calls.

**LLM calls to non-LLM operations ratio**
- **What it measures:** Ratio of LLM API calls to bash/MCP/file operations
- **Better values:** Lower ratio indicates judicious LLM usage
- **Aggregation:** Per-story, per-feature, overall
- **Indicates:** Cost efficiency and tool-first approach
- **Related metrics:** Tool calls per story, Non-LLM tool operations
- **Recommended Action:** If ratio high, encourage tool-first problem solving.
- **Priority:** Very High
- **Priority Rationale:** Key LLM judiciousness ratio; computed from other counts.

#### Code Metrics

**Lines of code added/modified/deleted per story**
- **What it measures:** LOC delta categorized by change type
- **Better values:** Balanced; deletions can indicate refactoring (positive)
- **Aggregation:** Per-iteration, per-story, per-feature, overall
- **Indicates:** Story impact scope
- **Related metrics:** Average story size
- **Recommended Action:** Use to calibrate story sizing guidelines.
- **Priority:** Very High
- **Priority Rationale:** Primary productivity metric; from git diff analysis.

**LOC per iteration**
- **What it measures:** Lines of code touched (added + modified + deleted) in each iteration
- **Better values:** Consistent across iterations indicates stable velocity
- **Aggregation:** Per-iteration, aggregated to per-story and overall
- **Indicates:** Per-iteration productivity and iteration sizing appropriateness
- **Related metrics:** Iterations per story
- **Recommended Action:** If highly variable, normalize iteration scope.
- **Priority:** High
- **Priority Rationale:** Velocity metric; derived from LOC per story.

**LOC churn rate**
- **What it measures:** (Lines modified + Lines deleted) / Total lines touched
- **Better values:** Lower is better; high churn indicates rework
- **Aggregation:** Per-story, per-feature, overall
- **Indicates:** Code stability and implementation confidence
- **Related metrics:** Same line edited multiple times
- **Recommended Action:** If high, investigate cause of rework.
- **Priority:** Very High
- **Priority Rationale:** Key rework indicator; computed from LOC breakdown.

**Net LOC delta per feature**
- **What it measures:** Lines added minus lines deleted across all stories in a feature
- **Better values:** Proportional to feature scope; net negative can indicate good refactoring
- **Aggregation:** Per-feature, overall
- **Indicates:** Feature complexity and codebase growth/shrinkage
- **Related metrics:** Average story size
- **Recommended Action:** Use for estimating future similar features.
- **Priority:** Medium
- **Priority Rationale:** Aggregate metric; computed from LOC per story.

**Files touched per story**
- **What it measures:** Number of unique files modified
- **Better values:** Lower indicates focused changes; 1-5 typical
- **Indicates:** Change dispersion
- **Related metrics:** File edits per story
- **Recommended Action:** If high, may indicate poor code organization or story scope.
- **Priority:** High
- **Priority Rationale:** Indicates story scope; count from unique file paths in edits.

**Commits per story**
- **What it measures:** Git commits made per story
- **Better values:** 1 is ideal (atomic commits)
- **Indicates:** Commit discipline
- **Related metrics:** None
- **Recommended Action:** If multiple commits per story, consider squashing or improving atomicity.
- **Priority:** Low
- **Priority Rationale:** Nice-to-have for commit hygiene; count from git log.

**Build/typecheck runs per story**
- **What it measures:** Verification cycles per story
- **Better values:** Lower is better; 1-2 runs ideal
- **Indicates:** Implementation confidence and accuracy
- **Related metrics:** Typecheck failures before success
- **Recommended Action:** If high, agent is iterating through errors; improve upfront correctness.
- **Priority:** Very High
- **Priority Rationale:** Key quality gate; count from typecheck command invocations.

**Test runs per story**
- **What it measures:** Test suite executions per story
- **Better values:** At least 1; more may indicate test-driven approach
- **Indicates:** Testing discipline
- **Related metrics:** Test coverage delta per story
- **Recommended Action:** If zero, enforce testing in acceptance criteria.
- **Priority:** High
- **Priority Rationale:** Key testing metric; count from test command invocations.

#### Error Metrics

**Typecheck failures before success**
- **What it measures:** Type errors encountered before clean pass
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Type-safety awareness during implementation
- **Related metrics:** Build/typecheck runs per story
- **Recommended Action:** If high, add typing patterns to AGENTS.md.
- **Priority:** Very High
- **Priority Rationale:** Direct code quality metric; count from typecheck output.

**Test failures before success**
- **What it measures:** Test failures before all tests pass
- **Better values:** Some expected for TDD; excessive indicates issues
- **Indicates:** Test-driven vs fix-after-fail approach
- **Related metrics:** Test runs per story
- **Recommended Action:** If very high, review test understanding and story clarity.
- **Priority:** High
- **Priority Rationale:** Testing quality metric; count from test output.

**Build errors encountered**
- **What it measures:** Compilation/build failures during implementation
- **Better values:** Zero is ideal
- **Indicates:** Build system familiarity
- **Related metrics:** Typecheck failures before success
- **Recommended Action:** If recurring, document build patterns in AGENTS.md.
- **Priority:** High
- **Priority Rationale:** Build quality metric; count from build command output.

**Rollbacks/undos performed**
- **What it measures:** Reverts of changes during implementation
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Implementation confidence and planning quality
- **Related metrics:** Git resets performed
- **Recommended Action:** If high, improve upfront design or break into smaller steps.
- **Priority:** Very High
- **Priority Rationale:** Critical rework indicator; count from undo operations.

**Git resets performed**
- **What it measures:** Hard resets during implementation
- **Better values:** Zero is ideal
- **Indicates:** Significant implementation failures requiring full restart
- **Related metrics:** Rollbacks/undos performed
- **Recommended Action:** If occurring, investigate root cause and add guardrails.
- **Priority:** Very High
- **Priority Rationale:** Critical failure indicator; count from git reset commands.

#### Rework Metrics

**Same file edited multiple times**
- **What it measures:** Files modified more than once in a story
- **Better values:** Lower is better; some rework normal
- **Indicates:** Implementation uncertainty or iterative refinement
- **Related metrics:** Same line edited multiple times
- **Recommended Action:** If high, improve upfront design or story clarity.
- **Priority:** High
- **Priority Rationale:** Rework indicator; count from file edit history.

**Same line edited multiple times**
- **What it measures:** Lines changed multiple times in a story
- **Better values:** Zero is ideal
- **Indicates:** Trial-and-error coding
- **Related metrics:** Same file edited multiple times
- **Recommended Action:** If high, agent is guessing; improve context or examples.
- **Priority:** Very High
- **Priority Rationale:** Critical trial-and-error indicator; from line-level edit tracking.

**Stories reopened after marked done**
- **What it measures:** Stories moving from done back to in-progress
- **Better values:** Zero is ideal
- **Indicates:** Premature completion or missed requirements
- **Related metrics:** % of stories completed on first attempt
- **Recommended Action:** Enforce verification before marking done.
- **Priority:** Very High
- **Priority Rationale:** Critical quality indicator; track story state transitions.

---

## 4. Coordination/Orchestration Capability

Focuses on Ralph's loop management — iteration control, context handoff, failure recovery, and overall workflow.

### Effectiveness of Orchestration

#### Iteration Success

**% of iterations that complete without error**
- **What it measures:** Iterations ending cleanly vs crashing
- **Better values:** 100% is ideal; higher is better
- **Indicates:** System stability
- **Related metrics:** Clean exit rate
- **Recommended Action:** If <100%, investigate error patterns and add error handling.
- **Priority:** Very High
- **Priority Rationale:** Core system health metric; track iteration exit codes.

**% of iterations that make meaningful progress (at least 1 story advanced)**
- **What it measures:** Productive iterations vs wasted cycles
- **Better values:** 100% is ideal
- **Indicates:** Each iteration is contributing value
- **Related metrics:** Wasted iterations
- **Recommended Action:** If low, improve story selection or context handoff.
- **Priority:** Very High
- **Priority Rationale:** Core productivity metric; track story status changes per iteration.

**Iterations ending in recoverable vs unrecoverable state**
- **What it measures:** Classification of iteration failures
- **Better values:** All failures should be recoverable; unrecoverable = zero
- **Indicates:** Resilience of the system
- **Related metrics:** Successful recovery from failed iterations
- **Recommended Action:** If unrecoverable states occur, add checkpointing or recovery logic.
- **Priority:** Very High
- **Priority Rationale:** Critical for reliability; classify failures at iteration end.

**Clean exit rate (success vs max iterations vs error)**
- **What it measures:** Distribution of iteration end reasons
- **Better values:** High success rate; low max iterations and error rates
- **Indicates:** Overall completion health
- **Related metrics:** % of iterations that complete without error
- **Recommended Action:** If max iterations common, increase limit or improve efficiency.
- **Priority:** Very High
- **Priority Rationale:** Primary health distribution; track exit reason per iteration.

#### Context Handoff

**Information loss between iterations (measured by repeated work)**
- **What it measures:** Work duplicated across iterations due to lost context
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Quality of context preservation mechanism
- **Related metrics:** Context preserved across iterations
- **Recommended Action:** If high, improve progress.txt detail or add explicit state tracking.
- **Priority:** High
- **Priority Rationale:** Important for multi-iteration efficiency; detect repeated file reads.

**Successful continuation after interruption**
- **What it measures:** % of iterations that successfully resume previous work
- **Better values:** 100% is ideal
- **Indicates:** Robustness of handoff mechanism
- **Related metrics:** Information loss between iterations
- **Recommended Action:** If low, standardize progress.txt format or add validation.
- **Priority:** Very High
- **Priority Rationale:** Core continuation metric; track if first action is context reload.

**Context window utilization at iteration end**
- **What it measures:** Percentage of context window used when iteration completes
- **Better values:** Below 80% to allow headroom for next iteration startup
- **Aggregation:** Per-iteration
- **Indicates:** Whether context is being managed effectively across iterations
- **Related metrics:** Context overflow events
- **Recommended Action:** If consistently high, implement aggressive context summarization.
- **Priority:** Very High
- **Priority Rationale:** Critical context metric; from final input token count.

**Context overflow events**
- **What it measures:** Count of iterations where context window was truncated/compressed
- **Better values:** Zero is ideal
- **Aggregation:** Per-story, overall
- **Indicates:** Planning may be creating too many dependencies requiring large context
- **Related metrics:** Context window utilization at iteration end
- **Recommended Action:** If occurring, break work into more independent iterations.
- **Priority:** Very High
- **Priority Rationale:** Critical system limit indicator; track truncation events.

**Time to context reload per iteration**
- **What it measures:** Time spent re-establishing context at iteration start
- **Better values:** Lower is better; should be minimal
- **Indicates:** Efficiency of context retrieval
- **Related metrics:** Context window utilization at iteration end
- **Recommended Action:** If high, optimize context storage or reduce verbosity.
- **Priority:** High
- **Priority Rationale:** Handoff efficiency metric; timestamp at iteration start after context load.

#### Failure Recovery

**Successful recovery from failed iterations**
- **What it measures:** % of failures that are successfully recovered in next iteration
- **Better values:** 100% is ideal
- **Indicates:** System resilience
- **Related metrics:** Iterations ending in recoverable vs unrecoverable state
- **Recommended Action:** If low, improve error logging and recovery procedures.
- **Priority:** Very High
- **Priority Rationale:** Critical recovery metric; track failed→success transitions.

**Average iterations to recover from failure**
- **What it measures:** Iterations needed to get back on track after a failure
- **Better values:** 1 is ideal; lower is better
- **Indicates:** Recovery efficiency
- **Related metrics:** Successful recovery from failed iterations
- **Recommended Action:** If >1, improve failure diagnosis or add automated recovery steps.
- **Priority:** High
- **Priority Rationale:** Recovery efficiency metric; count iterations until success after failure.

**Repeated failures on same story**
- **What it measures:** Count of consecutive failures on a single story
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Whether system is stuck or making progress
- **Related metrics:** Stories requiring human intervention
- **Recommended Action:** If >2, escalate to human or skip story temporarily.
- **Priority:** Very High
- **Priority Rationale:** Critical stuck indicator; count consecutive failures per story.

#### Workflow Efficiency

**Wasted iterations (no progress made)**
- **What it measures:** Iterations that don't advance any story
- **Better values:** Zero is ideal
- **Indicates:** Iteration productivity
- **Related metrics:** % of iterations that make meaningful progress
- **Recommended Action:** If occurring, investigate why and improve story selection logic.
- **Priority:** Very High
- **Priority Rationale:** Critical waste indicator; track iterations with zero story advancement.

**Stories requiring human intervention**
- **What it measures:** Stories that couldn't be completed autonomously
- **Better values:** Zero is ideal; lower is better
- **Indicates:** System autonomy level
- **Related metrics:** Repeated failures on same story
- **Recommended Action:** If high, analyze common blockers and add capabilities or patterns.
- **Priority:** High
- **Priority Rationale:** Autonomy metric; flag stories escalated to human.

**Average stories completed per iteration**
- **What it measures:** Mean story throughput per iteration
- **Better values:** Higher is better; 1+ is good
- **Indicates:** Overall system productivity
- **Related metrics:** % of stories completable in single iteration
- **Recommended Action:** If <1, stories may be too large or iterations too short.
- **Priority:** Very High
- **Priority Rationale:** Primary throughput metric; simple story count per iteration.

**Iteration time variance**
- **What it measures:** Standard deviation of iteration durations
- **Better values:** Lower variance indicates predictability
- **Indicates:** Consistency of iteration performance
- **Related metrics:** None
- **Recommended Action:** If high, investigate outliers and standardize iteration scope.
- **Priority:** Medium
- **Priority Rationale:** Predictability metric; computed from iteration duration data.

#### Decision Quality

**Story selection accuracy (selected story was completable)**
- **What it measures:** % of selected stories that were successfully completed
- **Better values:** Higher is better; aim for >90%
- **Indicates:** Quality of story prioritization logic
- **Related metrics:** Blocked stories due to missing dependencies
- **Recommended Action:** If low, improve dependency checking before selection.
- **Priority:** Very High
- **Priority Rationale:** Core selection quality metric; track selection→completion rate.

**Dependency resolution accuracy**
- **What it measures:** % of times dependencies were correctly identified and satisfied
- **Better values:** 100% is ideal
- **Indicates:** Dependency tracking effectiveness
- **Related metrics:** Prerequisite satisfaction rate
- **Recommended Action:** If <100%, improve dependency validation logic.
- **Priority:** High
- **Priority Rationale:** Planning quality metric; compare declared vs actual dependencies.

**Appropriate escalation rate**
- **What it measures:** % of escalations that were genuinely necessary
- **Better values:** High (escalations should be justified)
- **Indicates:** Whether system knows when it needs help
- **Related metrics:** Stories requiring human intervention
- **Recommended Action:** If low, improve escalation criteria. If zero, may be missing needed escalations.
- **Priority:** Medium
- **Priority Rationale:** Escalation quality metric; requires human validation of escalations.

---

## Cross-Cutting: Resource Observability

Resource observability spans all phases and provides aggregate views of LLM usage efficiency and cost management. These metrics help measure the judiciousness of LLM usage across the entire Ralph workflow.

### Aggregate Token Consumption

#### Total tokens per PRD lifecycle

- **What it measures:** Sum of all tokens (input + output + thinking) from PRD creation through all stories completed
- **Better values:** Lower is better; proportional to PRD scope
- **Indicates:** Overall resource consumption for a feature set
- **Related metrics:** Tokens consumed per story, Token cost estimate
- **Recommended Action:** Use as baseline for estimating future PRDs of similar scope.
- **Priority:** Very High
- **Priority Rationale:** Top-line cost metric; aggregate from per-phase token counts.

#### Tokens per line of code ratio

- **What it measures:** Total tokens consumed divided by net LOC added
- **Better values:** Lower indicates more efficient code generation
- **Indicates:** Cost efficiency of code generation
- **Related metrics:** Total tokens per PRD lifecycle, Net LOC delta per feature
- **Recommended Action:** If high, investigate verbose exploration or inefficient prompts.
- **Priority:** Very High
- **Priority Rationale:** Key efficiency ratio; computed from other metrics.

#### Token cost estimate

- **What it measures:** Estimated financial cost (tokens × cost per token by model)
- **Better values:** Lower is better; track trends over time
- **Aggregation:** Per-story, per-feature, overall PRD lifecycle
- **Indicates:** Financial efficiency of the system
- **Related metrics:** Total tokens per PRD lifecycle
- **Recommended Action:** If trending up, investigate cost drivers.
- **Priority:** Very High
- **Priority Rationale:** Business-critical cost metric; from token counts × pricing.

### Aggregate API Performance

#### Total API calls per PRD lifecycle

- **What it measures:** Count of all LLM API invocations across planning through implementation
- **Better values:** Lower indicates more efficient use of LLM
- **Indicates:** API call efficiency
- **Related metrics:** LLM calls to non-LLM operations ratio
- **Recommended Action:** Track trends; investigate increases.
- **Priority:** Very High
- **Priority Rationale:** Aggregate call count; sum from all phases.

#### API error rate trend

- **What it measures:** Percentage of API calls that result in errors over time
- **Better values:** Lower is better; stable or decreasing trend
- **Indicates:** API reliability and prompt quality
- **Related metrics:** API timeout/retry count
- **Recommended Action:** If increasing, investigate error types and root causes.
- **Priority:** High
- **Priority Rationale:** Reliability trend metric; track error codes over time.

#### Average API latency trend

- **What it measures:** Mean API response time over time (daily/weekly aggregates)
- **Better values:** Lower and stable is better
- **Indicates:** API performance trends and potential degradation
- **Related metrics:** API response time per call
- **Recommended Action:** If increasing, investigate prompt complexity or API provider issues.
- **Priority:** High
- **Priority Rationale:** Performance trend; aggregate from per-call latencies.

### Resource Efficiency Ratios

#### LLM to non-LLM operations ratio (overall)

- **What it measures:** Ratio of total LLM API calls to total non-LLM operations (bash, MCP, file ops)
- **Better values:** Lower indicates judicious LLM usage
- **Indicates:** Whether agent leverages cheaper alternatives before LLM calls
- **Related metrics:** LLM calls to non-LLM operations ratio (per story)
- **Recommended Action:** If high, encourage tool-first problem-solving approaches.
- **Priority:** Very High
- **Priority Rationale:** Key LLM judiciousness metric; aggregate ratio.

#### Tokens per acceptance criterion

- **What it measures:** Average tokens used to satisfy each acceptance criterion
- **Better values:** Lower indicates efficient verification
- **Aggregation:** Per-story average, overall average
- **Indicates:** Verification efficiency
- **Related metrics:** Tokens consumed per story
- **Recommended Action:** If high, criteria may be vague or overly complex.
- **Priority:** Medium
- **Priority Rationale:** Efficiency ratio; derived from tokens and criteria counts.

#### Productive token ratio

- **What it measures:** Tokens resulting in kept code changes vs total tokens consumed
- **Better values:** Higher is better; indicates less wasted exploration
- **Indicates:** Efficiency of exploration and implementation
- **Related metrics:** LOC churn rate, Rollbacks/undos performed
- **Recommended Action:** If low, agent may be exploring too much before committing.
- **Priority:** High
- **Priority Rationale:** Efficiency metric; requires tracking which tokens led to kept changes.

### Time Efficiency

#### Total agent active time per PRD lifecycle

- **What it measures:** Cumulative wall-clock time agent was working across all iterations
- **Better values:** Lower is better; proportional to PRD scope
- **Aggregation:** Per-story, per-feature, overall
- **Indicates:** Overall time efficiency
- **Related metrics:** Wall-clock time per story
- **Recommended Action:** Use for capacity planning and estimation.
- **Priority:** Very High
- **Priority Rationale:** Business-critical time metric; sum of iteration durations.

#### LLM wait time percentage

- **What it measures:** Percentage of total time spent waiting for LLM API responses
- **Better values:** Lower indicates better parallelization or faster APIs
- **Indicates:** Bottleneck identification (LLM vs tool execution)
- **Related metrics:** Average API latency trend
- **Recommended Action:** If high, investigate async tool execution or API alternatives.
- **Priority:** High
- **Priority Rationale:** Bottleneck identification; from API latency vs total time.

#### Time per LOC ratio

- **What it measures:** Total agent active time divided by net LOC added
- **Better values:** Lower indicates faster development velocity
- **Aggregation:** Per-feature, overall
- **Indicates:** Development speed efficiency
- **Related metrics:** Total agent active time per PRD lifecycle
- **Recommended Action:** Track trends to identify improvement or degradation.
- **Priority:** High
- **Priority Rationale:** Velocity ratio; derived from time and LOC metrics.
