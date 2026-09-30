import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../../resultados/dados/repositorio_resultados.dart';
import '../dados/repositorio_backup.dart';

class TelaBackupRestauracao extends ConsumerStatefulWidget {
  const TelaBackupRestauracao({super.key});

  @override
  ConsumerState<TelaBackupRestauracao> createState() =>
      _TelaBackupRestauracaoEstado();
}

class _TelaBackupRestauracaoEstado
    extends ConsumerState<TelaBackupRestauracao> {
  bool _processando = false;

  @override
  Widget build(BuildContext context) {
    final backups = ref.watch(provedorBackupsLocais);

    return TelaDendro(
      titulo: 'Backup e Restauração',
      icone: Icons.backup_outlined,
      filhos: [
        CartaoDendro(
          filho: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Proteja os dados coletados',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'O backup reúne cadastros, levantamentos, parcelas, árvores, modelos e configurações do banco de dados.',
                style: TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'As cópias locais são apagadas se o aplicativo for desinstalado. Compartilhe o arquivo para guardá-lo fora do aplicativo.',
                style: TextStyle(
                  color: CoresDendro.textoDiscreto,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _processando ? null : _criarBackup,
                  icon: const Icon(Icons.add_to_drive_outlined),
                  label: const Text('Criar novo backup'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _processando ? null : _selecionarParaRestaurar,
                  icon: const Icon(Icons.restore),
                  label: const Text('Restaurar de um arquivo'),
                ),
              ),
              if (_processando) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        const TituloSecao(titulo: 'Backups salvos neste dispositivo'),
        backups.when(
          data: (itens) {
            if (itens.isEmpty) {
              return const CartaoDendro(
                filho: Text(
                  'Nenhum backup local foi criado.',
                  style: TextStyle(
                    color: CoresDendro.textoDiscreto,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final backup in itens)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _BackupCartao(
                      backup: backup,
                      habilitado: !_processando,
                      aoCompartilhar: () => _compartilhar(backup),
                      aoRestaurar: () => _confirmarRestauracao(backup.caminho),
                      aoExcluir: () => _confirmarExclusao(backup),
                    ),
                  ),
              ],
            );
          },
          loading: () => const CartaoDendro(
            filho: Center(child: CircularProgressIndicator()),
          ),
          error: (erro, pilha) => CartaoDendro(
            filho: Column(
              children: [
                const Text(
                  'Não foi possível consultar os backups locais.',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                TextButton.icon(
                  onPressed: () => ref.invalidate(provedorBackupsLocais),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _criarBackup() async {
    setState(() => _processando = true);
    try {
      final backup = await ref.read(provedorRepositorioBackup).criarBackup();
      ref.invalidate(provedorBackupsLocais);
      if (!mounted) return;
      final compartilhar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: CoresDendro.principal),
          title: const Text('Backup criado'),
          content: Text(
            '${backup.nomeArquivo}\n\nDeseja compartilhar uma cópia agora?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Agora não'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.share),
              label: const Text('Compartilhar'),
            ),
          ],
        ),
      );
      if (compartilhar == true && mounted) await _compartilhar(backup);
    } catch (erro) {
      if (mounted) _mostrarErro(_mensagemErro(erro));
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  Future<void> _selecionarParaRestaurar() async {
    try {
      final selecao = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const [RepositorioBackup.extensaoArquivo],
      );
      final caminho = selecao?.path;
      if (caminho == null || !mounted) return;
      await _confirmarRestauracao(caminho);
    } catch (erro) {
      if (mounted) _mostrarErro(_mensagemErro(erro));
    }
  }

  Future<void> _confirmarRestauracao(String caminho) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
        title: const Text('Restaurar backup?'),
        content: const Text(
          'Os dados atuais serão substituídos pelos dados do backup. Antes da restauração, o aplicativo criará automaticamente uma cópia de segurança do estado atual.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    setState(() => _processando = true);
    try {
      await ref.read(provedorRepositorioBackup).restaurar(caminho);
      ref.read(provedorFiltroPropriedadeResultados.notifier).state = null;
      ref.read(provedorFiltroLevantamentoResultados.notifier).state = null;
      ref.read(provedorFiltroEspecieResultados.notifier).state = null;
      ref.read(provedorFiltroTalhoesResultados.notifier).state = <int>{};
      ref.invalidate(provedorBackupsLocais);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: CoresDendro.principal),
          title: const Text('Restauração concluída'),
          content: const Text('Os dados do backup já estão disponíveis.'),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Concluir'),
            ),
          ],
        ),
      );
    } catch (erro) {
      if (mounted) _mostrarErro(_mensagemErro(erro));
    } finally {
      if (mounted) setState(() => _processando = false);
    }
  }

  Future<void> _compartilhar(BackupLocal backup) async {
    final caixa = context.findRenderObject() as RenderBox?;
    final origem = caixa == null
        ? null
        : caixa.localToGlobal(Offset.zero) & caixa.size;
    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'Backup DENDRO Mobile',
          text: 'Backup completo dos dados do DENDRO Mobile.',
          files: [XFile(backup.caminho, mimeType: RepositorioBackup.tipoMime)],
          fileNameOverrides: [backup.nomeArquivo],
          sharePositionOrigin: origem,
        ),
      );
    } catch (_) {
      if (mounted) _mostrarErro('Não foi possível compartilhar o backup.');
    }
  }

  Future<void> _confirmarExclusao(BackupLocal backup) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir backup local?'),
        content: Text('O arquivo ${backup.nomeArquivo} será excluído.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    await ref.read(provedorRepositorioBackup).excluirBackup(backup.caminho);
    ref.invalidate(provedorBackupsLocais);
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red.shade700, content: Text(mensagem)),
    );
  }

  String _mensagemErro(Object erro) {
    return erro is ExcecaoBackup
        ? erro.mensagem
        : 'Não foi possível concluir a operação de backup.';
  }
}

class _BackupCartao extends StatelessWidget {
  const _BackupCartao({
    required this.backup,
    required this.habilitado,
    required this.aoCompartilhar,
    required this.aoRestaurar,
    required this.aoExcluir,
  });

  final BackupLocal backup;
  final bool habilitado;
  final VoidCallback aoCompartilhar;
  final VoidCallback aoRestaurar;
  final VoidCallback aoExcluir;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      espacamentoInterno: const EdgeInsets.fromLTRB(14, 12, 8, 10),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: CoresDendro.principal,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatarData(backup.criadoEm),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatarTamanho(backup.tamanhoBytes)} • ${backup.nomeArquivo}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CoresDendro.textoDiscreto,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<_AcaoBackup>(
                enabled: habilitado,
                onSelected: (acao) {
                  switch (acao) {
                    case _AcaoBackup.compartilhar:
                      aoCompartilhar();
                    case _AcaoBackup.restaurar:
                      aoRestaurar();
                    case _AcaoBackup.excluir:
                      aoExcluir();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: _AcaoBackup.compartilhar,
                    child: ListTile(
                      leading: Icon(Icons.share_outlined),
                      title: Text('Compartilhar'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _AcaoBackup.restaurar,
                    child: ListTile(
                      leading: Icon(Icons.restore),
                      title: Text('Restaurar'),
                    ),
                  ),
                  PopupMenuItem(
                    value: _AcaoBackup.excluir,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Excluir'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _AcaoBackup { compartilhar, restaurar, excluir }

String _formatarData(DateTime data) {
  String dois(int valor) => valor.toString().padLeft(2, '0');
  return '${dois(data.day)}/${dois(data.month)}/${data.year} '
      '${dois(data.hour)}:${dois(data.minute)}';
}

String _formatarTamanho(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
