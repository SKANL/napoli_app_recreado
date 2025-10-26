import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final void Function()? onTap;
  const ProductListItem({super.key, required this.title, required this.subtitle, required this.price, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: FlutterLogo()),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(price),
      onTap: onTap,
    );
  }
}
