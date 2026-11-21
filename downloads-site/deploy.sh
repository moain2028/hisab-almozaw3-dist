#!/usr/bin/env bash
# نشر صفحة التنزيلات على Cloudflare Pages — مشروع مستقل «alabbasi-downloads».
# لا يلمس أي مشروع أو سجل DNS آخر في alabbasi.uk سوى downloads.alabbasi.uk.
#
# المطلوب: API Token بصلاحيات Account › Cloudflare Pages: Edit  +  Zone(alabbasi.uk) › DNS: Edit
#   export CLOUDFLARE_API_TOKEN=...   CLOUDFLARE_ACCOUNT_ID=...
set -euo pipefail
cd "$(dirname "$0")"
P=alabbasi-downloads
DOMAIN=downloads.alabbasi.uk
API=https://api.cloudflare.com/client/v4
H=(-H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json")

# 1) المشروع (يُنشأ مرة واحدة)
curl -sf "${H[@]}" "$API/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$P" >/dev/null ||
  curl -sf "${H[@]}" -X POST "$API/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects" \
    -d "{\"name\":\"$P\",\"production_branch\":\"main\"}" >/dev/null

# 2) رفع الملفات (بدون deploy.sh)
TMP=$(mktemp -d); cp -r index.html apps.json _headers assets fonts "$TMP/"
npx --yes wrangler@4 pages deploy "$TMP" --project-name "$P" --branch main --commit-dirty=true

# 3) ربط النطاق الفرعي (مرة واحدة)
curl -s "${H[@]}" -X POST "$API/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects/$P/domains" -d "{\"name\":\"$DOMAIN\"}" | grep -o '"success":[a-z]*'

# 4) سجل CNAME فقط لـ downloads (لا يعدّل غيره؛ يتوقف لو السجل موجود ويشير لمكان آخر)
ZONE=$(curl -s "${H[@]}" "$API/zones?name=alabbasi.uk" | python3 -c 'import json,sys;print(json.load(sys.stdin)["result"][0]["id"])')
EXIST=$(curl -s "${H[@]}" "$API/zones/$ZONE/dns_records?name=$DOMAIN" | python3 -c 'import json,sys;r=json.load(sys.stdin)["result"];print(r[0]["content"] if r else "")')
if [ -z "$EXIST" ]; then
  curl -s "${H[@]}" -X POST "$API/zones/$ZONE/dns_records" \
    -d "{\"type\":\"CNAME\",\"name\":\"downloads\",\"content\":\"$P.pages.dev\",\"proxied\":true}" | grep -o '"success":[a-z]*'
elif [ "$EXIST" != "$P.pages.dev" ]; then
  echo "⚠ $DOMAIN يشير إلى $EXIST — لم أغيّره. راجع يدوياً."; exit 1
fi
echo "✓ https://$P.pages.dev  ←→  https://$DOMAIN"
