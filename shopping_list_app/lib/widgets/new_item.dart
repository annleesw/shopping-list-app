import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/category_models.dart';
import 'package:shopping_list_app/models/grocery_item_models.dart';

class NewItem extends StatefulWidget{
 const NewItem({super.key});

  @override
 State<NewItem> createState() {
    return _NewItemState();
 }
}

class _NewItemState extends State<NewItem>{
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!; //! to avoid null safety error

  void _saveItem () {
    if (_formKey.currentState!.validate()) { //execute validation
      _formKey.currentState!.save(); //save form data
      Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now().toString(), 
          name: _enteredName, 
          quantity: _enteredQuantity, 
          category: _selectedCategory,
        ),
      ); //close the form
    } 
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField( //instead of TextField()
                maxLength: 50,
                decoration: const InputDecoration( //1st row: name
                  label: Text('Name'),
                ),
                validator: (value) { //validate input
                  if (value == null || 
                     value.isEmpty || 
                     value.trim().length <= 1 ||
                     value.trim().length > 50) {
                    return 'Please enter a name between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row( //2nd row: quantity and category
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: '1',
                      validator: (value) { //validate input
                        if (value == null || 
                          value.isEmpty || 
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                          return 'Please enter a valid positive number';
                        }
                        return null; 
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!); //parse output error, tryparse yields null
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row( //2nd row: category color sqr and title
                              children: [
                                Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ], 
                      onChanged: (value) {
                        setState(() { //update UI aka onSaved()
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row( //3rd row: buttons
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    }, 
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem, 
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}