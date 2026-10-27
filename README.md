# agent-obs
Agent observability using otel. The goal is to reconstruct an OpenCode agent session using otel tracing.

Plan:

- Run agent in msb sandbox
- Pass a model uri
- Transform opencode event stream to otel traces maybe using github.com/openlit/openlit.
- Push traces to local collector

# Examples

Raw event collector

````sh 
mkdir -p events

curl --fail-with-body --no-buffer \
  http://127.0.0.1:4096/global/event \
  | tee "events/opencode-$(date +%Y%m%d-%H%M%S).sse"
````

openLIT

````sh
go install github.com/openlit/openlit/cli/cmd/openlit@latest

openlit coding install --vendor=opencode

# Note! We can't use host.microsandbox.internal since openlit enforce
# TLS if non-local host. Use raw IP.
openlit configure \
  --endpoint http://172.16.0.5:4318 \
  --application-name agent-observability \
  --environment poc \
  --content-capture full

openlit doctor
````

# POC

````sh
# Run sandbox
 export OPENCODE_API_KEY=...
msb run -d --name agent --conf sandbox.yaml
msb exec agent -- /bin/sh
opencode attach http://127.0.0.1:4096
# Run local otel collector
otel-tui --host 127.0.0.1
unset OPENCODE_API_KEY
````

# TODOs

- [ ] webgui (requires xdg-open stub to run in a sandbox)
- [ ] vscode opencode extension
- [ ] remove plugins we don't need
