import 'package:flutter/material.dart';
import 'package:globo_fitness/shared/menu_bottom.dart';
import 'package:globo_fitness/shared/menu_drawer.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final TextEditingController txtHeight = TextEditingController();
  final TextEditingController txtWeight = TextEditingController();

  String result = '';
  bool isMetric = true;
  bool isImperial = false;
  double? height;
  double? weight;
  final double fontSize = 18;

  late List<bool> isSelected;

  String heightMsg = '';
  String weightMsg = '';

  @override
  void initState() {
    this.isSelected = [isMetric, isImperial];
    heightMsg =
        'Please insert your height in ' + ((isMetric) ? ' meters' : 'inches');
    weightMsg =
        'Please insert your height in ' + ((isMetric) ? ' kg' : 'pounds');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("BMI Calculator")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ToggleButtons(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Metric',
                        style: TextStyle(fontSize: fontSize),
                      )),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Imperial',
                        style: TextStyle(fontSize: fontSize),
                      )),
                ],
                isSelected: isSelected,
                onPressed: (value) {
                  toggleMeasure(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  controller: txtHeight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: heightMsg),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextField(
                  controller: txtWeight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: weightMsg),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: ElevatedButton(
                    child: Text(
                      'Calculate BMI',
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                    ),
                    onPressed: findBMI,
                ),
              ),
              Text(
                result,
                style: TextStyle(fontSize: fontSize),
              )
            ],
          ),
        ),
        drawer: MenuDrawer(),
        bottomNavigationBar: BottomMenu());
  }

  void toggleMeasure(int value) {
    if (value == 0) {
      isMetric = true;
      isImperial = false;
    } else {
      isMetric = false;
      isImperial = true;
    }
    setState(() {
      isSelected = [isMetric, isImperial];
    });
    heightMsg =
        'Please insert your height in ' + ((isMetric) ? ' meters' : 'inches');
    weightMsg =
        'Please insert your height in ' + ((isMetric) ? ' kg' : 'pounds');
  }

  void findBMI() {
    double bmi = 0;
    double height = double.tryParse(txtHeight.text) ?? 0;
    double weight = double.tryParse(txtWeight.text) ?? 0;
    if (isMetric) {
      bmi = weight / (height * height);
    } else {
      bmi = weight * 703 / (height * height);
    }

    setState(() {
      result = "Your BMI is " + bmi.toStringAsFixed(2);
    });
  }
}
