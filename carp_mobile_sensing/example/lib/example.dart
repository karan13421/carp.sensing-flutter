import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is the code for the very minimal example used in the README.md file.
void example() {
  Study study = Study("1234", "bardram", name: "bardram study");
  study.dataEndPoint = FileDataEndPoint()
    ..bufferSize = 50 * 1000
    ..zip = true
    ..encrypt = false;

  study.addTask(Task('Location Task')..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.LOCATION))));

  study.addTask(ParallelTask('Sensor Task')
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.ACCELEROMETER),
        frequency: 10 * 1000, // sample every 10 secs
        duration: 100 // for 100 ms
        ))
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.GYROSCOPE),
        frequency: 20 * 1000, // sample every 20 secs
        duration: 100 // for 100 ms
        )));

  study.addTask(Task('Audio Recording Task')
    ..addMeasure(AudioMeasure(MeasureType(NameSpace.CARP, DataType.AUDIO),
        frequency: 10 * 60 * 1000, // sample sound every 10 min
        duration: 10 * 1000, // for 10 secs
        studyId: study.id))
    ..addMeasure(NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
        frequency: 10 * 60 * 1000, // sample sound every 10 min
        duration: 10 * 1000, // for 10 secs
        samplingRate: 500 // configure sampling rate to 500 ms
        )));

  study.addTask(SequentialTask('Sample Activity with Weather Task')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.ACTIVITY))..configuration['jakob'] = 'was here')
    ..addMeasure(PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.WEATHER))));

  study.addTask(SequentialTask('Task collecting a list of all installed apps')
    ..addMeasure(Measure(MeasureType(NameSpace.CARP, DataType.APPS))));

  // Create a Study Manager that can manage this study, initialize it, and start it.
  StudyManager manager =
      StudyManager(study, transformer: ((events) => events.where((event) => (event is BatteryDatum))));

  manager = StudyManager(study,
      transformer: ((events) => events.map((datum) {
            PrivacySchema.full().protect(datum);
          })));

  //manager = StudyManager(study, transformer: ((events) => events.transform(streamTransformer)));
  manager.initialize();
  manager.start();

  // listening on all data events from the study
  manager.events.forEach(print);

  // listening on a specific probe
  ProbeRegistry.probes[DataType.LOCATION].events.forEach(print);
}
