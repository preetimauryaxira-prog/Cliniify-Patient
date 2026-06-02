import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../utils/apptheme.dart';

class ClinicGalleryPage extends StatelessWidget {
  const ClinicGalleryPage({super.key});
  static const String routerName = '/gallery';

  @override
  Widget build(BuildContext context) {
    // Mocked Gallery Images
    final images = [
      "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=500&auto=format", // Clinic Front
      "https://images.unsplash.com/photo-1581594693702-fbdc51b2763b?q=80&w=500&auto=format", // Waiting Area
      "https://images.unsplash.com/photo-1504439468489-c8920d786a2b?q=80&w=500&auto=format", // Operating Room
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clinic Gallery", style: TextStyle(color: AppColor.darkBlue, fontWeight: FontWeight.bold)),
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.darkBlue),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.globalBackgroundGradient),
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: AppColor.green)),
                errorWidget: (context, url, error) => Container(color: AppColor.lightGrey, child: const Icon(Icons.image_not_supported, color: AppColor.grey)),
              ),
            );
          },
        ),
      ),
    );
  }
}