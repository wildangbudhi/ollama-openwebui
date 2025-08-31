# Ollama OpenWeb UI

Lightweight docker-compose setup for running an Ollama backend plus Open WebUI, with a helper script to pre-pull the models you list in `models.txt`.

## Files

- `docker-compose.yml` – Defines `ollama` and `openwebui` services.
- `models.txt` – One model name per line (e.g. `llama3`, `mistral`, `qwen2:7b`).
- `pull-model.sh` – Script (mounted into the Ollama container) that reads `models.txt` and pulls each model via `ollama pull`.

## Prerequisites

- Docker & Docker Compose plugin installed (`docker compose version` should work).

## Quick Start

1. Edit `models.txt` with the models you want (one per line). Example:
   ```
   gpt-oss:20b
   llama3.1:8b
   ```
2. Pull (or update) images:
   ```bash
   docker compose pull
   ```
3. Start the stack (detached recommended):
   ```bash
   docker compose up -d
   ```
4. Exec into (or just run the script inside) the `ollama` container to pull the listed models:
   ```bash
   docker compose exec ollama /bin/bash /usr/local/bin/pull-model.sh
   ```

   The script will iterate through each non-empty, non-comment line in `models.txt` and run `ollama pull <model>`.

## Access

- Open WebUI: http://localhost:3000
- Ollama API: http://localhost:11434 (internal hostname `ollama` inside the compose network)

## Updating / Adding Models Later

1. Append new model names to `models.txt`.
2. Re-run:
   ```bash
   docker compose exec ollama /bin/bash /usr/local/bin/pull-model.sh
   ```

## Stopping & Cleanup

Stop containers (preserves pulled models & data volumes):
```bash
docker compose down
```

Full reset (removes volumes, models, and WebUI data):
```bash
docker compose down -v
```

## Notes

- The volumes under `./volumes/ollama` and `./volumes/open-webui` persist model blobs and UI data between restarts.
- If a model line includes a tag (e.g. `qwen2:7b`), it will be pulled exactly; otherwise the latest tag is used.

---
Minimal flow recap:
```bash
echo "llama3" > models.txt
docker compose pull
docker compose up -d
docker compose exec ollama /bin/bash /usr/local/bin/pull-model.sh
```
