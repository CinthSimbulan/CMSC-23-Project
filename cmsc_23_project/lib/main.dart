import 'package:cmsc_23_project/pages/DonorPage/DonatePage/generate.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/addImageDrive.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/adddrive.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/drive.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/drivedetails.dart';
import 'package:cmsc_23_project/pages/OrganizationPage/organizationHomePage.dart';
import 'package:cmsc_23_project/pages/SignInPage/signin.dart';
import 'package:cmsc_23_project/pages/SignInPage/loadingpage.dart';
import 'package:cmsc_23_project/pages/homepage.dart';
import 'package:cmsc_23_project/pages/profile.dart';
import 'package:cmsc_23_project/pages/DonorPage/DonatePage/donor.dart';
import 'package:cmsc_23_project/providers/auth_provider.dart';
import 'package:cmsc_23_project/providers/image_provider.dart';
import 'package:cmsc_23_project/providers/organizations_provider.dart';
import 'package:cmsc_23_project/providers/users_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: ((context) => UsersListProvider())),
        ChangeNotifierProvider(create: ((context) => OrganizationProvider())),
        ChangeNotifierProvider(create: ((context) => ImageUploadProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elbi Donation System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Loadingpage.routename,
      routes: {
        Homepage.routename: (context) => const Homepage(),
        Profile.routename: (context) => const Profile(),
        Donor.routename: (context) => const Donor(),
        OrganizationHomepage.routename: (context) =>
            const OrganizationHomepage(),
        AddDrivePage.routename: (context) => const AddDrivePage(),
        DrivePage.routename: (context) => const DrivePage(),
        Drivedetails.routename: (context) => const Drivedetails(),
        Addimagedrive.routename: (context) => const Addimagedrive(),
        SignInPage.routename: (context) => const SignInPage(),
        Loadingpage.routename: (context) => const Loadingpage(),
        GenerateQrButtonWidget.routename: (context) =>
            const GenerateQrButtonWidget(),
      },
    );
  }
}
