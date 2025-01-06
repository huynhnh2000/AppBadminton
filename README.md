# DavidBadminton

### Để cài đặt hãy chạy lần lượt các đoạn mã sau ở cmd của project (nhấn CTRL+` để mở cmd):

```bash
flutter pub get
flutter build apk --release (để build apk bản release)
flutter build apk --debug (để build apk bản debug)
flutter doctor
```

### Sau đó chạy dòng lệnh sau để chạy app

```bash
flutter run --release (để chạy bản release)
flutter run --debug (để chạy bản debug)
```

### Để chuyển giữa coach và student hãy vào file sau: 

```bash
lib\ccui\ccauth\first_view.dart
```

### Sau đó tại hàm initState chỉnh:

```bash
userTypeStrategy = CoachStrategy(); (để chạy bản coach)
userTypeStrategy = StudentStrategy(); (để chạy bản student)
```

### Để đổi tên của app hãy vào:

```bash
android\app\src\main\AndroidManifest.xml
```

### Sau đó tại phần code sau chỉnh thành tên mong muốn là DavidBadminton_Coach hay DavidBadminton_Student

```bash
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="DavidBadminton"
```


