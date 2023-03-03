import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_project/app/data/entertainment_response.dart';
import 'package:mobile_project/app/data/sports_response.dart';
import 'package:mobile_project/app/data/technology_response.dart';
import 'package:mobile_project/app/modules/home/views/home_view.dart';

import '../../../data/headline_response.dart';
import '../controllers/dashboard_controller.dart';


class DashboardView extends GetView<DashboardController> {

  @override
  Widget build(BuildContext context) {  
    DashboardController controller = Get.put(DashboardController());
    final ScrollController scrollController = ScrollController();
    final auth = GetStorage();

    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await auth.erase();
              Get.offAll(() => HomeView());
            },
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.logout_rounded),
          ),

          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Hallo",
                    textAlign: TextAlign.end,
                  ),
                  subtitle: Text(
                    auth.read('full_name').toString(),
                    textAlign: TextAlign.end,
                  ),

                  trailing: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 50.0,
                    height: 50.0,
                    child: Lottie.network(
                      'https://gist.githubusercontent.com/olipiskandar/2095343e6b34255dcfb042166c4a3283/raw/d76e1121a2124640481edcf6e7712130304d6236/praujikom_kucing.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: TabBar(
                    labelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(text: "Headline"),
                      Tab(text: "Teknologi"),
                      Tab(text: "Olahraga"),
                      Tab(text: "Hiburan"),
                      Tab(text: "Profile"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          body: TabBarView(
            children: [
              headline(controller, scrollController),
              technology(controller, scrollController),
              sports(controller, scrollController),
              entertaiment(controller, scrollController),
              Center(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                              //set border radius more than 50% of height and width to make circle
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 30,
                                child: ClipOval(
                                  child: Image.network(
                                      'data:image/png;base64,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'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          child: Card(
                            child: Wrap(
                              children: [
                                ListTile(
                                  title: Text('Github Account'),
                                  subtitle: Text('@tasyaa01.github'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          child: Card(
                            child: Wrap(
                              children: [
                                ListTile(
                                  title: Text('Tasyaa'),
                                  subtitle: Text('XII RPL 3'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: 1,
                ),
              ),
            ],  
          ),

        ),
      ),
    );
  }

  FutureBuilder<HeadlineResponse> headline(DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<HeadlineResponse>(
      future: controller.getHeadline(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<TechnologyResponse> technology(DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<TechnologyResponse>(
      future: controller.getTechnology(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<SportsResponse> sports(DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<SportsResponse>(
      future: controller.getSports(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FutureBuilder<EntertainmentResponse> entertaiment(DashboardController controller, ScrollController scrollController) {
    return FutureBuilder<EntertainmentResponse>(
      future: controller.getEntertaiment  (),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.network(
              'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
              repeat: true,
              width: MediaQuery.of(context).size.width / 1,
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.data!.length,
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 8,
                right: 8,
                bottom: 5,
              ),
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      snapshot.data!.data![index].urlToImage.toString(),
                      height: 130,
                      width: 130,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snapshot.data!.data![index].title.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Author : ${snapshot.data!.data![index].author}'),
                            Text('Sumber :${snapshot.data!.data![index].name}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}