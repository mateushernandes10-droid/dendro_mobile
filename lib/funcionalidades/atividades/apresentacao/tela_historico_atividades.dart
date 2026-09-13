import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../dados/repositorio_atividades.dart';
import 'componentes_atividades.dart';

class TelaHistoricoAtividades extends ConsumerWidget {
  const TelaHistoricoAtividades({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final atividades = ref.watch(provedorHistoricoAtividades);
    final agora = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historico de atividades'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: MarcaDendro(tamanho: 32)),
          ),
        ],
      ),
      body: SafeArea(
        child: atividades.when(
          data: (itens) {
            if (itens.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: CartaoDendro(
                  fundoCor: Color(0xFFF3F4F3),
                  filho: Text(
                    'Nenhuma atividade registrada ainda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                for (final atividade in itens)
                  ItemRegistroAtividade(
                    atividade: atividade,
                    exibicaoHora: formatoRegistroAtividadeData(
                      atividade.ocorridoEm,
                      agora,
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (erro, pilhaTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CartaoDendro(
                filho: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 10),
                    const Text(
                      'Nao foi possivel carregar o historico.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => ref.invalidate(provedorHistoricoAtividades),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
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
