import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

DateTime? convertToMonth(int timeStamp) {
  // Convert Firebase timestamp to DateTime
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

  // Format the month as a string in "yyyy-MM" format
  DateTime monthDateTime = DateTime(dateTime.year, dateTime.month);

  return monthDateTime;
}

dynamic newCustomFunction(
  List<RidesRecord> documents,
  String diagnostic,
  bool isMonthly,
) {
  Map<int, double> result = {};
  DateTime currentDate = DateTime.now();
  DateTime startDate;

  if (isMonthly) {
    // Calculate start date for monthly sum (last 5 months)
    startDate = currentDate.subtract(Duration(days: 30 * 5));
  } else {
    // Calculate start date for weekly sum (past 7 days)
    startDate = currentDate.subtract(Duration(days: 7));
  }

  for (var document in documents) {
    int timestamp = document.timestamp;
    // int batteryCurrent = document.batteryCurrent;
    double valueToSum;

    if (diagnostic == 'Current') {
      valueToSum = document.batteryCurrent.toDouble();
    } else if (diagnostic == 'Voltage') {
      valueToSum = document.batteryVoltage;
      // Assuming there is a batteryVoltage property in the RidesRecord class
    } else if (diagnostic == 'Temp') {
      valueToSum = document.motorTemperature.toDouble();
    } else if (diagnostic == 'Brake') {
      valueToSum = document.brakePressure.toDouble();
    } else {
      // Handle unsupported diagnostic values or provide a default behavior
      throw ArgumentError('Unsupported diagnostic value: $diagnostic');
    }

    // Convert timestamp to DateTime
    DateTime rideDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Check if the rideDateTime is within the last 5 months
    if (rideDateTime.isAfter(startDate)) {
      // Extract month from DateTime
      int key = isMonthly ? rideDateTime.month : rideDateTime.day;

      // Update the sum of Battery_Current for the corresponding month
      result[key] = (result[key] ?? 0) + valueToSum;
    }
  }

  // Sort the keys in ascending order
  List<int> sortedKeys = result.keys.toList()..sort();

  // Create a new map with sorted keys
  Map<int, double> sortedResult = {};
  for (var key in sortedKeys) {
    sortedResult[key] = result[key]!;
  }

  return sortedResult;
  // return result;
}

dynamic testFunction(
  String diagnostic,
  bool isMonthly,
  List<RidesRecord> documents,
) {
  Map<int, double> result = {};
  DateTime currentDate = DateTime.now();
  DateTime startDate;

  if (isMonthly) {
    // Calculate start date for monthly sum (last 5 months)
    startDate = currentDate.subtract(Duration(days: 30 * 5));
  } else {
    // Calculate start date for weekly sum (past 7 days)
    startDate = currentDate.subtract(Duration(days: 7));
  }

  for (var document in documents) {
    int timestamp = document.timestamp;
    // int batteryCurrent = document.batteryCurrent;
    double valueToSum;

    if (diagnostic == 'RPM') {
      valueToSum = document.motorRPM.toDouble();
    } else if (diagnostic == 'Voltage') {
      valueToSum = document.batteryVoltage;
      // Assuming there is a batteryVoltage property in the RidesRecord class
    } else {
      // Handle unsupported diagnostic values or provide a default behavior
      throw ArgumentError('Unsupported diagnostic value: $diagnostic');
    }

    // Convert timestamp to DateTime
    DateTime rideDateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Check if the rideDateTime is within the last 5 months
    if (rideDateTime.isAfter(startDate)) {
      // Extract month from DateTime
      int key = isMonthly ? rideDateTime.month : rideDateTime.day;

      // Update the sum of Battery_Current for the corresponding month
      result[key] = (result[key] ?? 0) + valueToSum;
    }
  }

  // Sort the keys in ascending order
  List<int> sortedKeys = result.keys.toList()..sort();

  // Create a new map with sorted keys
  Map<int, double> sortedResult = {};
  for (var key in sortedKeys) {
    sortedResult[key] = result[key]!;
  }

  return sortedResult;
}
