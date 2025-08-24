// lib/categories.dart

import 'package:flutter/material.dart';
import 'category_detail_page.dart';

/// Data model for a skin cancer category
class SkinCategory {
  final String title;
  final String assetImage;
  final String description;
  final String prevention;
  final String homeRemedies;

  SkinCategory({
    required this.title,
    required this.assetImage,
    required this.description,
    required this.prevention,
    required this.homeRemedies,
  });
}

/// Displays a grid of skin cancer categories
class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key}) : super(key: key);

  final List<SkinCategory> categories = [
    SkinCategory(
      title: 'Actinic Keratosis',
      assetImage: 'assets/images/actinic_keratosis.jpg',
      description:
          'Actinic keratosis is a rough, scaly patch on sun-exposed areas such as the face, ears, neck, scalp, chest, backs of hands, or lips. It is considered a precancerous lesion and may develop into squamous cell carcinoma if left untreated.',
      prevention:
          'Apply broad‑spectrum sunscreen daily, wear protective clothing and hats, and avoid peak sun hours (10 AM–4 PM).',
      homeRemedies:
          'Use aloe vera gel to soothe and moisturize; consider topical green tea extract for antioxidant benefits.',
    ),
    SkinCategory(
      title: 'Basal Cell Carcinoma',
      assetImage: 'assets/images/basal_cell_carcinoma.jpg',
      description:
          'Basal cell carcinoma is the most common type of skin cancer, typically appearing as a pearly, waxy bump or a flat, flesh-colored lesion that may bleed and heal repeatedly.',
      prevention:
          'Use sunscreen with SPF 30+, seek shade, and wear UPF‑rated clothing to minimize UV exposure.',
      homeRemedies:
          'Keep the area clean; coconut oil may help with mild irritation, but medical evaluation is essential.',
    ),
    SkinCategory(
      title: 'Dermatofibroma',
      assetImage: 'assets/images/dermatofibroma.jpg',
      description:
          'Dermatofibroma is a benign skin nodule often found on the legs and arms. It is firm, red to brown in color, and may dimple inward when pinched.',
      prevention:
          'There are no specific prevention measures; protect your skin from trauma and insect bites.',
      homeRemedies:
          'Warm compresses may soothe any itchiness; consult a dermatologist if removal is desired.',
    ),
    SkinCategory(
      title: 'Melanoma',
      assetImage: 'assets/images/melanoma.jpg',
      description:
          'Melanoma is a dangerous form of skin cancer arising from pigment-producing melanocytes. It can appear as an irregular mole with varying colors.',
      prevention:
          'Perform regular skin self-exams, use high‑SPF sunscreen, and avoid tanning beds.',
      homeRemedies:
          'No proven home remedies—early professional evaluation and treatment are critical.',
    ),
    SkinCategory(
      title: 'Nevus (Mole)',
      assetImage: 'assets/images/nevus.jpg',
      description:
          'A nevus, or mole, is a common benign growth of melanocytes. Most are harmless but changes warrant medical evaluation.',
      prevention:
          'Monitor moles for changes using the ABCDE rule (Asymmetry, Border, Color, Diameter, Evolving).',
      homeRemedies:
          'Keep the area protected from sun exposure; no direct removal at home.',
    ),
    SkinCategory(
      title: 'Pigmented Benign Keratosis',
      assetImage: 'assets/images/pigmented_benign_keratosis.jpg',
      description:
          'Pigmented benign keratoses include solar lentigines (“age spots”) and other noncancerous pigmented lesions caused by UV damage.',
      prevention:
          'Limit sun exposure and use sunscreen to reduce new lesion formation.',
      homeRemedies:
          'Topical retinoids may lighten spots; consult a dermatologist for options.',
    ),
    SkinCategory(
      title: 'Seborrheic Keratosis',
      assetImage: 'assets/images/seborrheic_keratosis.jpg',
      description:
          'Seborrheic keratosis is a benign, wart-like lesion that appears as a waxy, raised growth usually in older adults.',
      prevention:
          'No specific prevention known; maintain overall skin health.',
      homeRemedies:
          'Use mild soap and moisturizer; professional removal available if bothersome.',
    ),
    SkinCategory(
      title: 'Squamous Cell Carcinoma',
      assetImage: 'assets/images/squamous_cell_carcinoma.jpg',
      description:
          'Squamous cell carcinoma is a common skin cancer presenting as a firm red nodule or a scaly patch that may ulcerate.',
      prevention:
          'Avoid peak sun hours, apply sunscreen, and wear protective clothing.',
      homeRemedies:
          'No home remedies—prompt medical treatment is required.',
    ),
    SkinCategory(
      title: 'Vascular Lesion',
      assetImage: 'assets/images/vascular_lesion.jpg',
      description:
          'Vascular lesions are benign overgrowths of blood vessels such as hemangiomas, presenting as red or purple patches.',
      prevention:
          'Often congenital or hereditary; no known prevention.',
      homeRemedies:
          'Cold compresses may reduce swelling; professional laser treatment for removal.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Skin Cancer Categories',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryDetailPage(category: category),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.blue.shade200, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.asset(
                        category.assetImage,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        category.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        category.description.split('.').first + '.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
