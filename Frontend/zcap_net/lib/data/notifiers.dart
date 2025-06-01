//ValueNotifier: hold the data
//ValueListenableBuilder: listen to the data (no need of setstate)

import 'package:flutter/widgets.dart';

ValueNotifier<int> selectdPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(false);
