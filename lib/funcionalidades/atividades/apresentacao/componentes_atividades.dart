import 'package:flutter/material.dart';

import '../../../aplicativo/tema/tema_dendro.dart';
import '../../../compartilhado/componentes/componentes_dendro.dart';
import '../dados/repositorio_atividades.dart';

class ItemRegistroAtividade extends StatelessWidget {
  const ItemRegistroAtividade({
    required this.atividade,
    required this.exibicaoHora,
    super.key,
  });

  final RegistroAtividade atividade;
  final String exibicaoHora;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CartaoDendro(
        espacamentoInterno: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filho: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: CoresDendro.principalSuave,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                atividadeIcon(atividade.tipo),
                size: 18,
                color: CoresDendro.principal,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    atividade.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    atividade.subtitulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CoresDendro.textoDiscreto,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              exibicaoHora,
              style: const TextStyle(
                color: CoresDendro.textoDiscreto,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData atividadeIcon(TipoAtividade tipo) {
  switch (tipo) {
    case TipoAtividade.propriedadeCriada:
    case TipoAtividade.propriedadeAtualizada:
    case TipoAtividade.propriedadeExcluida:
      return Icons.home_work_outlined;
    case TipoAtividade.talhaoCriado:
    case TipoAtividade.talhaoAtualizado:
    case TipoAtividade.talhaoExcluido:
    case TipoAtividade.talhaoConcluido:
    case TipoAtividade.talhaoAdicionadoLevantamento:
    case TipoAtividade.talhaoAtualizadoLevantamento:
    case TipoAtividade.talhaoRemovidoLevantamento:
      return Icons.forest_outlined;
    case TipoAtividade.parcelaCriada:
    case TipoAtividade.parcelaAtualizada:
    case TipoAtividade.parcelaExcluida:
      return Icons.grid_view_outlined;
    case TipoAtividade.parcelaColetada:
      return Icons.check_circle_outline;
    case TipoAtividade.especieCriada:
    case TipoAtividade.especieAtualizada:
    case TipoAtividade.especieExcluida:
    case TipoAtividade.especieModeloMatematicoVinculado:
    case TipoAtividade.especieModeloMatematicoDesvinculado:
    case TipoAtividade.especiePadraoModeloMatematicoAlterado:
      return Icons.eco_outlined;
    case TipoAtividade.modeloMatematicoCriado:
    case TipoAtividade.modeloMatematicoAtualizado:
    case TipoAtividade.modeloMatematicoExcluido:
    case TipoAtividade.modeloMatematicoCoeficientesAtualizado:
      return Icons.functions;
    case TipoAtividade.levantamentoIniciado:
    case TipoAtividade.levantamentoConcluido:
    case TipoAtividade.levantamentoExcluido:
      return Icons.assignment_outlined;
    case TipoAtividade.exportacaoCriada:
      return Icons.ios_share;
  }
}

String formatoRegistroAtividadeData(DateTime ocorridoEm, DateTime agora) {
  final eventoData = DateTime(ocorridoEm.year, ocorridoEm.month, ocorridoEm.day);
  final hoje = DateTime(agora.year, agora.month, agora.day);
  final ontem = hoje.subtract(const Duration(days: 1));

  if (eventoData == hoje) {
    return '${_duasDigitos(ocorridoEm.hour)}:${_duasDigitos(ocorridoEm.minute)}';
  }

  if (eventoData == ontem) return 'Ontem';

  return '${_duasDigitos(ocorridoEm.day)}/${_duasDigitos(ocorridoEm.month)}/${ocorridoEm.year}';
}

String _duasDigitos(int valor) {
  return valor.toString().padLeft(2, '0');
}
