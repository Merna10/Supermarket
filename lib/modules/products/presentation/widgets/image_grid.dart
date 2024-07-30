import 'package:flutter/material.dart';
import 'package:market/modules/products/presentation/widgets/image_viewer.dart';

class ImageGrid extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageGrid(
      {super.key, required this.imageUrls, required this.initialIndex});

  @override
  State<ImageGrid> createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1,
    );
    _currentPageNotifier = ValueNotifier(widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewer(
              imageUrls: widget.imageUrls,
              initialIndex: widget.initialIndex,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.fitWidth,
              );
            },
            controller: _pageController,
            onPageChanged: (index) {
              _currentPageNotifier.value = index;
            },
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              left: 8.0,
              top: MediaQuery.of(context).size.height * 0.222 -
                  20, // Center vertically
              child: ValueListenableBuilder(
                valueListenable: _currentPageNotifier,
                builder: (context, currentIndex, _) {
                  return currentIndex > 0
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () {
                            int previousPage = currentIndex - 1;
                            if (previousPage >= 0) {
                              _pageController.animateToPage(
                                previousPage,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        )
                      : Container();
                },
              ),
            ),
          Positioned(
            right: 8.0,
            top: MediaQuery.of(context).size.height * 0.222 -
                20, // Center vertically
            child: ValueListenableBuilder(
              valueListenable: _currentPageNotifier,
              builder: (context, currentIndex, _) {
                return currentIndex < widget.imageUrls.length - 1
                    ? IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                        onPressed: () {
                          int nextPage = currentIndex + 1;
                          if (nextPage < widget.imageUrls.length) {
                            _pageController.animateToPage(
                              nextPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
