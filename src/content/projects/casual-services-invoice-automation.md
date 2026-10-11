---
title: "Casual Services Invoice Automation"
slug: "casual-services-invoice-automation"
summary: "Built for my own monthly invoicing. A scheduled Lambda works out the billable days for two sites from business-day calendars, public holidays and leave, writes the amounts into my existing PDF template, and leaves a Gmail draft for me to review. It never sends - issuing the invoice stays with me. Invoice numbers are reserved in a DynamoDB transaction, and a marker written before the Gmail call means a retry looks for the existing draft instead of creating a second one."
stack:
  - "Python"
  - "AWS (Lambda, EventBridge Scheduler, DynamoDB, S3, Secrets Manager, SNS, SQS, CloudWatch)"
  - "CloudFormation"
  - "Gmail API"
order: 3
body:
  whatItIs: "A monthly job that turns the previous month's service dates into an invoice and a Gmail draft, without my computer being on. Preparing the draft is automated. Sending it is not - I review it and send it myself.\n\nIt is small on purpose: two sites, one PDF template, one invoice a month. The work went into the parts that are easy to get wrong - invoice numbering, retries against an API that can fail without saying whether it succeeded, and not creating the same draft twice."
  built:
    - "The billing calculation. Each site's billable days come from its working weekdays and that year's regional public holidays, with date overrides for leave. A site override wins over a global one. Amounts use Decimal and round half up to cents. A year with no holiday calendar configured fails instead of guessing."
    - "PDF generation that keeps my existing template. Five fields are replaced - invoice number, issue date, two site amounts and the total. Everything else on the page is left alone, and the tests compare rendered pixels outside those fields."
    - "Invoice numbering in DynamoDB. One conditional transaction updates the counter and inserts the month's row, so two runs can't take the same number and a repeated month reuses its own."
    - "Draft creation that is safe to retry. The PDF and the full email are written to S3 first, then a creating marker is recorded before the Gmail request. A retry searches the drafts for the operation ID. Exactly one match is accepted; none or several stops the job for me to look at."
    - "The hosted runtime. EventBridge Scheduler runs a monthly generate and a daily monitor on Melbourne time, a Lambda does the work, SNS emails me when a draft is ready or a run is missing, and failures land in a dead-letter queue with CloudWatch alarms on it."
    - "Tests and an isolated acceptance run. 53 offline tests cover calendars, leave, timezone rollover, money, PDF fidelity, concurrent numbering and draft retries. A one-off schedule against a separate ledger and a synthetic template ran the whole path on AWS without touching the real numbering."
  decisions:
    - decision: "The job creates a draft and stops. The code has no send path."
      rejected: "Sending the invoice automatically once it's generated."
      why: "Preparing the invoice is the repetitive part. Issuing it is the part I want to stay answerable for, so that step stays manual. One limit: the Gmail compose permission would allow sending at Google's end, even though the code never calls it."
    - decision: "When a draft request has an uncertain outcome, the job stops and waits for me."
      rejected: "Retrying the Gmail request automatically."
      why: "A blind retry can produce two drafts for the same invoice. I chose duplicate prevention over automatic recovery, and the cost is that some failures need me to step in."
    - decision: "Two CloudFormation stacks - one for stored data, one for the runtime."
      rejected: "A single stack for everything."
      why: "The runtime can be replaced without resetting invoice numbering, and the bucket and table are retained if a stack is deleted."
    - decision: "The email is saved in full before the remote call and reused on retry."
      rejected: "Rebuilding the email from current configuration on each attempt."
      why: "If a rate, an address or the template changes between attempts, the retry still carries the invoice that was originally prepared."
---
