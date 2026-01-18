# Backlog of potential enhancements

## Phase 1: Single Agent Type Projects

To support multiple agent types working on different projects, we need to first create a system that can support a single agent type working on different projects. This will help us identify the commonalities and differences between agents and projects, and create a foundation for multi-agent type projects. The following enhancements are proposed for this phase -

1. **OS Configuration**: Adapt the system to work with a configurable OS (default value: Ubuntu 24.04 NobleOS)
2. **Master AGENTS.md file**: Adapt the system to have a single global AGENTS.md file.
3. **Learnings**:
   1. Include a learnings section on the anti-patterns you encounter in the system. This will help us identify common mistakes and avoid them in the future.
   2. Classify each learning based on its applicability, relevance and usefulness - specific directory level, project level, global level (to be reused in other projects). This will help us identify the scope of each learning and reuse it appropriately.
4. **Refactor: Separation of Concerns**: Define the purposes of prompt.md, AGENTS.md and progress.txt to be mutually exclusive and exhaustive based on industry best practices. Refactor the contents of prompt.md, AGENTS.md and progress.txt accordingly.
5. **Agent Provider Configuration**: Adapt the system to work with a configurable agent provider (default value: Antigravity AI).

## Phase 2: Multi Agent Type Projects

For multiple agents to work on the same project seamlessly over time, we need to create an agent agnostic version of all features an agent relies on while building a project. These features involve -

- Fetching and analyzing past sessions
- Intermediate artifacts created to support the project
- A universal way of mapping and storing the above (i.e. session chat history, thinking history, actions taken history and artifacts created)

Summarization and storage of the above will be required to manage context window constraints. Agents will need to use something like MCP tools to access the history.
