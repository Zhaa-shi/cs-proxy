#!/usr/bin/env bash
set -e
cd "$HOME"
if [ ! -x xray/xray ]; then
  command -v unzip >/dev/null 2>&1 || { sudo apt-get update -qq >/dev/null 2>&1; sudo apt-get install -y -qq unzip >/dev/null 2>&1; }
  mkdir -p xray && cd xray
  curl -sL --retry 5 --retry-delay 2 --ssl-no-revoke -o x.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
  unzip -oq x.zip && rm -f x.zip
fi
cd "$HOME/xray"
cat > config.json <<'JSON'
{
  "log": { "loglevel": "warning" },
  "inbounds": [{
    "port": 443,
    "listen": "0.0.0.0",
    "protocol": "vless",
    "settings": { "clients": [{ "id": "4af0d479-9b05-4e7a-8b3c-f5e777b4b7fc", "flow": "" }], "decryption": "none" },
    "streamSettings": { "network": "ws", "security": "none", "wsSettings": { "path": "/cy73zx9flnvtepiqwom6" } }
  }],
  "outbounds": [{ "protocol": "freedom" }]
}
JSON
pkill -f "xray run" 2>/dev/null || true
nohup ./xray run -c config.json > xray.log 2>&1 &
sleep 1
if ./xray version >/dev/null 2>&1; then echo XRAY_OK; else echo XRAY_FAIL; cat xray.log; exit 1; fi
