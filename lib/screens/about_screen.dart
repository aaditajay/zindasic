import 'package:flutter/material.dart';
import '../widgets/developer_contact_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 23, 22, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'public/logo.png',
            height: 65,
            fit: BoxFit.contain,
          ),
          const DeveloperContactButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Nav Bar
          _buildNavBar(context),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 170),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: A Note From The Creator
                  const Text(
                    'A Note From The Creator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quote section
                  Text(
                    '“you can tell a lot about a person by what’s on their playlist”',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 32,
                      fontFamily: 'Griffiths',
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '- Begin Again (2013)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Subsection: zindasic: favorites' favorites
                  const Text(
                    "zindasic : favorites' favorites",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Griffiths',
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Body Paragraph 1
                  Text(
                    "Music tells us more about people than they often tell us themselves.\n"
                    "Every song in this collection belongs to someone who has, in one way or another, left a mark on my life.\n"
                    "Some songs remind them of home. Some of love. Some of friendships, journeys, and moments they never want to forget.\n"
                    "Zindasic is an attempt to preserve those people through the music they love.\n"
                    "One person. One song. One story.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 15,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Title: Why Zindasic?
                  const Text(
                    'Why Zindasic?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w800,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Body Paragraph 2
                  Text(
                    "The name combines Zindagi (life) and music.\n"
                    "Because sometimes a single song can tell the story of a life better than words ever could.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 15,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Centered final quote
                  Center(
                    child: Text(
                      '“Not every memory can be preserved.\n Some are best kept in a song.”',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      'Thank you to everyone who shared a piece of themselves through a song. And thank you for making my story a little more beautiful.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 15,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Bottom signature aligned right
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'with love,',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Griffiths',
                              fontStyle: FontStyle.italic,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Aadit',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 18,
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
