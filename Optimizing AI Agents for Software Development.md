# **Strategic Orchestration of Multi-Agent Systems: Cost-Performance Optimization and Architectural Patterns**

## **1\. The Economic and Architectural Imperative of Multi-Agent Systems**

The enterprise integration of Generative AI has transitioned from a phase of novel experimentation with single-prompt interactions to the engineering of complex, autonomous systems. For the Chief Technology Officer, this shift fundamentally alters the unit of analysis from the individual model inference to the aggregate performance of the entire cognitive supply chain. The deployment of Multi-Agent Systems (MAS) represents a paradigmatic evolution in how computational work is modeled, distributed, and executed. However, this evolution introduces a non-linear relationship between utility and cost, creating a landscape where unoptimized architectures can lead to exponential resource consumption without commensurate gains in output quality.

The central optimization challenge in 2026 is no longer binary—determining whether an AI can solve a problem—but rather economic: determining the minimum viable cost to achieve a requisite level of quality and reliability. The "Reasoning Cliff," a phenomenon where model performance degrades catastrophically as task complexity exceeds a certain threshold, necessitates a move away from monolithic architectures.1 In a monolithic setup, a single frontier-class model (e.g., GPT-4 or Claude Opus) is tasked with end-to-end execution. This approach suffers from acute cost inelasticity: high-complexity reasoning tasks and low-complexity data formatting tasks are processed by the same expensive inference engine, resulting in a misallocation of resources. Furthermore, massive context windows, while technically feasible, introduce "context pollution," where the retrieval accuracy of the model degrades as the volume of irrelevant information increases, leading to hallucinations and reduced reasoning efficacy.2

Multi-agent architectures address these systemic inefficiencies by decomposing monolithic workflows into discrete, tractable sub-tasks. This decomposition allows for the application of **Heterogeneous Compute**, where different models are assigned to different agents based on the specific cognitive requirements of their role. A "Planner" agent may utilize a reasoning-heavy frontier model, while a "Scraper" agent operates on a cost-effective Small Language Model (SLM) or even a quantized local model.2 This report provides an exhaustive evaluation of the frameworks, patterns, and algorithmic strategies required to orchestrate these systems effectively, ensuring that work distribution is optimized for both quality and fiscal sustainability.

### **1.1 The Shift from Monoliths to Modular Swarms**

The industry is moving from "God Models" to modular swarms. Early implementations of agentic AI often defaulted to a single, powerful Large Language Model (LLM) for every task, from writing emails to complex planning and code generation. While simple to implement, this monolithic approach quickly revealed significant drawbacks. Cloud fees ballooned as usage scaled because every interaction, no matter how trivial, incurred the cost associated with a large, expensive parameter set. Latency accumulated because every micro-task waited on a distant mega-model's queue. Moreover, one-size-fits-all limitations made fine-tuning difficult; adapting a massive LLM for a highly specific, narrow task was inefficient and often led to "catastrophic forgetting," where the model would lose general capabilities after specialized training.2

In contrast, modular multi-agent systems treat intelligence as a flexible resource that can be provisioned dynamically. By orchestrating specialized agents, companies achieve more adaptive and reliable solutions than one agent working alone. This shift matters because complex business workflows—such as customer support, sales, and research analysis—often involve sub-tasks that no single agent can handle optimally. For example, a "Sales Pipeline" workflow might involve lead qualification (pattern matching), email drafting (creative writing), and CRM updating (structured data entry). Using a single model for all three is economically inefficient. A MAS approach assigns the pattern matching to a logistic regression or lightweight LLM, the drafting to a mid-tier model, and the CRM entry to a deterministic script, reserving high-cost inference only for handling ambiguous or high-value client interactions.4

### **1.2 Defining the Optimization Function**

To rigorously optimize a multi-agent system, we must define the objective function. The goal is to maximize the **Task Success Rate (TSR)** and **Output Quality (Q)** while minimizing the **Total Cost of Ownership (TCO)** and **Latency (L)**, subject to constraints on reliability and safety.

The optimization function can be conceptualized as:

![][image1]  
Where:

* **Quality (Q):** Measured by benchmarks (e.g., HumanEval for code, GSM8K for math) or domain-specific KPIs (e.g., resolution rate in support).  
* **Cost (C):** The sum of all token costs across all agents, plus infrastructure overhead.  
* **Latency (L):** The end-to-end time to task completion.  
* ![][image2]**:** A weighting factor representing the business sensitivity to delay.

Research indicates that different architectural patterns yield vastly different profiles within this equation. For instance, **Voting and Consensus** patterns, where multiple agents debate a problem before agreeing on a solution, can significantly increase Quality (Q) by mitigating hallucinations, but they do so by increasing Cost (C) linearly or polynomially with the number of agents.5 Conversely, **LLM Cascading** (FrugalGPT) focuses on minimizing Cost (C) by attempting tasks with cheaper models first, effectively maintaining Quality (Q) while reducing the average cost per query by up to 98%.6 The CTO's role is to select the architecture that aligns with the specific ![][image2] of the use case.

## **2\. Comprehensive Evaluation of Multi-Agent Frameworks**

The selection of an orchestration framework is a foundational strategic decision. The framework dictates the "physics" of the agent environment—how agents communicate, how memory is shared, how state is preserved, and how conflicts are resolved. The market has consolidated around four primary frameworks: **LangGraph**, **CrewAI**, **AutoGen**, and **MetaGPT**. Each represents a distinct philosophy regarding the trade-off between control (predictability/cost) and autonomy (flexibility/innovation).

### **2.1 LangGraph: The Control-Centric Architecture**

**LangGraph**, an extension of the LangChain ecosystem, adopts a graph-theoretic approach to agent orchestration. It models workflows as **StateGraphs**, where nodes represent reasoning steps (agents or tools) and edges represent the flow of state.4

#### **Architectural Philosophy: Explicit Control**

Unlike frameworks that rely on an LLM to "hallucinate" the next step in a process, LangGraph requires the developer to define the transition probabilities and state schema explicitly. It supports both **Directed Acyclic Graphs (DAGs)** for deterministic workflows and cyclic graphs for iterative processes (e.g., "Plan \-\> Execute \-\> Observe \-\> Refine"). This explicit control is critical for enterprise environments where non-deterministic looping behaviors can lead to runaway costs.8

#### **Cost Optimization Capabilities**

* **Fine-Grained State Management:** Developers define a strict schema for the State object. This allows for the pruning of context between nodes. Instead of passing the entire conversation history to every agent, LangGraph allows the orchestrator to pass only the relevant data fields (e.g., extracted\_data, summary), preventing the context window—and thus the cost—from bloating as the workflow progresses.9  
* **Conditional Edges:** LangGraph enables deterministic routing logic via conditional\_entry\_points or add\_conditional\_edges. A router node can use a simple Python function (or a lightweight classifier) to decide the next step (e.g., if sentiment \== negative \-\> route to escalation\_agent). This logic executes at zero inference cost, unlike purely agentic frameworks that require an LLM call to decide "who speaks next".8  
* **Human-in-the-Loop (HITL):** LangGraph treats human intervention as a first-class citizen via "checkpoints." The graph can pause execution at a specific node, wait for human approval or input, and then resume with the state updated. This capability is essential for "Deep Research" or financial agents where an expensive downstream action (like executing a trade or scraping a massive dataset) requires validation before tokens are committed.8

#### **Enterprise Applicability**

LangGraph is the preferred framework for production-grade, mission-critical applications where auditability and reliability are paramount. It powers complex "Deep Research" agents where recursive loops must be tightly controlled to prevent infinite recursion. The introduction of **LangGraph Studio** provides a specialized IDE to visually design, debug, and trace these agent graphs, lowering the barrier to entry for complex logic.4

### **2.2 CrewAI: The Role-Based Organizational Metaphor**

**CrewAI** abstracts the complexity of loops and state management into a "Role-Playing" framework. It mimics a human organization, defining agents by their **Role**, **Goal**, and **Backstory**.11

#### **Architectural Philosophy: Collaborative Autonomy**

CrewAI groups agents into a "Crew" that processes tasks either sequentially or hierarchically. In the **Hierarchical** process, a "Manager" agent (typically a stronger LLM) is automatically instantiated to assign tasks, review outcomes, and coordinate the team. This mimics a corporate structure but introduces a "management tax"—tokens spent on delegation instructions and managerial oversight rather than direct task execution.11

#### **Cost Optimization Capabilities**

* **Delegation Control:** The allow\_delegation boolean flag is a critical cost control lever. When set to True, agents can autonomous spawn sub-tasks and delegate them to other agents. While this enables dynamic problem-solving, it can lead to "lazy agent" syndrome, where agents endlessly pass the buck. Disabling this flag (allow\_delegation=False) forces agents to execute tasks themselves, tightening the control loop and reducing token usage.13  
* **Heterogeneous Model Configuration:** CrewAI allows for granular model assignment. A "Researcher" agent can be configured to run on a cost-effective model like gpt-3.5-turbo or llama-3-8b, while the "Senior Analyst" agent is assigned gpt-4-turbo. This allows the CTO to align model costs with the value of the specific sub-task.14  
* **Agent Operations Platform (AOP):** For scaling, CrewAI provides an AOP that offers enterprise-grade governance, Role-Based Access Control (RBAC), and visual observability. This platform is used by a significant portion of the Fortune 500 to move agents from prototype to production, providing dashboards to monitor agent performance and cost.4

### **2.3 AutoGen: The Conversational Swarm**

Developed by Microsoft Research, **AutoGen** treats multi-agent systems as "conversations." Agents (including a UserProxyAgent representing the human) interact via a chat interface to solve problems iteratively.7

#### **Architectural Philosophy: Conversational Synthesis**

In AutoGen, computation is a side effect of the dialogue between agents. The framework supports diverse communication patterns, including two-agent chat, group chat, and hierarchical chat. The GroupChatManager acts as a dynamic router, selecting the next speaker based on the conversation history.16

#### **Cost Optimization Capabilities**

* **Transform Messages:** AutoGen introduces a middleware capability called TransformMessages. This allows the system to modify incoming messages before they are processed by the LLM agent. Transformations can include truncating old history, summarizing long contexts, or filtering out irrelevant information. This is a direct mechanism for managing the context window and controlling the cost curve of long-running conversations.17  
* **Human-in-the-Loop Integration:** AutoGen allows for seamless human participation. The UserProxyAgent can intervene at any point, providing feedback or steering the conversation. This "early steering" prevents agents from going down "rabbit holes" of incorrect reasoning, saving the tokens that would have been wasted on a failed solution path.16  
* **Local Execution & Code Interpretation:** AutoGen excels at code generation and execution. The UserProxyAgent can execute code locally (e.g., in a Docker container) and report the output back to the agent. This allows the system to use the "computer" as a tool, offloading computational work (like math or data processing) from the LLM to the CPU, which is infinitely cheaper and more accurate.9

#### **Limitations and Risks**

The primary risk with AutoGen is its default "chatty" nature. Without strict termination conditions (e.g., max\_consecutive\_auto\_reply), agents can engage in circular compliments or redundant affirmations, burning tokens without advancing the state. The GroupChat manager also requires reading the entire history to select the next speaker, which can become expensive as the conversation grows.18

### **2.4 MetaGPT: The Standard Operating Procedure (SOP) Engine**

**MetaGPT** differentiates itself by encoding **Standard Operating Procedures (SOPs)** directly into the agent prompt structure. It treats the agent team as a software company (Product Manager, Architect, Engineer, QA) and enforces a waterfall-like process.7

#### **Architectural Philosophy: Code \= SOP(Team)**

MetaGPT forces agents to produce structured outputs (PRDs, API Designs, Code, Tests) rather than free-form chat. It utilizes a **Shared Message Pool** based on a publish-subscribe mechanism. Agents do not broadcast to everyone; they "publish" artifacts to the pool, and other agents "subscribe" based on their role requirements. This significantly reduces redundancy and context pollution compared to the "reply-all" dynamics of a standard chat.20

#### **Cost Optimization Capabilities**

* **Structured Communication:** By restricting communication to standardized documents, MetaGPT eliminates the "fluff" of conversational headers and pleasantries. This focus on artifacts ensures that every token generated is contributing directly to the final deliverable.  
* **Global Memory:** The shared memory pool allows agents to access only the information they need. An engineer agent might only need the API design, not the market research report used by the Product Manager. This selective context loading optimizes token usage per agent.20

#### **Benchmarking Insights**

Benchmarks comparing MetaGPT to other frameworks like ChatDev indicate that it produces more coherent software repositories. While ChatDev can generate a basic game for approximately **$0.30** in API costs, it often suffers from "hallucinated dependencies" or logic errors. MetaGPT's rigid role definitions and SOPs tend to result in higher initial costs but a higher rate of compilable, functional code, reducing the "cost of rework".22

### **2.5 Comparative Decision Matrix**

| Feature | LangGraph | CrewAI | AutoGen | MetaGPT |
| :---- | :---- | :---- | :---- | :---- |
| **Primary Philosophy** | Graph Control (DAGs) | Role-Based Teams | Conversational Swarm | SOPs & Artifacts |
| **Control Level** | Very High (Explicit) | High (Delegation flags) | Low/Medium (Chat) | High (Process) |
| **Cost Efficiency** | High (Deterministic routing) | Medium (Management tax) | Variable (Chat overhead) | High (Structured) |
| **Best Use Case** | Complex Enterprise Workflow | Departmental Automation | R\&D / Code Gen | Software Engineering |
| **Scalability** | High (Stateless nodes) | Medium (Hierarchical) | Medium (Chat history) | High (Shared Pool) |

## **3\. Algorithmic Work Distribution and Dynamic Routing**

The "Router" or "Orchestrator" pattern is the single most critical component for cost optimization in a multi-agent system. A static routing map (e.g., "Always send SQL queries to Agent A") is insufficient for real-world complexity, where queries often contain ambiguity or multi-domain requirements. To maximize efficiency, we must implement **Complexity-Aware Dynamic Routing**.

### **3.1 The "Reasoning Cliff" and Ternary Routing Logic**

Recent research identifies a "Reasoning Cliff" where standard LLMs fail catastrophically as query complexity exceeds a specific threshold. A binary router (Weak Model vs. Strong Model) often fails because it misses the middle ground: tasks that do not require a genius-level model, but do require a **tool-augmented** model.1

A **Ternary Router** logic is superior for optimizing work distribution:

1. **Lane 1: Direct Answer (Low Cost):** Route to an SLM (e.g., Llama-3-8B, Haiku). Use for greetings, simple facts, and classification tasks.  
2. **Lane 2: Tool-Augmented (Medium Cost):** Route to an SLM equipped with specialized tools (Calculator, Python REPL, Vector DB). Use for math, precise data lookups, and deterministic processing. The model essentially acts as a natural language interface for a deterministic engine.  
3. **Lane 3: Reasoning Engine (High Cost):** Route to a Frontier Model (e.g., GPT-4o, Claude 3.5). Use for ambiguity resolution, creative synthesis, complex planning, and nuanced decision-making.

This ternary approach ensures that expensive "reasoning tokens" are preserved strictly for tasks that require them, while "computation tokens" are offloaded to cheaper models or CPU-based tools.1

### **3.2 Semantic Routing: Zero-Shot and Embedding-Based**

Traditional intent classification relies on LLMs to categorize queries, which itself incurs a cost and latency penalty. **Semantic Routing** utilizes vector embeddings to make routing decisions in milliseconds at near-zero cost.25

#### **Mechanism of Action**

1. **Canonical Utterances:** Define a set of representative queries for each agent's capability (e.g., "Reset my password" for the IT Support Agent, "What is the ROI?" for the Finance Agent).  
2. **Vector Embedding:** Embed these canonical utterances into a vector space using a lightweight embedding model (e.g., text-embedding-3-small or a local BERT model).  
3. **Cosine Similarity:** When a user query arrives, embed it and calculate the **Cosine Similarity** against the canonical vectors.  
4. **Thresholding:** If the similarity score exceeds a defined threshold (e.g., 0.82), route the query to the corresponding agent. If no match is found, route to a generalist or fallback handler.27

#### **Dynamic Thresholding**

Static thresholds often fail because different domains have different semantic densities. A **Dynamic Thresholding** system calibrates the sensitivity per route. For instance, a "Politics" route might require a very high threshold (0.90) to avoid false positives and potential PR risks, while a "Chitchat" route can operate with a looser threshold (0.40). Libraries like semantic-router allow for the optimization of these thresholds using training data to maximize routing accuracy.27

### **3.3 The FrugalGPT Framework: LLM Cascading**

**FrugalGPT** proposes a sequential "Cascade" architecture rather than a single selection. This is a defensive cost strategy designed to minimize the use of expensive models.6

#### **The Cascade Algorithm**

1. **Step 1 (Attempt):** Send the query to the cheapest available model (e.g., GPT-3.5 or a quantized local model).  
2. **Step 2 (Scoring):** Evaluate the response using a lightweight "Scoring Function" or a specialized "Judge" model (typically a smaller, fine-tuned verifier). The scoring function assesses factors like completeness, formatting adherence, and confidence.  
3. **Step 3 (Decision):** If the score exceeds the quality acceptance threshold, return the result to the user.  
4. **Step 4 (Escalation):** If the score is low, pass the *original query* and the *failed attempt* (as negative context) to the next model in the hierarchy (e.g., GPT-4).

#### **Performance Benchmarks**

Research demonstrates that this cascading approach can match the performance of the best individual LLM (e.g., GPT-4) with up to **98% cost reduction** in high-volume scenarios. By filtering out the "easy" queries at the bottom of the cascade, the system ensures that the high-cost models are only engaged when absolutely necessary.6

### **3.4 Predictive Complexity Estimation (RouteLLM)**

For scenarios where the latency of a cascade (sequential attempts) is unacceptable, **Predictive Complexity Estimation** is used. This involves a lightweight classifier trained to predict the "difficulty" of a prompt *before* it is sent to any model.31

#### **Zero-Shot Complexity Prompting**

Instead of training a custom classifier, a prompt template can be used with a cheap model to self-assess complexity.

**Prompt Template:** "Analyze the following user query. Rate its complexity on a scale of 1-5 based on: 1\) Need for external knowledge, 2\) Multi-step reasoning requirements, 3\) Ambiguity. Return ONLY the integer.".32

Routing logic is then applied based on the score:

* **Score 1-2:** Route to SLM.  
* **Score 3:** Route to RAG-equipped Mid-tier model.  
* **Score 4-5:** Route to Reasoning Model (o1, R1).

#### **RouteLLM and Bayesian Classification**

More advanced implementations, such as **RouteLLM**, utilize Bayesian classifiers or Matrix Factorization trained on human preference data (e.g., Chatbot Arena). These routers learn to predict the probability that a stronger model is *required* to satisfy the user, rather than just predicting abstract complexity. This approach has been shown to achieve a 40%+ cost reduction while maintaining a win-rate comparable to GPT-4.1

## **4\. Design Patterns for Cost-Quality Optimization**

Once a task is routed to the appropriate agent or crew, the internal orchestration pattern dictates the efficiency of execution.

### **4.1 The Reflection and Self-Correction Pattern**

Rather than defaulting to a more expensive model to ensure quality, the **Reflection** pattern asks the *same* model to critique its own work.

#### **Mechanism**

1. **Generate:** The agent generates a draft response.  
2. **Reflect:** The agent is prompted with instructions to "Review the above for logical inconsistencies, missing data, or style violations."  
3. **Refine:** The agent generates a final version based on its own critique.

#### **ROI Analysis**

"Reflexion" techniques have been shown to improve pass rates on coding benchmarks (HumanEval) from 80% to 91%, often outperforming a single-shot pass from a model that is 10x more expensive.34 While this pattern effectively doubles the token count for that specific interaction, it avoids the massive cost of a more advanced model or the downstream operational cost of correcting errors manually. However, this pattern should not be used for purely factual queries—an LLM either knows the fact or it doesn't; reflection will not help it "remember" a fact it doesn't know.35

### **4.2 Multi-Agent Debate and Consensus**

For high-stakes tasks where accuracy is non-negotiable (e.g., medical diagnosis, legal contract review), the **Debate** pattern is utilized. Multiple agents with different personas (e.g., "Skeptic" vs. "Optimist" or "Compliance Officer" vs. "Strategist") debate a solution.

#### **The Cost-Quality Trade-off**

Research indicates that multi-agent debate and consensus mechanisms significantly improve accuracy on reasoning benchmarks (GSM8K, MATH) but introduce a linear or polynomial increase in token usage.37

* **Majority Voting:** Spawning 3-5 agents to solve the same problem and taking the majority answer can eliminate random hallucinations.  
* **Optimization:** To control costs, use a "Judge" agent to monitor the debate. If a consensus is reached early, the Judge terminates the debate, preventing unnecessary turns. Additionally, capping the number of debate rounds is essential to prevent infinite circular arguments.5

### **4.3 The Map-Reduce and Fan-Out Pattern**

For large-scale tasks (e.g., "Analyze these 50 financial reports"), a sequential loop is cost-prohibitive and slow. The **Map-Reduce** pattern spawns parallel "Worker" agents (using cheaper models) to process individual documents, then an "Aggregator" agent (using a smart model) synthesizes the results.40

* **Cost Benefit:** Parallel workers can be strictly limited to small context windows (just one document). This avoids the quadratic cost scaling of "long context" processing.  
* **Latency Benefit:** Processing time is determined by the slowest single worker, not the sum of all.  
* **Anti-Pattern Warning:** Avoid "All-to-All" communication in swarms. Latency scales quadratically with the number of agents if they are all allowed to talk to each other. Use a "Hub-and-Spoke" topology where agents only talk to the Orchestrator to keep communication overhead manageable.41

## **5\. Operational Excellence: Observability and Infrastructure**

To deploy these systems effectively, a robust operational stack—often termed "AgentOps"—is required to provide visibility into the "black box" of agent reasoning.

### **5.1 Observability and Traceability**

Standard LLM logs are insufficient for agentic workflows because they obscure the "chain" of thought and the interaction between agents. Tools like **AgentOps**, **LangSmith**, and **Datadog LLM Observability** are mandatory for production deployments.42

* **Session Replay:** These tools allow developers to "replay" an agent's session, showing the exact sequence of thoughts, tool calls, and state transitions. This is the only reliable way to debug infinite loops or circular logic.  
* **Cost Tracking Granularity:** Observability tools must be configured to track cost *per user*, *per session*, and *per feature*. This allows the CTO to calculate the unit economics of the system (e.g., "The 'Report Generation' feature costs $1.50 per run. Is that profitable?").  
* **Tagging:** Heavily tag agent runs with metadata (e.g., agent\_id, workflow\_version, model\_id). This allows for the identification of specific agents or prompts that are "budget vampires," consuming disproportionate resources.44

### **5.2 Context Window Management Strategies**

The largest hidden cost in multi-agent systems is **Context Stuffing**. In a conversation loop, the history grows linearly, but the cost grows based on the accumulation of tokens.

* **Summarization Middleware:** Implement a "TransformMessage" capability (available in AutoGen) that summarizes the conversation history before passing it to the next agent. Instead of passing 50 raw messages, pass a 1-paragraph summary of the current state. This keeps the context window small and focused.17  
* **Ephemeral State:** In LangGraph, define "state" strictly. Only persist the specific variables needed for the next step (e.g., extracted\_data), and discard the conversational fluff ("Hello, I found this...").8

### **5.3 Caching Strategies**

Implement multi-layer caching to prevent agents from doing the same work twice.

1. **Exact Match Cache:** Use Redis or Memcached for identical queries.  
2. **Semantic Cache:** Use a Vector Database to find "close enough" previous answers. If a user asks "What is the revenue?" and later "Show me sales figures," semantic caching can retrieve the previous analysis without re-running the expensive agent workflow.6

## **6\. Case Studies and Benchmarks**

### **6.1 SwarmBench: The Limits of Decentralization**

The **SwarmBench** study evaluated agents under "swarm-like" constraints, such as limited local perception and communication.

* **Key Finding:** Current LLMs (even GPT-4) struggle with long-range planning in decentralized swarms. They perform well on local coordination but fail at global strategic alignment without a strong Orchestrator.  
* **Strategic Implication:** For enterprise business processes, **centralized orchestration (Hierarchical/Graph-based)** is superior to decentralized swarms. Do not rely on emergent behavior for mission-critical workflows; enforce it via LangGraph or CrewAI hierarchy.45

### **6.2 ChatDev: The Cost of Software Generation**

Analysis of **ChatDev** (a MetaGPT-like framework) shows it can generate a basic software application for approximately **$0.29** in API costs.23

* **Key Insight:** While the cost is remarkably low, the code often contains "hallucinated dependencies" or logic errors that require human debugging. The "Waterfall" model used by ChatDev can also lead to "forgetfulness," where decisions made in the Design phase are lost by the time the agent reaches the Testing phase due to context window limits.  
* **Optimization:** The most cost-effective pattern for code generation is **Hybrid**: The Agent generates the boilerplate (80% of code, low cost), a Human reviews and refines the logic (High value), and the Agent writes the unit tests (High volume, low risk).

## **7\. Strategic Roadmap and Recommendations**

### **7.1 The "3-Tier" Model Strategy**

Adopt a standardized, tiered model strategy across all agent frameworks to optimize the cost-performance ratio:

| Tier | Model Examples | Target Cost (per 1M tokens) | Role & capability |
| :---- | :---- | :---- | :---- |
| **Tier 1: The Interns** | Llama-3-8B, Haiku, Gemini Flash | \< $0.50 | Data formatting, classification, simple extraction, routing. |
| **Tier 2: The Associates** | GPT-3.5-Turbo, Mixtral 8x7B, Claude Sonnet | $3.00 \- $10.00 | Drafting content, standard coding, summarizing meetings. |
| **Tier 3: The Experts** | GPT-4o, Claude 3.5 Opus | $15.00 \- $30.00+ | Final review, complex reasoning, architectural planning, resolving escalations. |

**Action Item:** Configure the Orchestrator (LangGraph/CrewAI) to default to Tier 1\. Explicitly require a "reasoning score" or "complexity flag" from the Router to unlock Tier 2 or Tier 3 access.48

### **7.2 Buy vs. Build: The Framework Decision Guide**

* **Use LangGraph if:** You are building a core product feature where the agent is the product. You need absolute control over the user experience, safety guardrails, and auditability.  
* **Use CrewAI if:** You are automating internal business processes (Marketing, Ops) and need to spin up teams quickly with "good enough" reliability and minimal coding overhead.  
* **Use MetaGPT if:** You are specifically building software development pipelines or complex documentation generation workflows.

### **7.3 The "Agent-as-a-Service" API Gateway**

Do not let every developer call LLM APIs directly. Funnel all agent traffic through a unified **AI Gateway** (e.g., Portkey, LiteLLM).

* **Benefits:**  
  * **Unified Caching:** A query answered for the Marketing team is cached and available for the Sales team.  
  * **Rate Limiting:** Prevent a rogue agent loop from draining the corporate budget.  
  * **Model Swapping:** If a provider has an outage or raises prices, you can swap the backend model for the entire fleet of Tier 2 agents instantly via the Gateway configuration.6

### **7.4 Future-Proofing: Edge Agents**

Prepare for the rise of **Edge AI**. As SLMs become capable of running on employee laptops (e.g., via Ollama/Llama.cpp), offload the "Drafting" and "Thinking" phases to local compute. Only send the final summary or the difficult queries to the cloud. This hybrid architecture will be the dominant cost-saving mechanism in the 2026-2027 timeframe.

## **Conclusion**

Optimizing multi-agent systems is an exercise in **constraint management**. The capability of these systems is theoretically unbounded, but so is their potential cost. By implementing a **LangGraph-based control plane** for rigorous state management, utilizing **Semantic Routing** to filter and direct tasks, and enforcing a **FrugalGPT cascade** for model selection, a CTO can achieve the "Goldilocks" zone: agents that are smart enough to do the job, but not smart enough to waste money. The future belongs not to the smartest model, but to the most efficient supply chain of intelligence.

#### **Works cited**

1. Beyond Binary: A Ternary Router for the LLM Reasoning Cliff \- Level Up Coding, accessed on January 23, 2026, [https://levelup.gitconnected.com/beyond-binary-a-ternary-router-for-the-llm-reasoning-cliff-2581ac649dc3](https://levelup.gitconnected.com/beyond-binary-a-ternary-router-for-the-llm-reasoning-cliff-2581ac649dc3)  
2. Small Language Models vs Large Language Models: Why Tiny Is the Future of Agentic AI, accessed on January 23, 2026, [https://vatsalshah.in/blog/small-language-models-future-of-agentic-ai](https://vatsalshah.in/blog/small-language-models-future-of-agentic-ai)  
3. LLM Prompt Routing: The Strategic Key to Scaling AI Applications | Sam Selvanathan, accessed on January 23, 2026, [https://samselvanathan.com/posts/llm-prompt-routing/](https://samselvanathan.com/posts/llm-prompt-routing/)  
4. LangGraph vs. CrewAI vs. AutoGen: Top 10 Agent ... \- O-mega.ai, accessed on January 23, 2026, [https://o-mega.ai/articles/langgraph-vs-crewai-vs-autogen-top-10-agent-frameworks-2026](https://o-mega.ai/articles/langgraph-vs-crewai-vs-autogen-top-10-agent-frameworks-2026)  
5. Patterns for Democratic Multi‑Agent AI: Voting-Based Council — Part 1 | by edoardo schepis, accessed on January 23, 2026, [https://medium.com/@edoardo.schepis/patterns-for-democratic-multi-agent-ai-voting-based-council-part-1-9a9164a173ff](https://medium.com/@edoardo.schepis/patterns-for-democratic-multi-agent-ai-voting-based-council-part-1-9a9164a173ff)  
6. FrugalGPT: Reducing LLM Costs & Improving Performance \- Portkey, accessed on January 23, 2026, [https://portkey.ai/blog/implementing-frugalgpt-smarter-llm-usage-for-lower-costs/](https://portkey.ai/blog/implementing-frugalgpt-smarter-llm-usage-for-lower-costs/)  
7. CrewAI vs LangGraph vs AutoGen: Choosing the Right Multi-Agent AI Framework, accessed on January 23, 2026, [https://www.datacamp.com/tutorial/crewai-vs-langgraph-vs-autogen](https://www.datacamp.com/tutorial/crewai-vs-langgraph-vs-autogen)  
8. LangGraph 101: Let's Build A Deep Research Agent | Towards Data Science, accessed on January 23, 2026, [https://towardsdatascience.com/langgraph-101-lets-build-a-deep-research-agent/](https://towardsdatascience.com/langgraph-101-lets-build-a-deep-research-agent/)  
9. Langchain vs LlamaIndex vs CrewAI vs Custom? Which framework to use to build Multi-Agents application? : r/LocalLLaMA \- Reddit, accessed on January 23, 2026, [https://www.reddit.com/r/LocalLLaMA/comments/1chkl62/langchain\_vs\_llamaindex\_vs\_crewai\_vs\_custom\_which/](https://www.reddit.com/r/LocalLLaMA/comments/1chkl62/langchain_vs_llamaindex_vs_crewai_vs_custom_which/)  
10. LangGraph \- LangChain, accessed on January 23, 2026, [https://www.langchain.com/langgraph](https://www.langchain.com/langgraph)  
11. AI Agent Frameworks: Choosing the Right Foundation for Your Business | IBM, accessed on January 23, 2026, [https://www.ibm.com/think/insights/top-ai-agent-frameworks](https://www.ibm.com/think/insights/top-ai-agent-frameworks)  
12. Design, Develop, and Deploy Multi-Agent Systems with CrewAI, accessed on January 23, 2026, [https://www.youtube.com/watch?v=guXhZ\_q6sVY](https://www.youtube.com/watch?v=guXhZ_q6sVY)  
13. Agents \- CrewAI Documentation, accessed on January 23, 2026, [https://docs.crewai.com/en/concepts/agents](https://docs.crewai.com/en/concepts/agents)  
14. Connect to any LLM \- CrewAI Documentation, accessed on January 23, 2026, [https://docs.crewai.com/en/learn/llm-connections](https://docs.crewai.com/en/learn/llm-connections)  
15. Loading Multiple LLM for multiple Agent \- CrewAI Community Support, accessed on January 23, 2026, [https://community.crewai.com/t/loading-multiple-llm-for-multiple-agent/3613](https://community.crewai.com/t/loading-multiple-llm-for-multiple-agent/3613)  
16. Autogen — Easy way to build multi- conversational agents (part 1 ) | by Sadiq G Pasha, accessed on January 23, 2026, [https://medium.com/@sadiqgpasha89/autogen-easy-way-to-build-multi-conversational-agents-part-1-5213be5d486d](https://medium.com/@sadiqgpasha89/autogen-easy-way-to-build-multi-conversational-agents-part-1-5213be5d486d)  
17. Introduction to Transform Messages | AutoGen 0.2, accessed on January 23, 2026, [https://microsoft.github.io/autogen/0.2/docs/topics/handling\_long\_contexts/intro\_to\_transform\_messages/](https://microsoft.github.io/autogen/0.2/docs/topics/handling_long_contexts/intro_to_transform_messages/)  
18. Cost calculation for the whole chat session · Issue \#1070 · microsoft/autogen \- GitHub, accessed on January 23, 2026, [https://github.com/microsoft/autogen/issues/1070](https://github.com/microsoft/autogen/issues/1070)  
19. What is MetaGPT ? | IBM, accessed on January 23, 2026, [https://www.ibm.com/think/topics/metagpt](https://www.ibm.com/think/topics/metagpt)  
20. MetaGPT \- Foundation Agents, accessed on January 23, 2026, [https://foundationagents.org/projects/metagpt/](https://foundationagents.org/projects/metagpt/)  
21. MetaGPT: Meta Programming for A Multi-Agent Collaborative Framework \- OpenReview, accessed on January 23, 2026, [https://openreview.net/forum?id=VtmBAGCN7o](https://openreview.net/forum?id=VtmBAGCN7o)  
22. ChatDev: Communicative Agents for Software Development \- ACL Anthology, accessed on January 23, 2026, [https://aclanthology.org/2024.acl-long.810.pdf](https://aclanthology.org/2024.acl-long.810.pdf)  
23. Characterizing and improving ChatDev coding performance \- Diva-Portal.org, accessed on January 23, 2026, [http://www.diva-portal.org/smash/get/diva2:1931827/FULLTEXT01.pdf](http://www.diva-portal.org/smash/get/diva2:1931827/FULLTEXT01.pdf)  
24. ChatDev: Communicative Agents for Software Development \- arXiv, accessed on January 23, 2026, [https://arxiv.org/html/2307.07924v5](https://arxiv.org/html/2307.07924v5)  
25. vLLM Semantic Router: Improving efficiency in AI reasoning | Red Hat Developer, accessed on January 23, 2026, [https://developers.redhat.com/articles/2025/09/11/vllm-semantic-router-improving-efficiency-ai-reasoning](https://developers.redhat.com/articles/2025/09/11/vllm-semantic-router-improving-efficiency-ai-reasoning)  
26. semantic-router/docs/00-introduction.ipynb at main \- GitHub, accessed on January 23, 2026, [https://github.com/aurelio-labs/semantic-router/blob/main/docs/00-introduction.ipynb](https://github.com/aurelio-labs/semantic-router/blob/main/docs/00-introduction.ipynb)  
27. Threshold optimization \- Semantic Router \- Aurelio AI, accessed on January 23, 2026, [https://docs.aurelio.ai/semantic-router/user-guide/features/threshold-optimization](https://docs.aurelio.ai/semantic-router/user-guide/features/threshold-optimization)  
28. Dynamic routes \- Semantic Router \- Aurelio AI, accessed on January 23, 2026, [https://docs.aurelio.ai/semantic-router/user-guide/features/dynamic-routes](https://docs.aurelio.ai/semantic-router/user-guide/features/dynamic-routes)  
29. \[2305.05176\] FrugalGPT: How to Use Large Language Models While Reducing Cost and Improving Performance \- arXiv, accessed on January 23, 2026, [https://arxiv.org/abs/2305.05176](https://arxiv.org/abs/2305.05176)  
30. FrugalGPT and Reducing LLM Operating Costs \- Towards Data Science, accessed on January 23, 2026, [https://towardsdatascience.com/frugalgpt-and-reducing-llm-operating-costs-ff1a6428bf96/](https://towardsdatascience.com/frugalgpt-and-reducing-llm-operating-costs-ff1a6428bf96/)  
31. Harnessing Chain-of-Thought Metadata for Task Routing and Adversarial Prompt Detection, accessed on January 23, 2026, [https://arxiv.org/html/2503.21464v1](https://arxiv.org/html/2503.21464v1)  
32. Doing More with Less – Implementing Routing Strategies in Large Language Model-Based Systems: An Extended Survey \- arXiv, accessed on January 23, 2026, [https://arxiv.org/html/2502.00409v1](https://arxiv.org/html/2502.00409v1)  
33. BEST-Route: Adaptive LLM Routing with Test-Time Optimal Compute \- OpenReview, accessed on January 23, 2026, [https://openreview.net/forum?id=tFBIbCVXkG](https://openreview.net/forum?id=tFBIbCVXkG)  
34. Agentic AI from First Principles: Reflection | Towards Data Science, accessed on January 23, 2026, [https://towardsdatascience.com/agentic-ai-from-first-principles-reflection/](https://towardsdatascience.com/agentic-ai-from-first-principles-reflection/)  
35. Finding the Sweet Spot: Trading Quality, Cost, and Speed During Inference-Time LLM Reflection \- arXiv, accessed on January 23, 2026, [https://arxiv.org/html/2510.20653v1](https://arxiv.org/html/2510.20653v1)  
36. Reflection Agent Pattern — Agent Patterns 0.2.0 documentation, accessed on January 23, 2026, [https://agent-patterns.readthedocs.io/en/stable/patterns/reflection.html](https://agent-patterns.readthedocs.io/en/stable/patterns/reflection.html)  
37. "Research shows that AI systems with 30+ agents out-performs a simple LLM call i... | Hacker News, accessed on January 23, 2026, [https://news.ycombinator.com/item?id=41174920](https://news.ycombinator.com/item?id=41174920)  
38. Compute-efficient Evaluation of LLM Voting Accuracy | OpenReview, accessed on January 23, 2026, [https://openreview.net/forum?id=Q6hMSV2QAg](https://openreview.net/forum?id=Q6hMSV2QAg)  
39. Minimizing Hallucinations and Communication Costs: Adversarial Debate and Voting Mechanisms in LLM-Based Multi-Agents \- MDPI, accessed on January 23, 2026, [https://www.mdpi.com/2076-3417/15/7/3676](https://www.mdpi.com/2076-3417/15/7/3676)  
40. Choosing the Right Multi-Agent Architecture \- LangChain Blog, accessed on January 23, 2026, [https://www.blog.langchain.com/choosing-the-right-multi-agent-architecture/](https://www.blog.langchain.com/choosing-the-right-multi-agent-architecture/)  
41. Comparing 4 Agentic Frameworks: LangGraph, CrewAI, AutoGen, and Strands Agents | by Dr Alexandra Posoldova | Medium, accessed on January 23, 2026, [https://medium.com/@a.posoldova/comparing-4-agentic-frameworks-langgraph-crewai-autogen-and-strands-agents-b2d482691311](https://medium.com/@a.posoldova/comparing-4-agentic-frameworks-langgraph-crewai-autogen-and-strands-agents-b2d482691311)  
42. LangGraph monitoring & observability | Dynatrace Hub, accessed on January 23, 2026, [https://www.dynatrace.com/hub/detail/langchain-agent-observability/](https://www.dynatrace.com/hub/detail/langchain-agent-observability/)  
43. The Essential Guide to AgentOps \- Medium, accessed on January 23, 2026, [https://medium.com/@bijit211987/the-essential-guide-to-agentops-c3c9c105066f](https://medium.com/@bijit211987/the-essential-guide-to-agentops-c3c9c105066f)  
44. Unified cost tracking for LLMs, tools, retrieval \- LangChain \- Changelog, accessed on January 23, 2026, [https://changelog.langchain.com/announcements/unified-cost-tracking-for-llms-tools-retrieval](https://changelog.langchain.com/announcements/unified-cost-tracking-for-llms-tools-retrieval)  
45. \[2505.04364\] Benchmarking LLMs' Swarm intelligence \- arXiv, accessed on January 23, 2026, [https://arxiv.org/abs/2505.04364](https://arxiv.org/abs/2505.04364)  
46. Benchmarking LLMs' Swarm intelligence \- arXiv, accessed on January 23, 2026, [https://arxiv.org/html/2505.04364v4](https://arxiv.org/html/2505.04364v4)  
47. Paper review — Communicative Agents for Software Development \- Medium, accessed on January 23, 2026, [https://medium.com/data-science/paper-review-communicative-agents-for-software-development-103d4d816fae](https://medium.com/data-science/paper-review-communicative-agents-for-software-development-103d4d816fae)  
48. Multi-LLM routing strategies for generative AI applications on AWS | Artificial Intelligence, accessed on January 23, 2026, [https://aws.amazon.com/blogs/machine-learning/multi-llm-routing-strategies-for-generative-ai-applications-on-aws/](https://aws.amazon.com/blogs/machine-learning/multi-llm-routing-strategies-for-generative-ai-applications-on-aws/)

[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAwAAAAZCAYAAAAFbs/PAAAAw0lEQVR4Xu3RMQtBURjG8RORz6AYDHYTKyWTMiiLFGWR1aAkn4CSwarssplMlCgfwGClfAMG/rfznnrZlMFwn/rVfZ/3nOHea4yff0wWC2xwQAeBtxMqVVyRlDmBGwYy91CQZ5PGHUVXSKa4IIgtQm5xxMkNKl08UcNYL766kJJy4gqVtrG7PWKurEhZd4VKy9hdQ5c5KT9f2Evf2F1GlxGcMVJdFENj/8kDZZQQdwe8bz7HEmvMkJddEzusEJbOz2/zAof7JwWmKm+7AAAAAElFTkSuQmCC>