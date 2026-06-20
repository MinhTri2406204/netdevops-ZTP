#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HOME=/home/ztp

cd /home/ztp/netdevops

git fetch origin main

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
  echo "================================================="
  echo "$(date): [Gitops Engine] Phat hien cau hinh moi" 
  git reset --hard HEAD
  git pull origin main >> /var/log/gitops.log 2>&1
  echo "BAT DAU KICH HOAT ANSIBLE" >> /var/log/gitops.log
  ansible-playbook -i ansible/hosts ansible/deploy_services.yml >> /var/log/gitops.log 2>&1
  echo "[Gitops Engine] Chu trinh hoan tat" >> /var/log/gitops.log 
else
  echo "$(date): [Gitops Engine] He thong khong co thay doi." > /dev/null
fi
