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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FormBannerState extends State<FormBanner> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
            stretch: false,
            expandedHeight: 250,
            backgroundColor: Color(0xFF288242),
            title: Text(
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                "${widget.subtitle} ${widget.title}"),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 5),
                            widget.subtitle.toUpperCase())),
                    Flexible(
                        child: Text(
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                            widget.title)),
                  ],
                ),
              ),
              stretchModes: const [StretchMode.fadeTitle],
            )),
        SliverToBoxAdapter(child: widget.widget)
      ],
    );

    // AppBar(

    //     bottom: PreferredSize(
    //         preferredSize: Size.fromHeight(200), child: SizedBox(height: 200)));
  }
}
