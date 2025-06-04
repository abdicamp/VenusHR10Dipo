import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback onTap;
  final String? urlImage;
  final String? judul;
  const BouncingButton(
      {super.key, required this.onTap, this.urlImage, this.judul});

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  final kLightBlue = Color(0xffEBF6FF);
  final kDarkBlue = Color(0xff369FFF);
  final kGreen = Color(0xff8AC53E);
  final kOrange = Color(0xffFF993A);
  final kYellow = Color(0xffFFD143);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          width: 170,
          height: 150,
          decoration: BoxDecoration(
              color: kLightBlue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.1), // Warna bayangan dan opasitas
                  spreadRadius: 1, // Jarak penyebaran bayangan
                  blurRadius: 9, // Radius blur bayangan
                  offset: Offset(0, 1), // Offset (x, y) dari bayangan
                ),
              ]),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "${widget.urlImage}",
                    width: 60,
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 7,
                        decoration: BoxDecoration(
                            color: kDarkBlue,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      Text(
                        "${widget.judul}",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: widget.judul == "Absen" &&
                                  widget.judul == "Leave" &&
                                  widget.judul == "Loan" &&
                                  widget.judul == "Claim"
                              ? 30
                              : widget.judul == "Overtime" &&
                                      widget.judul == "Permission"
                                  ? 15
                                  : widget.judul == "Attendance Log"
                                      ? 13
                                      : 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff006ED3),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
