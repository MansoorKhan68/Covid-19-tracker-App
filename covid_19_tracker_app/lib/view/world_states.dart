import 'package:covid_19_tracker_app/model/world_states_model.dart';
import 'package:covid_19_tracker_app/services/states_services.dart';
import 'package:covid_19_tracker_app/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = const <Color>[
    Color(0xff4285f4), // Total cases color
    Color(0xff1aa260), // Recovered color
    Color(0xffde5246), // Deaths color
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    // Show the loading spinner if data is not yet available
                    return Expanded(
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ),
                      ),
                    );
                  } else {
                    // When data is available, display the charts and data rows
                    return Expanded(
                      child: Column(
                        children: [
                          PieChart(
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true),
                            chartRadius:
                                MediaQuery.of(context).size.width / 3.2,
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left),
                            dataMap: {
                              "Total": double.parse(
                                  snapshot.data!.cases!.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered!.toString()),
                              "Deaths": double.parse(
                                  snapshot.data!.deaths!.toString()),
                            },
                            animationDuration:
                                const Duration(milliseconds: 1200),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.06),
                          Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                    title: "Total Cases",
                                    value: snapshot.data!.cases!.toString()),
                                ReusableRow(
                                    title: "Recovered",
                                    value:
                                        snapshot.data!.recovered!.toString()),
                                ReusableRow(
                                    title: "Deaths",
                                    value: snapshot.data!.deaths!.toString()),
                                ReusableRow(
                                    title: "Active",
                                    value: snapshot.data!.active!.toString()),
                                ReusableRow(
                                    title: "Critical",
                                    value: snapshot.data!.critical!.toString()),
                                ReusableRow(
                                    title: "Today Recover",
                                    value: snapshot.data!.todayRecovered!
                                        .toString()),
                                ReusableRow(
                                    title: "Today Deaths",
                                    value:
                                        snapshot.data!.todayDeaths!.toString()),
                              ],
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.06),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CountriesListScreen()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xff1aa260),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text("Track Countries"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// REUSABLE ROW

class ReusableRow extends StatelessWidget {
  final String title, value;
  const ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(height: 5),
          const Divider()
        ],
      ),
    );
  }
}
