import 'package:flutter/material.dart';
import 'package:market/shared/widgets/image_viewer.dart';

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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PageView.builder(
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.contain,
                );
              },
              controller: _pageController,
              onPageChanged: (index) {
                _currentPageNotifier.value = index;
              },
            ),
          ),
        ],
      ),
    );
  }
}
