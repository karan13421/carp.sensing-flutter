// GENERATED CODE - DO NOT MODIFY BY HAND

part of apps;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppsDatum _$AppsDatumFromJson(Map<String, dynamic> json) {
  return AppsDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..installedApps =
        (json['installed_apps'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$AppsDatumToJson(AppsDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('installed_apps', instance.installedApps);
  return val;
}

AppUsageDatum _$AppUsageDatumFromJson(Map<String, dynamic> json) {
  return AppUsageDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..deviceInfo = json['device_info'] == null
        ? null
        : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>)
    ..usage = (json['usage'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, (e as num)?.toDouble()));
}

Map<String, dynamic> _$AppUsageDatumToJson(AppUsageDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('device_info', instance.deviceInfo);
  writeNotNull('usage', instance.usage);
  return val;
}
