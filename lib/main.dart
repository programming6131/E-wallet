import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_millionnaire/Utils/Configs/helpers.dart';
import 'package:next_millionnaire/imports.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     switch (task) {
//       case "renewScansTask":
//         printSuccess("Running resetScans background sync...");

//         try {
//           await resetScans();
//         } on Exception catch (e) {
//           printError(e);
//         }
//         break;
//     }
//     // print("Native called background task: $backgroundTask"); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }

Future<void> main() async {
  // Flutter Widgets.
  final settingsController = ThemeSettingsController(SettingsService());
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// You can request multiple permissions at once.
  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );

  // Workmanager().registerPeriodicTask("renewScans", "renewScansTask",
  //     frequency: Duration(minutes: 1));
  // await initService();
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();
  runApp(MyApp(settingsController: settingsController));
}
// Future initService() async {
//   printInfo("Starting services");

//   await Get.putAsync<MidnightService>(
//       () async => await MidnightService().resetScans());

//   printSuccess("All services started");
// }
class MyApp extends StatefulWidget {
  MyApp({
    required this.settingsController,
    Key? key,
  }) : super(key: key);
  final ThemeSettingsController settingsController;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: themeDataLight(context),
      darkTheme: themeDataDark(context),
      themeMode: widget.settingsController.themeMode,
      home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const NavigationView();
                  }
                  return SigninView();
                },
              ),
    );
  }
}
