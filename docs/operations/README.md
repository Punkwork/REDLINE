# PANOPTICON Development Operations Hub — OPS-001

Single shared source of truth for ChatGPT, Claude, Claude Code and Codex. All agents use main for operations records even when reporting work on another branch. Existing branch, approval and audit rules remain binding.

- [Surprises](SURPRISES.md)
- [Missing tools](MISSING_TOOLS.md)
- [Pull requests — live GitHub register](https://github.com/Punkwork/REDLINE/pulls)
- [To-dos — live GitHub Issues](https://github.com/Punkwork/REDLINE/issues)
- [Daily reports](reports/)
- [Daily priorities](DAILY_PRIORITIES.md)

At each session end, file a report for actual work, surprises and missing capabilities. Use reports/YYYY-MM-DD-AGENT.md (Toronto date; append sessions with time and branch). Use REPORT_TEMPLATE.md. Report no findings explicitly only if observed; absence of report is unknown, not zero. Link existing entries instead of duplicating. Use agent/date/sequence IDs for surprises and tools; check for duplicates before adding. GitHub issue numbers and PR numbers are canonical; do not mirror them into independent lists. Search existing issues before creating actionable tasks. Link originating surprise/tool IDs. Do not create branches, merge PRs, approve design or assign work without applicable authorization.

At 22:00 America/Toronto daily, ChatGPT consolidates reports, both registers, actual open/recently changed PRs and issues, and proposes next working day's agenda. Review missing reports and inaccessible data explicitly. Record dated proposed agenda in DAILY_PRIORITIES.md, preserving prior entries. Designer confirms priorities before execution; record confirmation and carryovers. Claude contributes to the same files, not a parallel review register. Re-read current SHA before writes; on conflict re-fetch and reconcile, never overwrite another agent's changes. No secrets or unrelated private conversation content. No gameplay changes authorized by this workflow.
