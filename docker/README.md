# Docker Sandbox (P1)

This is an optional pattern for running Ralph in an isolated container when using dangerous permissions.

## Build

```bash
docker build -t ralph-sandbox -f docker/Dockerfile .
```

## Run

```bash
# Default (AMP provider)
docker run --rm -it -v "$PWD:/workspace" -w /workspace ralph-sandbox ./ralph.sh 10

# With a different provider
docker run --rm -it -e RALPH_PROVIDER=claude-code -v "$PWD:/workspace" -w /workspace ralph-sandbox ./ralph.sh 10
```

Notes:
- The container includes `git`, `jq`, and `envsubst`, but does NOT install any AI CLI.
- Provide your preferred provider's CLI and credentials in the container.
- Set `RALPH_PROVIDER` environment variable to select the provider (default: amp).
- See `config/providers.json` for available providers and their configurations.
