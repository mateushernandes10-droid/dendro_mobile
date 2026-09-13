package br.com.dendromobile.app

import android.app.Activity
import android.content.Intent
import java.io.File
import java.io.FileInputStream
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val nomeCanal = "br.com.dendromobile.app/file_saver"
    private val codigoSolicitacaoDocumento = 7104
    private var salvamentoPendente: SalvamentoPendente? = null
    private var resultadoPendente: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            nomeCanal
        ).setMethodCallHandler { chamada, resultado ->
            when (chamada.method) {
                "saveFile" -> salvarArquivo(chamada.arguments as? Map<*, *>, resultado)
                else -> resultado.notImplemented()
            }
        }
    }

    private fun salvarArquivo(argumentos: Map<*, *>?, resultado: MethodChannel.Result) {
        if (resultadoPendente != null) {
            resultado.error("SAVE_IN_PROGRESS", "Já existe um salvamento em andamento.", null)
            return
        }

        val caminho = argumentos?.get("path") as? String
        val nomeArquivo = argumentos?.get("fileName") as? String
        val tipoMime = argumentos?.get("mimeType") as? String

        if (caminho.isNullOrBlank() || nomeArquivo.isNullOrBlank() || tipoMime.isNullOrBlank()) {
            resultado.error("INVALID_ARGUMENTS", "Dados do arquivo inválidos.", null)
            return
        }

        val origem = File(caminho)
        if (!origem.exists()) {
            resultado.error("FILE_NOT_FOUND", "Arquivo de origem não encontrado.", null)
            return
        }

        salvamentoPendente = SalvamentoPendente(caminho, nomeArquivo, tipoMime)
        resultadoPendente = resultado

        val intencao = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = tipoMime
            putExtra(Intent.EXTRA_TITLE, nomeArquivo)
        }
        startActivityForResult(intencao, codigoSolicitacaoDocumento)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != codigoSolicitacaoDocumento) return

        val salvamento = salvamentoPendente
        val resultado = resultadoPendente
        salvamentoPendente = null
        resultadoPendente = null

        if (resultado == null || salvamento == null) return

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            resultado.success(false)
            return
        }

        try {
            val uri = data.data!!
            contentResolver.openOutputStream(uri)?.use { saida ->
                FileInputStream(File(salvamento.caminho)).use { entrada ->
                    entrada.copyTo(saida)
                }
            } ?: throw IllegalStateException("Não foi possível abrir o destino.")
            resultado.success(true)
        } catch (erro: Exception) {
            resultado.error("SAVE_FAILED", erro.message, null)
        }
    }
}

private data class SalvamentoPendente(
    val caminho: String,
    val nomeArquivo: String,
    val tipoMime: String,
)
