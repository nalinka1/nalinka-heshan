---
title: "Claims Intelligence Assistant"
slug: "claims-intelligence-assistant"
summary: "A question-and-answer tool for insurance claim documents, built on retrieval-augmented generation over synthetic data. Two rules shape it: every answer cites the document it came from, and LLM cost is capped per request. I chose pgvector over a separate vector database so one Postgres instance holds both the claims data and the embeddings. The scaffolding is done; document ingestion and the cited Q&A pipeline are next."
stack:
  - "Python"
  - "FastAPI"
  - "Postgres + pgvector"
  - "AWS Bedrock"
  - "AWS CDK"
status: "in progress"
order: 4
---
