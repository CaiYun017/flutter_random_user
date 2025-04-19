import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Screen that fetches and displays random user information
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchRandomUser(); //Fetch user data when screen initializes
  }

  //Function to fetch random user data from API
  Future<void> fetchRandomUser() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data['results'][0];
          isLoading = false;
        });

        // Show a Snackbar to indicate successful refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User refreshed!")),
        );
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      setState(() {
        error = 'Error: ${e.toString()}';  // Capture and display error
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random User Info"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()  // Show loading indicator
            : error != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error!,  // Show error message
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchRandomUser,  // Retry button
                        child: const Text("Retry"),
                      ),
                    ],
                  )
                : UserCard(userData: userData!),  // Display user info
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchRandomUser,
        tooltip: "Refresh",
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

//Widget to display user's detailed information
class UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    //Extract user details
    final name = userData['name'];
    final location = userData['location'];
    final picture = userData['picture'];
    final email = userData['email'];
    final gender = userData['gender'];
    final dob = userData['dob'];
    final phone = userData['phone'];
    final cell = userData['cell'];
    final registered = userData['registered'];
    final login = userData['login'];
    final id = userData['id'];
    final nationality = userData['nat'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Picture
              ClipOval(
                child: Image.network(
                  picture['large'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 100, color: Colors.red);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                '${name['title']} ${name['first']} ${name['last']}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Gender: ${gender[0].toUpperCase()}${gender.substring(1)}',
                style: const TextStyle(color: Colors.grey),
              ),

              const Divider(height: 30),

              // Location Info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.blueGrey),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      '${location['street']['number']} ${location['street']['name']}, '
                      '${location['city']}, ${location['state']}, ${location['country']} - ${location['postcode']}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

              // Contact Info
              _infoRow(Icons.email, 'Email', email),
              const SizedBox(height: 10),
              _infoRow(Icons.phone, 'Phone', phone),
              const SizedBox(height: 10),
              _infoRow(Icons.smartphone, 'Cell', cell),

              const Divider(height: 30),

              // Other Details
              _infoRow(Icons.cake, 'DOB', '${dob['date'].substring(0,10)} (${dob['age']} yrs)'),
              const SizedBox(height: 10),
              _infoRow(Icons.calendar_today, 'Registered', '${registered['date'].substring(0,10)}'),
              const SizedBox(height: 10),
              _infoRow(Icons.account_circle, 'Username', login['username']),
              const SizedBox(height: 10),
              _infoRow(Icons.lock, 'Password', login['password']),
              const SizedBox(height: 10),
              _infoRow(Icons.badge, 'ID', '${id['name']} ${id['value'] ?? 'N/A'}'),
              const SizedBox(height: 10),
              _infoRow(Icons.flag, 'Nationality', nationality),
            ],
          ),
        ),
      ),
    );
  }

  //Helper widget to display an icon with label and value
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
