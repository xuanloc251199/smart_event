import 'package:flutter/widgets.dart';

import '../../../resources/strings.dart';

class CalenderDetailScreen extends StatelessWidget {
  final String eventId;
  const CalenderDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppString.appName),
    );
  }
}
