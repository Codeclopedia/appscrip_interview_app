import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = StateProvider.autoDispose<bool>((ref) => false);
final registerProvider = StateProvider.autoDispose<bool>((ref) => false);
