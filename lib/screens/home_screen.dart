import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../widgets/user_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_display.dart';
import '../screens/user_detail_screen.dart';
import '../screens/user_form_screen.dart';

enum LoadingState { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LoadingState _state = LoadingState.loading;
  List<User> _users = [];
  String _errorMessage = '';
  String _searchQuery = '';

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void initState() {
    super.initState();
    _listenToNetwork();
    _fetchUsers();
  }

  void _listenToNetwork() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = !results.contains(ConnectivityResult.none);

      if (hasConnection) {
        if (_state == LoadingState.error) {
          _fetchUsers();
        }
      }
    });
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _state = LoadingState.loading;
      _errorMessage = '';
    });

    final results = await Connectivity().checkConnectivity();

    if (results.contains(ConnectivityResult.none)) {
      setState(() {
        _errorMessage = "Không có kết nối Internet.";
        _state = LoadingState.error;
      });
      return;
    }

    try {
      final users = await UserService.fetchUsers();
      setState(() {
        _users = users;
        _state = LoadingState.success;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Không thể tải dữ liệu. Kiểm tra kết nối mạng.";
        _state = LoadingState.error;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'TH3 - Trương Quang Việt Hoàng - 2351060450',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),

      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search user...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
          if (result == true) _fetchUsers();
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case LoadingState.loading:
        return const LoadingWidget(message: 'Loading users...');

      case LoadingState.success:
        return _buildUsersList();

      case LoadingState.error:
        return ErrorDisplay(message: _errorMessage, onRetry: _fetchUsers);
    }
  }

  Widget _buildUsersList() {
    if (_users.isEmpty) {
      return const Center(child: Text("No users found"));
    }

    final filteredUsers = _users.where((user) {
      return user.name.toLowerCase().contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery);
    }).toList();

    final width = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (width > 1200) {
      crossAxisCount = 4;
    } else if (width > 800) {
      crossAxisCount = 3;
    }

    return RefreshIndicator(
      onRefresh: _fetchUsers,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredUsers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final user = filteredUsers[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),

            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
              );

              if (result == true) {
                _fetchUsers();
              }
            },

            // 👉 GIỮ LÂU để xoá
            onLongPress: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Xác nhận xoá"),
                  content: Text("Bạn có chắc muốn xoá ${user.name}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Huỷ"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Xoá"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await UserService.deleteUser(user.id);
                _fetchUsers();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã xoá user thành công")),
                );
              }
            },

            child: UserCard(user: user),
          );
        },
      ),
    );
  }
}
