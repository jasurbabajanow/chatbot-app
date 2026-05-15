import 'package:flutter/material.dart';

import '../screens/winds.dart';

class CreatedGens extends StatelessWidget {
  CreatedGens({
    super.key,
    required this.title,
    required this.description,
    required this.content,
  });

  final String title;
  final String description;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Song(title: description, ans: content)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  top: -15,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (title == 'Song'
                              ? Colors.orange
                              : title == 'Story'
                                  ? Colors.redAccent
                                  : Colors.blueAccent)
                          .withOpacity(0.1),
                    ),
                    child: Icon(
                      title == 'Song'
                          ? Icons.music_note
                          : title == 'Story'
                              ? Icons.book
                              : Icons.text_snippet,
                      size: 40,
                      color: (title == 'Song'
                              ? Colors.orange
                              : title == 'Story'
                                  ? Colors.redAccent
                                  : Colors.blueAccent)
                          .withOpacity(0.2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: title == 'Song'
                                    ? [Colors.orange, Colors.orangeAccent]
                                    : title == 'Story'
                                        ? [Colors.redAccent, Colors.red]
                                        : [Colors.blueAccent, Colors.blue],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              title.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Raleway',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              color: title == 'Song'
                                  ? Colors.orangeAccent
                                  : title == 'Story'
                                      ? Colors.redAccent
                                      : Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: title == 'Song'
                                ? Colors.orangeAccent
                                : title == 'Story'
                                    ? Colors.redAccent
                                    : Colors.blueAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
