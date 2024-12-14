# ML Tools Container

This repository contains a Docker container designed for ML/AI development with
essential tools such as Jupyter Lab, Code Server, and NVIDIA CUDA support. The
container is based on Arch Linux and includes configurations for Supervisor to
manage multiple services.

## Features

- **Arch Linux Base**: A lightweight and up-to-date Linux distribution.
- **Pre-installed Tools**:
  - Jupyter Lab for interactive notebooks.
  - Code Server for browser-based VS Code.
  - NVIDIA CUDA, cuDNN, and ML libraries (PyTorch, Polars, etc.).
- **Supervisor**: Manages multiple processes, such as Jupyter Lab and Code Server.
- **Customizable**: Easily extensible to meet your development needs.

## Installation

### Building the Docker Image

Clone the repository and build the Docker image:

```bash
# Clone the repository
git clone https://github.com/Xpos587/ml-tools
cd ml-tools

# Build the Docker image
docker build -t ml-tools .
```

### Running the Container

Run the container with necessary port bindings:

```bash
docker run -it --rm \
  -p 22:22 \
  -p 80:80 \
  -p 8080:8080 \
  -p 8888:8888 \
  -p 3000:3000 \
  ml-tools
```

### Accessing Services

- **SSH**: Connect via `ssh clore@<host>` (port `22`).
- **Nginx**: Visit `http://<host>:80` or `http://<host>:8080`.
- **Jupyter Lab**: Accessible at `http://<host>:8888`.
- **Code Server**: Accessible at `http://<host>:3000`.

## Environment Variables

The container supports several environment variables to customize its behavior:

### Required Environment Variables

- **`SSH_PASSWORD`**:

  - Description: Sets the password for SSH access.
  - Example: `export SSH_PASSWORD=my_secure_password`

- **`SSH_KEY`** (optional):

  - Description: Adds an authorized SSH key for access.
  - Example: `export SSH_KEY="ssh-rsa AAAAB... user@host"`

- **`WEBUI_PASSWORD`** (optional):
  - Description: Sets the password for the WebUI (e.g., Nginx Basic Auth).
  - Example: `export WEBUI_PASSWORD=webui_secure_password`

### Optional Environment Variables

- **`DEBIAN_FRONTEND`**:

  - Default: `noninteractive`
  - Description: Used to suppress prompts during package installation.

- **`NVIDIA_VISIBLE_DEVICES`**:

  - Default: `all`
  - Description: Defines which GPUs are accessible inside the container.

- **`NVIDIA_DRIVER_CAPABILITIES`**:
  - Default: `compute,utility`
  - Description: Specifies driver capabilities for NVIDIA GPUs.

## Directory Structure

```plain
 .
├──  config
│   ├──  code-server
│   │   ├──  User
│   │   └──  coder.json
│   ├──  fish
│   │   └──  config.fish
│   ├──  jupyter
│   │   └──  lab
│   ├──  nginx
│   │   ├──  conf.d
│   │   ├──  modules-enabled
│   │   ├──  sites-available
│   │   ├──  sites-enabled
│   │   ├──  snippets
│   │   ├──  fastcgi.conf
│   │   ├──  fastcgi_params
│   │   ├──  mime.types
│   │   ├──  nginx.conf
│   │   ├──  proxy_params
│   │   ├──  scgi_params
│   │   └──  uwsgi_params
│   ├──  supervisor
│   │   ├──  conf.d
│   │   └──  supervisord.conf
│   └──  onstart.sh
├──  scripts
│   ├──  code-server-runner.sh
│   ├──  init.sh
│   ├──  jupyter-lab-runner.sh
│   └──  run-init-sw.sh
├──  Dockerfile
├──  LICENSE
└──  README.md
```

## Supervisor Configuration

Supervisor manages all services in the container. Individual configurations are
stored in `config/supervisor/conf.d/`.

### Example Service Configurations

#### Code Server

```ini
[program:code-server]
command=/usr/bin/su clore -c '/etc/supervisor/code-server-runner.sh'
autostart=true
autorestart=true
stderr_logfile=/var/log/code-server.err.log
stdout_logfile=/var/log/code-server.out.log
```

#### Jupyter Lab

```ini
[program:jupyter]
command=/usr/bin/su clore -c '/etc/supervisor/jupyter-lab-runner.sh'
autostart=true
autorestart=true
stderr_logfile=/var/log/jupyter-lab.err.log
stdout_logfile=/var/log/jupyter-lab.out.log
```

## Troubleshooting

- **Supervisor Logs**:
  - Check logs in `/var/log/supervisor/` or the specified paths in `.conf` files.
- **NVIDIA Issues**:
  - Ensure the host system has the necessary NVIDIA drivers installed.
  - Verify the container has access to the GPUs using `docker run --gpus all`.

## Contributing

Feel free to contribute to this repository by opening an issue or
submitting a pull request.
