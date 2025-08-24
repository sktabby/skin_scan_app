import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_page.dart'; // Import HomePage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImagePath;
  final TextEditingController _nameController = TextEditingController(text: "Shaikh Tabish");
  final TextEditingController _dobController = TextEditingController(text: "28/03/2003");
  final TextEditingController _emailController = TextEditingController(text: "21co52@aiktc.ac.in");

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFE8EF),
      appBar: AppBar(
        title: Text(
          'SkinScan',
          style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _drawerItem(Icons.home, "HOME", _navigateToHome),
            _drawerItem(Icons.category, "CATEGORIES"),
            _drawerItem(Icons.image, "IMAGES"),
            _drawerItem(Icons.report, "REPORT"),
            _drawerItem(Icons.contact_mail, "CONTACT US"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[200],
                    backgroundImage: _profileImagePath != null ? AssetImage(_profileImagePath!) : null,
                    child: _profileImagePath == null ? Icon(Icons.person, size: 60) : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Shaikh Tabish",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),

              // User Details
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _infoField("NAME", _nameController),
                    Row(
                      children: [
                        Expanded(child: _infoField("DOB", _dobController)),
                        SizedBox(width: 10),
                        Expanded(child: _infoField("GENDER", TextEditingController(text: "M"), enabled: false)),
                      ],
                    ),
                    _infoField("Email", _emailController),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Report Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "REPORT",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue, width: 1.5),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  "NOT TESTED YET",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          if (index == 0) {
            _navigateToHome();
          }
        },
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }

  Widget _infoField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
