# 🚀 دليل CI/CD بالعربي

## ما اللي عملته ليك؟

عملت لك **نظام CI/CD كامل** للمشروع بتاعك، يعني:

### ✅ اللي هيحصل تلقائياً:
1. **كل ما تعمل Push** → الكود يتفحص ويتختبر تلقائياً
2. **كل ما تعمل Pull Request** → الكود يتراجع قبل الموافقة
3. **كل ما تبعت للـ Main Branch** → الـ Docker Images تتبني وترفع على Docker Hub
4. **كل أسبوع** → فحص أمني تلقائي للثغرات
5. **كل ما تعمل Release** → النسخة تتبني وتتوثق تلقائياً

---

## 🎯 اللي محتاج منك (ضروري)

### 1️⃣ حساب Docker Hub
**دقيقتين بس!**

1. روح https://hub.docker.com/signup
2. سجل حساب جديد (مجاني)
3. روح Settings → Security → New Access Token
4. اعمل Token جديد وانسخه (مش هتقدر تشوفه تاني!)

### 2️⃣ حط المعلومات في GitHub

روح على:
```
الريبو بتاعك → Settings → Secrets and variables → Actions → New repository secret
```

حط **سريّن** (Secrets):

| الاسم | القيمة |
|------|--------|
| `DOCKER_USERNAME` | اسم المستخدم في Docker Hub |
| `DOCKER_PASSWORD` | الـ Token اللي عملته |

---

## 🎉 خلاص كده! 

دلوقتي:
1. اعمل Push لأي حاجة على الـ main branch
2. روح على تاب **Actions** في GitHub
3. هتلاقي الـ workflows شغالة تلقائياً! 🎊

---

## 📁 الملفات اللي أضفتها

```
.github/
├── workflows/                   # الـ workflows (شغالة تلقائي)
│   ├── build-and-test.yml      # فحص واختبار الكود
│   ├── build-push-images.yml   # بناء ورفع Docker Images
│   ├── deploy-kubernetes.yml   # النشر على Kubernetes
│   ├── security-scan.yml       # الفحص الأمني
│   └── release.yml             # إدارة الإصدارات
│
├── QUICK-START.md              # دليل سريع (5 دقايق)
├── REQUIREMENTS.md             # المتطلبات
├── CI-CD-SETUP.md              # دليل كامل ومفصل
└── README.md                   # فهرس الملفات
```

---

## 🚀 لو عايز تنشر على Kubernetes (اختياري)

### الطريقة الأولى: Google Cloud (GKE)

محتاج تضيف أسرار إضافية:

| الاسم | القيمة | من فين |
|------|--------|--------|
| `GCP_PROJECT_ID` | رقم المشروع | من ملف `terraform.tfvars` |
| `GCP_SA_KEY` | مفتاح Service Account | شوف الشرح تحت |
| `GKE_CLUSTER_NAME` | اسم الـ Cluster | `my_cluster` (الافتراضي) |
| `GKE_ZONE` | منطقة الـ Cluster | `us-central1-a` (الافتراضي) |

#### كيف تعمل Service Account Key:
```bash
export PROJECT_ID="saedny"

gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions SA" \
    --project=$PROJECT_ID

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.developer"

gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions@$PROJECT_ID.iam.gserviceaccount.com

# انسخ محتوى الملف key.json وحطه في GCP_SA_KEY
cat key.json
```

### الطريقة الثانية: أي Kubernetes Cluster

```bash
# اعمل encode للـ kubeconfig
cat ~/.kube/config | base64 -w 0

# انسخ الناتج وحطه في secret اسمه KUBE_CONFIG
```

---

## 🎮 كيف تستخدم الـ CI/CD

### ✅ اختبار تلقائي
- كل ما تعمل Pull Request، الاختبارات تشتغل تلقائياً
- لو كل حاجة OK، تقدر تعمل Merge

### 🐳 بناء الـ Images
- كل ما تعمل Push للـ main، الـ images تتبني وترفع على Docker Hub
- الـ images بتتخزن بأسماء:
  - `latest` → آخر نسخة
  - `main-abc123` → نسخة الـ commit
  - `v1.0.0` → نسخ محددة

### 🚀 النشر على Kubernetes
1. روح **Actions**
2. اختار **Deploy to Kubernetes**
3. اضغط **Run workflow**
4. اختار البيئة (staging أو production)
5. اضغط **Run workflow** مرة تانية

---

## ⏱️ المدة المتوقعة

| العملية | المدة |
|---------|-------|
| الاختبارات | 5-10 دقائق |
| بناء كل الـ Images | 15-25 دقيقة |
| النشر على K8s | 3-5 دقائق |
| الفحص الأمني | 10-15 دقيقة |

---

## 🎯 الخلاصة السريعة

### اللي محتاجه دلوقتي (إجباري):
```
✅ 1. Docker Hub username
✅ 2. Docker Hub access token
✅ 3. ضيفهم كـ Secrets في GitHub
✅ 4. اعمل Push
```

### اللي محتاجه بعدين (اختياري):
```
⭕ 5. معلومات GCP (لو عايز تنشر على GKE)
⭕ 6. أو kubeconfig (لو عايز تنشر على cluster تاني)
```

---

## 🆘 لو واجهت مشاكل

### ❌ Build فشل: "unauthorized"
→ تأكد من الـ Docker Hub secrets صح

### ❌ Workflow مش شغال
→ تأكد إن Actions مفعّلة في الريبو

### ❌ Images مش ظاهرة في Docker Hub
→ شوف الـ logs في Actions tab

---

## 📚 الملفات الإنجليزية المفصلة

لو عايز تفاصيل أكتر:
- **[QUICK-START.md](QUICK-START.md)** - دليل 5 دقائق
- **[REQUIREMENTS.md](REQUIREMENTS.md)** - كل المتطلبات
- **[CI-CD-SETUP.md](CI-CD-SETUP.md)** - دليل كامل ومفصل

---

## 💡 نصائح مهمة

1. **ما تنساش** تحط الـ Secrets في GitHub
2. **استخدم** Docker Hub Token مش الباسورد
3. **اتأكد** من اسم الـ Docker Hub username صح
4. **شوف** Actions tab عشان تتابع الـ builds
5. **اقرأ** الـ logs لو حصل error

---

---

## 🏗️ Terraform (إدارة البنية التحتية)

### ما هو Terraform؟
أداة لإنشاء وإدارة البنية التحتية (GKE Cluster, Networks, etc.) من خلال الكود!

### كيف تستخدمه؟

#### 1️⃣ إعداد أولي (مرة واحدة - 3 دقائق)

```bash
export PROJECT_ID="saedny"

# إنشاء service account
gcloud iam service-accounts create terraform-sa \
    --display-name="Terraform SA" \
    --project=$PROJECT_ID

# إعطاء الصلاحيات
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:terraform-sa@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/container.admin"

# إنشاء المفتاح
gcloud iam service-accounts keys create terraform-key.json \
    --iam-account=terraform-sa@$PROJECT_ID.iam.gserviceaccount.com

# عرض المفتاح
cat terraform-key.json
```

#### 2️⃣ إضافة الأسرار في GitHub

روح: **Settings → Secrets → Actions**

أضف سريّن جديدين:

| الاسم | القيمة |
|------|--------|
| `GCP_PROJECT_ID` | `saedny` |
| `GCP_SA_KEY` | محتوى ملف terraform-key.json كامل |

#### 3️⃣ الاستخدام

**لإنشاء البنية التحتية:**
```
1. Actions → "Terraform Infrastructure Management"
2. Run workflow
3. Action: "plan" (للمعاينة أولاً)
4. شوف النتيجة
5. Run workflow مرة تانية
6. Action: "apply" (للتنفيذ)
7. Approve
8. استنى 15-20 دقيقة
9. البنية التحتية جاهزة! ✅
```

**لحذف كل حاجة (⚠️ خطير!):**
```
1. Actions → Terraform
2. Action: "destroy"
3. Approve (متأكد؟)
4. كل حاجة اتمسحت
```

### اللي هيتعمل:
✅ GKE Cluster (الكلاستر للكوبرنيتس)
✅ Networks و Subnets
✅ Firewall rules
✅ IAM permissions
✅ (اختياري) Redis Memorystore

### التكلفة:
تقريباً **$90-150 شهرياً** (حسب الاستخدام)

### الملفات:
- **[TERRAFORM-QUICK-GUIDE.md](.github/TERRAFORM-QUICK-GUIDE.md)** - مرجع سريع
- **[TERRAFORM-WORKFLOW.md](.github/TERRAFORM-WORKFLOW.md)** - دليل كامل

---

## 🎊 مبروك!

دلوقتي عندك:
✅ CI/CD احترافي
✅ Infrastructure as Code (Terraform)
✅ أتمتة كاملة من الكود للنشر

**لو محتاج مساعدة:** افتح issue أو شوف الملفات المفصلة فوق

**بالتوفيق!** 🚀

