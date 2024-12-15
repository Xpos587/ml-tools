#!/bin/bash
cd /etc/supervisor/
mkdir -p /etc/apache2 /etc/ssh /run/sshd

echo $SSH_PASSWORD

SSH_PASSWORD_SET=/etc/supervisor/SSH_PASSWORD_SET
SSH_KEY_FILE=/home/clore/.ssh/authorized_keys
HTTP_BASIC_AUTH_FILE=/etc/apache2/.htpasswd

# Установка пароля SSH
if [ "$SSH_PASSWORD" != "" ]; then
  if ! test -f "$SSH_PASSWORD_SET"; then
    echo "root:$SSH_PASSWORD" | chpasswd
    echo "clore:$SSH_PASSWORD" | chpasswd
    touch $SSH_PASSWORD_SET
    echo "PermitRootLogin yes" >>/etc/ssh/sshd_config
  fi
  export SSH_PASSWORD=""
fi

# Добавление SSH-ключа, если он предоставлен
if [ "$SSH_KEY" != "" ]; then
  if ! test -f "$SSH_KEY_FILE"; then
    mkdir -p /root/.ssh
    echo "$SSH_KEY" >/root/.ssh/authorized_keys
    echo "$SSH_KEY" >$SSH_KEY_FILE
    chown clore $SSH_KEY_FILE
    chmod 700 $SSH_KEY_FILE
  fi
  export SSH_KEY=""
fi

# Генерация хост-ключей SSH, если они отсутствуют
if ! ls /etc/ssh/ssh_host_* &>/dev/null; then
  ssh-keygen -A
fi

# Настройка HTTP Basic Auth
if ! test -f "$HTTP_BASIC_AUTH_FILE"; then
  if [ "$WEBUI_PASSWORD" != "" ]; then
    htpasswd -b -c $HTTP_BASIC_AUTH_FILE clore $WEBUI_PASSWORD
  else
    echo "no WEBUI password supplied"
  fi
fi

# Запуск Supervisor
supervisord -c /etc/supervisor/supervisord.conf
