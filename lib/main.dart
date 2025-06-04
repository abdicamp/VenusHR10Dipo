import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venushr_10_dipo_mobile/presentation/auth/pages/login_page.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/attendance_log/bloc/attendance_log_bloc.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/bloc/get_date/get_date_bloc.dart';
import 'package:venushr_10_dipo_mobile/presentation/home/bloc/get_location/get_location_bloc.dart';
import 'package:venushr_10_dipo_mobile/presentation/request/bloc/list_request/list_request_bloc.dart';
import 'package:venushr_10_dipo_mobile/presentation/request/bloc/update_request/update_request_bloc.dart';
import 'core/constants/colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/datasource/auth_remote_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetLocationBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => AttendanceLogBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ListRequestBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => UpdateRequestBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetDateBloc(AuthRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            dividerTheme:
                DividerThemeData(color: AppColors.light.withOpacity(0.5)),
            textTheme: GoogleFonts.kumbhSansTextTheme(
              Theme.of(context).textTheme,
            ),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              color: AppColors.white,
              elevation: 0,
              titleTextStyle: GoogleFonts.kumbhSans(
                color: AppColors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: LoginPage()),
    );
  }
}
