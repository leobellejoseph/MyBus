import 'package:equatable/equatable.dart';

class Favorite extends Equatable {
  final String busStopCode;
  final String serviceNo;
  final String description;
  const Favorite({
    required this.busStopCode,
    required this.serviceNo,
    required this.description,
  });
  factory Favorite.empty() =>
      const Favorite(busStopCode: '', serviceNo: '', description: '');
  factory Favorite.fromJson(Map<String, dynamic> data) {
    final busStopCode = data['busStopCode'] ?? '';
    final serviceNo = data['serviceNo'] ?? '';
    final description = data['description'] ?? '';
    return Favorite(
        busStopCode: busStopCode,
        serviceNo: serviceNo,
        description: description);
  }
  @override
  List<Object?> get props =>
      [this.busStopCode, this.serviceNo, this.description];
}
