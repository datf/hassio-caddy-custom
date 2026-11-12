# Home Assistant App: Caddy Custom

Caddy is a modern, cross-platform open-source web server and reverse proxy written in Go with automatic HTTPS certificate renewal built-in.

This app allows you to run Caddy directly on your Home Assistant instance and dynamically compile any Caddy plugins you need on the fly using `xcaddy`—straight from the app configuration, without maintaining custom Docker builds or using Caddy's downloads page.

## Documentation

For the full app documentation, including detailed installation instructions, configuration options (`plugins`, `args`, `env_vars`, `log_level`), `Caddyfile` setup, reverse proxy examples, and hardening Caddy with [CrowdSec](https://github.com/datf/app-crowdsec), please refer to the documentation file:

**[Read the Full App Documentation here](caddy-custom/DOCS.md)**

## Installation Quick Start

This app is available through a custom repository. To install it:

1. In Home Assistant, go to **Settings** -> **Apps** -> **Install app**, select **Repositories** from the context menu (**⋮**), and add:
   `https://github.com/datf/hassio-addons`
2. Search for **Caddy Custom** and click **Install**.
3. Place your `Caddyfile` in the app's `/config` (`addon_config`) directory (or start with the built-in test configuration).

_Please read the [full documentation](caddy-custom/DOCS.md) before starting the app to ensure it is configured securely._
