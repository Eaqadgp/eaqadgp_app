import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Item> items = [
    Item('Item1', 200),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),
    Item('Item2', 50),

  ];
  List<Item> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child:ListView.builder(
                itemCount: items.length,
                itemBuilder: (x,index)=>ItemCard(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(items[index])) {
                        selectedItems.remove(items[index]);
                      } else {
                        selectedItems.add(items[index]);
                      }
                    });
                  },
                  item: items[index],
                  isSelected: selectedItems.contains(items[index]),
                ))
            ),
          Expanded(
            child:ListView.builder(
                itemCount: items.length,
                itemBuilder: (x,index)=>ItemCard(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(items[index])) {
                        selectedItems.remove(items[index]);
                      } else {
                        selectedItems.add(items[index]);
                      }
                    });
                  },
                  item: items[index],
                  isSelected: selectedItems.contains(items[index]),
                ))
            ),
          Expanded(
            child:ListView.builder(
                itemCount: items.length,
                itemBuilder: (x,index)=>ItemCard(
                  onTap: () {
                    setState(() {
                      if (selectedItems.contains(items[index])) {
                        selectedItems.remove(items[index]);
                      } else {
                        selectedItems.add(items[index]);
                      }
                    });
                  },
                  item: items[index],
                  isSelected: selectedItems.contains(items[index]),
                ))
            ),
        ],
      ),
      floatingActionButton: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        onPressed: () {},
        child: Text('${selectedItems.length} Items',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }


}

class Item {
  String? title;
  int? price;

  Item(title, price){
    this.title = title;
    this.price = price;
  }
}
class ItemCard extends StatelessWidget {
  final void Function() onTap;
  final bool isSelected;
  final Item item;
  const ItemCard(
      { required this.onTap, required this.isSelected, required this.item});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      onPressed: onTap,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.title!, style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text('\$${item.price}')
              ],
            ),
          ),
          if (isSelected)  // Show tick mark only if item is selected
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}