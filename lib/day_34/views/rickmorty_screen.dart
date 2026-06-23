import 'package:flutter/material.dart';
import 'package:latihan_flutterd7/day_33/services/dio_client.dart';
import 'package:latihan_flutterd7/day_34/models/rickmorty_models.dart';
import 'package:latihan_flutterd7/day_34/services/api_rickmorty_services.dart';

class RickmortyScreen extends StatefulWidget {
  const RickmortyScreen({super.key});

  @override
  State<RickmortyScreen> createState() => _RickmortyScreenState();
}

class _RickmortyScreenState extends State<RickmortyScreen> {
  late final ApiRickmortyService _apiRickmortyService;
  late Future<RickmortyModels> _rickmortyfuture;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiRickmortyService = ApiRickmortyService(dio);
    _rickmortyfuture = _apiRickmortyService.getAllPosts();
  }

  void _refreshPosts() {
    setState(() {
      _rickmortyfuture = _apiRickmortyService.getAllPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        // iconTheme: const IconThemeData(color: Colors.white),
      ), // AppBar
      body: FutureBuilder<RickmortyModels>(
        future: _rickmortyfuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ), // Text
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshPosts,
                      child: const Text('Coba Lagi'),
                    ), // ElevatedButton
                  ],
                ), // Column
              ), // Padding
            ); // Center
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data post.'));
          }

          final posts = snapshot.data!.results;

          return RefreshIndicator(
            onRefresh: () async => _refreshPosts(),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ), // EdgeInsets.symmetric
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        '${post.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ), // TextStyle
                      ), // Text
                    ), // CircleAvatar
                    title: Text(
                      post.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ), // Text
                    // subtitle: Text(
                    //   post.status,
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    // ), // Text
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ), // ListTile
                ); // Card
              },
            ), // ListView.builder
          ); // RefreshIndicator
        },
      ), // FutureBuilder

      //
    );
  }
}
