# Capabilities Report: Autonomous Personal Website on deepg.in

This report analyzes the gap between the current `ralph-1` agentic system and the requirements to build and host a fully autonomous personal website on your MilesWeb hosting (`deepg.in`).

## 1. Hosting Environment Analysis (Target)
Based on the screenshot provided:
- **Provider**: MilesWeb (Shared Hosting / cPanel-style dashboard).
- **Access Methods**: FTP, File Manager, Databases (MySQL).
- **Likely OS**: Linux (Standard for MilesWeb).
- **Constraint**: This is likely **Standard Web Hosting**, meaning it expects static files (HTML/CSS/JS) or PHP. It probably does *not* support long-running Node.js processes or Docker containers unless specifically upgraded to "Cloud" or "VPS".
- **Recommended Tech Stack**: Static Site Generator (e.g., Next.js Static Export, raw HTML/CSS, or simple React built to static).

## 2. Capability Gap Analysis

| Capability | Status | Description | Action Required |
| :--- | :---: | :--- | :--- |
| **Autonomous Coding** | ✅ **Existing** | `ralph-1` (AMP/Claude/Antigravity) can write code, fix bugs, and iterate based on a PRD. | None. |
| **Task Management** | ✅ **Existing** | `prd.json` and `ralph` skill handle task breakdown and tracking. | None. |
| **Verification** | ⚠️ **Partial** | `dev-browser` exists for local checking, but no live staging verification. | Sufficient for now. |
| **Project Bootstrap** | ❌ **Missing** | Ralph works on *existing* repos. There is no automated way to "start from zero" (init git, basic scaffold). | **Create a Bootstrap Workflow** |
| **Deployment** | ❌ **Missing** | Ralph has no way to move files to MilesWeb. The dashboard shows **FTP**. | **Create an FTP/SFTP Deployment Skill** |
| **Content Source** | ❌ **Missing** | The agents don't know *who* you are (Bio, History, Interests) to populate the site. | **Create a `complete_profile.md`** |
| **Continuous Sync** | ❌ **Missing** | Deployment is currently manual. We need a "Deploy" story or hook in Ralph. | **Update `ralph.sh` or `prd.json` workflow** |

## 3. Detailed Missing Components

### A. Deployment Mechanism (FTP Skill)
MilesWeb offers **FTP** (File Transfer Protocol).
*   **Requirement**: A script or MCP tool that uses `lftp` or `curl` to upload the `build/` directory to the server.
*   **Agent Integration**: The agent needs a tool like `deploy_website(source_dir, remote_dir)`.

### B. Project Scaffolding (Bootstrap)
We need a "One-Click" setup script to:
1.  Create a new directory `~/Desktop/deepg-website`.
2.  Initialize a git repo.
3.  Copy the `ralph` machinery (scripts, config) into it.
4.  Scaffold a basic `index.html` or Next.js app.
5.  Create the first `prd.json` (Task 1: "Customize Homepage").

### C. The "Context-inject"
Agents will hallucinate your bio if not provided. We need a structured file (`USER_CONTEXT.md`) containing:
*   Name, Tagline, Introduction.
*   Links (GitHub, LinkedIn, plain text).
*   Preferences (Design style, colors).

## 4. Proposed Execution Plan

1.  **Bootstrap**: Use `antigravity` to manually scaffold the folder `deepg-website`.
2.  **Tooling**: I will write a simple `deploy.sh` script using `lftp` (if available) or standard `ftp` commands.
3.  **Credential Setup**: You will need to create an FTP account in the MilesWeb dashboard and provide the credentials (saved safely in `.env`, not committed).
4.  **Agent Instruction**: We will create a defined `workflow` for Ralph to:
    *   Code Feature -> Verify -> **Deploy Configured**.

## 5. Security Note
*   The screenshot shows IP `103.86.176.233`.
*   **FTP is unencrypted**. If MilesWeb supports **SFTP** (Secure FTP), we MUST use that. (Usually port 22 or 2222). Check the "FTP" or "Developer tools" section in your dashboard.

---
### Summary
The system is **80% ready** for coding, but **0% ready** for delivery. We need to build the bridge (Deployment Skill) and the foundation (Project Scaffold).
