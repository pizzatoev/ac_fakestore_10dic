import '../viewmodels/cart.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carritos MVVM"),
      ),
      body: cartViewModel.cargando
          ? const Center(child: CircularProgressIndicator())
          : cartViewModel.error != null
              ? Center(child: Text('Error: ${cartViewModel.error}'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final cart = cartViewModel.carts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.shopping_cart),
                        title: Text("Carrito ID: ${cart.id}"),
                        subtitle: Text(
                          "Usuario ID: ${cart.userId}\nProductos: ${cart.products.length}",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Carrito ID: ${cart.id}"),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Usuario ID: ${cart.userId}"),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Productos:",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    ...cart.products.map(
                                      (product) => Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "  • Producto ID: ${product.productId}, Cantidad: ${product.quantity}",
                                        ),
                                      ),
                                    ),
                                    if (cart.products.isEmpty)
                                      const Text("  (Sin productos)"),
                                  ],
                                ),
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
                      ),
                    );
                  },
                  itemCount: cartViewModel.carts.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cartViewModel.fetchCarts();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

