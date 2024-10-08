import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'biodata_form_page.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String email;
  final String? profileImageUrl;

  ProfileDetailScreen({
    required this.userId,
    required this.username,
    required this.email,
    this.profileImageUrl,
  });

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  // Data yang akan ditampilkan di profil
  String name = '';
  String gender = 'Laki-laki';
  String address = '';
  String city = '';
  String phone = '';
  String tahunLulus = '';
  String job = '';
  String maritalStatus = '';
  String siblings = '';
  String lastClass = ''; 
  String bidangLokasiKerja = ''; 
  String jumlahAnak = ''; 
  String kondisiSaatIni = '';
  String hopes = '';
  String candidateSuggestion = '';

  String? _profileImageUrl;

  // Instansiasi Firestore
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _profileImageUrl = widget.profileImageUrl;
    name = widget.username;
    _loadProfileData(); // Memuat data dari Firestore
  }

  @override
  void didUpdateWidget(ProfileDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userId != oldWidget.userId) {
      _loadProfileData(); // Muat ulang data jika userId berubah
    }
  }

  // Fungsi untuk memuat data dari Firestore
  Future<void> _loadProfileData() async {
    print("Memuat data untuk userId: ${widget.userId}");
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(widget.userId).get();

      if (userDoc.exists) {
        print("Data ditemukan: ${userDoc.data()}");
        setState(() {
          name = userDoc['name'] ?? '';
          gender = userDoc['gender'] ?? 'Laki-laki';
          address = userDoc['address'] ?? '';  // Alamat dari Firestore
          city = userDoc['city'] ?? '';        // Kota dari Firestore
          phone = userDoc['phone'] ?? '';      // Telepon dari Firestore
          tahunLulus = userDoc['graduationYear'] ?? ''; // Tahun lulus
          job = userDoc['job'] ?? '';          // Pekerjaan dari Firestore
          maritalStatus = userDoc['maritalStatus'] ?? ''; // Status pernikahan
          siblings = userDoc['childrenCount'] ?? ''; // Jumlah anak
          lastClass = userDoc['lastClass'] ?? ''; // Asal kelas terakhir
          bidangLokasiKerja = userDoc['bidangLokasiKerja'] ?? ''; // Bidang/Lokasi kerja
          kondisiSaatIni = userDoc['currentCondition'] ?? ''; // Kondisi saat ini
          hopes = userDoc['hopes'] ?? ''; // Harapan
          candidateSuggestion = userDoc['candidateSuggestion'] ?? ''; // Kandidat ketua alumni
          jumlahAnak = userDoc['childrenCount'] ?? ''; // Jumlah anak
        });
      } else {
        print("Tidak ada data ditemukan untuk userId ini.");
      }
    } catch (e) {
      print('Terjadi kesalahan saat memuat data profil dari Firestore: $e');
    }
  }

  // Widget untuk menampilkan field profil
  Widget _buildProfileField(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(value.isNotEmpty ? value : 'Data tidak tersedia'),
          ),
        ),
        Divider(thickness: 1), // Garis pemisah
      ],
    );
  }

  // Header profil dengan foto dan nama
  Widget _buildProfileHeader() {
    return Stack(
      children: [
        ClipPath(
          clipper: CustomCurveClipper(),
          child: Container(
            padding: const EdgeInsets.all(30.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 10, 90, 156),
                  Color.fromARGB(255, 10, 90, 156)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: 140,
          ),
        ),
        ClipPath(
          clipper: CustomCurveClipper2(),
          child: Container(
            padding: const EdgeInsets.all(30.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 106, 62, 182)
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            height: 140,
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 140,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showProfileDialog,
                  child: CircleAvatar(
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : AssetImage('lib/assets/images/user1.png') as ImageProvider,
                    radius: 40,
                  ),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.username.isNotEmpty ? widget.username : 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.email.isNotEmpty ? widget.email : 'Email tidak tersedia',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Dialog untuk mengubah foto profil
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : AssetImage('lib/assets/images/user1.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Ubah Foto"),
                onPressed: () {
                  _pickImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _uploadImageToFirebase(file);
    }
  }

  Future<void> _uploadImageToFirebase(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${widget.userId}.jpg');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'profileImage': downloadUrl,
      });
    } catch (e) {
      print('Terjadi kesalahan saat mengunggah gambar ke Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Detail'),
        backgroundColor: const Color.fromRGBO(15, 128, 221, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BiodataFormPage(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              _buildProfileField('Nama', name),
              _buildProfileField('Email', widget.email),
              _buildProfileField('Alamat', address),
              _buildProfileField('Kota', city),
              _buildProfileField('Telepon', phone),
              _buildProfileField('Tahun Lulus', tahunLulus),
              _buildProfileField('Pekerjaan', job),
              _buildProfileField('Status Pernikahan', maritalStatus),
              _buildProfileField('Jumlah Anak', siblings),
              _buildProfileField('Asal Kelas Terakhir', lastClass),
              _buildProfileField('Bidang/Lokasi Kerja', bidangLokasiKerja),
              _buildProfileField('Harapan', hopes),
              _buildProfileField('Ketua Alumni', candidateSuggestion),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clippers untuk efek gradasi pada header
class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width - 70, 0);
    path.quadraticBezierTo(size.width, size.height / 1, size.width - 150, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomCurveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width - 70, 0);
    path.quadraticBezierTo(size.width, size.height / 1, size.width - 150, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
