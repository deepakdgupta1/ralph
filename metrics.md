# Metrics for Ralph

## Requirements Identification Capability

### Effectiveness of PRD Generation

**Structure Quality**:

Number of user stories generated
Number of acceptance criteria per story
Avg words per acceptance criteria (specificity)
Number of functional requirements
Presence of all PRD sections (completeness score)
Non-goals section length (scope clarity)

**Actionability Indicators**:

% of acceptance criteria with verifiable language ("must", "shows", "returns")
% of stories with file path references
Number of ambiguous words ("appropriate", "properly", "correctly")
Ratio of technical terms to explanations

**Outcome-based (post-implementation)**:

% of stories completed without modification
Number of clarification questions asked during implementation
Stories requiring scope changes mid-implementation
PRD revision count before implementation started

### Efficiency of PRD Generation

**Time Metrics**:

Wall-clock time from prompt to PRD file creation
Number of Amp iterations to generate PRD
Number of clarifying question rounds

**Token/Resource Usage**:

Total tokens consumed during PRD generation
Number of tool calls made
Number of web searches performed
Number of file reads during research

**Iteration Metrics**:

PRD revision count
Number of user feedback cycles

## Planning Capability

### Effectiveness of PRD Breakdown into Features

**Granularity Quality**:

Average story size (lines of code changed per story)
Story size variance (consistency)
% of stories completable in single iteration
Dependency count between stories
Circular dependency detection

**Ordering Quality**:

Stories completed in original order vs reordered
Blocked stories due to missing dependencies
Prerequisite satisfaction rate

**Outcome-based**:

% of stories marked done without rework
Stories split mid-implementation
Stories merged mid-implementation
Acceptance criteria added post-breakdown

### Efficiency of PRD Breakdown into Features

**Time Metrics**:

Time from PRD creation to prd.json generation
Iterations spent on breakdown vs implementation

**Volume Metrics**:

Stories per PRD
Acceptance criteria per story
Total acceptance criteria count
Ratio of setup stories to feature stories

## Implementation Capability

### Efficiency of Feature Implementation

**Time Metrics**:

Wall-clock time per story
Iterations per story
Time per acceptance criterion

**Token/Resource Usage**:

Tokens consumed per story
Tool calls per story
File edits per story
Commands executed per story

**Code Metrics**:

Lines of code added/modified/deleted per story
Files touched per story
Commits per story
Build/typecheck runs per story
Test runs per story

**Error Metrics**:

Typecheck failures before success
Test failures before success
Build errors encountered
Rollbacks/undos performed
Git resets performed

**Rework Metrics**:

Same file edited multiple times
Same line edited multiple times
Stories reopened after marked done

## Learning Capability

**Learning Capture**:

AGENTS.md additions per iteration (diff size)
AGENTS.md sections modified
Number of anti-patterns documented
Number of patterns documented
Learning classification counts (directory/project/global)

**Learning Quality**:

AGENTS.md references in subsequent prompts
Repeated errors after learning documented
Same anti-pattern encountered twice
Pattern reuse frequency

**Learning Quality (proxy metrics)**:

Iteration performance improvement over time
Error rate reduction across iterations
Time-per-story reduction trend
Stories-per-iteration improvement trend

**Progress.txt Metrics**:

Updates per iteration
Blockers logged vs resolved
Context preserved across iterations
