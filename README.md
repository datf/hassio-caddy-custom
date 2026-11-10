# Home Assistant App: Caddy Custom

Caddy is a modern, cross-platform open-source web server written in Go with
HTTPS certificate renewal built-in.

## About

Add the Caddy plugins you want straight from the configuration! No need to
compile caddy yourself or use their downloads page.

### Plugins Configuration

Standard plugins, specific versions, module replacements, and subpackages are supported:

```yaml
plugins:
  # Standard plugin (defaults to @latest)
  - github.com/caddyserver/replace-response
  # Pinned version
  - github.com/caddyserver/ntlm-transport@v0.1.1
  # Module replacement syntax (forks, patches) and subpackages
  - github.com/hslatman/caddy-crowdsec-bouncer=github.com/datf/caddy-crowdsec-bouncer@v0.0.1
  - github.com/hslatman/caddy-crowdsec-bouncer/http
  - github.com/hslatman/caddy-crowdsec-bouncer/appsec
  - github.com/hslatman/caddy-crowdsec-bouncer/layer4
```
