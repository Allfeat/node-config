# NixOS Configuration for Allfeat Node Deployment

## Overview

This repository contains a NixOS configuration for setting up a system with the minimal tools required to efficiently deploy an Allfeat blockchain node. The configuration is optimized for deployment on servers and provides a streamlined environment to get your node up and running with minimal effort.

## Features

- Minimal toolset for Allfeat blockchain node deployment
- Optimized configuration for server environments
- Pre-configured user allfeat for node management
- Nginx with SSL via ACME (disabled by default)
- Firewall configured for typical Allfeat/Substrate node ports

## Pre-Requisites

- A server with NixOS installed
- Basic knowledge of NixOS and Nix configuration

## Setup Instructions

1) Clone the Repository

```sh
git clone https://github.com/allfeat/allfeat.git
cd allfeat
```

(If you don't have git installed, try `nix-shell -p git`)

2) Build the System

To build the system with the specified configuration, run:

```sh
sudo nixos-rebuild switch --flake .#allfeat-node 
```

3) Change Password for 'allfeat' User

**Important**: After the system has rebooted, you must change the password for the allfeat user to ensure security.

```sh
sudo passwd allfeat
```

**THIS STEP IS CRUCIAL TO SECURE YOUR NODE AND PREVENT UNAUTHORIZED ACCESS.**

## Configuration Details

### Nginx Configuration

- **Nginx is Disabled by Default**: Nginx can be enabled in the configuration.nix file.
- **SSL with ACME**: By default, Nginx uses SSL via ACME. Make sure to change the default email address for ACME by setting security.acme.defaults.email.
- **Disabling SSL**: If you do not want SSL, set both enableACME and forceSSL to false in the Nginx configuration section.

### Firewall Configuration

- **Firewall Enabled by Default**: The firewall is enabled by default and opens the ports commonly used in the context of an Allfeat/Substrate node.

## Notes

- This configuration is specifically optimized for server environments and may not be suitable for desktop or non-server use cases.

## Support

If you encounter any issues or have questions about this configuration, please open an issue in this repository or reach out to the NixOS community for assistance.

## Contributing

Contributions to enhance this configuration are welcome. Please fork the repository, make your changes, and submit a pull request.


Thank you for using this NixOS configuration to deploy your Allfeat blockchain node. Secure your node and happy deploying!
