package br.com.dendromobile.app

import android.app.Activity
import android.content.Intent
import java.io.File
import java.io.FileInputStream
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "br.com.dendromobile.app/file_saver"
    private val createDocumentRequestCode = 7104
    private var pendingSave: PendingSave? = null
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveFile" -> saveFile(call.arguments as? Map<*, *>, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun saveFile(arguments: Map<*, *>?, result: MethodChannel.Result) {
        if (pendingResult != null) {
            result.error("SAVE_IN_PROGRESS", "Já existe um salvamento em andamento.", null)
            return
        }

        val path = arguments?.get("path") as? String
        val fileName = arguments?.get("fileName") as? String
        val mimeType = arguments?.get("mimeType") as? String

        if (path.isNullOrBlank() || fileName.isNullOrBlank() || mimeType.isNullOrBlank()) {
            result.error("INVALID_ARGUMENTS", "Dados do arquivo inválidos.", null)
            return
        }

        val source = File(path)
        if (!source.exists()) {
            result.error("FILE_NOT_FOUND", "Arquivo de origem não encontrado.", null)
            return
        }

        pendingSave = PendingSave(path, fileName, mimeType)
        pendingResult = result

        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = mimeType
            putExtra(Intent.EXTRA_TITLE, fileName)
        }
        startActivityForResult(intent, createDocumentRequestCode)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != createDocumentRequestCode) return

        val save = pendingSave
        val result = pendingResult
        pendingSave = null
        pendingResult = null

        if (result == null || save == null) return

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            result.success(false)
            return
        }

        try {
            val uri = data.data!!
            contentResolver.openOutputStream(uri)?.use { output ->
                FileInputStream(File(save.path)).use { input ->
                    input.copyTo(output)
                }
            } ?: throw IllegalStateException("Não foi possível abrir o destino.")
            result.success(true)
        } catch (error: Exception) {
            result.error("SAVE_FAILED", error.message, null)
        }
    }
}

private data class PendingSave(
    val path: String,
    val fileName: String,
    val mimeType: String,
)
