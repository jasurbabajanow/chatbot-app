import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemini_app/components/createdGens.dart';
import 'package:gemini_app/screens/auth/login.dart';
import 'package:gemini_app/screens/noGens.dart';
import 'package:gemini_app/services/firebaseService.dart';

class MyGens extends StatefulWidget {
  MyGens({super.key});

  @override
  _MyGensState createState() => _MyGensState();
}

class _MyGensState extends State<MyGens> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseService _firebaseService = FirebaseService();
  List<DocumentSnapshot> _generatedContents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGeneratedContents();
  }

  Future<void> _fetchGeneratedContents() async {
    List<DocumentSnapshot> contents =
        await _firebaseService.getGeneratedContents();
    setState(() {
      _generatedContents = contents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF302B63),
              Color(0xFF24243E),
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orangeAccent))
            : SafeArea(
                child: RefreshIndicator(
                  color: Colors.orangeAccent,
                  backgroundColor: Color(0xFF302B63),
                  onRefresh: _fetchGeneratedContents,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.6),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      '${user?.displayName ?? 'Genius'}',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.power,
                                    color: Colors.redAccent,
                                  ),
                                  iconSize: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),
                              Container(
                                height: 4,
                                width: 60,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.orange, Colors.redAccent],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Recent Creations',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      _generatedContents.isEmpty
                          ? SliverFillRemaining(child: NoGens())
                          : SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    DocumentSnapshot doc =
                                        _generatedContents[index];
                                    final email = doc['email'] as String?;
                                    final currentUserEmail = _firebaseService
                                        .getCurrentUser()
                                        ?.email
                                        ?.toString();

                                    if (email == currentUserEmail) {
                                      return CreatedGens(
                                        title: doc['title'] ?? '',
                                        description: doc['description'] ?? '',
                                        content: doc['content'] ?? '',
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                  childCount: _generatedContents.length,
                                ),
                              ),
                            ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
