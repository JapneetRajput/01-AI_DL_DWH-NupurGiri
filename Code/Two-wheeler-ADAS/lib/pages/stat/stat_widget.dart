import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'stat_model.dart';
export 'stat_model.dart';

class StatWidget extends StatefulWidget {
  const StatWidget({Key? key}) : super(key: key);

  @override
  _StatWidgetState createState() => _StatWidgetState();
}

class _StatWidgetState extends State<StatWidget> with TickerProviderStateMixin {
  late StatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: Offset(-40.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatModel());

    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
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

    final chartPieChartColorsList6 = [Color(0xFF01A74F), Color(0xFFEF343A)];
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
          leading: Container(
            decoration: BoxDecoration(),
            child: Text(
              dateTimeFormat('d/M h:mm a', getCurrentTimestamp),
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ),
          title: Align(
            alignment: AlignmentDirectional(0.00, 0.00),
            child: AutoSizeText(
              'Rider Statistics',
              style: FlutterFlowTheme.of(context).headlineLarge,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if ((Theme.of(context).brightness == Brightness.light) ==
                      true) {
                    setDarkModeSetting(context, ThemeMode.dark);
                    if (animationsMap['containerOnActionTriggerAnimation'] !=
                        null) {
                      animationsMap['containerOnActionTriggerAnimation']!
                          .controller
                          .forward(from: 0.0);
                    }
                  } else {
                    setDarkModeSetting(context, ThemeMode.light);
                    if (animationsMap['containerOnActionTriggerAnimation'] !=
                        null) {
                      animationsMap['containerOnActionTriggerAnimation']!
                          .controller
                          .reverse();
                    }
                  }
                },
                child: Container(
                  width: 80.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
                    child: Stack(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.90, 0.00),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                6.0, 0.0, 0.0, 0.0),
                            child: Icon(
                              Icons.wb_sunny_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.00, 0.00),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 6.0, 0.0),
                            child: Icon(
                              Icons.mode_night_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.00, 0.00),
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x430B0D0F),
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(30.0),
                              shape: BoxShape.rectangle,
                            ),
                          ).animateOnActionTrigger(
                            animationsMap['containerOnActionTriggerAnimation']!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowLineChart(
                        data: [
                          FFLineChartData(
                            xData: List.generate(
                                random_data.randomInteger(3, 3),
                                (index) => random_data.randomInteger(0, 10)),
                            yData: List.generate(
                                random_data.randomInteger(3, 3),
                                (index) => random_data.randomInteger(0, 10)),
                            settings: LineChartBarData(
                              color: FlutterFlowTheme.of(context)
                                  .filledProgressBattery,
                              barWidth: 2.0,
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color(0x00000000),
                              ),
                            ),
                          )
                        ],
                        chartStylingInfo: ChartStylingInfo(
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          showGrid: true,
                          borderWidth: 1.0,
                        ),
                        axisBounds: AxisBounds(),
                        xAxisLabelInfo: AxisLabelInfo(),
                        yAxisLabelInfo: AxisLabelInfo(),
                      ),
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowLineChart(
                        data: [
                          FFLineChartData(
                            xData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(1, 30)),
                            yData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(0, 10)),
                            settings: LineChartBarData(
                              color: Color(0xFF2772FF),
                              barWidth: 2.0,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color(0x402772FF),
                              ),
                            ),
                          )
                        ],
                        chartStylingInfo: ChartStylingInfo(
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderColor: FlutterFlowTheme.of(context).primaryText,
                          borderWidth: 1.0,
                        ),
                        axisBounds: AxisBounds(),
                        xAxisLabelInfo: AxisLabelInfo(
                          title: 'date',
                          titleTextStyle:
                              FlutterFlowTheme.of(context).bodySmall,
                        ),
                        yAxisLabelInfo: AxisLabelInfo(
                          title: 'Driving time',
                          titleTextStyle:
                              FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowLineChart(
                        data: [
                          FFLineChartData(
                            xData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(1, 30)),
                            yData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(0, 50)),
                            settings: LineChartBarData(
                              color: Color(0xFFE4DB27),
                              barWidth: 2.0,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color(0x40FFFF1A),
                              ),
                            ),
                          )
                        ],
                        chartStylingInfo: ChartStylingInfo(
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderColor: FlutterFlowTheme.of(context).primaryText,
                          borderWidth: 1.0,
                        ),
                        axisBounds: AxisBounds(),
                        xAxisLabelInfo: AxisLabelInfo(
                          title: 'date',
                          titleTextStyle:
                              FlutterFlowTheme.of(context).bodySmall,
                        ),
                        yAxisLabelInfo: AxisLabelInfo(
                          title: 'average speed',
                          titleTextStyle:
                              FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowLineChart(
                        data: [
                          FFLineChartData(
                            xData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(1, 30)),
                            yData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(0, 5)),
                            settings: LineChartBarData(
                              color: Color(0xFF9600EF),
                              barWidth: 2.0,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color(0x409300EF),
                              ),
                            ),
                          )
                        ],
                        chartStylingInfo: ChartStylingInfo(
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderColor: FlutterFlowTheme.of(context).primaryText,
                          borderWidth: 1.0,
                        ),
                        axisBounds: AxisBounds(),
                        xAxisLabelInfo: AxisLabelInfo(
                          title: 'date',
                          titleTextStyle:
                              FlutterFlowTheme.of(context).bodySmall,
                        ),
                        yAxisLabelInfo: AxisLabelInfo(
                          title: 'acceleration',
                          titleTextStyle:
                              FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowPieChart(
                        data: FFPieChartData(
                          values: [random_data.randomInteger(1, 10)],
                          colors: [Color(0xFF72B4EB)],
                          radius: [40.0],
                          borderWidth: [5.0],
                        ),
                        donutHoleRadius: 30.0,
                        donutHoleColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        sectionLabelType: PieChartSectionLabelType.percent,
                        sectionLabelStyle: FlutterFlowTheme.of(context)
                            .titleLarge
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              fontSize: 17.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .titleLargeFamily),
                            ),
                        labelFormatter: LabelFormatter(
                          numberFormat: (val) => val.toString(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Container(
                      width: 332.0,
                      height: 230.0,
                      child: FlutterFlowPieChart(
                        data: FFPieChartData(
                          values: List.generate(random_data.randomInteger(1, 3),
                              (index) => random_data.randomInteger(0, 10)),
                          colors: chartPieChartColorsList6,
                          radius: [25.0],
                          borderWidth: [1.0],
                          borderColor: [FlutterFlowTheme.of(context).secondary],
                        ),
                        donutHoleRadius: 45.0,
                        donutHoleColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        sectionLabelType: PieChartSectionLabelType.percent,
                        sectionLabelStyle: FlutterFlowTheme.of(context)
                            .labelLarge
                            .override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).labelLargeFamily,
                              color:
                                  FlutterFlowTheme.of(context).settingsButtons,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .labelLargeFamily),
                            ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Container(
                      width: 370.0,
                      height: 230.0,
                      child: FlutterFlowBarChart(
                        barData: [
                          FFBarChartData(
                            yData: List.generate(
                                random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(0, 10)),
                            color: Color(0xFF2772FF),
                            borderWidth: 1.0,
                            borderColor:
                                FlutterFlowTheme.of(context).primaryText,
                          )
                        ],
                        xLabels: List.generate(random_data.randomInteger(1, 5),
                                (index) => random_data.randomInteger(1, 30))
                            .map((e) => e.toString())
                            .toList(),
                        barWidth: 10.0,
                        barBorderRadius: BorderRadius.circular(0.0),
                        groupSpace: 10.0,
                        chartStylingInfo: ChartStylingInfo(
                          backgroundColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderColor: FlutterFlowTheme.of(context).secondary,
                          borderWidth: 1.0,
                        ),
                        axisBounds: AxisBounds(
                          maxY: 100.0,
                        ),
                        xAxisLabelInfo: AxisLabelInfo(
                          title: 'date',
                          titleTextStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        yAxisLabelInfo: AxisLabelInfo(
                          title: 'driver score',
                          titleTextStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ].addToEnd(SizedBox(height: 10.0)),
          ),
        ),
      ),
    );
  }
}
