import '../viewmodels/user.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios MVVM"),
      ),
      body: userViewModel.cargando
          ? const Center(child: CircularProgressIndicator())
          : userViewModel.error != null
              ? Center(child: Text('Error: ${userViewModel.error}'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final user = userViewModel.users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.username[0].toUpperCase()),
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: Text(
                        "ID: ${user.id}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(user.username),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("ID: ${user.id}"),
                                Text("Email: ${user.email}"),
                                Text("Username: ${user.username}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cerrar"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  itemCount: userViewModel.users.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userViewModel.fetchUsers();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

