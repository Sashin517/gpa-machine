import 'package:flutter/material.dart';
import 'constants.dart';
import 'result_screen.dart';
import 'colours.dart';

// Main screen for the GPA calculator

class GPACalculatorScreen extends StatefulWidget {
  const GPACalculatorScreen({super.key});

  @override
  State<GPACalculatorScreen> createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> {
  final List<TextEditingController> _nameControllers = [];
  final List<int> _creditValues = [];
  final List<String> _gradeValues = [];

  @override
  void initState() {
    super.initState();
    // Initialize with 6 courses
    for (int i = 0; i < 6; i++) {
      _nameControllers.add(TextEditingController());
      _creditValues.add(1);
      _gradeValues.add('A+');
    }
  }

  @override
  void dispose() {
    for (var controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'GPA Machine',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        color: AppColors.accent,
        child: Column(children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Course',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Credit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Grade',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _nameControllers.length,
              itemBuilder: (context, index) {
                return CourseInputRow(
                  nameController: _nameControllers[index],
                  credit: _creditValues[index],
                  grade: _gradeValues[index],
                  onCreditChanged: (value) {
                    setState(() => _creditValues[index] = value!);
                  },
                  onGradeChanged: (value) {
                    setState(() => _gradeValues[index] = value!);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculateGPA,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.highlight, // Change this to your desired color
                    foregroundColor: Colors.black, // Text color
                  ),
                  child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
                            child: const Text(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              'Calculate GPA'),
                          ),
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    _nameControllers.add(TextEditingController());
                    _creditValues.add(1);
                    _gradeValues.add('A+');
                  }),
                  backgroundColor: AppColors.selection, // Change button color
                  foregroundColor: Colors.black, // Change icon color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Adjust roundness
                  ),
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    if (_nameControllers.isNotEmpty) _nameControllers.removeLast();
                    if (_creditValues.isNotEmpty) _creditValues.removeLast();
                    if (_gradeValues.isNotEmpty) _gradeValues.removeLast();
                  }),
                  backgroundColor: AppColors.selection, // Change button color
                  foregroundColor: Colors.black, // Change icon color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50), // Adjust roundness
                  ),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  void _calculateGPA() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (int i = 0; i < _nameControllers.length; i++) {
      int credit = _creditValues[i];
      if (credit == 0) continue;
      String grade = _gradeValues[i];
      double gradePoint = gradeToPoint[grade] ?? 0.0;
      totalGradePoints += credit * gradePoint;
      totalCredits += credit;
    }

    if (totalCredits == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid courses')),
      );
      return;
    }

    double gpa = totalGradePoints / totalCredits;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(gpa: gpa),
      ),
    );
  }
}

class CourseInputRow extends StatelessWidget {
  final TextEditingController nameController;
  final int credit;
  final String grade;
  final ValueChanged<int?> onCreditChanged;
  final ValueChanged<String?> onGradeChanged;

  const CourseInputRow({
    super.key,
    required this.nameController,
    required this.credit,
    required this.grade,
    required this.onCreditChanged,
    required this.onGradeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Type Name',
                labelStyle: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14),
                border: InputBorder.none, // Removes default border
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Invisible border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2.0), // Visible border when focused
                ),
                fillColor: AppColors.selection,
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<int>(
              value: credit,
              items: creditOptions.map((credit) {
                return DropdownMenuItem<int>(
                  value: credit,
                  child: Text('$credit',
                  style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: onCreditChanged,
              decoration: const InputDecoration(
                //labelText: 'Credit',
                border: InputBorder.none, // Removes default border
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Invisible border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2.0), // Visible border when focused
                ),
                fillColor: AppColors.selection,
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: grade,
              items: gradeOptions.map((grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text(grade,
                  style: TextStyle(fontSize: 14)
                  ),
                );
              }).toList(),
              onChanged: onGradeChanged,
              decoration: const InputDecoration(
                //labelText: 'Grade',
                border: InputBorder.none, // Removes default border
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Invisible border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary, width: 2.0), // Visible border when focused
                ),
                fillColor: AppColors.selection,
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}