import 'package:flutter/material.dart';
import 'package:venushr_10_dipo_mobile/core/core.dart';
import '../../data/datasource/auth_local_datasource.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(60.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bgHome.provider(),
            alignment: Alignment.topCenter,
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 236, 235, 235),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundImage: NetworkImage(
                                  "https://i.pinimg.com/originals/1b/14/53/1b14536a5f7e70664550df4ccaa5b231.jpg"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80, top: 90),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(Icons.edit),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(25),
                  FutureBuilder(
                    future: AuthLocalDatasource().getAuthDataDetail(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      } else {
                        final user = snapshot.data?.employeeName;
                        return Column(
                          children: [
                            Text(
                              user ?? '-',
                              style: const TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                              maxLines: 2,
                            ),
                            const SpaceHeight(10),
                            Text(
                              snapshot.data?.nik ?? '-',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                              maxLines: 2,
                            ),
                            const SpaceHeight(100),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        color: const Color.fromARGB(
                                            255, 44, 44, 44),
                                        "assets/images/address.png",
                                        width: 35,
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Address",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 44, 44, 44),
                                              ),
                                            ),
                                            const SpaceHeight(10),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.1,
                                              child: Text(
                                                '${snapshot.data?.homeAdr == '' ? '-' : snapshot.data?.homeAdr}',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 44, 44, 44),
                                                ),
                                                maxLines: 3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SpaceHeight(40),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/smartphone.png",
                                        width: 35,
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Phone Number",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 44, 44, 44),
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data?.privateMobile == '' ? '-' : snapshot.data?.privateMobile}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 44, 44, 44),
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SpaceHeight(40),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/cardname.png",
                                        width: 35,
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Product",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 44, 44, 44),
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data?.position == '' ? '-' : snapshot.data?.position}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 44, 44, 44),
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    },
                    // child: Text(
                    //   'Hello, Chopper Sensei',
                    //   style: TextStyle(
                    //     fontSize: 18.0,
                    //     color: AppColors.white,
                    //   ),
                    //   maxLines: 2,
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
