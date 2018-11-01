/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// An [AudioDatum] that holds bytes of an audio file.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AudioDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.AUDIO_MEASURE);

  /// Audio bytes recorded with the microphone.
  List<int> audioBytes;

  AudioDatum({this.audioBytes}) : super(includeDeviceInfo: false);

  factory AudioDatum.fromJson(Map<String, dynamic> json) => _$AudioDatumFromJson(json);
  Map<String, dynamic> toJson() => _$AudioDatumToJson(this);

  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  String toString() => 'Audio bytes length: ${audioBytes.length}';
}
