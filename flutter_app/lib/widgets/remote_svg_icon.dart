import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemoteSvgIcon extends StatelessWidget {
  const RemoteSvgIcon({
    required this.url,
    required this.fallback,
    this.size = 24,
    this.color,
    super.key,
  });

  final String url;
  final IconData fallback;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SvgPicture.network(
        url,
        width: size,
        height: size,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        placeholderBuilder: (_) => Icon(fallback, size: size, color: color),
      );
}
