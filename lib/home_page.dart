import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'detail_page.dart';
import 'notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref().child("poubelle");

  double temperature = 0.0;
  int niveau = 0;
  bool mouvement = false;
  bool estPleine = false;

  @override
  void initState() {
    super.initState();
    _ref.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        temperature = (data['temperature'] ?? 0).toDouble();
        niveau = data['niveau_remplissage_cm'] ?? 0;
        mouvement = data['mouvement_detecte'] ?? false;
        estPleine = data['est_pleine'] ?? false;
        // 🔔 Notification locale si température > 40°C
  if (temperature > 40) {
    NotificationService.showNotification(
      title: "🔥 Température élevée",
      body: "La température a dépassé 40°C dans la poubelle !",
    );
  }

  if (niveau < 10) {
    NotificationService.showNotification(
      title: "🔥 Poubelle presque pleine",
      body: "Le niveau de remplissage a dépassé 90%.la poubelle est presque pleine !",
    );
  }
  // 🔔 Notification locale si la poubelle est pleine
if (estPleine) {
  NotificationService.showNotification(
    title: "🚮 Poubelle pleine",
    body: "La poubelle est pleine, veuillez la vider !",
  );
}
      });
    });
  }

  Future<void> signOut() async {
    bool? shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('Smart Bin'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Données en temps réel 🟢",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            infoCard("🌡️ Température", "$temperature °C", Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailPage(
                  title: "Température",
                  value: "$temperature °C",
                  color: Colors.orange,
                  temperature: temperature, // Passer la température ici
                  niveau: 0, // Pas de niveau ici
                ),
              ));
            }),
            infoCard("📏 Niveau de remplissage", "$niveau cm", Colors.blue, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailPage(
                  title: "Niveau de remplissage",
                  value: "$niveau cm",
                  color: Colors.blue,
                  temperature: 0, // Pas de température ici
                  niveau: niveau, // Passer le niveau de remplissage ici
                ),
              ));
            }),
            infoCard("🧍 Mouvement détecté", mouvement ? "Oui" : "Non", Colors.purple, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailPage(
                  title: "Mouvement détecté",
                  value: mouvement ? "Oui" : "Non",
                  color: Colors.purple,
                  temperature: 0, // Pas de température ici
                  niveau: 0, // Pas de niveau ici
                ),
              ));
            }),
            infoCard("🚮 État de la poubelle",
             estPleine ? "Pleine ❌" : "Disponible ✅",
                estPleine ? Colors.red : Colors.green, () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => DetailPage(
                  title: "État de la poubelle",
                  value: estPleine ? "Pleine ❌" : "Disponible ✅",
                  color: estPleine ? Colors.red : Colors.green,
                  temperature: 0, // Pas de température ici
                  niveau: 0, // Pas de niveau ici
                ),
              ));
            }),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String value, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.sensor_window, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}