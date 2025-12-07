import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/resume_model.dart';
import '../../models/personal_info_model.dart';
import '../../models/education_model.dart';
import '../../models/experience_model.dart';
import '../../models/skill_model.dart';
import '../../models/certificate_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';
import 'resume_preview_screen.dart';

class ResumeFormScreen extends StatefulWidget {
  const ResumeFormScreen({super.key});

  @override
  State<ResumeFormScreen> createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _websiteController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _summaryController = TextEditingController();

  // Lists
  List<EducationModel> _educations = [];
  List<ExperienceModel> _experiences = [];
  List<SkillModel> _skills = [];
  List<String> _languages = [];
  List<CertificateModel> _certificates = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _summaryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveResume() async {
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mohon lengkapi data pribadi yang wajib diisi'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final resumeProvider = Provider.of<ResumeProvider>(
        context,
        listen: false,
      );

      if (authProvider.currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      final personalInfo = PersonalInfoModel(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text.isEmpty ? null : _cityController.text,
        country: _countryController.text.isEmpty
            ? null
            : _countryController.text,
        website: _websiteController.text.isEmpty
            ? null
            : _websiteController.text,
        linkedin: _linkedinController.text.isEmpty
            ? null
            : _linkedinController.text,
        github: _githubController.text.isEmpty ? null : _githubController.text,
      );

      final resume = ResumeModel(
        id: const Uuid().v4(),
        uid: authProvider.currentUser!.uid,
        personalInfo: personalInfo,
        education: _educations,
        experience: _experiences,
        skills: _skills,
        languages: _languages,
        certificates: _certificates,
        personalSummary: _summaryController.text.isEmpty
            ? null
            : _summaryController.text,
        templateId: 'minimalist',
        createdAt: DateTime.now(),
      );

      final resumeId = await resumeProvider.createResume(resume);

      if (mounted) {
        if (resumeId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResumePreviewScreen(resumeId: resumeId),
            ),
          );
        } else {
          throw Exception('Gagal menyimpan CV');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat CV Baru'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / 6,
            backgroundColor: Colors.grey[200],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            _buildPersonalInfoPage(),
            _buildEducationPage(),
            _buildExperiencePage(),
            _buildSkillsPage(),
            _buildLanguagesPage(),
            _buildSummaryPage(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPage,
                    child: const Text('Kembali'),
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : (_currentPage == 5 ? _saveResume : _nextPage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _currentPage == 5 ? 'Simpan & Lanjut' : 'Selanjutnya',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Pribadi',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan informasi pribadi Anda',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap *',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Email tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Nomor Telepon *',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true
                ? 'Nomor telepon tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Alamat *',
              prefixIcon: Icon(Icons.home),
            ),
            maxLines: 2,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Alamat tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Kota',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Negara',
                    prefixIcon: Icon(Icons.flag),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              labelText: 'Website (Opsional)',
              prefixIcon: Icon(Icons.language),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _linkedinController,
            decoration: const InputDecoration(
              labelText: 'LinkedIn (Opsional)',
              prefixIcon: Icon(Icons.work),
            ),
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _githubController,
            decoration: const InputDecoration(
              labelText: 'GitHub (Opsional)',
              prefixIcon: Icon(Icons.code),
            ),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pendidikan',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan riwayat pendidikan Anda',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          if (_educations.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.school, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pendidikan',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _educations.length,
              itemBuilder: (context, index) {
                final edu = _educations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(edu.degree),
                    subtitle: Text(
                      '${edu.institution}\n${edu.startDate} - ${edu.endDate ?? "Sekarang"}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _educations.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showAddEducationDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Pendidikan'),
          ),
        ],
      ),
    );
  }

  Widget _buildExperiencePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengalaman Kerja',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan pengalaman kerja Anda',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          if (_experiences.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.work, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pengalaman',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _experiences.length,
              itemBuilder: (context, index) {
                final exp = _experiences[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(exp.position),
                    subtitle: Text(
                      '${exp.company}\n${exp.startDate} - ${exp.endDate ?? "Sekarang"}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _experiences.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showAddExperienceDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Pengalaman'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keahlian',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan keahlian Anda',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          if (_skills.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.star, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada keahlian',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                return Chip(
                  label: Text(skill.name),
                  onDeleted: () {
                    setState(() {
                      _skills.remove(skill);
                    });
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showAddSkillDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Keahlian'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bahasa',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan bahasa yang Anda kuasai',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          if (_languages.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.language, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada bahasa',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _languages.map((lang) {
                return Chip(
                  label: Text(lang),
                  onDeleted: () {
                    setState(() {
                      _languages.remove(lang);
                    });
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showAddLanguageDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Bahasa'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Diri',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Ceritakan tentang diri Anda (opsional)',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _summaryController,
            decoration: const InputDecoration(
              labelText: 'Ringkasan Profesional',
              hintText:
                  'Contoh: Software Developer dengan 2+ tahun pengalaman...',
              alignLabelWithHint: true,
            ),
            maxLines: 8,
          ),
        ],
      ),
    );
  }

  void _showAddEducationDialog() {
    final institutionController = TextEditingController();
    final degreeController = TextEditingController();
    final fieldController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pendidikan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: institutionController,
                decoration: const InputDecoration(labelText: 'Institusi'),
              ),
              TextField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: 'Gelar'),
              ),
              TextField(
                controller: fieldController,
                decoration: const InputDecoration(labelText: 'Jurusan'),
              ),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: 'Tahun Mulai'),
              ),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'Tahun Selesai (kosongkan jika masih berlangsung)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (institutionController.text.isNotEmpty &&
                  degreeController.text.isNotEmpty) {
                setState(() {
                  _educations.add(
                    EducationModel(
                      id: const Uuid().v4(),
                      institution: institutionController.text,
                      degree: degreeController.text,
                      fieldOfStudy: fieldController.text,
                      startDate: startDateController.text,
                      endDate: endDateController.text.isEmpty
                          ? null
                          : endDateController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showAddExperienceDialog() {
    final companyController = TextEditingController();
    final positionController = TextEditingController();
    final locationController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pengalaman'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: companyController,
                decoration: const InputDecoration(labelText: 'Perusahaan'),
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Posisi'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Lokasi'),
              ),
              TextField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: 'Tahun Mulai'),
              ),
              TextField(
                controller: endDateController,
                decoration: const InputDecoration(
                  labelText: 'Tahun Selesai (kosongkan jika masih bekerja)',
                ),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (companyController.text.isNotEmpty &&
                  positionController.text.isNotEmpty) {
                setState(() {
                  _experiences.add(
                    ExperienceModel(
                      id: const Uuid().v4(),
                      company: companyController.text,
                      position: positionController.text,
                      location: locationController.text,
                      startDate: startDateController.text,
                      endDate: endDateController.text.isEmpty
                          ? null
                          : endDateController.text,
                      description: descController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showAddSkillDialog() {
    final skillController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Keahlian'),
        content: TextField(
          controller: skillController,
          decoration: const InputDecoration(labelText: 'Nama Keahlian'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (skillController.text.isNotEmpty) {
                setState(() {
                  _skills.add(
                    SkillModel(
                      id: const Uuid().v4(),
                      name: skillController.text,
                      category: 'General',
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showAddLanguageDialog() {
    final langController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Bahasa'),
        content: TextField(
          controller: langController,
          decoration: const InputDecoration(labelText: 'Nama Bahasa'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (langController.text.isNotEmpty) {
                setState(() {
                  _languages.add(langController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }
}
