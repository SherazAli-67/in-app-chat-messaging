import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_messaging/firebase_options.dart';
import 'package:in_app_messaging/src/app_theme/app_theme.dart';
import 'package:in_app_messaging/src/bloc_cubit/auth_cubit/auth_cubit.dart';
import 'package:in_app_messaging/src/bloc_cubit/main_menu_bloc/main_menu_bloc.dart';
import 'package:in_app_messaging/src/features/main_menu_page/main_menu_page.dart';
import 'package:in_app_messaging/src/features/welcome_page.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=> MainMenuTabChangeBloc()),
        BlocProvider(create: (_)=> AuthCubit()),

      ],
      child: MaterialApp(
        title: 'Chat Messaging Application',
        theme: AppTheme.darkTheme,
        home:  FirebaseAuth.instance.currentUser!= null ? const MainMenuPage() : const WelcomePage()
      ),
    );
  }
}