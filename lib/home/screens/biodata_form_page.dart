import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_detail_screen.dart'; // Import screen Profile Detail
import 'package:intl/intl.dart';  // Untuk format tanggal

class BiodataFormPage extends StatefulWidget {
  final String userId;

  BiodataFormPage({required this.userId});

  @override
  _BiodataFormPageState createState() => _BiodataFormPageState();
}

class _BiodataFormPageState extends State<BiodataFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Inisialisasi variabel untuk field
  String name = '';
  String email = '';
  String address = '';
  String phone = '';
  String city = '';
  String gender = 'Laki-laki';
  String job = 'Wirausaha'; 
  String maritalStatus = 'Menikah'; 
  String workLocation = ''; 
  String otherJob = ''; 
  String otherMaritalStatus = ''; 
  String childrenCount = ''; 
  String childrenDetails = ''; 
  String healthDescription = ''; 
  String economicCondition = ''; 
  String currentCondition = ''; 
  String hopes = ''; 
  String candidateSuggestion = ''; 
  String lastClass = ''; // Field baru untuk Asal Kelas
  String bidangLokasiKerja = ''; // Field baru untuk Bidang/Lokasi Kerja
  DateTime? selectedDate;  
  String formattedDate = '';

  // Inisialisasi koleksi Firestore
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // Fungsi untuk menyimpan data ke Firestore
  Future<void> _saveBiodata() async {
    try {
      await usersCollection.doc(widget.userId).set({
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'city': city,
        'gender': gender,
        'job': job == 'Lainnya' ? otherJob : job,  
        'maritalStatus': maritalStatus == 'Lainnya' ? otherMaritalStatus : maritalStatus, 
        'workLocation': workLocation,  
        'childrenCount': childrenCount, 
        'childrenDetails': childrenDetails, 
        'healthDescription': healthDescription, 
        'economicCondition': economicCondition, 
        'currentCondition': currentCondition, 
        'hopes': hopes, 
        'candidateSuggestion': candidateSuggestion, 
        'lastClass': lastClass, // Menyimpan field Asal Kelas
        'bidangLokasiKerja': bidangLokasiKerja, // Menyimpan field Bidang/Lokasi Kerja
        'graduationYear': formattedDate,  
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biodata berhasil disimpan!')),
      );

      // Navigasi ke halaman ProfileDetailScreen setelah data berhasil disimpan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetailScreen(
            userId: widget.userId, 
            username: name, // Kirim nama yang diisi ke ProfileDetailScreen
            email: email,   // Kirim email yang diisi ke ProfileDetailScreen
          ),
        ),
      );
    } catch (e) {
      print('Error saving biodata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan biodata.')),
      );
    }
  }

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),  
      lastDate: DateTime(2101),   
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('MMMM yyyy').format(picked);  
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Apakah kamu ingin diingat oleh temanmu?",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                "Maka isi data diri kamu di bawah ini!",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              
              // Nama Lengkap Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 20),

              // Jenis Kelamin Field
              Text('Jenis Kelamin', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Pria'),
                      leading: Radio<String>(
                        value: 'Laki-laki',
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Wanita'),
                      leading: Radio<String>(
                        value: 'Perempuan',
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),

              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Tolong berikan email yang benar';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Alamat Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Alamat/Domisili',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Kota Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kota/Kab',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    city = value;
                  });
                },
              ),  

              SizedBox(height: 20),

              // Nomor HP Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Tahun Lulus/Keluar Field (Date Picker)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tahun Lulus/Keluar',
                  border: UnderlineInputBorder(),
                ),
                readOnly: true, 
                onTap: () {
                  _selectDate(context); 
                },
                controller: TextEditingController(text: formattedDate), 
              ),

              SizedBox(height: 20),

              // Pekerjaan Field (Radio Button)
              Text('Pekerjaan', style: TextStyle(fontSize: 16)),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Wirausaha'),
                    value: 'Wirausaha',
                    groupValue: job,
                    onChanged: (String? value) {
                      setState(() {
                        job = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('PNS'),
                    value: 'PNS',
                    groupValue: job,
                    onChanged: (String? value) {
                      setState(() {
                        job = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Karyawan Swasta'),
                    value: 'Karyawan Swasta',
                    groupValue: job,
                    onChanged: (String? value) {
                      setState(() {
                        job = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Karyawan BUMN'),
                    value: 'Karyawan BUMN',
                    groupValue: job,
                    onChanged: (String? value) {
                      setState(() {
                        job = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Pensiun'),
                    value: 'Pensiun',
                    groupValue: job,
                    onChanged: (String? value) {
                      setState(() {
                        job = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Lainnya'),
                    value: 'Lainnya',
                    groupValue: job,
                    onChanged: (String? value) {
                      setState(() {
                        job = value!;
                      });
                    },
                  ),
                  if (job == 'Lainnya')
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Sebutkan Pekerjaan',
                      ),
                      onChanged: (value) {
                        setState(() {
                          otherJob = value;
                        });
                      },
                    ),
                ],
              ),

              SizedBox(height: 20),

              // Status Perkawinan Field
              Text('Status Perkawinan', style: TextStyle(fontSize: 16)),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Menikah'),
                    value: 'Menikah',
                    groupValue: maritalStatus,
                    onChanged: (String? value) {
                      setState(() {
                        maritalStatus = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Belum Menikah'),
                    value: 'Belum Menikah',
                    groupValue: maritalStatus,
                    onChanged: (String? value) {
                      setState(() {
                        maritalStatus = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Duda'),
                    value: 'Duda',
                    groupValue: maritalStatus,
                    onChanged: (String? value) {
                      setState(() {
                        maritalStatus = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Janda'),
                    value: 'Janda',
                    groupValue: maritalStatus,
                    onChanged: (String? value) {
                      setState(() {
                        maritalStatus = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Lainnya'),
                    value: 'Lainnya',
                    groupValue: maritalStatus,
                    onChanged: (String? value) {
                      setState(() {
                        maritalStatus = value!;
                      });
                    },
                  ),
                  if (maritalStatus == 'Lainnya')
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Sebutkan Status Perkawinan',
                      ),
                      onChanged: (value) {
                        setState(() {
                          otherMaritalStatus = value;
                        });
                      },
                    ),
                ],
              ),

              SizedBox(height: 20),

              // Asal Kelas Field (Baru)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Asal Kelas',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    lastClass = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Bidang/Lokasi Kerja Field (Baru)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bidang/Lokasi Kerja',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    bidangLokasiKerja = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Jumlah Anak Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Anak',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    childrenCount = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Keterangan Anak Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Keterangan Anak (Opsional)',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    childrenDetails = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Keterangan Kesehatan Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Keterangan Kesehatan',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    healthDescription = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Kondisi Ekonomi Keluarga Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kondisi Ekonomi Keluarga',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    economicCondition = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Kondisi Saat Ini Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kondisi Saat Ini (Istri/Suami) dan Kesibukan Sehari-hari',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    currentCondition = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Harapan Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Harapan',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    hopes = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Kandidat Ketua Ikatan Alumni Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Jika Ada Pemilihan Ketua Ikatan Alumni Angkatan, Siapa Kandidat yang Anda Usulkan?',
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    candidateSuggestion = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Tombol Simpan
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveBiodata(); // Menyimpan data ke Firestore dan navigasi ke ProfileDetailScreen
                    }
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
