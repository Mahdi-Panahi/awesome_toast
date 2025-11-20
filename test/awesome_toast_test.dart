import 'package:flutter_test/flutter_test.dart';

import 'package:awesome_toast/awesome_toast.dart';

void main() {
  test('ToastService can be instantiated', () {
    final toastService = ToastService.instance;
    expect(toastService, isA<ToastService>());
  });
}
