import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_quest/configs/color/color.dart';
import 'package:team_quest/configs/components/network_image_widget.dart';
import 'package:team_quest/configs/routes/routes_name.dart';
import 'package:team_quest/services/auth_services.dart';
import 'package:team_quest/view/auth/widgets/login_button_widget.dart';
import 'package:team_quest/view_model/home/home_view_model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AuthService {
  @override
  void initState() {
    super.initState();
    // Start listening to real-time updates from Firebase
    Future.microtask(() =>
        Provider.of<HomeViewModel>(context, listen: false).listenToEvents());
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: const Text('Messages',
              style: TextStyle(fontSize: 24, color: AppColors.whiteColor)),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.whiteColor),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.whiteColor),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
              indicatorColor: AppColors.blackColor,
              labelColor: AppColors.blackColor,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Events'),
                Tab(text: 'Teams'),
                Tab(text: 'Tasks'),
                Tab(text: 'Equipment'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildEventsTab(homeViewModel), // First tab content
                  buildTeamsTab(), // Second tab content
                  buildTasksTab(), // Third tab content
                  buildEquipmentTab(), // Fourth tab content
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.add_event,
          backgroundColor: AppColors.blackColor,
          animatedIconTheme: const IconThemeData(color: AppColors.whiteColor),
          overlayColor: AppColors.blackColor,
          overlayOpacity: 0.5,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.event),
              label: 'New Message',
              onTap: () => print('Create Task'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.task),
              label: 'Team Invite',
              onTap: () => print('Create Task'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.group_add),
              label: 'Create Task',
              onTap: () => print('Team Invite'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.message),
              label: 'Create Event',
              onTap: () => Navigator.pushNamed(context, RoutesName.createEvent),
            ),
          ],
        ),
      ),
    );
  }

  // Widget buildEventsTab() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         TextField(
  //           decoration: InputDecoration(
  //             hintText: 'Search here!',
  //             prefixIcon: const Icon(Icons.search),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //         const Text('Recent',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 16),
  //         Expanded(
  //           child: ListView(
  //             children: const [
  //               EventCard(
  //                 imageUrl:
  //                     'https://dummyimage.com/300x200/000/fff', // Replace with your image URL
  //                 eventName: 'Event Name',
  //                 description: 'Description',
  //                 location: 'Location',
  //                 dateTime: 'Date and time',
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildEventsTab(HomeViewModel homeViewModel) {
    if (homeViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (homeViewModel.errorMessage.isNotEmpty) {
      return Center(child: Text(homeViewModel.errorMessage));
    }

    if (homeViewModel.events.isEmpty) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add a New Event!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              'Invite the New Location Admins to their new Event and Management App',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ));
    }

    return ListView.builder(
      itemCount: homeViewModel.events.length,
      itemBuilder: (context, index) {
        final event = homeViewModel.events[index];
        return EventCard(
          imageUrl: event.imageUrl ?? 'https://dummyimage.com/300x200/000/fff',
          eventName: event.eventName,
          description: event.description,
          location: event.location,
          dateTime: '${event.date} at ${event.time}',
        );
      },
    );
  }

  Widget buildTeamsTab() {
    return const Center(child: Text('Teams Tab Content'));
  }

  Widget buildTasksTab() {
    return const Center(child: Text('Tasks Tab Content'));
  }

  Widget buildEquipmentTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: PrimaryButton(
          title: "Logout",
          onPress: () async {
            bool result = await onLogOut();
            if (result && mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.login, (route) => false);
            }
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String eventName;
  final String description;
  final String location;
  final String dateTime;

  const EventCard({
    Key? key,
    required this.imageUrl,
    required this.eventName,
    required this.description,
    required this.location,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.greyColor.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            NetworkImageWidget(
              borderRadius: 06,
              imageUrl: imageUrl,
              height: 80,
              width: 80,
              boxFit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.blackColor)),
                  const SizedBox(height: 4),
                  Text(location,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.blackColor)),
                  const SizedBox(height: 4),
                  Text(dateTime,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.blackColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
