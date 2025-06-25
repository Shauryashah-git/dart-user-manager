import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final apiUrl = 'https://jsonplaceholder.typicode.com/users';
  List<Map<String, dynamic>> users = [];

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      users = List<Map<String, dynamic>>.from(data);
    } else {
      print('Failed to load users. Status code: ${response.statusCode}');
      return;
    }
  } catch (e) {
    print('Error fetching user data: $e');
    return;
  }

  while (true) {
    print('''
==== User Manager Menu ====
1. Show all usernames
2. Show details of a user by ID
3. Filter users by city
4. Exit
Enter your choice:
''');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('\nUsernames:');
        for (var user in users) {
          print('- ${user['username']}');
        }
        break;

      case '2':
        stdout.write('Enter user ID: ');
        String? idInput = stdin.readLineSync();
        int? id = int.tryParse(idInput ?? '');
        if (id == null) {
          print('Invalid ID.');
          break;
        }

        var user = users.firstWhere(
          (u) => u['id'] == id,
          orElse: () => {},
        );

        if (user.isEmpty) {
          print('User with ID $id not found.');
        } else {
          print('\nUser Details:');
          print('Name    : ${user['name']}');
          print('Username: ${user['username']}');
          print('Email   : ${user['email']}');
          print('City    : ${user['address']['city']}');
          print('Company : ${user['company']['name']}');
        }
        break;

      case '3':
        stdout.write('Enter city name: ');
        String? city = stdin.readLineSync();

        var filteredUsers = users.where((u) =>
            u['address']['city'].toString().toLowerCase() ==
            city?.toLowerCase());

        if (filteredUsers.isEmpty) {
          print('No users found in city "$city".');
        } else {
          print('\nUsers in $city:');
          for (var user in filteredUsers) {
            print('- ${user['name']} (${user['username']})');
          }
        }
        break;

      case '4':
        print('Goodbye!');
        return;

      default:
        print('Invalid choice. Please enter a number between 1 and 4.');
    }

    print('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}
