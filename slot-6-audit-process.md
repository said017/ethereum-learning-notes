# Audit **Process from Secureum**

1. Read Spec/Docs to understand

- The goals and requirements , Specification is why things need to be done
- Documentation is how aspect, in the form of [README.me](http://README.me), natspec.
- Identifying Assets & Actors & Actions.

2. Fast Tools (Slither)

- Investigate common pitfalls and best practices
- Control/Data flow false positives/negatives

3. Manual Analysis (Read code to understand)

- Analyze business logic and constrains
- Missed flagging vulnerabilities
- Implementation vs specs

4. Slow/Deep Tools - Run Fuzzer/Symbolic (Echidna)

- Custom Properties run in minutes
- More pre/expertise deeper analyses

5. Discuss Findings

- “Given enough eyeballs, all bugs are shallow”
- Independent vs Group (discussion with other auditors)
- Bias & Effectiveness (discussion with other auditors)
- Overhead vs Overlap (discussion with other auditors)

6. Convey Status - clarify to project team if any

- Clarify Assumptions (discussion with project team)
- Discuss findings/impact/fixes (discussion with project team)
- Update status

7. Iterate

8. Write Report

- Summary & Details (numbers, highlight, actors, assets etc.)
- Findings : Severity, Scenarios, justification, suggestions
- Quality : Coding, conventions, coverage
- Articulate & Actionable

9. Deliver the Report

- Publish & present
- Agree on findings/severity
- Review & respond
- Private/public

10. Evaluate Fixes

- Findings : accepts/acknowledge/deny
- Fixes: Recommend or review
- Evaluation : Time & Timeline
- Ensure security
