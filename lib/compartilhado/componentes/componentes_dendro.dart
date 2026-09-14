import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../aplicativo/tema/tema_dendro.dart';
import '../../nucleo/constantes/recursos_dendro.dart';

class TelaDendro extends StatelessWidget {
  const TelaDendro({
    required this.titulo,
    required this.icone,
    required this.filhos,
    this.flutuanteAcaoBotao,
    this.mostrarVoltarBotao,
    this.aoVoltar,
    super.key,
  });

  final String titulo;
  final IconData icone;
  final List<Widget> filhos;
  final Widget? flutuanteAcaoBotao;
  final bool? mostrarVoltarBotao;
  final VoidCallback? aoVoltar;

  @override
  Widget build(BuildContext context) {
    final deveMostrarVoltarBotao =
        mostrarVoltarBotao ?? Navigator.of(context).canPop();

    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              14,
              16,
              flutuanteAcaoBotao == null ? 24 : 96,
            ),
            children: [
              CabecalhoDendro(
                titulo: titulo,
                icone: icone,
                mostrarVoltarBotao: deveMostrarVoltarBotao,
                aoVoltar: aoVoltar,
              ),
              const SizedBox(height: 20),
              ...filhos,
            ],
          ),
          if (flutuanteAcaoBotao != null)
            Positioned(right: 16, bottom: 16, child: flutuanteAcaoBotao!),
        ],
      ),
    );
  }
}

class CabecalhoDendro extends StatelessWidget {
  const CabecalhoDendro({
    required this.titulo,
    required this.icone,
    this.mostrarVoltarBotao = false,
    this.aoVoltar,
    super.key,
  });

  final String titulo;
  final IconData icone;
  final bool mostrarVoltarBotao;
  final VoidCallback? aoVoltar;

  @override
  Widget build(BuildContext context) {
    final corEsquema = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (mostrarVoltarBotao)
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              onPressed: aoVoltar ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              style: IconButton.styleFrom(
                backgroundColor: CoresDendro.principalSuave,
                foregroundColor: CoresDendro.principal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          )
        else
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: CoresDendro.principalSuave,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: CoresDendro.principal, size: 22),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ).copyWith(color: corEsquema.onSurface),
          ),
        ),
        const SizedBox(width: 10),
        const MarcaDendro(),
      ],
    );
  }
}

class MarcaDendro extends StatelessWidget {
  const MarcaDendro({this.tamanho = 34, super.key});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        RecursosDendro.logo,
        width: tamanho,
        height: tamanho,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ParcelaDimensoesEntrada extends StatelessWidget {
  const ParcelaDimensoesEntrada({
    required this.larguraControlador,
    required this.comprimentoControlador,
    this.larguraValidator,
    this.comprimentoValidator,
    super.key,
  });

  final TextEditingController larguraControlador;
  final TextEditingController comprimentoControlador;
  final String? Function(String?)? larguraValidator;
  final String? Function(String?)? comprimentoValidator;

  @override
  Widget build(BuildContext context) {
    final corEsquema = Theme.of(context).colorScheme;
    final entradaFormatadores = [
      FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 13),
          child: Text(
            'Parcela:',
            style: TextStyle(
              color: corEsquema.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: larguraControlador,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            inputFormatters: entradaFormatadores,
            decoration: const InputDecoration(
              hintText: 'X',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            validator: larguraValidator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 13),
          child: Text(
            'x',
            style: TextStyle(
              color: corEsquema.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: comprimentoControlador,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            inputFormatters: entradaFormatadores,
            decoration: const InputDecoration(
              hintText: 'X',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            validator: comprimentoValidator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 13),
          child: Text(
            'm',
            style: TextStyle(
              color: corEsquema.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class CartaoDendro extends StatelessWidget {
  const CartaoDendro({
    required this.filho,
    this.fundoCor,
    this.bordaCor,
    this.espacamentoInterno = const EdgeInsets.all(14),
    super.key,
  });

  final Widget filho;
  final Color? fundoCor;
  final Color? bordaCor;
  final EdgeInsetsGeometry espacamentoInterno;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final brutoFundo = fundoCor ?? tema.cardColor;
    final resolvidoFundo = _cartaoFundoParaTema(brutoFundo, tema.brightness);
    final claroFundo =
        ThemeData.estimateBrightnessForColor(resolvidoFundo) ==
        Brightness.light;
    final primeiroPlanoCor = claroFundo ? CoresDendro.texto : Colors.white;
    final utilizaLegivelCartao =
        resolvidoFundo == CoresDendro.escuroLegivelCartao ||
        resolvidoFundo == CoresDendro.escuroLegivelCartaoDestaque;
    final entradaTema = TemaDendro.claro.inputDecorationTheme.copyWith(
      fillColor: utilizaLegivelCartao ? CoresDendro.escuroLegivelCampo : null,
      labelStyle: const TextStyle(
        color: CoresDendro.textoDiscreto,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: const TextStyle(color: CoresDendro.textoDiscreto),
      prefixIconColor: CoresDendro.principal,
      suffixIconColor: CoresDendro.principal,
    );

    return Container(
      width: double.infinity,
      padding: espacamentoInterno,
      decoration: BoxDecoration(
        color: resolvidoFundo,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              bordaCor ??
              (utilizaLegivelCartao
                  ? CoresDendro.escuroLegivelBorda
                  : CoresDendro.contorno),
        ),
      ),
      child: Theme(
        data: claroFundo
            ? tema.copyWith(
                colorScheme: TemaDendro.claro.colorScheme,
                textTheme: tema.textTheme.apply(
                  bodyColor: CoresDendro.texto,
                  displayColor: CoresDendro.texto,
                ),
                primaryTextTheme: tema.primaryTextTheme.apply(
                  bodyColor: CoresDendro.texto,
                  displayColor: CoresDendro.texto,
                ),
                inputDecorationTheme: entradaTema,
                iconButtonTheme: IconButtonThemeData(
                  style: IconButton.styleFrom(
                    foregroundColor: CoresDendro.principal,
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: CoresDendro.principal,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CoresDendro.principal,
                    side: const BorderSide(color: CoresDendro.principal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                listTileTheme: tema.listTileTheme.copyWith(
                  textColor: CoresDendro.texto,
                  iconColor: CoresDendro.textoDiscreto,
                  titleTextStyle: const TextStyle(
                    color: CoresDendro.texto,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitleTextStyle: const TextStyle(
                    color: CoresDendro.textoDiscreto,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : tema,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: primeiroPlanoCor),
          child: IconTheme.merge(
            data: IconThemeData(
              color: claroFundo ? CoresDendro.textoDiscreto : Colors.white,
            ),
            child: filho,
          ),
        ),
      ),
    );
  }

  Color _cartaoFundoParaTema(Color cor, Brightness brilho) {
    if (brilho != Brightness.dark) return cor;
    if (cor == CoresDendro.escuroLegivelCartao ||
        cor == CoresDendro.escuroLegivelCartaoDestaque ||
        cor == CoresDendro.escuroLegivelCampo) {
      return cor;
    }
    if (ThemeData.estimateBrightnessForColor(cor) == Brightness.dark) {
      return cor;
    }
    if (cor == CoresDendro.principalSuave ||
        cor == const Color(0xFFE0F2E8) ||
        cor == const Color(0xFFEAF7EF)) {
      return CoresDendro.escuroLegivelCartaoDestaque;
    }
    return CoresDendro.escuroLegivelCartao;
  }
}

class SecaoTitulo extends StatelessWidget {
  const SecaoTitulo({required this.titulo, this.complemento, super.key});

  final String titulo;
  final Widget? complemento;

  @override
  Widget build(BuildContext context) {
    final corEsquema = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ).copyWith(color: corEsquema.onSurface),
            ),
          ),
          ?complemento,
        ],
      ),
    );
  }
}

class SituacaoIndicador extends StatelessWidget {
  const SituacaoIndicador({
    required this.rotulo,
    this.cor = CoresDendro.principalSuave,
    this.textoCor = CoresDendro.principal,
    super.key,
  });

  final String rotulo;
  final Color cor;
  final Color textoCor;

  @override
  Widget build(BuildContext context) {
    final resolvidoCor = _fundoParaTema(cor, Theme.of(context).brightness);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolvidoCor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          rotulo,
          style: TextStyle(
            color: textoCor,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Color _fundoParaTema(Color cor, Brightness brilho) {
    if (brilho != Brightness.dark) return cor;
    if (cor == CoresDendro.escuroLegivelCampo ||
        cor == CoresDendro.escuroLegivelCartao ||
        cor == CoresDendro.escuroLegivelCartaoDestaque) {
      return cor;
    }
    if (ThemeData.estimateBrightnessForColor(cor) == Brightness.dark) {
      return cor;
    }
    return CoresDendro.escuroLegivelCampo;
  }
}

class IndicadorBloco extends StatelessWidget {
  const IndicadorBloco({
    required this.rotulo,
    required this.valor,
    required this.icone,
    super.key,
  });

  final String rotulo;
  final String valor;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return CartaoDendro(
      espacamentoInterno: const EdgeInsets.all(12),
      filho: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: 19, color: CoresDendro.secundario),
          const SizedBox(height: 8),
          Text(
            rotulo,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CoresDendro.textoDiscreto,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: const TextStyle(
              color: CoresDendro.texto,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
