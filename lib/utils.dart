import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/main.dart';

void showDescription(BuildContext context, String machineName) {
  String description = getDescription(machineName);
  String img = getImg(machineName);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MachineDetails(
        machineName: machineName,
        description: description,
        img: img,
      ),
    ),
  );
}

String getDescription(String machineName) {
  switch (machineName) {
    case "Cable Machine":
      return "A cable machine is a versatile piece of equipment that allows for a wide range of exercises.";
    case "Chest Press Machine":
      return "The chest press machine is designed to target the muscles in the chest, shoulders, and arms.";
    case "Elliptical Trainer":
      return "An elliptical trainer provides a low-impact cardiovascular workout that simulates walking, running, or stair climbing.";
    case "Lat Pulldown Machine":
      return "The lat pulldown machine targets the muscles of the upper back and arms, particularly the latissimus dorsi.";
    case "Leg Extension Machine":
      return "The leg extension machine isolates and strengthens the quadriceps muscles on the front of the thigh.";
    case "Leg Press Machine":
      return "The leg press machine primarily targets the muscles of the thighs, including the quadriceps, hamstrings, and glutes.";
    case "Rowing Machine":
      return "A rowing machine provides a full-body cardiovascular workout while also engaging the muscles of the back, arms, and core.";
    case "Smith Machine":
      return "The Smith machine is a weight training machine that consists of a barbell fixed within steel rails, allowing for vertical movement in a guided path.";
    case "Stationary Bike":
      return "A stationary bike provides a low-impact cardiovascular workout that targets the muscles of the legs and glutes.";
    case "Treadmill":
      return "A treadmill is a popular piece of cardio equipment that simulates walking, running, or jogging indoors.";
    default:
      return "Description not available.";
  }
}

String getImg(String machineName) {
  switch (machineName) {
    case "Cable Machine":
      return "assets/machines/cablemachine.jpg";
    case "Chest Press Machine":
      return "assets/machines/chestpressmachine.jpg";
    case "Elliptical Trainer":
      return "assets/machines/ellip.jpg";
    case "Lat Pulldown Machine":
      return "assets/machines/latpul.jpg";
    case "Leg Extension Machine":
      return "assets/machines/legex.png";
    case "Leg Press Machine":
      return "assets/machines/lpress.jpg";
    case "Rowing Machine":
      return "assets/machines/row.jpg";
    case "Smith Machine":
      return "assets/machines/smith.png";
    case "Stationary Bike":
      return "assets/machines/stat.jpg";
    case "Treadmill":
      return "assets/machines/readmill.jpg";
    default:
      return "Description not available.";
  }
}
