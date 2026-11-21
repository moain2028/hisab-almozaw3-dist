# hisab-almozaw3-dist — توزيع «حساب الموزع»

مستودع عام يقرأه التطبيق للتحكم عن بعد (نفس منظومة MoTechSys/keif_blins و diafa-apps).

| الملف | الغرض |
|---|---|
| `hisab-almozaw3/license.json` | الترخيص: `active` true=مفتوح · false=مقفل ويطلب الكود (المنشور هنا **هاشه فقط** `codeHash`، والكود في المستودع الخاص) · تغيير `code` يعيد القفل · حذف الملف بعد رؤيته = قفل نهائي |
| `hisab-almozaw3/update.json` | التحديث: `version`, `build`, `versionCodes{arm64,armv7}`, `apks{abi:{url,sha256,size}}`, `notes`, `minSupportedBuild` (إلزامي) |

- القراءة عبر GitHub Contents API (بدون كاش) ثم raw كبديل.
- بلا إنترنت: يبقى التطبيق على آخر حالة معروفة. الفحص عند الفتح وعند العودة (كل 10 دقائق كحد أدنى)، والتحديث كل 24 ساعة.
- ملفات APK تُرفع في **Releases** ويُولَّد `update.json` بـ `tool/make_update_json.py` (SHA-256 إلزامي).

## الإصدارات
| الإصدار | arm64 | armv7 |
|---|---|---|
| [2.4.0](https://github.com/moain2028/hisab-almozaw3-dist/releases/tag/v2.4.0) | 9.1MB · versionCode 2240 | 8.8MB · versionCode 1240 |
| [2.3.1](https://github.com/moain2028/hisab-almozaw3-dist/releases/tag/v2.3.1) | 19.3MB · versionCode 2231 | 16.9MB · versionCode 1231 |
| [2.3.0](https://github.com/moain2028/hisab-almozaw3-dist/releases/tag/v2.3.0) | 19.5MB · versionCode 2230 | 17.1MB · versionCode 1230 |
| [2.2.0](https://github.com/moain2028/hisab-almozaw3-dist/releases/tag/v2.2.0) | 26.6MB · versionCode 2220 | 22.6MB · versionCode 1220 |

## التحكم
- **قفل كل النسخ:** `"active": false` (المستخدم يُدخل الكود لفتحها).
- **تغيير الكود:** `python3 tool/license_hash.py NEW-CODE` في مستودع المصدر ثم ضع الناتج في `codeHash`.
- **تحديث إلزامي:** ارفع `minSupportedBuild` لأعلى من build النسخ القديمة.

## صفحة التنزيلات `downloads.alabbasi.uk`
- المصدر: `downloads-site/` (HTML ثابت عربي RTL، فاتح/داكن). يقرأ `apps.json` (قائمة التطبيقات) ثم `update.json` لكل تطبيق ⇒ **الإصدار والحجم وروابط arm64/armv7 تتحدّث تلقائياً** عند نشر إصدار جديد بلا إعادة نشر للصفحة.
- إضافة تطبيق آخر: عنصر جديد في `apps.json` + أيقونته في `assets/`.
- **منشورة الآن (مؤقتاً) على GitHub Pages:** https://moain2028.github.io/hisab-almozaw3-dist/ (فرع `gh-pages` = نسخة من `downloads-site/` بدون deploy.sh/_headers). لتحديث الصفحة نفسها انسخ الملفات للفرع؛ الإصدارات تتحدّث تلقائياً من update.json.
- النشر على الدومين: `CLOUDFLARE_API_TOKEN=… CLOUDFLARE_ACCOUNT_ID=… ./downloads-site/deploy.sh` (مشروع Pages مستقل `alabbasi-downloads`، يلمس سجل `downloads` فقط).
