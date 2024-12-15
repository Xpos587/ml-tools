FROM archlinux:latest

# Копируем pacman конфигурацию до первого использования pacman
COPY config/pacman.conf /etc/pacman.conf

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
    fish \
    btop \
    nginx \
    apache \
    openssh \
    fastfetch \
    jupyterlab \
    supervisor && \
    pacman -Scc --noconfirm && rm -rf /var/cache/pacman/pkg/*

# Создаём пользователя clore
RUN useradd -m -s /usr/bin/fish clore && echo "clore ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# Устанавливаем paru (AUR helper) от имени пользователя clore
USER clore
WORKDIR /home/clore
RUN git clone https://aur.archlinux.org/paru.git && \
    cd paru && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf paru

# Устанавливаем micromamba
RUN paru -S --noconfirm micromamba-bin && \
    paru -Scc --noconfirm && rm -rf ~/.cache/paru

# Копируем пользовательские конфигурации
COPY --chown=clore:clore config/fish/ /home/clore/.config/fish/
COPY --chown=clore:clore config/jupyter/ /home/clore/.jupyter/
COPY --chown=clore:clore config/onstart.sh /home/clore/onstart.sh

# Настроим micromamba в домашней директории пользователя
ENV MAMBA_ROOT_PREFIX=/home/clore/.micromamba
RUN micromamba shell init -s bash --root-prefix $MAMBA_ROOT_PREFIX && \
    micromamba create -n default -y && \
    micromamba install -n default -y \
    ipykernel && \
    micromamba clean -a -y

# Настройка ядра IPython в домашней директории
RUN micromamba run -n default python -m ipykernel install --user --name micromamba_default --display-name "Micromamba (default)"

# Возвращаемся к пользователю root для финальных установок
USER root

# Копируем конфиги Supervisor
COPY config/supervisor/ /etc/supervisor/

# Копируем конфиги Nginx
COPY config/nginx/ /etc/nginx/

# Копируем скрипты
COPY scripts/*.sh /etc/supervisor/

# Настраиваем права
RUN chmod +x /etc/supervisor/*.sh

# Устанавливаем переменные окружения для скриптов
ENV WEBUI_PASSWORD=passwd
ENV SSH_PASSWORD=toor

# Экспонируем необходимые порты
EXPOSE 22 80

# Задаём init.sh в качестве команды запуска контейнера
CMD ["/etc/supervisor/init.sh"]

