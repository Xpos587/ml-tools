#!/bin/bash
cd /etc/supervisor/
echo $SSH_PASSWORD
SSH_PASSWORD_SET=/etc/supervisor/SSH_PASSWORD_SET
SSH_INIT_SET=/etc/supervisor/SSH_INIT_SET
SSH_KEY_FILE=/home/clore/.ssh/authorized_keys
HTTP_BASIC_AUTH_FILE=/etc/apache2/.htpasswd
if [ "$SSH_PASSWORD" == "" ]; then
  echo ""
else
  if test -f "$SSH_PASSWORD_SET"; then
    echo ""
  else
    echo "root:$SSH_PASSWORD" | chpasswd
    echo "clore:$SSH_PASSWORD" | chpasswd
    touch $SSH_PASSWORD_SET
    echo "PermitRootLogin yes" >>/etc/ssh/sshd_config
  fi
  export SSH_PASSWORD=""
fi
if [ "$SSH_KEY" != "" ]; then
  if test -f "$SSH_KEY_FILE"; then
    echo ""
  else
    echo "$SSH_KEY" >/root/.ssh/authorized_keys
    echo "$SSH_KEY" >$SSH_KEY_FILE
    chown clore $SSH_KEY_FILE
    chmod 700 $SSH_KEY_FILE
  fi
  export SSH_KEY=""
fi
if test -f "$SSH_INIT_SET"; then
  rm /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key.pub
  ssh-keygen -A
  mkdir -p /run/sshd
  rm $SSH_INIT_SET
fi

if test -f "$HTTP_BASIC_AUTH_FILE"; then
  echo ''
else
  if [ "$WEBUI_PASSWORD" == "" ]; then
    echo "no WEBUI password supplied"
  else
    htpasswd -b -c $HTTP_BASIC_AUTH_FILE clore $WEBUI_PASSWORD
  fi
fi

cd /root
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
