import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lilac_test/constatnts/styles.dart';
import 'package:lilac_test/data/local/provider/auth_provider.dart';
import 'package:lilac_test/data/local/provider/video_provider.dart';
import 'package:lilac_test/data/models/user_model.dart';
import 'package:lilac_test/main.dart';
import 'package:lilac_test/presentation/screens/profile.dart';
import 'package:lilac_test/widgets/nav_button_widget.dart';
import 'package:lilac_test/widgets/video_player_widget.dart';
import 'package:pod_player/pod_player.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthProvider authProvider = AuthProvider();
  VideoProvider videoProvider = VideoProvider();
  List<String> videoUrls = [];
  UserModel userModel = UserModel();
  bool isLoading = false;
  late PageController _pageController;
  int totalPages = 0;
  int activePage = 0;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    userModel = (await authProvider.fetchFromLocal())!;
    videoUrls = await videoProvider.fetchVideos();
    _pageController = PageController();

    totalPages = videoUrls.length;

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String loadingText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 38.0, horizontal: 18),
          child: Column(
            children: [
              ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => ProfileScreen(
                      userModel: userModel,
                    ),
                  ),
                ),
                title: const Text('Profile'),
              ),
              ListTile(
                onTap: () {
                  MyApp.themeNotifier.value = MyApp.themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                },
                title: const Text('Change Theme'),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 50),
                videoUrls.isEmpty
                    ? Center(
                        child: Text('No Videos Found'),
                      )
                    : Stack(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _pageController,
                              itemBuilder: (c, pp) {
                                return VideoPlayerWidget(videoUrl: videoUrls[pp], image: userModel.image);
                              },
                              onPageChanged: (int page) {
                                setState(() {
                                  activePage = page;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: Image.asset('assets/Group 1.png')),
                                Container(
                                  width: 70,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(userModel.image!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                const SizedBox(height: 20),
                videoUrls.isEmpty
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NavButton(
                            onTap: () {
                              if (_pageController.hasClients && activePage > 0) {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              var t = await videoProvider.downloadVideo(videoUrls[activePage], videoUrls[activePage]);
                              setState(() {
                                loadingText = t;
                              });
                            },
                            style: AppStyles.filledButton.copyWith(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              shadowColor: const WidgetStatePropertyAll(Colors.black26),
                              foregroundColor: const WidgetStatePropertyAll(Colors.black),
                              backgroundColor: const WidgetStatePropertyAll(Colors.white),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Colors.green.shade600,
                            ),
                            label: const Text('Download'),
                          ),
                          NavButton(
                            isPreviousButton: false,
                            onTap: () {
                              if (_pageController.hasClients && activePage < totalPages - 1) {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 600),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                Text(loadingText)
              ],
            ),
    );
  }
}
