import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool hasDrawer;
  final VoidCallback? onDrawerTap;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;

  const SiteAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.hasDrawer = false,
    this.onDrawerTap,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      child: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: _text(),
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: elevation,
      leading: leading ??
          (hasDrawer
              ? Builder(
                  builder: (context) => Container(
                    margin: const EdgeInsets.all(8),
                    decoration: _leadingBoxDecoration(),
                    child: _iconButton(context),
                  ),
                )
              : null),
      actions: actions?.map((action) {
        if (action is IconButton) {
          return Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: action,
          );
        }
        return action;
      }).toList(),
      systemOverlayStyle: _systemUiOverlayStyle(),
    );
  }

  Widget _text() {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  BoxDecoration _leadingBoxDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  IconButton _iconButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.menu_rounded,
        color: Colors.white,
        size: 24,
      ),
      onPressed: onDrawerTap ?? () => Scaffold.of(context).openDrawer(),
    );
  }

  SystemUiOverlayStyle _systemUiOverlayStyle() {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
