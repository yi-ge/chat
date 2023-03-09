#!/usr/bin/env bash

# service
cd service/
pnpm build
rsync -avr --delete-after \
  --exclude ".git" \
  --exclude ".gitignore" \
  --exclude ".vscode" \
  --exclude ".DS_Store" \
  --exclude ".dockerignore" \
  --exclude "node_modules" \
  --exclude "src" \
  --exclude "test" \
  --exclude "tsconfig.json" \
  --exclude "tsconfig.tsbuildinfo" \
  --exclude "release.sh" \
  --exclude "generated" \
  --exclude "deploy.sh" \
  --exclude "Dockerfile" \
  --exclude "README.md" \
  . root@47.242.18.162:/root/chat-api

# ssh to remote server as root
ssh root@47.242.18.162 <<EOF

docker run -it --rm -v /root/chat-api:/chat-api \
  -w /chat-api node:19.7.0-alpine pnpm install --ignore-engines

# check if chat-api container is running
if ! docker ps --filter "name=chat-api" --filter "status=running" | grep -q chat-api; then

  # if not running, start new container
  docker run --name chat-api -itd -m 4096m -p 65526:3002 \
  -v /root/chat-api:/chat-api -v /etc/localtime:/etc/localtime:ro -w /chat-api \
  --env "NODE_ENV=production" \
  --restart=always node:19.7.0-alpine pnpm start

else

  # if running, restart existing container
  docker restart chat-api

fi

EOF

cd ..
pnpm build

rsync -avr --delete-after \
  --exclude ".git" \
  --exclude ".gitignore" \
  --exclude ".vscode" \
  --exclude ".DS_Store" \
  --exclude ".dockerignore" \
  --exclude "node_modules" \
  --exclude "src" \
  --exclude "test" \
  --exclude "tsconfig.json" \
  --exclude "tsconfig.tsbuildinfo" \
  --exclude "release.sh" \
  --exclude "generated" \
  --exclude "deploy.sh" \
  --exclude "Dockerfile" \
  --exclude "README.md" \
  dist/* root@47.242.18.162:/root/chat

