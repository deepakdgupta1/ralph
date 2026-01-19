# Backlog of potential enhancements

## Phase 1: Single Agent Type Projects

To support multiple agent types working on different projects, we need to first create a system that can support a single agent type working on different projects. This will help us identify the commonalities and differences between agents and projects, and create a foundation for multi-agent type projects. The following enhancements are proposed for this phase -

1. **Analytics**: Build telemetry and observability capabilities that will make the autonomous agentic development process transparent. They should measure the following -
   1. Effectiveness of PRD generation
   2. Efficiency of PRD generation
   3. Effectiveness of PRD breakdown into features
   4. Efficiency of PRD breakdown into features
   5. Efficiency of feature implementation
   6. Effectiveness of the learning process

2. **OS Configuration**: Adapt the system to work with a configurable OS (default value: Ubuntu 24.04 NobleOS)
3. **Master AGENTS.md file**: Adapt the system to have a single global AGENTS.md file.
4. **Learnings**:
   1. Include a section on the anti-patterns you encounter in the system. This will help us identify common mistakes and avoid them in the future.
   2. Include a section on what did not work and why. This will help us identify the limitations of the system and improve it.
   3. Classify each learning based on its applicability, relevance and usefulness - specific directory level, project level, global level (to be reused in other projects). This will help us identify the scope of each learning and reuse it appropriately.
5. **Refactor: Separation of Concerns**: Define the purposes of prompt.md, AGENTS.md and progress.txt to be mutually exclusive and exhaustive based on industry best practices. Refactor the contents of prompt.md, AGENTS.md and progress.txt accordingly.
6. **Agent Provider Configuration**: Adapt the system to work with a configurable agent provider (default value: Antigravity AI).

## Phase 2: Multi Agent Type Projects

For multiple agents to work on the same project seamlessly over time, we need to create an agent agnostic version of all features an agent relies on while building a project. These features involve -

- Fetching and analyzing past sessions
- Intermediate artifacts created to support the project
- A universal way of mapping and storing the above (i.e. session chat history, thinking history, actions taken history and artifacts created)

Summarization and storage of the above will be required to manage context window constraints. Agents will need to use something like MCP tools to access the history.
