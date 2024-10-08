import 'package:aurora/components/IconWithLabel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:shimmer/shimmer.dart';

class ReusableCarousel extends StatelessWidget {
  final List<dynamic>? carouselData;
  final String? title;
  final String? tag;
  final bool? secondary;

  const ReusableCarousel({
    super.key,
    this.title,
    this.carouselData,
    this.tag,
    this.secondary = true,
  });

  @override
  Widget build(BuildContext context) {
    final customScheme = Theme.of(context).colorScheme;
    if (carouselData == null || carouselData!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder(
      valueListenable: Hive.box('app-data').listenable(),
      builder: (context, Box box, _) {
        final bool usingCompactCards =
            box.get('usingCompactCards', defaultValue: true);
        final bool usingSaikouCards =
            box.get('usingSaikouCards', defaultValue: false);

        return normalCard(
            customScheme, context, usingCompactCards, usingSaikouCards);
      },
    );
  }

  Column normalCard(ColorScheme customScheme, BuildContext context,
      bool usingCompactCards, bool usingSaikouCards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              title ?? '??',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: customScheme.primary,
              ),
            ),
            secondary!
                ? const Text(
                    ' Animes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  )
                : const SizedBox.shrink()
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: usingSaikouCards
              ? (usingCompactCards ? 190 : 220)
              : (usingCompactCards ? 280 : 300),
          child: InfiniteCarousel.builder(
            itemCount: carouselData!.length,
            itemExtent: MediaQuery.of(context).size.width /
                (usingSaikouCards ? 3.3 : 2.3),
            center: false,
            anchor: 0,
            loop: false,
            velocityFactor: 0.7,
            axisDirection: Axis.horizontal,
            itemBuilder: (context, itemIndex, realIndex) {
              final itemData = carouselData![itemIndex];
              final String posterUrl =
                  itemData['poster'] ?? itemData['image'] ?? '??';
              final tagg = itemData.toString() + tag!;
              const String proxyUrl =
                  'https://goodproxy.goodproxy.workers.dev/fetch?url=';
              String extraData = itemData['rank'] ??
                  itemData['type'] ??
                  itemData['relationType'] ??
                  '??';

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: {
                        'id': itemData['id'],
                        'posterUrl': proxyUrl + posterUrl,
                        'tag': tagg
                      },
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: usingSaikouCards ? 170 : 240,
                            child: Hero(
                              tag: tagg,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: proxyUrl + posterUrl,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[900]!,
                                    highlightColor: Colors.grey[700]!,
                                    child: Container(
                                      color: Colors.grey[900],
                                      height: usingSaikouCards ? 170 : 250,
                                      width: double.infinity,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: usingSaikouCards
                                      ? (usingCompactCards ? 200 : 170)
                                      : (usingCompactCards ? 280 : 250),
                                ),
                              ),
                            ),
                          ),
                          if (usingCompactCards)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (usingCompactCards)
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Text(
                                itemData?['name'] ?? itemData?['title'],
                                style: TextStyle(
                                  color: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface ==
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimaryFixedVariant
                                      ? Colors.black
                                      : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryFixedVariant ==
                                              const Color(0xffe2e2e2)
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: usingSaikouCards ? 10 : 13,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.7),
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          else
                            Column(
                              children: [
                                SizedBox(
                                  height: usingSaikouCards ? 174 : 248,
                                  width: MediaQuery.of(context).size.width /
                                      (usingSaikouCards ? 3.3 : 2.3),
                                ),
                                Text(
                                  itemData?['name'] ?? itemData?['title'] ?? itemData?['title']['english'],
                                  style: TextStyle(
                                    color: Theme.of(context)
                                                .colorScheme
                                                .inverseSurface ==
                                            Theme.of(context)
                                                .colorScheme
                                                .onPrimaryFixedVariant
                                        ? Colors.black
                                        : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryFixedVariant ==
                                                const Color(0xffe2e2e2)
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: usingSaikouCards ? 10 : 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          Positioned(
                            top: 7,
                            right: 7,
                            child: iconWithName(
                              icon: Iconsax.play_circle5,
                              TextColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface ==
                                      Theme.of(context)
                                          .colorScheme
                                          .onPrimaryFixedVariant
                                  ? Colors.black
                                  : Theme.of(context)
                                              .colorScheme
                                              .onPrimaryFixedVariant ==
                                          const Color(0xffe2e2e2)
                                      ? Colors.black
                                      : Colors.white,
                              color: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface ==
                                      Theme.of(context)
                                          .colorScheme
                                          .onPrimaryFixedVariant
                                  ? Colors.black
                                  : Theme.of(context)
                                              .colorScheme
                                              .onPrimaryFixedVariant ==
                                          const Color(0xffe2e2e2)
                                      ? Colors.black
                                      : Colors.white,
                              name: extraData,
                              isVertical: false,
                              borderRadius: BorderRadius.circular(5),
                              backgroundColor:
                                  customScheme.onPrimaryFixedVariant,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
