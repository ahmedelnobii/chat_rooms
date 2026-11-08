import 'package:chat_rooms/core/app_bloc_observer.dart';
import 'package:chat_rooms/core/di/get_it.dart';
import 'package:chat_rooms/core/routes/routers.dart';
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AuthCubit>()),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Chat Rooms',
            routerConfig: routers,
          ),
        );
      },
    );
  }
}
