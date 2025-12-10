import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.model.dart';
import '../models/cart_product.model.dart';
import '../models/user.model.dart';
import '../models/product.model.dart';
import '../viewmodels/cart.viewmodel.dart';
import '../viewmodels/user.viewmodel.dart';
import '../viewmodels/product.viewmodel.dart';

class CartFormView extends StatefulWidget {
  final Cart? cart;

  const CartFormView({super.key, this.cart});

  @override
  State<CartFormView> createState() => _CartFormViewState();
}

class _CartFormViewState extends State<CartFormView> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedUserId;
  late int _idController;
  List<CartProduct> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _idController = widget.cart?.id ?? 0;
    _selectedUserId = widget.cart?.userId;
    _products = widget.cart?.products.toList() ?? [];
    
    // Cargar usuarios y productos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchUsers();
      Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
    });
  }

  void _addProduct() {
    showDialog(
      context: context,
      builder: (context) => _AddProductDialog(
        onAdd: (productId, quantity) {
          setState(() {
            _products.add(CartProduct(productId, quantity));
          });
        },
        availableProducts: Provider.of<ProductViewModel>(context, listen: false).products,
      ),
    );
  }

  void _editProduct(int index) {
    final product = _products[index];
    showDialog(
      context: context,
      builder: (context) => _AddProductDialog(
        productId: product.productId,
        quantity: product.quantity,
        onAdd: (productId, quantity) {
          setState(() {
            _products[index] = CartProduct(productId, quantity);
          });
        },
        availableProducts: Provider.of<ProductViewModel>(context, listen: false).products,
      ),
    );
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context);
    final productViewModel = Provider.of<ProductViewModel>(context);
    final isEditing = widget.cart != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Carrito' : 'Nuevo Carrito'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selector de Usuario
              Consumer<UserViewModel>(
                builder: (context, userVM, child) {
                  if (userVM.cargando) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  if (userVM.users.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No hay usuarios disponibles',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => userVM.fetchUsers(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Cargar usuarios'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return DropdownButtonFormField<int>(
                    value: _selectedUserId,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: userVM.users.map((user) {
                      return DropdownMenuItem<int>(
                        value: user.id,
                        child: Text('${user.username} (ID: ${user.id})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona un usuario';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Título de productos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Productos (${_products.length})',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addProduct,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Lista de productos
              if (_products.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos en el carrito',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Presiona "Agregar" para añadir productos',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final productInfo = productViewModel.products.firstWhere(
                    (p) => p.id == product.productId,
                    orElse: () => Product(0, 'Producto eliminado', 0, '', '', ''),
                  );
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(
                        productInfo.title.isNotEmpty 
                            ? productInfo.title 
                            : 'Producto ID: ${product.productId}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${product.productId}'),
                          Text('Cantidad: ${product.quantity}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editProduct(index),
                            tooltip: 'Editar',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeProduct(index),
                            color: Colors.red,
                            tooltip: 'Eliminar',
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              
              const SizedBox(height: 32),
              
              // Botón de guardar
              ElevatedButton(
                onPressed: _isLoading ? null : () => _saveCart(cartViewModel),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isEditing ? 'Actualizar Carrito' : 'Crear Carrito',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCart(CartViewModel cartViewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor agrega al menos un producto al carrito'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cart = Cart(
      _idController,
      _selectedUserId!,
      _products,
    );

    bool success;
    if (widget.cart != null) {
      success = await cartViewModel.updateCart(_idController, cart);
    } else {
      success = await cartViewModel.createCart(cart);
    }

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.cart != null
                ? 'Carrito actualizado exitosamente'
                : 'Carrito creado exitosamente',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cartViewModel.error ?? 'Error al guardar el carrito',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _AddProductDialog extends StatefulWidget {
  final int? productId;
  final int? quantity;
  final Function(int productId, int quantity) onAdd;
  final List<Product> availableProducts;

  const _AddProductDialog({
    this.productId,
    this.quantity,
    required this.onAdd,
    required this.availableProducts,
  });

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  int? _selectedProductId;
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.productId;
    _quantityController.text = widget.quantity?.toString() ?? '1';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.productId != null ? 'Editar Producto' : 'Agregar Producto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: widget.availableProducts.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay productos disponibles',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Por favor carga productos primero',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: _selectedProductId,
                      decoration: const InputDecoration(
                        labelText: 'Producto',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag),
                      ),
                      items: widget.availableProducts.map((product) {
                        return DropdownMenuItem<int>(
                          value: product.id,
                          child: Text('${product.title} (ID: ${product.id})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProductId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona un producto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una cantidad';
                        }
                        final quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'La cantidad debe ser un número mayor a 0';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        if (widget.availableProducts.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onAdd(
                  _selectedProductId!,
                  int.parse(_quantityController.text),
                );
                Navigator.pop(context);
              }
            },
            child: Text(widget.productId != null ? 'Actualizar' : 'Agregar'),
          ),
      ],
    );
  }
}

