import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_services.dart';
import '../../../../shared/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await AppServices.profileRepository.getProfile();
      if (!mounted) return;
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showLinkLandlordDialog() async {
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var isLinking = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Link to Landlord'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter your landlord\'s shared code (e.g. LL-260827-01) to link your account.',
                  ),
                  const SizedBox(height: 16),
                  if (errorText != null) ...[
                    Text(
                      errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      hintText: 'Landlord Code (e.g. LL-260827-01)',
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Please enter a code.' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLinking ? null : () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: isLinking
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() {
                          isLinking = true;
                          errorText = null;
                        });
                        try {
                          await AppServices.authRepository.linkLandlord(
                            codeController.text.trim(),
                          );
                          if (!ctx.mounted) return;
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully linked to landlord!'),
                            ),
                          );
                          _loadProfile();
                        } catch (e) {
                          setDialogState(() {
                            isLinking = false;
                            errorText = e.toString().replaceAll('Exception: ', '');
                          });
                        }
                      },
                child: isLinking
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Link'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _logout() async {
    await AppServices.tokenStorage.clearAccessToken();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person_outline,
                    size: 48,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _user?.name.isNotEmpty == true ? _user!.name : 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    _user?.email ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (_user?.landlordCode != null && _user!.landlordCode!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.key_outlined,
                            size: 18,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Landlord Code: ${_user!.landlordCode}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: _user!.landlordCode!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Landlord code copied to clipboard!'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.copy_outlined,
                              size: 18,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Divider(),
                if (_user?.landlordCode == null || _user!.landlordCode!.isEmpty) ...[
                  ListTile(
                    leading: const Icon(Icons.link_outlined),
                    title: const Text('Link to Landlord'),
                    subtitle: Text(
                      _user?.landlordId != null
                          ? 'Linked to landlord'
                          : 'Not linked to any landlord',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showLinkLandlordDialog,
                  ),
                ],
                if (_user?.bankName != null && _user!.bankName!.isNotEmpty) ...[
                  ListTile(
                    leading: const Icon(Icons.account_balance_outlined),
                    title: Text(_user!.bankName!),
                    subtitle: Text(
                      _user?.bankAccountNumber ?? '',
                    ),
                  ),
                ],
                if (_user?.phoneNumber != null && _user!.phoneNumber!.isNotEmpty) ...[
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: const Text('Phone Number'),
                    subtitle: Text(_user!.phoneNumber!),
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password change coming soon.'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
    );
  }
}
