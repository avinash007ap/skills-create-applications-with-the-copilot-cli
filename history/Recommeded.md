Recommended improvements for Copilot sessions

Investigation summary
- Session history showed friction around PR reviewer handling (attempt to add 'copilot' failed), PR creation when branch equaled base (empty-commit workaround), and manual linking of issues when titles weren't exact.

Recommendations to include in .github/copilot-instructions.md (and saved here per request):

1) CODEOWNERS / Default reviewers
- Add a .github/CODEOWNERS file mapping /src/ to a team or user to auto-request reviewers and avoid unresolved usernames.

2) Reviewer validation step
- Before requesting a reviewer, run: gh api /users/<username> to confirm existence. If absent, prompt for a team or alternate account.

3) Branch & PR conventions
- Use feature/* branches. Create feature branch (git checkout -b feature/...) before working. Include "Closes #<num>" in PR body or commit message to auto-close issues.

4) Test/run commands
- Include commands: npm test (full suite) and npx jest src/tests/calculator.test.js (single-file). Show how to run one test: npx jest -t "modulo".

5) Merge workflow
- Prefer creating PRs from feature branches, run /review or automated checks before merging, and enable --delete-branch on merge.

If you want, I can add these changes directly into .github/copilot-instructions.md. Which should I do next?