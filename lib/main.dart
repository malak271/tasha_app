import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:tasha_app/screens/jawwal_pay_screen.dart';
import 'package:tasha_app/services/cubit/app_states.dart';
import 'package:tasha_app/services/cubit/app_cubit.dart';
import 'package:tasha_app/layout/main_layout.dart';
import 'package:tasha_app/shared/components/Constants.dart';
import 'package:tasha_app/services/observer.dart';
import 'package:tasha_app/styles/theme.dart';
import 'models/login_model.dart';
import 'screens/login_screen.dart';
import 'screens/on_boarding.dart';
import 'network/local/chache_helper.dart';
import 'network/local/hive.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  bool? boarding = CacheHelper.getData(key: 'OnBoarding');

  await MyHive.init();
  if(await Hive.boxExists(MyHive.loginModelKey)){
    await MyHive.openBox(
      name: MyHive.loginModelKey,
    );
    LoginModel model= await MyHive.getValue('UserInfo');
    token=model.token;
    print('token from hive $token');
  }

  Widget? widget;
  if (boarding != null) {
    if (token != null)
      widget = MainLayout();
    else {
      print('token equal null!');
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }


  BlocOverrides.runZoned(
    () {
      runApp(myApp(
        startWidget: widget ?? OnBoardingScreen(),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class myApp extends StatelessWidget {
  final Widget startWidget;

  myApp({required this.startWidget});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context)=> AppCubit()..getAddresses()..getPeriod(),
        ),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            child:startWidget,
            builder: (context, child) {
              return MaterialApp(
                theme: MyLightTheme.getTheme(),
                // darkTheme: darkTheme,
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.light,
                home: child,
                localizationsDelegates: [
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale('ar', 'AE'),
                  Locale('en', ''),
                ],
                locale:  Locale('ar', 'AE'),
              );
            },
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
