import 'package:flutter/material.dart';

class StepData {
  final Widget content;

  StepData({required this.content});
}

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<StepData> steps;
  final VoidCallback onStepContinue;
  final VoidCallback onStepCancel;
  final Color activeColor;
  final Color inactiveColor;

  const CustomStepper({super.key, 
    required this.currentStep,
    required this.steps,
    required this.onStepContinue,
    required this.onStepCancel,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    // Get the text scale factor to mimic rem-like scaling
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Dynamically calculate sizes based on screen width or scaling factors
    double stepSize = textScaleFactor * 10; // Example scaling relative to text
    double lineWidth = stepSize * 0.2;      // Example: 20% of stepSize
    double spacing = stepSize * 0.5;        // Example: 50% of stepSize

    // Wrapping the entire column inside a Container to limit its width
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9, // Limit width to 90% of screen
        ),
        child: Column(
          children: [
            // Stepper progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(steps.length, (index) {
                return Row(
                  children: [
                    // Circle with dynamic stepSize
                    Container(
                      width: stepSize,
                      height: stepSize,
                      decoration: BoxDecoration(
                        color: currentStep >= index ? activeColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentStep >= index ? Colors.transparent : inactiveColor, // Grey border for inactive
                          width: 2, // Adjust the width of the border as needed
                        ),
                      ),
                    ),
                    if (index < steps.length - 1) ...[
                      // Dynamic space between the circle and line
                      SizedBox(width: spacing),
                      
                      // Line with dynamic lineWidth
                      Container(
                        height: lineWidth,
                        width: MediaQuery.of(context).size.width / (steps.length - 1) - stepSize * 12,
                        color: currentStep > index ? activeColor : inactiveColor,
                      ),
                      
                      // Space after the line
                      SizedBox(width: spacing),
                    ],
                  ],
                );
              }),
            ),
            const SizedBox(height: 20), // Spacing between the progress indicator and content
            // Stepper content
            Expanded(
              child: steps[currentStep].content,
            ),
            const SizedBox(height: 20), // Spacing before the control buttons
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentStep > 0
                    ? TextButton(
                        onPressed: onStepCancel,
                        style: TextButton.styleFrom(
                          foregroundColor: inactiveColor,
                          textStyle: const TextStyle(fontSize: 12), // Smaller text
                        ),
                        child: const Text('BACK'),
                      )
                    : const SizedBox.shrink(),
                currentStep < steps.length - 1
                    ? TextButton(
                        onPressed: onStepContinue,
                        style: TextButton.styleFrom(
                          foregroundColor: activeColor,
                          textStyle: const TextStyle(fontSize: 12), // Smaller text
                        ),
                        child: const Text('NEXT'),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
