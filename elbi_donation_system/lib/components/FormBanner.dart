import 'package:flutter/material.dart';

class FormBanner extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget widget;
  const FormBanner(
      {required this.title,
      required this.subtitle,
      required this.widget,
      super.key});

  @override
  State<FormBanner> createState() => _FormBannerState();

  @override
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FormBannerState extends State<FormBanner> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          expandedHeight: 250,
          flexibleSpace: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF6FCC8A), Color(0xFF288242)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                        widget.subtitle)),
                Flexible(
                    child: Text(
                        style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                        widget.title)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: widget.widget)
      ],
    );

    // AppBar(

    //     bottom: PreferredSize(
    //         preferredSize: Size.fromHeight(200), child: SizedBox(height: 200)));
  }
}
