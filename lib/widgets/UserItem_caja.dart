import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const UserItem({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(email, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(phone, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Actualizar',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7), // Bordes redondeados
                    ),
                  ),
                  onPressed: onUpdate,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label:  Text('Eliminar',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7), // Bordes redondeados
                    ),
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
