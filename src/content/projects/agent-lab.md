---
title: "Agent Failure Lab"
slug: "agent-lab"
summary: "A hand-written tool-calling agent over three-way invoice matching, run fifty times to count how it fails. Four of the fifty runs approved an invoice whose vendor lookup had returned an error - with the same tool results as the run that escalated. The idempotency key the model supplied was identical every time and protected nothing, because the payment tool never checked it. What I took from it: preconditions belong in the tool, not the prompt."
stack:
  - "Python"
  - "OpenAI API (tool calling)"
repo: "https://github.com/nalinka1/agent-lab"
order: 4
body:
  whatItIs: "Three-way matching is an accounts payable control: before an invoice is paid, it is checked against the purchase order and the goods receipt, then approved, rejected or escalated to a person. One of those outcomes moves money. I used it to ask a question: when a tool has a side effect and the run fails halfway, what protects you?\n\nTen cases, five attempts each, on synthetic data. 44 of 50 runs reached the correct outcome, 4 of 50 were false approvals, and the whole pass cost about four cents. It took two days. It is an experiment, not a product - nothing is deployed, and the output is the findings file with a trace behind every claim."
  built:
    - "The agent loop, about 130 lines with no framework. It calls the model with the tool schemas, dispatches each tool call, appends the result, and stops on a terminal tool or a hard limit of 12 steps."
    - "Nine tools over five JSON fixture files standing in for an ERP. The approve tool appends to a payment history file - that write is the side effect under test."
    - "Ten cases with an expected outcome each, run five times, and a script that reads the traces and produces a per-case table of agreement, correctness and cost."
    - "A trace file per run, one line per event, flushed to disk on every write. The experiment kills a process mid-run, so buffered evidence would be lost."
    - "A crash experiment. I injected a failure straight after a successful approval and restarted the run. It did not pay twice - but only because the model chose to call the duplicate check, which nothing required. And it ended in reject, which is wrong for an invoice that was already paid."
    - "The finding I didn't expect. The model built the same idempotency key on all six approvals, from two fields in the transcript. The key still guaranteed nothing, because the tool wrote it and never read it."
  decisions:
    - decision: "Wrote the loop by hand, with no retries, no self-correction prompt and no validation layer."
      rejected: "An agent framework that handles retries and correction."
      why: "Each of those would have hidden the failures I was trying to count."
    - decision: "Tool errors go back to the model as data."
      rejected: "Raising the error and stopping the run."
      why: "What the model does with an error is the thing being measured. In one case it approved four times out of five with the error in front of it."
    - decision: "Approve, reject and escalate are tool calls."
      rejected: "Reading the decision out of the model's text."
      why: "A model that says it would approve but never calls the tool is recorded as a failure, not an approval."
    - decision: "Five attempts per case, reported as agreement."
      rejected: "One run per case, reported as accuracy."
      why: "On a single run the worst case would have looked like bad luck. The spread across attempts is the result."
  whatBroke: "My own test harness. One exploratory run wrote a payment into the history file, and the next fifty-run pass read it back as a duplicate. The agent rejected the first case five times out of five and it was right to - given what it could see. About nine of the fifteen misses in that pass were contamination, not model behaviour, and they looked exactly like model variance. The fix was eight lines: restore a seed file before every attempt. I kept the contaminated traces in the repo."
---
