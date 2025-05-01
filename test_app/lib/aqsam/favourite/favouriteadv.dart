import 'package:flutter/material.dart';

class Favouriteadv extends StatefulWidget {
  const Favouriteadv({super.key});

  @override
  State<Favouriteadv> createState() => _FavouriteadvState();
}

class _FavouriteadvState extends State<Favouriteadv> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "الإعلانات المفضلة",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: _controller,

                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF68316D),
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    suffixIcon:
                        _controller.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                });
                              },
                            )
                            : const Icon(Icons.search),
                    hintText: "إبحث في إعلاناتك المفضلة",
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),

              const Expanded(
                child: Center(
                  child: Text(
                    "لا يوجد لديك أي إعلان مفضل",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
