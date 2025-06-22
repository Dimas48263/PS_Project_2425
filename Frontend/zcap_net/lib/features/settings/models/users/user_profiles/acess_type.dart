import 'package:zcap_net_app/core/services/globals.dart';

// Permission types (no access, read-only access, full access) same as API
enum AccessType {
  readWrite,
  readOnly,
  none,
}

extension AccessTypeLabels on AccessType {
  String get label {
    switch (this) {
      case AccessType.readWrite:
        return 'access_type_write'.tr();
      case AccessType.readOnly:
        return 'access_type_read'.tr();
      case AccessType.none:
        return 'access_type_none'.tr();
    }
  }
}