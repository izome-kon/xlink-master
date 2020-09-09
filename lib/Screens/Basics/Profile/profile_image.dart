import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ProfileImage extends StatelessWidget {
  final String imageUrl;
  ProfileImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Hero(
        tag: "profileImage",
        child: Center(child:
        CachedNetworkImage(
          imageUrl: imageUrl,
        )
          ,),
      ),
    );
  }
}
