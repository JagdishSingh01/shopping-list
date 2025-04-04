import 'package:flutter/material.dart';
import 'package:shopping/data/categories.dart';
import 'package:shopping/models/category.dart';
import 'package:shopping/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  final _enteredName = TextEditingController();
  final _enteredQuantity = TextEditingController();
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final enteredAmount = int.tryParse(_enteredQuantity.text);
      _formKey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredName.text,
          quantity: enteredAmount!,
          category: _selectedCategory,
          )
        );
    }
  }

   @override
  void dispose() {
    _enteredName.dispose();
    _enteredQuantity.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new item"),
      ),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredName.text = value!;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('Quantity'),
                          ),
                          keyboardType: TextInputType.number,
                          controller: _enteredQuantity,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return 'Must be valid , positive number.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                           _enteredQuantity.text = value!;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                            value: _selectedCategory,
                            items: [
                              for (final category in categories.entries)
                                DropdownMenuItem(
                                    value: category.value,
                                    child: Row(children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: category.value.color,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(category.value.title),
                                    ]))
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            }),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: Text('Reset')),
                      ElevatedButton(
                          onPressed: _saveItem, child: Text('add item'))
                    ],
                  )
                ],
              ))),
    );
  }
}
