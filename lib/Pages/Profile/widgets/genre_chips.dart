import 'package:bookoodle/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GenreChips extends StatefulWidget {
  const GenreChips({
    Key? key,
  }) : super(key: key);

  @override
  _GenreChipsState createState() => _GenreChipsState();

  static GlobalKey<_GenreChipsState> genreChipsKey =
      GlobalKey<_GenreChipsState>();
}

class _GenreChipsState extends State<GenreChips> {
  List<String> getSelectedGenres() {
    List<String> selectedGenres = [];
    for (int i = 0; i < genres.length; i++) {
      if (isSelected[i]) {
        selectedGenres.add(genres[i]);
      }
    }
    return selectedGenres;
  }

  List<String> genres = [
    'Action and Adventure',
    'Biography',
    'Children',
    'Classic',
    'Comic Book',
    'Graphic Novel',
    'Detective and Mystery',
    'Fantasy',
    'Historical Fiction',
    'Horror',
    'Literary Fiction',
    'Romance',
    'Science Fiction',
    'Personal Development',
    'Thriller and Suspense',
    'Fiction',
    'Non-fiction',
    'Poetry',
    'Drama',
    'Humor',
    'Satire',
    'Tragedy',
    'Philosophy',
    'Science',
    'Travel',
    'Cookbooks',
    'Health and Fitness',
    'Religion and Spirituality',
    'History',
    'Art and Photography',
    'Science and Nature',
  ];
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    isSelected = List.filled(genres.length, false);
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5,
      radius: const Radius.circular(20),
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Wrap(
          spacing: 5.0,
          runSpacing: 0.0,
          children: List.generate(genres.length, (index) {
            return FilterChip(
              checkmarkColor: darkBrown,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(50)),
              selectedShadowColor: peach,
              label: Text(
                genres[index],
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected[index] ? darkBrown : Colors.black,
                ),
              ),
              selected: isSelected[index],
              onSelected: (bool selected) {
                setState(() {
                  isSelected[index] = selected;
                });
              },
              selectedColor: peach,
              backgroundColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }
}
