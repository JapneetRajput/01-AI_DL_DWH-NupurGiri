import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RidesRecord extends FirestoreRecord {
  RidesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Ride" field.
  int? _ride;
  int get ride => _ride ?? 0;
  bool hasRide() => _ride != null;

  // "Timestamp" field.
  int? _timestamp;
  int get timestamp => _timestamp ?? 0;
  bool hasTimestamp() => _timestamp != null;

  // "Battery_Current" field.
  int? _batteryCurrent;
  int get batteryCurrent => _batteryCurrent ?? 0;
  bool hasBatteryCurrent() => _batteryCurrent != null;

  // "Motor_Temperature" field.
  int? _motorTemperature;
  int get motorTemperature => _motorTemperature ?? 0;
  bool hasMotorTemperature() => _motorTemperature != null;

  // "Battery_Voltage" field.
  double? _batteryVoltage;
  double get batteryVoltage => _batteryVoltage ?? 0.0;
  bool hasBatteryVoltage() => _batteryVoltage != null;

  // "Motor_RPM" field.
  int? _motorRPM;
  int get motorRPM => _motorRPM ?? 0;
  bool hasMotorRPM() => _motorRPM != null;

  // "Brake_Pressure" field.
  int? _brakePressure;
  int get brakePressure => _brakePressure ?? 0;
  bool hasBrakePressure() => _brakePressure != null;

  // "Battery_State_Indicator" field.
  String? _batteryStateIndicator;
  String get batteryStateIndicator => _batteryStateIndicator ?? '';
  bool hasBatteryStateIndicator() => _batteryStateIndicator != null;

  void _initializeFields() {
    _ride = castToType<int>(snapshotData['Ride']);
    _timestamp = castToType<int>(snapshotData['Timestamp']);
    _batteryCurrent = castToType<int>(snapshotData['Battery_Current']);
    _motorTemperature = castToType<int>(snapshotData['Motor_Temperature']);
    _batteryVoltage = castToType<double>(snapshotData['Battery_Voltage']);
    _motorRPM = castToType<int>(snapshotData['Motor_RPM']);
    _brakePressure = castToType<int>(snapshotData['Brake_Pressure']);
    _batteryStateIndicator = snapshotData['Battery_State_Indicator'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Rides');

  static Stream<RidesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RidesRecord.fromSnapshot(s));

  static Future<RidesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RidesRecord.fromSnapshot(s));

  static RidesRecord fromSnapshot(DocumentSnapshot snapshot) => RidesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RidesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RidesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RidesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RidesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRidesRecordData({
  int? ride,
  int? timestamp,
  int? batteryCurrent,
  int? motorTemperature,
  double? batteryVoltage,
  int? motorRPM,
  int? brakePressure,
  String? batteryStateIndicator,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Ride': ride,
      'Timestamp': timestamp,
      'Battery_Current': batteryCurrent,
      'Motor_Temperature': motorTemperature,
      'Battery_Voltage': batteryVoltage,
      'Motor_RPM': motorRPM,
      'Brake_Pressure': brakePressure,
      'Battery_State_Indicator': batteryStateIndicator,
    }.withoutNulls,
  );

  return firestoreData;
}

class RidesRecordDocumentEquality implements Equality<RidesRecord> {
  const RidesRecordDocumentEquality();

  @override
  bool equals(RidesRecord? e1, RidesRecord? e2) {
    return e1?.ride == e2?.ride &&
        e1?.timestamp == e2?.timestamp &&
        e1?.batteryCurrent == e2?.batteryCurrent &&
        e1?.motorTemperature == e2?.motorTemperature &&
        e1?.batteryVoltage == e2?.batteryVoltage &&
        e1?.motorRPM == e2?.motorRPM &&
        e1?.brakePressure == e2?.brakePressure &&
        e1?.batteryStateIndicator == e2?.batteryStateIndicator;
  }

  @override
  int hash(RidesRecord? e) => const ListEquality().hash([
        e?.ride,
        e?.timestamp,
        e?.batteryCurrent,
        e?.motorTemperature,
        e?.batteryVoltage,
        e?.motorRPM,
        e?.brakePressure,
        e?.batteryStateIndicator
      ]);

  @override
  bool isValidKey(Object? o) => o is RidesRecord;
}
