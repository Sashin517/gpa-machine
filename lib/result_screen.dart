import 'package:flutter/material.dart';
import 'colours.dart';

class ResultScreen extends StatelessWidget {
  final double gpa;

  const ResultScreen({super.key, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
          'GPA Result'
          ),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
        color: Colors.white, // Change back icon color
      ),
        ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.accent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                'Your GPA \n${gpa.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlight, // Change this to your desired color
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
                child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
                            child: const Text(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              'Back to Calculator'),
                          ),
              ),
            ],
          ),
        )
      ),
    );
  }
}