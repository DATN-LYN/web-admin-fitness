import 'package:responsive_framework/responsive_wrapper.dart';

extension ResponsiveWrapperDataExt on ResponsiveWrapperData {
  T adap<T>(T small, T big) {
    if (isLargerThan(MOBILE)) {
      return big;
    } else {
      return small;
    }
  }
}
