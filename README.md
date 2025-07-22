# 🔁 Jira Issue Transition GitHub Action

This GitHub Action transitions a Jira issue (e.g. `IDS-123`, `PROJ-456`) based on a matching issue key in the pull request title.

It uses the Jira API to change the status of an issue, making it useful for automating transitions like `TO BE RELEASED → Released`, `In Progress → Ready for Review`, etc.

---

## 🚀 Features

- 🔍 Extracts issue key from PR title using a custom regex pattern
- 🔒 Supports private and public Jira Cloud instances
- 🔁 Performs status transition via Jira REST API
- 📦 Fully compatible with reusable or mono-repo workflows

---

## 📥 Inputs

| Name                 | Required | Description                                                                 |
|----------------------|----------|-----------------------------------------------------------------------------|
| `jira-base-url`      | ✅ Yes   | Base URL of your Jira instance (e.g. `https://yourcompany.atlassian.net`)  |
| `jira-user-email`    | ✅ Yes   | Email of the Jira user (must have API access)                               |
| `jira-api-token`     | ✅ Yes   | API token for Jira authentication                                           |
| `jira-transition-id` | ✅ Yes   | ID of the Jira transition (e.g. "31" for "Released")                        |
| `github-token`       | ✅ Yes   | GitHub token used to fetch PR information                                   |
| `issue-key-pattern`  | ✅ Yes   | Regex pattern to extract issue key from PR title (e.g. `IDS-[0-9]+`)       |

---

## 🛠️ Example Usage

```yaml
jobs:
  transition-jira:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Transition Jira issue to "Released"
        uses: sydque/jira-transition-action@v1
        with:
          jira-base-url: ${{ secrets.JIRA_BASE_URL }}
          jira-user-email: ${{ secrets.JIRA_USER_EMAIL }}
          jira-api-token: ${{ secrets.JIRA_API_TOKEN }}
          jira-transition-id: ${{ secrets.JIRA_TRANSITION_ID_RELEASE }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
          issue-key-pattern: 'IDS-[0-9]+'
