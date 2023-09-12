import 'package:flutter/material.dart';


class CountryCard extends StatelessWidget {
  const CountryCard({
    required this.column,
    required this.row,
  });

  final String column, row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: 180,
        child: AspectRatio(
          aspectRatio: 1.32,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  column,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                ),
                SizedBox(height: 5),
                Text(row),

              ],
            ),
          ),
        ),
      ),
    );
  }
}