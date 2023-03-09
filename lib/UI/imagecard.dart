import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
Widget imageCard(url) {
  return Container(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) =>LinearProgressIndicator(color: Colors.grey[200],backgroundColor: Colors.black12,),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )
      ));
}
