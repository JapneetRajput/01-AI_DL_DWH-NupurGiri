import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'diag2_model.dart';
export 'diag2_model.dart';

class Diag2Widget extends StatefulWidget {
  const Diag2Widget({Key? key}) : super(key: key);

  @override
  _Diag2WidgetState createState() => _Diag2WidgetState();
}

class _Diag2WidgetState extends State<Diag2Widget> {
  late Diag2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Diag2Model());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Page Title',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                  color: Colors.white,
                  fontSize: 22.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).headlineMediumFamily),
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 362.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-0.60, 0.27),
                      child: StreamBuilder<List<RidesRecord>>(
                        stream: queryRidesRecord(
                          queryBuilder: (ridesRecord) =>
                              ridesRecord.orderBy('Timestamp'),
                          limit: 5,
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<RidesRecord> chartRidesRecordList =
                              snapshot.data!;
                          return Container(
                            width: 370.0,
                            height: 230.0,
                            child: FlutterFlowLineChart(
                              data: [
                                FFLineChartData(
                                  xData: chartRidesRecordList
                                      .map((d) => d.batteryCurrent)
                                      .toList(),
                                  yData: chartRidesRecordList
                                      .map((d) => d.timestamp)
                                      .toList(),
                                  settings: LineChartBarData(
                                    color: FlutterFlowTheme.of(context)
                                        .filledProgressBattery,
                                    barWidth: 2.0,
                                    isCurved: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: FlutterFlowTheme.of(context)
                                          .filledProgressBattery,
                                    ),
                                  ),
                                ),
                                FFLineChartData(
                                  xData: chartRidesRecordList
                                      .take(1)
                                      .toList()
                                      .map((d) => d.timestamp)
                                      .toList(),
                                  yData: chartRidesRecordList
                                      .take(1)
                                      .toList()
                                      .map((d) => d.batteryCurrent)
                                      .toList(),
                                  settings: LineChartBarData(
                                    color: Color(0xFF6F28CB),
                                    barWidth: 2.0,
                                    isCurved: true,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color:
                                          FlutterFlowTheme.of(context).accent1,
                                    ),
                                  ),
                                )
                              ],
                              chartStylingInfo: ChartStylingInfo(
                                backgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                showBorder: false,
                              ),
                              axisBounds: AxisBounds(),
                              xAxisLabelInfo: AxisLabelInfo(
                                showLabels: true,
                                labelInterval: 10.0,
                              ),
                              yAxisLabelInfo: AxisLabelInfo(
                                showLabels: true,
                                labelInterval: 10.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
