**Core Workspace Topology (HDMI-A-1 & eDP-1)**

| Key | Monitor | Role / Domain | Default Layout | Strategic Intent & Window Behavior |
| --- | --- | --- | --- | --- |
| **`1`** | `HDMI-A-1` | **Terminal & System Ops** | **`master`** | Primary anchor for persistent Tmux, terminal compilers, and background tasks without cluttering your code editor. |
| **`2`** | `HDMI-A-1` | **Primary Web & Deep Research** | **`monocle`** | Zero-distraction, full-viewport focus for primary browser sessions (Zen/Edge/Docs). |
| **`3`** | `HDMI-A-1` | **Primary Codebase (Core IDE)** | **`dwindle`** | Active engineering hub. Auto-splits naturally between Neovim buffers, language servers, unit tests, and REPLs. |
| **`4`** | `HDMI-A-1` | **Secondary Codebase / Client / Tooling** | **`dwindle`** | Dedicated project staging, secondary repo context, or side-by-side backend/frontend cross-inspection. |
| **`5`** | `HDMI-A-1` | **API / Database & Canvas Workspace** | **`dwindle`** | Clean workspace for GUI dev tools: Postman/Bruno, pgAdmin/DBeaver, Figma, or design docs before pushing to code. |
| **`6`** | `HDMI-A-1` | **Secondary Research & Multi-Tab Hub** | **`scrolling`** | Horizontal filmstrip for parallel doc reading, multi-window comparison, and deep-dive documentation stacks. |
| **`7`** | `HDMI-A-1` | **Immersive Media & Content** | **`monocle`** | Dedicated full-viewport display for YouTube, video players, Spotify canvas, or courses. |
| **`8`** | `eDP-1` | **Auxiliary Reading / Multitask Strip** | **`scrolling`** | Side-screen infinite ribbon for reference materials, active reading, and live previews while keeping HDMI focused. |
| **`9`** | `eDP-1` | **Persistent Monitoring & Observability** | **`master`** | Pinned dashboard space: system metrics (`btop`), server logs, Docker stats, and continuous CI/CD tracking. |
| **`0 (10)`** | `eDP-1` | **Ephemeral Scratchpad & Dump Staging** | **`dwindle`** | Fast throwaway staging for short-lived utility windows, calculators, one-off file transfers, and quick diffs. |
