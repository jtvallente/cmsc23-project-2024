import 'package:elbi_donation_system/styles/project_colors.dart';
import 'package:flutter/material.dart';

class FormBanner extends StatefulWidget implements PreferredSizeWidget {
  final LinearGradient gradient;
  final Color color;
  final String title;
  final String subtitle;
  final Widget widget;
  final List<Widget> actions;
  final bool isRoot;
  const FormBanner(
      {this.isRoot = false,
      required this.color,
      required this.gradient,
      required this.title,
      required this.subtitle,
      required this.widget,
      required this.actions,
      super.key});

  @override
  State<FormBanner> createState() => _FormBannerState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FormBannerState extends State<FormBanner> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
            leading: widget.isRoot
                ? null
                : IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
            stretch: false,
            expandedHeight: 250,
            actions: widget.actions,
            elevation: 4,
            backgroundColor: widget.color,
            title: Text(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                "${widget.title}"),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: widget.gradient,
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
                                color: Color.fromARGB(180, 255, 255, 255),
                                letterSpacing: 5),
                            widget.subtitle.toUpperCase())),
                    Flexible(
                        child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'WorkSans',
                            shadows: [
                              Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(0, 4),
                                  blurRadius: 15)
                            ],
                          ),
                          widget.title),
                    )),
                  ],
                ),
              ),
              stretchModes: const [StretchMode.fadeTitle],
            )),
        SliverToBoxAdapter(child: widget.widget)
      ],
    );
  }
}
