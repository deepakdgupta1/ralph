# Metrics for Ralph

## Cross-Cutting: Learning Capability

Learning spans all phases and should be measured across the entire workflow.

### Learning Capture

#### AGENTS.md additions per iteration (diff size)

- **What it measures:** Lines added to AGENTS.md during each iteration
- **Better values:** Low-to-moderate additions; consistent small updates
- **Indicates:** Whether the system is capturing learnings incrementally rather than in large batches or not at all
- **Related metrics:** Repeated errors after learning documented, Pattern reuse frequency
- **Recommended Action:** If zero for multiple iterations, prompt agent to reflect on patterns. If very high, check if learnings are too verbose or redundant.

#### AGENTS.md sections modified

- **What it measures:** Which sections of AGENTS.md are being updated (Commands, Patterns, Anti-patterns, etc.)
- **Better values:** Balanced distribution across sections
- **Indicates:** Whether learning is comprehensive or concentrated in one area
- **Related metrics:** Number of anti-patterns documented, Number of patterns documented
- **Recommended Action:** If only one section is modified, review if other types of learnings are being missed.

#### Number of anti-patterns documented

- **What it measures:** Count of explicitly documented "what not to do" learnings
- **Better values:** Higher is better (indicates mistakes are being captured)
- **Indicates:** System's ability to learn from failures
- **Related metrics:** Same anti-pattern encountered twice, Error rate reduction across iterations
- **Recommended Action:** If low despite errors occurring, improve anti-pattern capture prompts.

#### Number of patterns documented

- **What it measures:** Count of reusable positive patterns captured
- **Better values:** Higher is better
- **Indicates:** System's ability to generalize successful approaches
- **Related metrics:** Pattern reuse frequency
- **Recommended Action:** If low, add prompts to extract patterns from successful stories.

#### Learning classification counts (directory/project/global)

- **What it measures:** Distribution of learnings by scope of applicability
- **Better values:** Higher global count indicates more reusable knowledge
- **Indicates:** Whether learnings are too specific or appropriately generalized
- **Related metrics:** Pattern reuse frequency
- **Recommended Action:** Review project-level learnings periodically for promotion to global.

### Learning Reuse

#### AGENTS.md references in subsequent prompts

- **What it measures:** How often documented learnings are cited during work
- **Better values:** Higher is better
- **Indicates:** Whether captured knowledge is actually being applied
- **Related metrics:** Pattern reuse frequency, Error rate reduction across iterations
- **Recommended Action:** If low, learnings may not be discoverable; improve organization or indexing.

#### Repeated errors after learning documented

- **What it measures:** Count of errors that recur despite being documented as anti-patterns
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Effectiveness of learning capture and retrieval
- **Related metrics:** Number of anti-patterns documented, Same anti-pattern encountered twice
- **Recommended Action:** Investigate why documented learnings aren't preventing recurrence; may need better formatting or placement.

#### Same anti-pattern encountered twice

- **What it measures:** Boolean or count of duplicate mistakes
- **Better values:** Zero is ideal
- **Indicates:** Failure in learning application; knowledge not being used
- **Related metrics:** Repeated errors after learning documented
- **Recommended Action:** Add explicit anti-pattern check step before implementation.

#### Pattern reuse frequency

- **What it measures:** How often documented patterns are applied to new work
- **Better values:** Higher is better
- **Indicates:** ROI of learning capture effort
- **Related metrics:** Number of patterns documented, Time-per-story reduction trend
- **Recommended Action:** If low, patterns may be too specific or poorly documented.

### Learning Impact (proxy metrics)

#### Iteration performance improvement over time

- **What it measures:** Trend of iterations needed per story over multiple PRDs
- **Better values:** Decreasing trend is better
- **Indicates:** Long-term effectiveness of learning system
- **Related metrics:** Stories-per-iteration improvement trend
- **Recommended Action:** If flat or increasing, audit learning capture quality.

#### Error rate reduction across iterations

- **What it measures:** Trend of errors per iteration over time
- **Better values:** Decreasing trend is better
- **Indicates:** Whether mistakes are being learned from
- **Related metrics:** Number of anti-patterns documented
- **Recommended Action:** If not decreasing, review anti-pattern documentation process.

#### Time-per-story reduction trend

- **What it measures:** Average wall-clock time per story over multiple PRDs
- **Better values:** Decreasing trend is better
- **Indicates:** Efficiency gains from accumulated learning
- **Related metrics:** Pattern reuse frequency
- **Recommended Action:** If flat, analyze which story types aren't improving.

#### Stories-per-iteration improvement trend

- **What it measures:** Average stories completed per iteration over time
- **Better values:** Increasing trend is better
- **Indicates:** Overall system efficiency improvement
- **Related metrics:** Iteration performance improvement over time
- **Recommended Action:** If decreasing, investigate context or complexity changes.

### Progress.txt Metrics

#### Updates per iteration

- **What it measures:** Number of edits to progress.txt each iteration
- **Better values:** Exactly 1 is ideal; consistent updates
- **Indicates:** Whether state is being properly recorded for handoff
- **Related metrics:** Context preserved across iterations
- **Recommended Action:** If zero, iteration may have failed silently. If multiple, may indicate instability.

#### Blockers logged vs resolved

- **What it measures:** Ratio of blockers recorded to blockers subsequently cleared
- **Better values:** Ratio close to 1:1 (all blockers eventually resolved)
- **Indicates:** Ability to identify and overcome obstacles
- **Related metrics:** Iterations ending in recoverable vs unrecoverable state
- **Recommended Action:** If blockers accumulate unresolved, escalate for human intervention.

#### Context preserved across iterations

- **What it measures:** Whether subsequent iterations have sufficient context to continue work
- **Better values:** High preservation (minimal repeated discovery work)
- **Indicates:** Quality of progress.txt and AGENTS.md as memory
- **Related metrics:** Information loss between iterations
- **Recommended Action:** If poor, improve progress.txt structure or add summary requirements.

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

#### Number of acceptance criteria per story

- **What it measures:** Average count of acceptance criteria across stories
- **Better values:** 3-7 per story is typically ideal
- **Indicates:** Specificity and testability of requirements
- **Related metrics:** Avg words per acceptance criteria
- **Recommended Action:** If <2, stories lack verification clarity. If >10, story may need splitting.

#### Avg words per acceptance criteria (specificity)

- **What it measures:** Average length of each acceptance criterion
- **Better values:** 10-25 words typically indicates good specificity
- **Indicates:** Whether criteria are concrete vs vague
- **Related metrics:** Number of ambiguous words
- **Recommended Action:** If too short, criteria may be vague. If too long, may be combining multiple criteria.

#### Number of functional requirements

- **What it measures:** Count of FR-numbered items in the PRD
- **Better values:** Higher indicates more comprehensive specification
- **Indicates:** Completeness of technical specification
- **Related metrics:** Number of user stories generated
- **Recommended Action:** If low relative to stories, add explicit functional requirements.

#### Presence of all PRD sections (completeness score)

- **What it measures:** Percentage of standard PRD sections present (Goals, Stories, FRs, Non-Goals, etc.)
- **Better values:** 100% is ideal
- **Indicates:** PRD structural completeness
- **Related metrics:** None
- **Recommended Action:** If sections missing, use PRD template validation.

#### Non-goals section length (scope clarity)

- **What it measures:** Word count or item count in Non-Goals section
- **Better values:** At least 3-5 items; longer indicates clearer boundaries
- **Indicates:** How well scope boundaries are defined
- **Related metrics:** Stories requiring scope changes mid-implementation
- **Recommended Action:** If empty or minimal, explicitly prompt for scope exclusions.

#### Actionability Indicators

#### % of acceptance criteria with verifiable language ("must", "shows", "returns")

- **What it measures:** Proportion of criteria using concrete, testable verbs
- **Better values:** Higher is better; aim for >80%
- **Indicates:** Whether criteria can be objectively verified
- **Related metrics:** Number of ambiguous words
- **Recommended Action:** If low, rewrite criteria with action verbs and observable outcomes.

#### % of stories with file path references

- **What it measures:** Proportion of stories that reference specific files or components
- **Better values:** Higher is better for implementation guidance
- **Indicates:** Whether stories provide sufficient technical context
- **Related metrics:** None
- **Recommended Action:** If low, add technical context or file references to stories.

#### Number of ambiguous words ("appropriate", "properly", "correctly")

- **What it measures:** Count of vague qualifiers in the PRD
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Risk of misinterpretation during implementation
- **Related metrics:** % of acceptance criteria with verifiable language
- **Recommended Action:** Replace each ambiguous word with specific, measurable criteria.

#### Ratio of technical terms to explanations

- **What it measures:** Whether technical jargon is explained for clarity
- **Better values:** Balanced; technical terms should have definitions or context
- **Indicates:** PRD accessibility for junior developers or new team members
- **Related metrics:** None
- **Recommended Action:** Add glossary or inline explanations for domain-specific terms.

#### Outcome-based (post-implementation)

#### % of stories completed without modification

- **What it measures:** Stories implemented exactly as specified without PRD changes
- **Better values:** Higher is better; aim for >80%
- **Indicates:** PRD accuracy and completeness
- **Related metrics:** Stories requiring scope changes mid-implementation
- **Recommended Action:** If low, analyze why modifications were needed and improve PRD process.

#### Number of clarification questions asked during implementation

- **What it measures:** Questions raised by implementer about PRD content
- **Better values:** Lower is better; zero is ideal
- **Indicates:** PRD clarity and completeness
- **Related metrics:** Number of ambiguous words
- **Recommended Action:** If high, review common question themes and address in PRD template.

#### Stories requiring scope changes mid-implementation

- **What it measures:** Count of stories where scope expanded or contracted during work
- **Better values:** Zero is ideal; lower is better
- **Indicates:** PRD scope definition quality
- **Related metrics:** Non-goals section length
- **Recommended Action:** If high, improve upfront scope definition and edge case identification.

#### PRD revision count before implementation started

- **What it measures:** Number of PRD edits after initial creation but before coding begins
- **Better values:** Low (1-2 minor revisions acceptable)
- **Indicates:** Initial PRD quality
- **Related metrics:** Number of user feedback cycles
- **Recommended Action:** If high, improve clarifying questions phase or user input gathering.

### Efficiency of PRD Generation

#### Time Metrics

#### Wall-clock time from prompt to PRD file creation

- **What it measures:** Total elapsed time to produce the PRD
- **Better values:** Lower is better, relative to feature complexity
- **Indicates:** Speed of requirements capture process
- **Related metrics:** Number of Amp iterations to generate PRD
- **Recommended Action:** If consistently high, streamline clarifying questions or provide more context upfront.

#### Number of Amp iterations to generate PRD

- **What it measures:** Agent invocations needed to complete PRD
- **Better values:** 1-2 iterations ideal; lower is better
- **Indicates:** Efficiency of single-pass generation
- **Related metrics:** Wall-clock time from prompt to PRD file creation
- **Recommended Action:** If high, improve prompt engineering or provide better templates.

#### Number of clarifying question rounds

- **What it measures:** Back-and-forth cycles with user for clarification
- **Better values:** 1-2 rounds ideal
- **Indicates:** Balance between thoroughness and efficiency
- **Related metrics:** Number of user feedback cycles
- **Recommended Action:** If zero, may be making assumptions. If >3, questions may be unfocused.

#### Token/Resource Usage

#### Total tokens consumed during PRD generation

- **What it measures:** LLM tokens used for the PRD phase
- **Better values:** Lower is better for cost efficiency
- **Indicates:** Resource efficiency of PRD generation
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If high, reduce verbose prompts or unnecessary research.

#### Number of tool calls made

- **What it measures:** Count of tools invoked (Read, Grep, web search, etc.)
- **Better values:** Proportional to PRD complexity; avoid excessive exploration
- **Indicates:** Research efficiency
- **Related metrics:** Number of file reads during research
- **Recommended Action:** If very high, may be exploring aimlessly. Improve focus.

#### Number of web searches performed

- **What it measures:** External searches during PRD creation
- **Better values:** Low unless external research genuinely needed
- **Indicates:** Whether existing context is sufficient
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If high for internal projects, improve internal documentation.

#### Number of file reads during research

- **What it measures:** Codebase files examined for context
- **Better values:** Proportional to scope; focused reading is better
- **Indicates:** Codebase familiarity and search efficiency
- **Related metrics:** Number of tool calls made
- **Recommended Action:** If very high, improve codebase documentation or AGENTS.md context.

#### Iteration Metrics

#### PRD revision count

- **What it measures:** Total edits to PRD file across all phases
- **Better values:** Lower is better; 1-3 minor revisions acceptable
- **Indicates:** Initial PRD quality and stability
- **Related metrics:** PRD revision count before implementation started
- **Recommended Action:** If high, invest more in upfront requirement gathering.

#### Number of user feedback cycles

- **What it measures:** Round-trips requiring user input
- **Better values:** 1-2 cycles ideal
- **Indicates:** User involvement efficiency
- **Related metrics:** Number of clarifying question rounds
- **Recommended Action:** If zero, validate assumptions are correct. If high, batch questions better.

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

#### Story size variance (consistency)

- **What it measures:** Standard deviation of LOC across stories
- **Better values:** Lower variance indicates consistent sizing
- **Indicates:** Predictability of story effort
- **Related metrics:** Average story size
- **Recommended Action:** If high, review outlier stories and standardize breakdown criteria.

#### % of stories completable in single iteration

- **What it measures:** Proportion of stories finished in one agent invocation
- **Better values:** Higher is better; aim for >80%
- **Indicates:** Story sizing appropriateness for context window
- **Related metrics:** Average story size, Iterations per story
- **Recommended Action:** If low, reduce story scope or improve context handoff.

#### Dependency count between stories

- **What it measures:** Average number of prerequisites per story
- **Better values:** Lower is better; 0-2 dependencies typical
- **Indicates:** Parallelization potential and sequencing complexity
- **Related metrics:** Circular dependency detection
- **Recommended Action:** If high, restructure to reduce coupling or reorder for independence.

#### Circular dependency detection

- **What it measures:** Presence of circular dependency chains
- **Better values:** Zero is required
- **Indicates:** Planning logic errors
- **Related metrics:** Dependency count between stories
- **Recommended Action:** If detected, immediately restructure affected stories.

#### Ordering Quality

#### Stories completed in original order vs reordered

- **What it measures:** % of stories completed in the sequence originally planned
- **Better values:** Higher indicates good initial ordering
- **Indicates:** Planning accuracy for dependencies and priorities
- **Related metrics:** Blocked stories due to missing dependencies
- **Recommended Action:** If frequently reordering, improve dependency analysis during planning.

#### Blocked stories due to missing dependencies

- **What it measures:** Count of stories that couldn't proceed due to unmet prerequisites
- **Better values:** Zero is ideal
- **Indicates:** Dependency identification quality
- **Related metrics:** Stories completed in original order vs reordered
- **Recommended Action:** If occurring, audit dependency specification process.

#### Prerequisite satisfaction rate

- **What it measures:** % of declared dependencies completed before dependent stories start
- **Better values:** 100% is ideal
- **Indicates:** Ordering effectiveness
- **Related metrics:** Blocked stories due to missing dependencies
- **Recommended Action:** If <100%, enforce ordering in prd.json or improve dependency tracking.

#### Outcome-based

#### % of stories marked done without rework

- **What it measures:** Stories completed and never reopened
- **Better values:** Higher is better; aim for >90%
- **Indicates:** Story definition completeness
- **Related metrics:** Stories reopened after marked done
- **Recommended Action:** If low, improve acceptance criteria specificity.

#### Stories split mid-implementation

- **What it measures:** Count of stories divided into smaller stories during work
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Initial breakdown was too coarse
- **Related metrics:** Average story size
- **Recommended Action:** If frequent, adjust sizing guidelines during planning.

#### Stories merged mid-implementation

- **What it measures:** Count of stories combined during work
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Initial breakdown was too fine-grained
- **Related metrics:** Average story size
- **Recommended Action:** If frequent, review minimum story size thresholds.

#### Acceptance criteria added post-breakdown

- **What it measures:** New criteria added after planning phase
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Requirements discovered during implementation
- **Related metrics:** % of stories completed without modification
- **Recommended Action:** If frequent, improve upfront criteria elicitation.

### Efficiency of PRD Breakdown into Features

#### Time Metrics

#### Time from PRD creation to prd.json generation

- **What it measures:** Elapsed time for the planning phase
- **Better values:** Lower is better; should be quick relative to implementation
- **Indicates:** Planning phase efficiency
- **Related metrics:** Iterations spent on breakdown vs implementation
- **Recommended Action:** If high, streamline planning process or automate prd.json generation.

#### Iterations spent on breakdown vs implementation

- **What it measures:** Ratio of planning iterations to building iterations
- **Better values:** Low ratio; planning should be small fraction of total
- **Indicates:** Whether planning is proportionate to implementation
- **Related metrics:** Time from PRD creation to prd.json generation
- **Recommended Action:** If ratio >0.2, planning may be over-engineered.

#### Volume Metrics

#### Stories per PRD

- **What it measures:** Total story count per PRD
- **Better values:** Proportional to feature scope; typically 5-15 for focused features
- **Indicates:** Breakdown granularity
- **Related metrics:** Number of user stories generated
- **Recommended Action:** If very high (>20), consider splitting into multiple PRDs.

#### Acceptance criteria per story

- **What it measures:** Average criteria count (same as in PRD section but measured post-planning)
- **Better values:** 3-7 per story
- **Indicates:** Verification specificity maintained through planning
- **Related metrics:** Total acceptance criteria count
- **Recommended Action:** If changed from PRD phase, investigate why criteria were added/removed.

#### Total acceptance criteria count

- **What it measures:** Sum of all criteria across all stories
- **Better values:** Proportional to scope; provides verification coverage
- **Indicates:** Overall testability of the implementation plan
- **Related metrics:** Acceptance criteria per story
- **Recommended Action:** If very low relative to story count, criteria may be too vague.

#### Ratio of setup stories to feature stories

- **What it measures:** Infrastructure/scaffolding stories vs user-facing feature stories
- **Better values:** Low ratio; setup should be minimal
- **Indicates:** Whether planning includes unnecessary boilerplate
- **Related metrics:** Stories per PRD
- **Recommended Action:** If high, look for reusable infrastructure or combine setup steps.

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

#### % of stories completed on first attempt (no reopening)

- **What it measures:** Stories done right the first time
- **Better values:** Higher is better; aim for >85%
- **Indicates:** Implementation quality and requirement understanding
- **Related metrics:** Stories reopened after marked done
- **Recommended Action:** If low, review common failure reasons and address in process.

#### Stories passing all acceptance criteria vs partially complete

- **What it measures:** Binary pass/fail per story vs partial completion
- **Better values:** All stories should fully pass, not partially
- **Indicates:** Whether stories are being rushed or improperly closed
- **Related metrics:** % of acceptance criteria marked complete per story
- **Recommended Action:** If partial completions exist, do not allow story closure until 100%.

#### Code Quality

**Test coverage delta per story**
- **What it measures:** Change in code coverage percentage after story completion
- **Better values:** Positive delta; coverage should increase or maintain
- **Indicates:** Whether new code is being tested
- **Related metrics:** Test runs per story
- **Recommended Action:** If negative, require tests as part of acceptance criteria.

**Lint/typecheck errors introduced vs resolved**
- **What it measures:** Net change in static analysis errors
- **Better values:** Net zero or negative (resolving more than introducing)
- **Indicates:** Code quality maintenance
- **Related metrics:** Typecheck failures before success
- **Recommended Action:** If net positive, add lint/typecheck pass as mandatory acceptance criterion.

**Code review feedback count (if applicable)**
- **What it measures:** Number of review comments on story-related code
- **Better values:** Lower is better
- **Indicates:** Code quality before review
- **Related metrics:** None
- **Recommended Action:** If high, analyze common feedback themes and add to AGENTS.md patterns.

**Technical debt markers added (TODOs, FIXMEs)**
- **What it measures:** Count of debt markers introduced per story
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Whether implementation is taking shortcuts
- **Related metrics:** None
- **Recommended Action:** If high, either resolve immediately or track in separate backlog.

#### Correctness

**Stories requiring hotfixes post-completion**
- **What it measures:** Stories needing fixes after being marked done
- **Better values:** Zero is ideal
- **Indicates:** Verification thoroughness
- **Related metrics:** % of stories completed on first attempt
- **Recommended Action:** If occurring, improve testing requirements in acceptance criteria.

**Bugs discovered in completed stories**
- **What it measures:** Defects found in "done" work
- **Better values:** Zero is ideal
- **Indicates:** Testing effectiveness and implementation quality
- **Related metrics:** Stories requiring hotfixes post-completion
- **Recommended Action:** Analyze bug patterns and add preventive checks.

**Regression test failures after story completion**
- **What it measures:** Existing tests broken by new code
- **Better values:** Zero is ideal
- **Indicates:** Whether changes are properly scoped and tested
- **Related metrics:** Test runs per story
- **Recommended Action:** If occurring, run full test suite before marking stories complete.

**Manual verification failures**
- **What it measures:** Stories that fail human/browser verification
- **Better values:** Zero is ideal
- **Indicates:** Gap between automated and real-world testing
- **Related metrics:** Stories requiring hotfixes post-completion
- **Recommended Action:** Add browser verification to UI story acceptance criteria.

### Efficiency of Feature Implementation

#### Time Metrics

**Wall-clock time per story**
- **What it measures:** Elapsed time from story start to completion
- **Better values:** Lower is better; proportional to story size
- **Indicates:** Implementation velocity
- **Related metrics:** Iterations per story
- **Recommended Action:** If high relative to story size, investigate blockers or complexity.

**Iterations per story**
- **What it measures:** Agent invocations needed per story
- **Better values:** 1 is ideal; lower is better
- **Indicates:** Whether stories fit in context window
- **Related metrics:** % of stories completable in single iteration
- **Recommended Action:** If >1 consistently, reduce story scope.

**Time per acceptance criterion**
- **What it measures:** Average time to satisfy each criterion
- **Better values:** Lower is better; consistent across criteria
- **Indicates:** Criterion complexity uniformity
- **Related metrics:** Wall-clock time per story
- **Recommended Action:** If highly variable, review outlier criteria for over-specification.

#### Token/Resource Usage

**Tokens consumed per story**
- **What it measures:** LLM tokens used per story
- **Better values:** Lower is better for cost; proportional to complexity
- **Indicates:** Resource efficiency
- **Related metrics:** Tool calls per story
- **Recommended Action:** If high, reduce exploration or improve context.

**Tool calls per story**
- **What it measures:** Total tool invocations per story
- **Better values:** Proportional to story complexity; avoid excessive exploration
- **Indicates:** Implementation focus vs exploration
- **Related metrics:** File edits per story
- **Recommended Action:** If very high, agent may be struggling; review story clarity.

**File edits per story**
- **What it measures:** Number of file modifications per story
- **Better values:** Proportional to story scope; focused changes preferred
- **Indicates:** Change localization
- **Related metrics:** Files touched per story
- **Recommended Action:** If high, story may be too broad or code may need refactoring.

**Commands executed per story**
- **What it measures:** Shell commands run per story
- **Better values:** Proportional to needs; minimal for simple stories
- **Indicates:** Build/test cycle frequency
- **Related metrics:** Build/typecheck runs per story
- **Recommended Action:** If high, may indicate trial-and-error; improve upfront planning.

#### Code Metrics

**Lines of code added/modified/deleted per story**
- **What it measures:** LOC delta categorized by change type
- **Better values:** Balanced; deletions can indicate refactoring (positive)
- **Indicates:** Story impact scope
- **Related metrics:** Average story size
- **Recommended Action:** Use to calibrate story sizing guidelines.

**Files touched per story**
- **What it measures:** Number of unique files modified
- **Better values:** Lower indicates focused changes; 1-5 typical
- **Indicates:** Change dispersion
- **Related metrics:** File edits per story
- **Recommended Action:** If high, may indicate poor code organization or story scope.

**Commits per story**
- **What it measures:** Git commits made per story
- **Better values:** 1 is ideal (atomic commits)
- **Indicates:** Commit discipline
- **Related metrics:** None
- **Recommended Action:** If multiple commits per story, consider squashing or improving atomicity.

**Build/typecheck runs per story**
- **What it measures:** Verification cycles per story
- **Better values:** Lower is better; 1-2 runs ideal
- **Indicates:** Implementation confidence and accuracy
- **Related metrics:** Typecheck failures before success
- **Recommended Action:** If high, agent is iterating through errors; improve upfront correctness.

**Test runs per story**
- **What it measures:** Test suite executions per story
- **Better values:** At least 1; more may indicate test-driven approach
- **Indicates:** Testing discipline
- **Related metrics:** Test coverage delta per story
- **Recommended Action:** If zero, enforce testing in acceptance criteria.

#### Error Metrics

**Typecheck failures before success**
- **What it measures:** Type errors encountered before clean pass
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Type-safety awareness during implementation
- **Related metrics:** Build/typecheck runs per story
- **Recommended Action:** If high, add typing patterns to AGENTS.md.

**Test failures before success**
- **What it measures:** Test failures before all tests pass
- **Better values:** Some expected for TDD; excessive indicates issues
- **Indicates:** Test-driven vs fix-after-fail approach
- **Related metrics:** Test runs per story
- **Recommended Action:** If very high, review test understanding and story clarity.

**Build errors encountered**
- **What it measures:** Compilation/build failures during implementation
- **Better values:** Zero is ideal
- **Indicates:** Build system familiarity
- **Related metrics:** Typecheck failures before success
- **Recommended Action:** If recurring, document build patterns in AGENTS.md.

**Rollbacks/undos performed**
- **What it measures:** Reverts of changes during implementation
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Implementation confidence and planning quality
- **Related metrics:** Git resets performed
- **Recommended Action:** If high, improve upfront design or break into smaller steps.

**Git resets performed**
- **What it measures:** Hard resets during implementation
- **Better values:** Zero is ideal
- **Indicates:** Significant implementation failures requiring full restart
- **Related metrics:** Rollbacks/undos performed
- **Recommended Action:** If occurring, investigate root cause and add guardrails.

#### Rework Metrics

**Same file edited multiple times**
- **What it measures:** Files modified more than once in a story
- **Better values:** Lower is better; some rework normal
- **Indicates:** Implementation uncertainty or iterative refinement
- **Related metrics:** Same line edited multiple times
- **Recommended Action:** If high, improve upfront design or story clarity.

**Same line edited multiple times**
- **What it measures:** Lines changed multiple times in a story
- **Better values:** Zero is ideal
- **Indicates:** Trial-and-error coding
- **Related metrics:** Same file edited multiple times
- **Recommended Action:** If high, agent is guessing; improve context or examples.

**Stories reopened after marked done**
- **What it measures:** Stories moving from done back to in-progress
- **Better values:** Zero is ideal
- **Indicates:** Premature completion or missed requirements
- **Related metrics:** % of stories completed on first attempt
- **Recommended Action:** Enforce verification before marking done.

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

**% of iterations that make meaningful progress (at least 1 story advanced)**
- **What it measures:** Productive iterations vs wasted cycles
- **Better values:** 100% is ideal
- **Indicates:** Each iteration is contributing value
- **Related metrics:** Wasted iterations
- **Recommended Action:** If low, improve story selection or context handoff.

**Iterations ending in recoverable vs unrecoverable state**
- **What it measures:** Classification of iteration failures
- **Better values:** All failures should be recoverable; unrecoverable = zero
- **Indicates:** Resilience of the system
- **Related metrics:** Successful recovery from failed iterations
- **Recommended Action:** If unrecoverable states occur, add checkpointing or recovery logic.

**Clean exit rate (success vs max iterations vs error)**
- **What it measures:** Distribution of iteration end reasons
- **Better values:** High success rate; low max iterations and error rates
- **Indicates:** Overall completion health
- **Related metrics:** % of iterations that complete without error
- **Recommended Action:** If max iterations common, increase limit or improve efficiency.

#### Context Handoff

**Information loss between iterations (measured by repeated work)**
- **What it measures:** Work duplicated across iterations due to lost context
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Quality of context preservation mechanism
- **Related metrics:** Context preserved across iterations
- **Recommended Action:** If high, improve progress.txt detail or add explicit state tracking.

**Successful continuation after interruption**
- **What it measures:** % of iterations that successfully resume previous work
- **Better values:** 100% is ideal
- **Indicates:** Robustness of handoff mechanism
- **Related metrics:** Information loss between iterations
- **Recommended Action:** If low, standardize progress.txt format or add validation.

**Time to context reload per iteration**
- **What it measures:** Time spent re-establishing context at iteration start
- **Better values:** Lower is better; should be minimal
- **Indicates:** Efficiency of context retrieval
- **Related metrics:** None
- **Recommended Action:** If high, optimize context storage or reduce verbosity.

#### Failure Recovery

**Successful recovery from failed iterations**
- **What it measures:** % of failures that are successfully recovered in next iteration
- **Better values:** 100% is ideal
- **Indicates:** System resilience
- **Related metrics:** Iterations ending in recoverable vs unrecoverable state
- **Recommended Action:** If low, improve error logging and recovery procedures.

**Average iterations to recover from failure**
- **What it measures:** Iterations needed to get back on track after a failure
- **Better values:** 1 is ideal; lower is better
- **Indicates:** Recovery efficiency
- **Related metrics:** Successful recovery from failed iterations
- **Recommended Action:** If >1, improve failure diagnosis or add automated recovery steps.

**Repeated failures on same story**
- **What it measures:** Count of consecutive failures on a single story
- **Better values:** Zero is ideal; lower is better
- **Indicates:** Whether system is stuck or making progress
- **Related metrics:** Stories requiring human intervention
- **Recommended Action:** If >2, escalate to human or skip story temporarily.

#### Workflow Efficiency

**Wasted iterations (no progress made)**
- **What it measures:** Iterations that don't advance any story
- **Better values:** Zero is ideal
- **Indicates:** Iteration productivity
- **Related metrics:** % of iterations that make meaningful progress
- **Recommended Action:** If occurring, investigate why and improve story selection logic.

**Stories requiring human intervention**
- **What it measures:** Stories that couldn't be completed autonomously
- **Better values:** Zero is ideal; lower is better
- **Indicates:** System autonomy level
- **Related metrics:** Repeated failures on same story
- **Recommended Action:** If high, analyze common blockers and add capabilities or patterns.

**Average stories completed per iteration**
- **What it measures:** Mean story throughput per iteration
- **Better values:** Higher is better; 1+ is good
- **Indicates:** Overall system productivity
- **Related metrics:** % of stories completable in single iteration
- **Recommended Action:** If <1, stories may be too large or iterations too short.

**Iteration time variance**
- **What it measures:** Standard deviation of iteration durations
- **Better values:** Lower variance indicates predictability
- **Indicates:** Consistency of iteration performance
- **Related metrics:** None
- **Recommended Action:** If high, investigate outliers and standardize iteration scope.

#### Decision Quality

**Story selection accuracy (selected story was completable)**
- **What it measures:** % of selected stories that were successfully completed
- **Better values:** Higher is better; aim for >90%
- **Indicates:** Quality of story prioritization logic
- **Related metrics:** Blocked stories due to missing dependencies
- **Recommended Action:** If low, improve dependency checking before selection.

**Dependency resolution accuracy**
- **What it measures:** % of times dependencies were correctly identified and satisfied
- **Better values:** 100% is ideal
- **Indicates:** Dependency tracking effectiveness
- **Related metrics:** Prerequisite satisfaction rate
- **Recommended Action:** If <100%, improve dependency validation logic.

**Appropriate escalation rate**
- **What it measures:** % of escalations that were genuinely necessary
- **Better values:** High (escalations should be justified)
- **Indicates:** Whether system knows when it needs help
- **Related metrics:** Stories requiring human intervention
- **Recommended Action:** If low, improve escalation criteria. If zero, may be missing needed escalations.
