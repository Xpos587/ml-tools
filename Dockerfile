FROM archlinux:latest

# Копируем pacman конфигурацию до первого использования pacman
COPY config/pacman.conf /etc/pacman.conf
COPY config/pacman.d/ /etc/pacman.d/

# Инициализируем pacman-key и обновляем систему
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    git \
    eza \
    bat \
    curl \
    openssh \
    fastfetch \
    jupyterlab \
    nvidia \
    nvidia-utils \
    cuda \
    cudnn \
    supervisor \
    fish \
    btop

# Создаём пользователя clore
RUN useradd -m -s /usr/bin/fish clore && echo "clore ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Устанавливаем paru (AUR helper) от имени пользователя clore
USER clore
WORKDIR /home/clore
RUN curl https://aur.archlinux.org/ && \
    git clone https://aur.archlinux.org/paru.git && \
    cd paru && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf paru

# Устанавливаем дополнительные пакеты через paru
RUN paru -S --noconfirm micromamba-bin code-server

# Копируем пользовательские конфигурации
COPY config/code-server/ /home/clore/.local/share/code-server/
COPY config/fish/ /home/clore/.config/fish/
COPY config/jupyter/ /home/clore/.jupyter/
COPY config/onstart.sh /home/clore/onstart.sh

# Копируем пользовательские конфигурации и задаём правильные права сразу
COPY --chown=clore:clore config/code-server/ /home/clore/.local/share/code-server/
COPY --chown=clore:clore config/fish/ /home/clore/.config/fish/
COPY --chown=clore:clore config/jupyter/ /home/clore/.jupyter/
COPY --chown=clore:clore config/onstart.sh /home/clore/onstart.sh

# Возвращаемся к пользователю root для дальнейших установок
USER root
WORKDIR /

# Настраиваем micromamba и создаём окружение
ENV MAMBA_ROOT_PREFIX=/opt/mamba
RUN micromamba shell init -s bash --root-prefix $MAMBA_ROOT_PREFIX && \
    micromamba create -n default -y && \
    micromamba install -n default -y \
    numpy \
    scipy \
    matplotlib \
    scikit-learn \
    pytorch \
    torchvision \
    polars[numpy,pandas,pyarrow] \
    jupyterlab \
    notebook \
    httpx \
    pydantic \
    openai \
    mlflow \
    pytest \
    plotly \
    dash \
    pillow \
    seaborn \
    dask \
    pyarrow \
    sqlalchemy \
    rich && \
    micromamba clean -a -y

# Копируем конфиги Supervisor
COPY config/supervisor/ /etc/supervisor/

# Копируем конфиги Nginx
COPY config/nginx/ /etc/nginx/

# Копируем скрипты
COPY scripts/*.sh /etc/supervisor/

# Настраиваем права
RUN chmod +x /etc/supervisor/*.sh

RUN mkdir -p /etc/apache2
RUN pacman -S --noconfirm apache

# Устанавливаем переменные окружения для скриптов
ENV WEBUI_PASSWORD=passwd
ENV SSH_PASSWORD=toor

# Экспонируем необходимые порты
EXPOSE 22 80 8080 8888 3000

# Задаём init.sh в качестве команды запуска контейнера
CMD ["/etc/supervisor/init.sh"]

