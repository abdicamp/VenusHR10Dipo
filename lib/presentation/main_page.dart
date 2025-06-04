import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venushr_10_dipo_mobile/presentation/request/request_view.dart';
import '../../../core/core.dart';
import 'account/account_view.dart';
import 'history/history_view.dart';
import 'home/main_home.dart';
import 'request/bloc/list_request/list_request_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final _widgets = [
    const HomeView(),
    const RequestView(),
    const HistoryView(),
    const AccountView(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgets,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 16.0,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            useLegacyColorScheme: false,
            currentIndex: _selectedIndex,
            onTap: (value) => setState(() => _selectedIndex = value),
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(color: AppColors.primary),
            selectedIconTheme: const IconThemeData(color: AppColors.primary),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Assets.icons.nav.home.svg(
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 0 ? AppColors.primary : AppColors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    // Icon utama
                    Assets.icons.nav.setting.svg(
                      colorFilter: ColorFilter.mode(
                        _selectedIndex == 1
                            ? AppColors.primary
                            : AppColors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    // Badge notifikasi
                    BlocBuilder<ListRequestBloc, ListRequestState>(
                        builder: (context, state) {
                      return state.maybeWhen(
                          orElse: () => Stack(),
                          empty: () {
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${0}', // Ganti dengan jumlah notifikasi yang diinginkan
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                          success: (data) {
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${data.length}', // Ganti dengan jumlah notifikasi yang diinginkan
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          });
                    })
                  ],
                ),
                label: 'Request',
              ),
              BottomNavigationBarItem(
                icon: Assets.icons.nav.history.svg(
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 2 ? AppColors.primary : AppColors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Assets.icons.nav.profile.svg(
                  colorFilter: ColorFilter.mode(
                    _selectedIndex == 3 ? AppColors.primary : AppColors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
