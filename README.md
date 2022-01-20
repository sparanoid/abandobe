# Abandobe

Disable agents/daemons and kill all running processes from Adobe for macOS

This script will:

- Remove all running processes from Adobe
- Remove all agents/daemons plist from known locations

This script does not:

- Prevent Adobe from regenerating the agents/daemons and starting them

This script may works for users only use Adobe products occasionally. You can run this script after finishing your work with Adobe products.

## Usage

```bash
sudo bash abandobe.bash
```
