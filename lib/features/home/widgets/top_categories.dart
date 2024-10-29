import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/home/screens/category_deals_screen.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  void navigateToCategoryDeals(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      CategoryDealsScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double dynamicItemExtent = screenWidth * 0.2;
    double dynamicImageWidth = screenWidth * 0.11;
    double dynamicImageHeight = screenWidth * 0.11;

    return SizedBox(
      height: 70,
      child: ListView.builder(
        itemCount: GlobalVariables.categoryImages.length,
        scrollDirection: Axis.horizontal,
        itemExtent: dynamicItemExtent,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigateToCategoryDeals(
                context,
                GlobalVariables.categoryImages[index]['title']!,
              );
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      GlobalVariables.categoryImages[index]['image']!,
                      fit: BoxFit.cover,
                      width: dynamicImageWidth,
                      height: dynamicImageHeight,
                    ),
                  ),
                ),
                Text(
                  GlobalVariables.categoryImages[index]['title']!,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
