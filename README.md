# ML-Tools

## Overview

This repository provides a comprehensive Dockerized environment tailored for ML/AI development. It incorporates essential tools such as JupyterLab, a Fish shell-based custom user environment, and robust service management with Supervisor. The container is based on Arch Linux, offering a lightweight yet cutting-edge Linux distribution. Additionally, NVIDIA CUDA support and an extensible architecture make it suitable for ML/AI workflows.

## Key Features

- **Arch Linux Base**: Offers a rolling release system with the latest updates.
- **Pre-installed Tools**:
  - **JupyterLab**: Provides interactive notebook capabilities.
  - **Fish Shell**: Includes custom aliases and enhancements for an optimized CLI experience.
  - **Micromamba**: Manages Python environments efficiently, with a preconfigured `default` environment.
  - **Nginx**: Configured as a reverse proxy to route traffic securely to JupyterLab and other services.
  - **Supervisor**: Manages multiple services such as JupyterLab, Nginx, and SSH for seamless startup and restart.

## Installation

### Build the Docker Image

Clone the repository and build the Docker image:

```bash
git clone https://github.com/xpos587/ml-tools.git
cd ml-tools
docker build -t ml-tools .
```

### Run the Container

Run the container with necessary port bindings:

```bash
docker run -it --rm \
  --gpus all \
  -p 22:22 \
  -p 80:80 \
  ml-tools
```

### Access Services

- **JupyterLab**: Accessible at `http://<host>:80/jupyter/`.
- **SSH Access**: Use `ssh clore@<host>` (port `22`).
- **Web UI**: Nginx serves at `http://<host>:80`.

## Configuration

### Environment Variables

- **`SSH_PASSWORD`**: Sets the SSH password for user access.
- **`WEBUI_PASSWORD`**: Configures Basic Auth for the web UI.
- **`NVIDIA_VISIBLE_DEVICES`**: Enables GPU access in the container (`all` by default).
- **`MAMBA_ROOT_PREFIX`**: Defines the Micromamba root directory (default: `/home/clore/.micromamba`).

### Directory Structure

```plaintext
.
├── config/
│   ├── fish/                  # Fish shell configuration
│   ├── jupyter/               # JupyterLab user settings
│   ├── nginx/                 # Nginx configuration
│   ├── supervisor/            # Supervisor configuration
│   └── onstart.sh             # Custom startup script
├── scripts/                   # Service runner scripts
├── Dockerfile                 # Container build instructions
├── LICENSE                    # License file
└── README.eng.md              # This readme file
```

## Preconfigured Services

Supervisor handles process management for services such as:

1. **JupyterLab**: Defined in `supervisor/jupyter.conf`.
2. **Nginx**: Reverse proxy setup in `supervisor/nginx.conf`.

### Example: Supervisor Config for JupyterLab

```ini
[program:jupyter]
command=/usr/bin/su clore -c '/etc/supervisor/jupyter-lab.sh'
autostart=true
autorestart=true
stderr_logfile=/var/log/jupyter-lab.err.log
stdout_logfile=/var/log/jupyter-lab.out.log
```

## Troubleshooting

- **Supervisor Logs**: Check logs in `/var/log/supervisor/`.
- **JupyterLab Access Issues**: Ensure the `base_url` in `jupyter-lab.sh` matches the Nginx configuration.
- **NVIDIA Issues**: Validate host GPU availability with `nvidia-smi` and ensure Docker is configured with GPU support.

## Contributing

We welcome contributions! Feel free to open issues or submit pull requests for bug fixes or feature additions.

## License

This project is licensed under the [MIT License](./LICENSE).

```

```
