import '../viewmodels/product.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos MVVM"),
      ),
      body: productViewModel.cargando
          ? const Center(child: CircularProgressIndicator())
          : productViewModel.error != null
              ? Center(child: Text('Error: ${productViewModel.error}'))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final product = productViewModel.products[index];
                    return ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      ),
                      title: Text(product.title),
                      subtitle: Text(
                        "\$${product.price.toStringAsFixed(2)} - ${product.category}",
                      ),
                      trailing: Text(
                        "ID: ${product.id}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        // Aquí puedes navegar a una vista de detalle si lo deseas
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(product.title),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    product.image,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.image_not_supported);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Text("Precio: \$${product.price.toStringAsFixed(2)}"),
                                  Text("Categoría: ${product.category}"),
                                  const SizedBox(height: 10),
                                  Text("Descripción: ${product.description}"),
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
                    );
                  },
                  itemCount: productViewModel.products.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productViewModel.fetchProducts();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

