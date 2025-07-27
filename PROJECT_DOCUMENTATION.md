# شرح مشروع Flutter API Testing

## 📋 نظرة عامة على المشروع

هذا المشروع عبارة عن تطبيق Flutter يختبر APIs مختلفة لنظام تعليمي. يحتوي على:
- نظام تسجيل دخول
- عرض الملف الشخصي للمستخدم  
- نظام إضافة وعرض التعليقات على الدروس
- إدارة حالة باستخدام BLoC/Cubit
- تخزين آمن للـ Authentication Token

---

## 🏗️ هيكل المشروع والملفات

### 📁 lib/core/ - الملفات الأساسية

#### 🔧 `api_constant.dart`
**الغرض:** تجميع جميع URLs الخاصة بالـ API في مكان واحد

```dart
class ApiConstants {
  static const String baseUrl = 'https://wka.mobile.icomgroupdeveloper.org/wp-json/ms_lms/v2';
  static const String loginEndpoint = '$baseUrl/login';
  static const String accountEndpoint = '$baseUrl/account';
  static const String addCommentEndpoint = '$baseUrl/lesson/questions';
}
```

**لماذا هذا التصميم؟**
- **مركزية**: كل الـ URLs في مكان واحد
- **سهولة التعديل**: لو اتغير الـ base URL نغيره من مكان واحد
- **تجنب الأخطاء**: منع كتابة URLs خاطئة في أماكن مختلفة

---

#### 🌐 `dio_helper.dart`
**الغرض:** طبقة وسطية للتعامل مع HTTP requests باستخدام مكتبة Dio

**الميزات المُطبقة:**
1. **إعداد تلقائي للـ Base URL**
2. **إضافة Token للـ Headers تلقائياً**
3. **معالجة شاملة للأخطاء**
4. **دعم GET, POST, PUT requests**

```dart
class DioHelper {
  final Dio _dio = Dio();
  
  DioHelper() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
  }
}
```

**معالجة الأخطاء:**
- **DioException**: أخطاء الشبكة والـ API
- **General Exception**: أي أخطاء أخرى غير متوقعة
- **Logging**: تسجيل تفاصيل الأخطاء للمطورين

**مثال على معالجة الخطأ:**
```dart
try {
  final response = await _dio.get(endpoint);
  return response;
} on DioException catch (e) {
  if (e.response != null) {
    log('API Error - Status: ${e.response!.statusCode}');
    return e.response!;
  } else {
    throw Exception('Network error: ${e.message}');
  }
}
```

---

#### 🔐 `secure_storage.dart`
**الغرض:** تخزين آمن لـ Authentication Token

**لماذا نحتاج تخزين آمن؟**
- الـ Token حساس ولا يجب تخزينه في SharedPreferences عادي
- FlutterSecureStorage يستخدم:
  - **Android**: Android Keystore
  - **iOS**: iOS Keychain

```dart
static const FlutterSecureStorage _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);
```

**الوظائف:**
- `saveToken(String token)`: حفظ الـ token
- `getToken()`: استرجاع الـ token

---

#### ✅ `validators.dart`
**الغرض:** التحقق من صحة البيانات المُدخلة

**أنواع التحقق:**
1. **validateLogin**: التحقق من اسم المستخدم
   - لا يكون فارغ
   - على الأقل 3 أحرف
   
2. **validatePassword**: التحقق من كلمة المرور
   - لا تكون فارغة
   - على الأقل 6 أحرف
   
3. **validateComment**: التحقق من التعليق
   - لا يكون فارغ (بعد إزالة المسافات)

```dart
static String? validateLogin(String? value) {
  if (value == null || value.isEmpty) {
    return 'Login cannot be empty';
  }
  if (value.length < 3) {
    return 'Login must be at least 3 characters long';
  }
  return null;
}
```

---

### 📁 lib/cubit/ - إدارة الحالة

#### 🎛️ `test_cubit.dart`
**الغرض:** إدارة حالة التطبيق باستخدام BLoC pattern

**لماذا BLoC/Cubit؟**
- **فصل UI عن Business Logic**
- **إدارة مركزية للحالة**
- **سهولة اختبار الكود**
- **Reactive Programming**

**الحالات المُدارة:**
1. **تسجيل الدخول** (Login)
2. **جلب بيانات المستخدم** (Get Account)
3. **إضافة تعليق** (Add Comment)
4. **جلب التعليقات** (Get Comments)
5. **إظهار/إخفاء كلمة المرور** (Password Visibility)

**مثال على وظيفة تسجيل الدخول:**
```dart
Future<void> login(String login, String password) async {
  emit(LoginLoading()); // إرسال حالة تحميل
  try {
    final response = await _dioHelper.post(ApiConstants.loginEndpoint, {
      'login': login,
      'password': password,
    });
    
    if (response.statusCode == 200) {
      final token = response.data['token'];
      await SecureStorage.saveToken(token);
      emit(LoginSuccess()); // نجح تسجيل الدخول
    } else {
      String errorMessage = _parseLoginError(response);
      emit(LoginFailure(errorMessage)); // فشل تسجيل الدخول
    }
  } catch (e) {
    emit(LoginFailure(e.toString()));
  }
}
```

**معالجة أخطاء مخصصة:**
```dart
String _parseCommentError(response) {
  if (response.data != null) {
    if (response.data['code'] != null) {
      final code = response.data['code'];
      switch (code) {
        case 'rest_no_route':
          return 'Invalid request. Please try again.';
        case 'rest_invalid_json':
          return 'Invalid data format. Please check your input.';
        default:
          return message.isNotEmpty ? message : 'Request failed';
      }
    }
  }
}
```

---

#### 📊 `test_state.dart`
**الغرض:** تعريف جميع الحالات الممكنة في التطبيق

**أنواع الحالات:**
- **Initial**: الحالة الأولية
- **Loading**: حالة التحميل
- **Success**: حالة النجاح (مع البيانات)
- **Failure**: حالة الفشل (مع رسالة الخطأ)

**مثال:**
```dart
class LoginSuccess extends TestState {
  const LoginSuccess();
}

class LoginFailure extends TestState {
  final String error;
  const LoginFailure(this.error);
  
  @override
  List<Object> get props => [error];
}
```

**استخدام Equatable:**
- يساعد في مقارنة الحالات
- يحسن من أداء rebuilding الـ UI
- يمنع rebuilds غير ضرورية

---

### 📁 lib/models/ - نماذج البيانات

#### 👤 `account/account_model.dart`
**الغرض:** نموذج بيانات المستخدم

**البيانات المُخزنة:**
```dart
class AccountModel extends Equatable {
  final int id;
  final String login;
  final String avatarUrl;
  final String email;
  final String url;
  final List<String> roles;
  final MetaModel meta;        // معلومات إضافية
  final RatingModel rating;    // تقييمات المستخدم
  final int totalCourses;
  final String profileUrl;
}
```

**الميزات:**
- **fromJson/toJson**: تحويل من وإلى JSON
- **empty constructor**: لإنشاء كائن فارغ
- **Equatable**: للمقارنة السليمة

---

#### 📝 `comment_model.dart`
**الغرض:** نموذج التعليق

```dart
class CommentModel extends Equatable {
  final String commentId;
  final String content;
  final CommentAuthor author;  // بيانات كاتب التعليق
  final String datetime;
  final String repliesCount;
  final List<CommentModel> replies; // التعليقات الفرعية
}
```

**التعليقات المتداخلة:**
- يدعم replies للتعليقات
- بنية recursive للتعليقات متعددة المستويات

---

### 📁 lib/pages/ - صفحات UI

#### 🔑 `login_page.dart`
**الغرض:** صفحة تسجيل الدخول

**عناصر UI المُستخدمة:**
1. **Form & GlobalKey**: للتحقق من صحة البيانات
2. **TextFormField**: لإدخال اسم المستخدم وكلمة المرور
3. **BlocConsumer**: للاستماع لتغييرات الحالة
4. **ElevatedButton**: زر تسجيل الدخول
5. **SnackBar**: لعرض رسائل الخطأ

**تفاعل مع الحالة:**
```dart
BlocConsumer<TestCubit, TestState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TestAllApi()),
      );
    } else if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error), backgroundColor: Colors.red),
      );
    }
  },
  builder: (context, state) {
    // بناء UI بناءً على الحالة
  },
)
```

**ميزات UX:**
- **إخفاء/إظهار كلمة المرور**: عبر أيقونة العين
- **تحميل أثناء الإرسال**: CircularProgressIndicator
- **التحقق من البيانات**: قبل الإرسال
- **onTapOutside**: إخفاء الكيبورد عند النقر خارج الحقل

---

#### 👤 `profile_page.dart`
**الغرض:** عرض الملف الشخصي للمستخدم

**تصميم UI:**
1. **CircleAvatar**: صورة المستخدم
   - عرض الصورة من URL
   - fallback للحرف الأول من الاسم
   
2. **Cards منظمة**:
   - Basic Information
   - Personal Information  
   - Rating Information
   - Social Media

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Basic Information', style: headlineStyle),
        BuildInfoRow(label: 'ID', value: account.id.toString()),
        BuildInfoRow(label: 'Login', value: account.login),
        // ... المزيد من البيانات
      ],
    ),
  ),
)
```

**معالجة الأخطاء:**
- Loading state أثناء جلب البيانات
- Empty state إذا لم تكن هناك بيانات
- Error handling مع SnackBar

---

#### 💬 `comments_page.dart`
**الغرض:** عرض وإضافة التعليقات على الدروس

**أقسام الصفحة:**
1. **قسم إضافة التعليق** (أعلى الصفحة)
2. **قائمة التعليقات** (باقي الصفحة)

**قسم إضافة التعليق:**
```dart
Form(
  key: formKey,
  child: Column(
    children: [
      TextFormField(
        controller: commentController,
        validator: Validators.validateComment,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Write your comment here...',
          border: OutlineInputBorder(),
        ),
      ),
      ElevatedButton(
        onPressed: state is AddCommentLoading ? null : () {
          if (formKey.currentState!.validate()) {
            context.read<TestCubit>().addComment(
              lessonId,
              commentController.text.trim(),
            );
          }
        },
        child: state is AddCommentLoading 
          ? CircularProgressIndicator() 
          : Text('Add Comment'),
      ),
    ],
  ),
)
```

**عرض التعليقات:**
- **RefreshIndicator**: للتحديث بالسحب
- **ListView.builder**: لعرض قائمة التعليقات
- **CommentCard**: widget مخصص لكل تعليق

**CommentCard Features:**
```dart
class CommentCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // صف معلومات المؤلف
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.author.avatarUrl),
                child: comment.author.avatarUrl.isEmpty 
                  ? Text(comment.author.login[0].toUpperCase())
                  : null,
              ),
              Column(
                children: [
                  Text(comment.author.login, style: boldStyle),
                  Text(comment.datetime, style: greyStyle),
                ],
              ),
            ],
          ),
          // محتوى التعليق
          Text(_parseHtmlToText(comment.content)),
          // عدد الردود
          if (comment.repliesCount != '0 replies')
            Text(comment.repliesCount),
        ],
      ),
    );
  }
}
```

**معالجة HTML في التعليقات:**
```dart
String _parseHtmlToText(String htmlString) {
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '') // إزالة HTML tags
      .replaceAll('&nbsp;', ' ')         // تحويل entities
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .trim();
}
```

---

#### 🧪 `test_all_api.dart`
**الغرض:** صفحة رئيسية لاختبار جميع APIs

**أزرار الاختبار:**
```dart
Column(
  children: [
    // زر عرض الملف الشخصي
    ElevatedButton(
      onPressed: () => Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => ProfilePage())
      ),
      child: Text('View Profile'),
    ),
    
    // زر تعليقات الدرس 32192
    ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommentsPage(
          lessonId: 32192,
          lessonTitle: "Applied Transplant Immunology",
        ))
      ),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
      child: Text('Lesson 32192 Comments'),
    ),
    
    // زر تعليقات الدرس 27144  
    ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommentsPage(
          lessonId: 27144,
          lessonTitle: "Lesson 27144",
        ))
      ),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      child: Text('Lesson 27144 Comments'),
    ),
  ],
)
```

**معلومات إضافية:**
- Card تشرح ميزات التطبيق
- ألوان مختلفة للأزرار لسهولة التمييز

---

## 🎨 قرارات تصميم UI

### نظام الألوان
- **Primary Color**: `Colors.deepPurple`
- **Success Color**: `Colors.green`  
- **Warning Color**: `Colors.orange`
- **Error Color**: `Colors.red`

### المكونات المُستخدمة

#### 🃏 Cards
```dart
Card(
  elevation: 2,           // ظل خفيف
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(...)
  ),
)
```
**لماذا Cards؟**
- تجميع المعلومات ذات الصلة
- إضافة depth للتصميم
- سهولة القراءة

#### 🔘 Buttons
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    minimumSize: Size(double.infinity, 50),
  ),
  child: Text('Button Text'),
)
```
**الميزات:**
- زوايا مستديرة (10px radius)
- عرض كامل للشاشة
- ارتفاع ثابت (50px)

#### 🔤 Input Fields
```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Label',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  ),
  onTapOutside: (event) => FocusScope.of(context).unfocus(),
)
```
**UX Improvements:**
- زوايا مستديرة متسقة
- إخفاء الكيبورد عند النقر خارج الحقل
- تحقق من البيانات مع رسائل خطأ واضحة

---

## 🔄 Flow التطبيق

### 1. تسجيل الدخول
```
LoginPage → إدخال البيانات → التحقق → API Call → حفظ Token → TestAllApi
```

### 2. عرض الملف الشخصي  
```
TestAllApi → ProfilePage → API Call → عرض البيانات
```

### 3. التعليقات
```
TestAllApi → CommentsPage → جلب التعليقات → عرض القائمة
                          ↓
                      إضافة تعليق → API Call → تحديث القائمة
```

---

## 🛡️ معالجة الأخطاء

### مستويات معالجة الأخطاء

#### 1. Network Level (DioHelper)
```dart
try {
  final response = await _dio.get(endpoint);
  return response;
} on DioException catch (e) {
  // معالجة أخطاء الشبكة
} catch (e) {
  // معالجة أخطاء عامة
}
```

#### 2. Business Logic Level (Cubit)
```dart
if (response.statusCode == 200) {
  // نجح الطلب
  emit(SuccessState(data));
} else {
  // فشل الطلب مع رسالة خطأ مخصصة
  String errorMessage = _parseError(response);
  emit(FailureState(errorMessage));
}
```

#### 3. UI Level (Pages)
```dart
BlocConsumer<TestCubit, TestState>(
  listener: (context, state) {
    if (state is FailureState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
)
```

---

## 🔧 تحسينات مُطبقة

### Performance
- **Lazy Loading**: البيانات تُحمل عند الحاجة فقط
- **Efficient State Management**: استخدام Equatable لمنع rebuilds غير ضرورية
- **Image Caching**: NetworkImage تحفظ الصور تلقائياً

### Security  
- **Secure Storage**: تخزين آمن للـ tokens
- **Input Validation**: التحقق من جميع المدخلات
- **Token Auto-inclusion**: إضافة token للـ headers تلقائياً

### UX
- **Loading States**: مؤشرات تحميل واضحة
- **Error Messages**: رسائل خطأ مفهومة ومحددة
- **Pull to Refresh**: تحديث البيانات بالسحب
- **Keyboard Management**: إخفاء الكيبورد تلقائياً

### Code Quality
- **Separation of Concerns**: فصل UI عن Business Logic
- **Single Responsibility**: كل class له مسؤولية واحدة
- **Centralized Constants**: تجميع الثوابت في مكان واحد
- **Consistent Naming**: تسمية متسقة عبر المشروع

---

## 📚 المكتبات المُستخدمة

1. **flutter_bloc**: إدارة الحالة
2. **dio**: HTTP requests
3. **flutter_secure_storage**: تخزين آمن
4. **equatable**: مقارنة الكائنات

---

## 🚀 كيفية التشغيل

1. تشغيل `flutter pub get` لتحميل المكتبات
2. تشغيل التطبيق على simulator/device
3. استخدام credentials صحيحة لتسجيل الدخول
4. اختبار جميع الميزات من الصفحة الرئيسية

---

## 📝 ملاحظات مهمة

- التطبيق يدعم offline لـ stored tokens
- جميع API calls تتضمن error handling شامل  
- UI responsive ويعمل على أحجام شاشات مختلفة
- الكود قابل للصيانة والتوسع بسهولة 