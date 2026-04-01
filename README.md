# FRP Client Add-on

Home Assistant add-on that runs `frpc` and reads its configuration from `/share/frpc.toml`.

## Configuration

The add-on no longer uses Home Assistant add-on options from `config.yaml`.

All runtime configuration is managed through:

`/share/frpc.toml`

If `/share/frpc.toml` does not exist yet, the add-on creates it from the bundled example on first start. Edit that file and restart the add-on.

The default example includes:

- FRP server address and port
- Token authentication
- Web UI settings
- A sample HTTP proxy for Home Assistant on port `8123`

## Basic Setup

1. Install the add-on from this repository.
2. Start the add-on once so `/share/frpc.toml` is created if it is missing.
3. Open `/share/frpc.toml` in the Home Assistant share folder.
4. Replace the example values with your real FRP client configuration.
5. Restart the add-on.

## Notes

- Logs are written to `/share/frpc.log`.
- The add-on starts `frpc` with `frpc -c /share/frpc.toml`.
- `frps.toml` is not part of this add-on anymore because the add-on only runs the FRP client.
