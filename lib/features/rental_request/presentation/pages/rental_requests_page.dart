import 'package:flutter/material.dart';

import '../../../../core/app_services.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../data/models/rental_request_model.dart';

class RentalRequestsPage extends StatefulWidget {
  const RentalRequestsPage({super.key});

  @override
  State<RentalRequestsPage> createState() => _RentalRequestsPageState();
}

class _RentalRequestsPageState extends State<RentalRequestsPage> {
  var _isLoading = true;
  String? _errorMessage;
  var _requests = <RentalRequestModel>[];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var requests =
          await AppServices.rentalRequestRepository.getTenantRequests();
      if (requests.isEmpty) {
        try {
          final landlordRequests =
              await AppServices.rentalRequestRepository.getLandlordRequests();
          if (landlordRequests.isNotEmpty) {
            requests = landlordRequests;
          }
        } catch (_) {
          // Ignore if tenant role doesn't have landlord permissions
        }
      }
      if (!mounted) return;
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load requests. Pull down to retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requests')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return RefreshIndicator(
        onRefresh: _loadRequests,
        child: ListView(
          children: [
            const SizedBox(height: 64),
            EmptyState(
              icon: Icons.cloud_off_outlined,
              message: _errorMessage!,
              detail: 'Pull down to retry.',
            ),
          ],
        ),
      );
    }

    if (_requests.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadRequests,
        child: ListView(
          children: const [
            SizedBox(height: 64),
            EmptyState(
              icon: Icons.assignment_outlined,
              message: 'No rental requests yet',
              detail: 'Requests you submit will appear here.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRequests,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final request = _requests[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.assignment_outlined,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(request.propertyTitle ?? 'Property'),
              subtitle: Text(
                [
                  if (request.propertyCity != null) request.propertyCity!,
                  if (request.status != null) request.status!.label,
                ].join(' - '),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
