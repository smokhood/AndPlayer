import 'dart:io';
import 'package:flutter/material.dart';
import 'now_playing_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class OfflinePage extends StatefulWidget {
  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  List<File> _songs = [];
  List<File> _displayedSongs = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  File? _nowPlaying;
  int _selectedIndex = 1; // Default to Songs tab
  List<Playlist> _playlists = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchSongs();
  }

  Future<void> _checkPermissionsAndFetchSongs() async {
    if (await Permission.storage.request().isGranted) {
      _fetchLocalSongs();
    } else {
      print('Storage permission denied');
    }
  }

  Future<void> _fetchLocalSongs() async {
    List<File> songs = [];
    try {
      // Check multiple directories
      List<Directory?> directories = await _getMusicDirectories();
      for (Directory? directory in directories) {
        if (directory != null && await directory.exists()) {
          List<FileSystemEntity> files = directory.listSync(recursive: true);
          for (FileSystemEntity file in files) {
            if (file is File && file.path.endsWith('.mp3')) {
              songs.add(file);
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching local songs: $e');
    }
    setState(() {
      _songs = songs;
      _displayedSongs = songs;
    });
  }

  Future<List<Directory?>> _getMusicDirectories() async {
    List<Directory?> directories = [];

    // Get the external storage directory
    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    if (externalStorageDirectory != null) {
      directories.add(Directory('${externalStorageDirectory.path}/Music'));
    }

    // Get the external storage directories (for other potential locations)
    List<Directory>? externalStorageDirectories = await getExternalStorageDirectories();
    if (externalStorageDirectories != null) {
      for (Directory dir in externalStorageDirectories) {
        directories.add(Directory('${dir.path}/Music'));
      }
    }

    // Add other common directories
    directories.add(Directory('/storage/emulated/0/Music'));
    directories.add(Directory('/storage/sdcard/Music'));
    directories.add(Directory('/storage/emulated/snaptube/download/Snaptube Audio'));
    directories.add(Directory('/storage/emulated/0/WhatsApp/Media/WhatsApp Audio'));
    directories.add(Directory('/storage/emulated/0/Download'));




    return directories;
  }

  void _sortSongs() {
    setState(() {
      _displayedSongs.sort((a, b) => a.path.split('/').last.compareTo(b.path.split('/').last));
    });
  }

  void _searchSongs(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _displayedSongs = _songs.where((song) => song.path.toLowerCase().contains(_searchQuery)).toList();
    });
  }

  void _refreshSongs() async {
    _fetchLocalSongs();
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _createPlaylist(String name) {
    setState(() {
      _playlists.add(Playlist(name: name, songs: []));
    });
  }

  void _renamePlaylist(int index, String newName) {
    setState(() {
      _playlists[index].name = newName;
    });
  }

  void _addSongToPlaylist(int playlistIndex, File song) {
    setState(() {
      _playlists[playlistIndex].songs.add(song);
    });
  }

  List<Widget> _buildPages() {
    return [
      _buildPlaylistsPage(),
      _buildSongsPage(),
      _buildArtistsPage(),
    ];
  }

  Widget _buildSongsPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
            ),
            onChanged: _searchSongs,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _displayedSongs.length,
            itemBuilder: (context, index) {
              File song = _displayedSongs[index];
              bool isNowPlaying = _nowPlaying == song;
              return ListTile(
                title: Text(
                  song.path.split('/').last,
                  style: TextStyle(color: Colors.white),
                ),
                tileColor: isNowPlaying ? Colors.blue.withOpacity(0.5) : null,
                onTap: () {
                  setState(() {
                    _nowPlaying = song;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlayingPage(filePath: song.path),
                    ),
                  );
                },
                trailing: PopupMenuButton<int>(
                  onSelected: (value) {
                    if (value == 0) {
                      _showAddToPlaylistDialog(song);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text('Add to Playlist'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddToPlaylistDialog(File song) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Playlist'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _playlists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_playlists[index].name),
                  onTap: () {
                    _addSongToPlaylist(index, song);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Your playlists:',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _playlists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_playlists[index].name, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistSongsPage(playlist: _playlists[index]),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _showRenameDialog(index);
                  },
                ),
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Press the button below to create a new playlist',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              FloatingActionButton(
                onPressed: () {
                  _showCreatePlaylistDialog();
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRenameDialog(int index) {
    TextEditingController renameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename Playlist'),
          content: TextField(
            controller: renameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _renamePlaylist(index, renameController.text);
                Navigator.pop(context);
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  void _showCreatePlaylistDialog() {
    TextEditingController playlistController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Playlist'),
          content: TextField(
            controller: playlistController,
            decoration: InputDecoration(hintText: "Enter playlist name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createPlaylist(playlistController.text);
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildArtistsPage() {
    // Example artists
    List<String> artists = ["Juice Wrld", "Drake", "Atif Aslam","Kendrick Lamar","Travis Scott"];

    return ListView.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(artists[index], style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtistSongsPage(artistName: artists[index], songs: _songs),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Music'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _sortSongs,
            tooltip: 'Sort',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshSongs,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg2.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          _buildPages()[_selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Artists',
          ),
        ],
      ),
    );
  }
}

class PlaylistSongsPage extends StatelessWidget {
  final Playlist playlist;

  PlaylistSongsPage({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playlist.name),
      ),
      body: ListView.builder(
        itemCount: playlist.songs.length,
        itemBuilder: (context, index) {
          File song = playlist.songs[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  song.path.split('/').last,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                tileColor: Colors.black.withOpacity(0.7),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NowPlayingPage(filePath: song.path),
                    ),
                  );
                },
              ),
              Divider(
                color: Colors.white.withOpacity(0.5),
                thickness: 0.5,
                height: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}

class Playlist {
  String name;
  List<File> songs;

  Playlist({required this.name, this.songs = const []});
}

class ArtistSongsPage extends StatelessWidget {
  final String artistName;
  final List<File> songs;

  ArtistSongsPage({required this.artistName, required this.songs});

  @override
  Widget build(BuildContext context) {
    List<File> artistSongs = songs.where((song) {
      // Add your logic here to filter songs by artist
      return song.path.toLowerCase().contains(artistName.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(artistName),
      ),
      body: ListView.builder(
        itemCount: artistSongs.length,
        itemBuilder: (context, index) {
          File song = artistSongs[index];
          return ListTile(
            title: Text(
              song.path.split('/').last,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Colors.black.withOpacity(0.7),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NowPlayingPage(filePath: song.path),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
