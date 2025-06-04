import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venushr_10_dipo_mobile/core/components/styles.dart';
import 'package:venushr_10_dipo_mobile/data/datasource/auth_remote_datasource.dart';
import 'package:venushr_10_dipo_mobile/data/get_version/get_version.dart';
import 'package:venushr_10_dipo_mobile/presentation/main_page.dart';
import '../../../core/core.dart';
import '../../../data/datasource/auth_local_datasource.dart';
import '../bloc/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  String? meesage;

  LoginPage({
    Key? key,
    this.meesage,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late AndroidDeviceInfo androidInfo;
  bool isLoggedIn = false;
  bool isLoading = false;
  String platform = 'Unknown';

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late IosDeviceInfo iosInfo;
  String? deviceId;
  bool isShowPassword = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _checkLoginStatus() async {
    setState(() {
      isLoading = true;
    });
    final getVersion = GetVersion();
    final pref = await SharedPreferences.getInstance();
    final result = await getVersion.getCekVersions();

    if (result == false) {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
        pref.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Version Not Compatible"),
          backgroundColor: AppColors.red,
        ),
      );
    } else {
      final response = await AuthLocalDatasource().getAuthData();
      androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceId = androidInfo.id;
      });
      if (response != null) {
        if (response.mobileLoginID != deviceId) {
          setState(() {
            isLoggedIn = false;
            AuthLocalDatasource().removeAuthData();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainPage()));
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/venusHR.png"),
                SizedBox(
                  height: 30,
                ),
                loadingSpin,
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpaceHeight(50),
                    Image.asset(
                      "assets/images/logo_login.png",
                      height: 200,
                    ),
                    const SpaceHeight(107),
                    CustomTextField(
                      controller: emailController,
                      label: 'User ID',
                      showLabel: false,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          Assets.icons.email.path,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    const SpaceHeight(20),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      showLabel: false,
                      obscureText: !isShowPassword,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          Assets.icons.password.path,
                          height: 20,
                          width: 20,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShowPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
                      ),
                    ),
                    const SpaceHeight(104),
                    BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () {},
                          success: (data) async {
                            AuthLocalDatasource().saveAuthData(data);
                            AuthRemoteDatasource().updateDevice(data, deviceId);

                            final busCode =
                                await AuthRemoteDatasource().getDataBuscode();

                            busCode.fold((f) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(f),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            }, (busCode) async {
                              await AuthLocalDatasource()
                                  .updateAuthData(busCode);
                            });
                          },
                          successUserDetail: (data) {
                            AuthLocalDatasource().saveAuthDataDetail(data);
                            context.pushReplacement(const MainPage());
                          },
                          error: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: AppColors.red,
                              ),
                            );
                          },
                        );
                      },
                      child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () {
                            return Button.filled(
                              onPressed: () {
                                context.read<LoginBloc>().add(
                                      LoginEvent.login(
                                          emailController.text,
                                          passwordController.text,
                                          deviceId ?? ''),
                                    );
                              },
                              label: 'Sign In',
                            );
                          },
                          loading: () {
                            return const Center(
                              child: loadingSpin,
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
