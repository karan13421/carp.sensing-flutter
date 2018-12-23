/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of audio;

/// A probe recording audio from the microphone.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// Use a [AudioMeasure] to configure this probe, including setting the
/// [frequency] and [duration] of the sampling rate.
///
/// Also note that this probe records raw sound directly from the microphone and hence
/// records everything - including human speech - in its vicinity.
///
/// The Audio probe generates an [AudioDatum] that holds the meta-data for each recording
/// along with the actual recording in an audio file. How to upload this data to a  data backend
/// if up to the implementation of a [DataManager] to decide.
class AudioProbe extends ListeningProbe {
  static final String AUDIO_FILE_PATH = 'audio';

  String studyId;
  String _path;
  FlutterSound flutterSound;
  String soundFileName;
  bool _isRecording = false;
  DateTime _startRecordingTime;
  DateTime _endRecordingTime;

  Stream<Datum> get stream => null;

  // Initialize an audio probe taking a [SensorMeasure] as configuration.
  AudioProbe(AudioMeasure _measure)
      : assert(_measure != null),
        super(_measure);

  @override
  void initialize() {
    flutterSound = new FlutterSound();
    super.initialize();
  }

  @override
  Future start() async {
    super.start();

    // create sound dir and initialize
    await path;

    // Define the probe sampling frequency
    // (not related to audio file sampling rate)
    int _frequency = (measure as AudioMeasure).frequency;
    Duration _pause = new Duration(milliseconds: _frequency);
    int _duration = (measure as AudioMeasure).duration;
    studyId = (measure as AudioMeasure).studyId;

    Duration _samplingDuration = new Duration(milliseconds: _duration);

    // create a recurrent timer that wait (pause) and then resume the sampling.
    Timer.periodic(_pause, (Timer timer) {
      this.resume();

      // create a timer that stops the sampling after the specified duration.
      new Timer(_samplingDuration, () {
        this.pause();
      });
    });
  }

  @override
  void stop() {
    flutterSound = null;
  }

  @override
  void resume() {
    startAudioRecording();
  }

  @override
  void pause() async {
    Datum _datum = await datum;
    if (_datum != null) this.notifyAllListeners(_datum);
  }

  void startAudioRecording() async {
    if (_isRecording) return;
    try {
      soundFileName = await filePath;
      _startRecordingTime = DateTime.now();
      await flutterSound.startRecorder(soundFileName);
      _isRecording = true;
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  Future<String> stopAudioRecording() async {
    String result = await flutterSound.stopRecorder();
    _endRecordingTime = DateTime.now();
    _isRecording = false;
    return result;
  }

  Future<Datum> get datum async {
    try {
      String result = await stopAudioRecording();
      if (result != null) {
        String filename = soundFileName.split("/").last;
        AudioDatum datum = new AudioDatum(
            measure: measure,
            filename: filename,
            startRecordingTime: _startRecordingTime,
            endRecordingTime: _endRecordingTime);
        return datum;
      } else {
        return ErrorDatum(measure: measure, message: "No sound recording");
      }
    } catch (err) {
      return ErrorDatum(measure: measure, message: "SoundProbe error - $err");
    }
  }

  ///Returns the local path on the device where sound files can be stored.
  ///Creates the directory, if not existing.
  Future<String> get path async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for sound files
      final directory =
          await Directory('${localApplicationDir.path}/${FileDataManager.CARP_FILE_PATH}/${studyId}/$AUDIO_FILE_PATH')
              .create(recursive: true);

      _path = directory.path;
    }
    return _path;
  }

  /// Returns the full file path to the sound file.
  /// The filename format is "audio-yyyy-mm-dd-hh-mm-ss-ms.m4a".
  Future<String> get filePath async {
    String dir = await path;
    String created =
        DateTime.now().toString().replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-").replaceAll(".", "-");
    return "$dir/audio-$created.m4a";
  }
}
