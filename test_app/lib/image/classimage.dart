import 'package:flutter/material.dart';

class Ahmad extends StatelessWidget {
  final List<String> l;
  const Ahmad({super.key, required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200, // ارتفاع مناسب للصور
        width: MediaQuery.of(context).size.width, // العرض يغطي الشاشة
        child: PageView.builder(
          itemCount: l.length,
          scrollDirection: Axis.horizontal,
          controller: PageController(viewportFraction: 0.9),
          physics: const BouncingScrollPhysics(), // ✅ السماح بالتمرير
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // زوايا دائرية
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    l[index],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
