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
| [2.3.0](https://github.com/moain2028/hisab-almozaw3-dist/releases/tag/v2.3.0) | 19.5MB · versionCode 2230 | 17.1MB · versionCode 1230 |
| [2.2.0](https://github.com/moain2028/hisab-almozaw3-dist/releases/tag/v2.2.0) | 26.6MB · versionCode 2220 | 22.6MB · versionCode 1220 |

## التحكم
- **قفل كل النسخ:** `"active": false` (المستخدم يُدخل الكود لفتحها).
- **تغيير الكود:** `python3 tool/license_hash.py NEW-CODE` في مستودع المصدر ثم ضع الناتج في `codeHash`.
- **تحديث إلزامي:** ارفع `minSupportedBuild` لأعلى من build النسخ القديمة.
