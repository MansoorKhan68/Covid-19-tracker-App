import 'package:covid_19_tracker_app/services/states_services.dart';
import 'package:covid_19_tracker_app/view/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  // search controller
  TextEditingController searchController = TextEditingController();
  StatesServices statesServices = StatesServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search With Country Name",
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: statesServices.countriesListApi(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    // Show the loading spinner if data is not yet available
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                title: Container(
                                  height: 10,
                                  width: 90,
                                  color: Colors.white,
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: 90,
                                  color: Colors.white,
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    // When data is available, display the charts and data rows
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // initialize name for country search
                        String name = snapshot.data![index]['country'];
                        if (searchController.text.isEmpty) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                                image: snapshot.data![index]
                                                            ['countryInfo']
                                                        ['flag'] ??
                                                    '', // Use a default empty string if null
                                                name: snapshot.data![index]
                                                        ['country'] ??
                                                    'Unknown Country', // Default name
                                                totalCases:
                                                    snapshot.data![index]
                                                            ['cases'] ??
                                                        0,
                                                totalDeaths:
                                                    snapshot.data![index]
                                                            ['deaths'] ??
                                                        0,
                                                totalRecovered:
                                                    snapshot.data![index]
                                                            ['recovered'] ??
                                                        0,
                                                active: snapshot.data![index]
                                                        ['active'] ??
                                                    0,
                                                critical: snapshot.data![index]
                                                        ['critical'] ??
                                                    0,
                                                todayRecovered: snapshot
                                                            .data![index]
                                                        ['todayRecovered'] ??
                                                    0,
                                                test: snapshot.data![index]
                                                        ['tests'] ??
                                                    0,
                                              )));
                                },
                                child: ListTile(
                                  title: Text(snapshot.data![index]['country']
                                      .toString()),
                                  subtitle: Text(snapshot.data![index]['cases']
                                      .toString()),
                                  leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(snapshot.data![index]
                                        ['countryInfo']['flag']),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else if (name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase())) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        image: snapshot.data![index]
                                                ['countryInfo']['flag'] ??
                                            '', // Use a default empty string if null
                                        name: snapshot.data![index]
                                                ['country'] ??
                                            'Unknown Country', // Default name
                                        totalCases:
                                            snapshot.data![index]['cases'] ?? 0,
                                        totalDeaths: snapshot.data![index]
                                                ['deaths'] ??
                                            0,
                                        totalRecovered: snapshot.data![index]
                                                ['recovered'] ??
                                            0,
                                        active: snapshot.data![index]
                                                ['active'] ??
                                            0,
                                        critical: snapshot.data![index]
                                                ['critical'] ??
                                            0,
                                        todayRecovered: snapshot.data![index]
                                                ['todayRecovered'] ??
                                            0,
                                        test:
                                            snapshot.data![index]['tests'] ?? 0,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(snapshot.data![index]['country']
                                      .toString()),
                                  subtitle: Text(
                                      snapshot.data![index]['cases'].toString()),
                                  leading: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(snapshot.data![index]
                                        ['countryInfo']['flag']),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                }),
          ),
        ],
      )),
    );
  }
}
