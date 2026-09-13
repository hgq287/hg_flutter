// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Hg Flutter';

  @override
  String get authTitle => 'Đăng nhập';

  @override
  String get authSubtitle => 'Dùng tài khoản của bạn để tiếp tục';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Mật khẩu';

  @override
  String get authSubmit => 'Đăng nhập';

  @override
  String get authValidation => 'Nhập email và mật khẩu';

  @override
  String get authError => 'Đăng nhập thất bại';

  @override
  String get homeTitle => 'Trang chủ';

  @override
  String homeSignedIn(String email) {
    return 'Đã đăng nhập với $email';
  }

  @override
  String get homeAssistant => 'Trợ lý';

  @override
  String get homeSignOut => 'Đăng xuất';

  @override
  String get assistantTitle => 'Trợ lý';

  @override
  String get assistantHint => 'Đặt câu hỏi';

  @override
  String get assistantSend => 'Gửi';

  @override
  String get assistantEmpty =>
      'Hỏi về bài viết trợ giúp hoặc số dư mẫu. Chuyển tiền sẽ bị từ chối.';
}
