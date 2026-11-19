import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/occurrence.dart';
import '../providers/occurrence_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_widgets.dart';

class OccurrencesScreen extends StatelessWidget {
  const OccurrencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OccurrenceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.occurrences.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null && provider.occurrences.isEmpty) {
          return StatusPanel(
            icon: Icons.storage_outlined,
            title: 'Não foi possível carregar as ocorrências',
            message: '${provider.error}',
            action: FilledButton(
              onPressed: provider.load,
              child: const Text('Tentar novamente'),
            ),
          );
        }
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PageHeading(
                      title: 'Ocorrências',
                      subtitle: 'Registros locais e anônimos do território',
                      trailing: FilledButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/occurrence/new'),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Registrar'),
                      ),
                    ),
                    if (provider.occurrences.isEmpty)
                      const StatusPanel(
                        icon: Icons.assignment_add,
                        title: 'Ainda não há ocorrências',
                        message:
                            'Registre uma ocorrência sem informar dados '
                            'pessoais para ajudar a acompanhar as necessidades '
                            'do território.',
                      )
                    else
                      for (final occurrence in provider.occurrences) ...[
                        _OccurrenceCard(occurrence: occurrence),
                        const SizedBox(height: 10),
                      ],
                    if (provider.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Falha ao atualizar registros: ${provider.error}',
                        style: const TextStyle(color: AppTheme.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OccurrenceCard extends StatelessWidget {
  const _OccurrenceCard({required this.occurrence});

  final Occurrence occurrence;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: const BoxDecoration(
              color: AppTheme.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.campaign_outlined, color: AppTheme.forest),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  occurrence.type,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text('${occurrence.neighborhood} · ${occurrence.urgency}'),
                const SizedBox(height: 7),
                Text(occurrence.description),
                const SizedBox(height: 7),
                Text(
                  _formatDate(occurrence.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OccurrenceFormScreen extends StatefulWidget {
  const OccurrenceFormScreen({super.key});

  @override
  State<OccurrenceFormScreen> createState() => _OccurrenceFormScreenState();
}

class _OccurrenceFormScreenState extends State<OccurrenceFormScreen> {
  static const _types = [
    'Saúde',
    'Zeladoria',
    'Mobilidade',
    'Assistência social',
    'Outro serviço',
  ];
  static const _neighborhoods = [
    'Sé',
    'Santo Amaro',
    'Itaquera',
    'Outro bairro',
  ];
  static const _urgencies = ['Baixa', 'Média', 'Alta'];

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _type = _types.first;
  String _neighborhood = _neighborhoods.first;
  String _urgency = _urgencies[1];
  bool _consent = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirme o consentimento para registrar.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final provider = context.read<OccurrenceProvider>();
    try {
      await provider.add(
        Occurrence(
          id: null,
          type: _type,
          neighborhood: _neighborhood,
          description: _descriptionController.text.trim(),
          urgency: _urgency,
          createdAt: DateTime.now(),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocorrência salva neste dispositivo.')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível salvar: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar ocorrência')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeading(
                      title: 'Conte o que aconteceu',
                      subtitle:
                          'O registro fica salvo localmente neste aparelho.',
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: _type,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de serviço',
                      ),
                      items: [
                        for (final type in _types)
                          DropdownMenuItem(value: type, child: Text(type)),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _type = value);
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _neighborhood,
                      decoration: const InputDecoration(labelText: 'Bairro'),
                      items: [
                        for (final neighborhood in _neighborhoods)
                          DropdownMenuItem(
                            value: neighborhood,
                            child: Text(neighborhood),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _neighborhood = value);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: _urgency,
                      decoration: const InputDecoration(labelText: 'Urgência'),
                      items: [
                        for (final urgency in _urgencies)
                          DropdownMenuItem(
                            value: urgency,
                            child: Text(urgency),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _urgency = value);
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 4,
                      maxLines: 7,
                      maxLength: 400,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText:
                            'Descreva a situação sem incluir dados pessoais.',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        final description = value?.trim() ?? '';
                        if (description.length < 10) {
                          return 'Descreva a ocorrência com pelo menos 10 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 4),
                    CheckboxListTile(
                      value: _consent,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'Concordo com o armazenamento local e anônimo deste registro.',
                      ),
                      subtitle: const Text(
                        'Não informe nome, telefone, endereço exato ou outros '
                        'dados que identifiquem alguém.',
                      ),
                      onChanged: (value) =>
                          setState(() => _consent = value ?? false),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isSaving ? null : _submit,
                        icon: _isSaving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _isSaving ? 'Salvando...' : 'Salvar registro',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} às $hour:$minute';
}
