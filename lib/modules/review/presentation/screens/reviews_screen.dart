import 'dart:async'; // For Timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:market/app/theme/text_styles.dart';
import 'package:market/modules/review/logic/bloc/review_bloc.dart';
import 'package:market/modules/review/data/model/review.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  final PageController _pageController = PageController();
  Timer? _pageTimer;
  bool _isHolding = false;

  @override
  void dispose() {
    _commentController.dispose();
    _pageTimer?.cancel();
    super.dispose();
  }

  void _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final String userName = userDoc.data()?['userName'] ?? 'Anonymous';
        final String comment = _commentController.text;
        if (comment.isNotEmpty) {
          final Review review = Review(
            commenterName: userName,
            commentText: comment,
            date: DateTime.now(),
          );
          BlocProvider.of<ReviewBloc>(context).add(AddReviewEvent(review));
          _commentController.clear();
          Navigator.pop(context); // Close the BottomSheet after submission
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  void _startPageTimer(int itemCount) {
    if (_pageTimer != null) {
      _pageTimer!.cancel();
    }

    _pageTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isHolding) {
        int nextPage = (_pageController.page!.toInt() + 1) % itemCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Add a review',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReview,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor('f1efde'),
        title: Text(
          'Reviews',
          style: AppTextStyles.textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ReviewBloc, ReviewState>(
                builder: (context, state) {
                  if (state is ReviewsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReviewsLoaded) {
                    _startPageTimer(state.reviews.length);

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: state.reviews.length,
                      onPageChanged: (index) {
                        if (!_isHolding) {
                          _startPageTimer(state.reviews.length);
                        }
                      },
                      itemBuilder: (context, index) {
                        final review = state.reviews[index];
                        final displayName = review.commenterName.length > 3
                            ? '${review.commenterName.substring(0, 3)}....'
                            : review.commenterName;

                        return GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _isHolding = true;
                            });
                          },
                          onLongPressUp: () {
                            setState(() {
                              _isHolding = false;
                            });
                            _startPageTimer(state.reviews.length);
                          },
                          child: Card(
                            margin: const EdgeInsets.all(7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(review.commentText),
                                const SizedBox(height: 8),
                                Text(review.date.toString(),
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ReviewError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else {
                    return const Center(child: Text('No reviews yet'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('f1efde'),
        onPressed: _showReviewBottomSheet,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
