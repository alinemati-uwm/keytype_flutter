package com.nematiai.keytype

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Log
import android.os.Build

class MainActivity : FlutterActivity() {
    
    private val KEYBOARD_CHANNEL = "keyboard_channel"
    private var keyboardMethodChannel: MethodChannel? = null
    
    companion object {
        const val TAG = "MainActivity"
        const val ACTION_TEXT_FROM_KEYBOARD = "com.nematiai.keytype.TEXT_FROM_KEYBOARD"
        const val ACTION_AI_REQUEST = "com.nematiai.keytype.AI_ACTION_REQUEST"
        const val ACTION_AI_RESPONSE = "com.nematiai.keytype.AI_ACTION_RESPONSE"
        const val ACTION_AI_ERROR = "com.nematiai.keytype.AI_ACTION_ERROR"
    }
    
    private val keyboardCommunicationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                ACTION_TEXT_FROM_KEYBOARD -> {
                    handleTextFromKeyboard(intent)
                }
                ACTION_AI_REQUEST -> {
                    handleAIActionRequest(intent)
                }
                else -> {
                    Log.w(TAG, "Received unknown broadcast action: ${intent?.action}")
                }
            }
        }
    }
    
    /**
     * Handle text received from keyboard (legacy support)
     */
    private fun handleTextFromKeyboard(intent: Intent) {
        try {
            val text = intent.getStringExtra("text") ?: ""
            Log.d(TAG, "Received text from keyboard: ${text.take(100)}...")
            
            // Send to Flutter via method channel (maintain backward compatibility)
            keyboardMethodChannel?.invokeMethod("textFromKeyboard", text)
            
        } catch (e: Exception) {
            Log.e(TAG, "Error handling text from keyboard", e)
        }
    }
    
    /**
     * Handle AI action request from keyboard
     */
    private fun handleAIActionRequest(intent: Intent) {
        try {
            val text = intent.getStringExtra("text") ?: ""
            val action = intent.getStringExtra("action") ?: ""
            
            Log.d(TAG, "Received AI action request: $action for text (${text.length} chars)")
            
            if (text.isBlank()) {
                Log.w(TAG, "Empty text received for AI action: $action")
                sendAIErrorResponse(action, "No text provided")
                return
            }
            
            if (action.isBlank()) {
                Log.w(TAG, "Empty action received for AI request")
                sendAIErrorResponse("UNKNOWN", "No action specified")
                return
            }
            
            // Validate action type
            val validActions = listOf("REWRITE", "SUMMARIZE", "GENERATE", "TRANSLATE", "FIX_GRAMMAR", "MAKE_FORMAL", "MAKE_INFORMAL")
            if (!validActions.contains(action)) {
                Log.w(TAG, "Invalid AI action received: $action")
                sendAIErrorResponse(action, "Invalid action type")
                return
            }
            
            // Send to Flutter for AI processing
            val params = mapOf(
                "text" to text,
                "action" to action,
                "timestamp" to System.currentTimeMillis()
            )
            
            keyboardMethodChannel?.invokeMethod("aiActionRequest", params, object : io.flutter.plugin.common.MethodChannel.Result {
                override fun success(result: Any?) {
                    handleAIActionResult(action, result)
                }
                
                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e(TAG, "AI action failed: $errorCode - $errorMessage")
                    sendAIErrorResponse(action, errorMessage ?: "Unknown error")
                }
                
                override fun notImplemented() {
                    Log.e(TAG, "AI action not implemented")
                    sendAIErrorResponse(action, "AI action not implemented")
                }
            })
            
            Log.d(TAG, "AI action request sent to Flutter: $action")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error handling AI action request", e)
            val action = intent.getStringExtra("action") ?: "UNKNOWN"
            sendAIErrorResponse(action, "Internal error: ${e.message}")
        }
    }
    
    /**
     * Handle AI action result from Flutter
     */
    private fun handleAIActionResult(action: String, result: Any?) {
        try {
            when (result) {
                is String -> {
                    // Success - result text received
                    Log.d(TAG, "AI action $action completed successfully")
                    sendAISuccessResponse(action, result)
                }
                is Map<*, *> -> {
                    // Structured response
                    val success = result["success"] as? Boolean ?: false
                    if (success) {
                        val outputs = result["outputs"] as? List<*>
                        if (outputs != null && outputs.isNotEmpty()) {
                            Log.d(TAG, "AI action $action completed successfully with ${outputs.size} outputs")
                            sendAISuccessResponseWithOutputs(action, outputs.map { it.toString() })
                        } else {
                            val resultText = result["result"] as? String ?: ""
                            Log.d(TAG, "AI action $action completed successfully (structured)")
                            sendAISuccessResponse(action, resultText)
                        }
                    } else {
                        val error = result["error"] as? String ?: "Unknown error"
                        Log.e(TAG, "AI action $action failed: $error")
                        sendAIErrorResponse(action, error)
                    }
                }
                null -> {
                    // No result - treat as error
                    Log.e(TAG, "AI action $action returned null result")
                    sendAIErrorResponse(action, "No result received")
                }
                else -> {
                    Log.w(TAG, "AI action $action returned unexpected result type: ${result::class.java}")
                    sendAIErrorResponse(action, "Unexpected result format")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling AI action result for $action", e)
            sendAIErrorResponse(action, "Error processing result: ${e.message}")
        }
    }
    
    /**
     * Send AI success response back to keyboard
     */
    private fun sendAISuccessResponse(action: String, result: String) {
        try {
            val intent = Intent(ACTION_AI_RESPONSE)
            intent.putExtra("action", action)
            intent.putExtra("success", true)
            intent.putExtra("result", result)
            intent.putExtra("timestamp", System.currentTimeMillis())
            intent.setPackage(packageName)
            sendBroadcast(intent)
            
            Log.d(TAG, "AI success response sent for action: $action")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending AI success response for $action", e)
        }
    }
    
    /**
     * Send AI success response with multiple outputs back to keyboard
     */
    private fun sendAISuccessResponseWithOutputs(action: String, outputs: List<String>) {
        try {
            val intent = Intent(ACTION_AI_RESPONSE)
            intent.putExtra("action", action)
            intent.putExtra("success", true)
            intent.putStringArrayListExtra("outputs", ArrayList(outputs))
            intent.putExtra("timestamp", System.currentTimeMillis())
            intent.setPackage(packageName)
            sendBroadcast(intent)
            
            Log.d(TAG, "AI success response sent for action: $action with ${outputs.size} outputs")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending AI success response with outputs for $action", e)
        }
    }
    
    /**
     * Send AI error response back to keyboard
     */
    private fun sendAIErrorResponse(action: String, error: String) {
        try {
            val intent = Intent(ACTION_AI_ERROR)
            intent.putExtra("action", action)
            intent.putExtra("success", false)
            intent.putExtra("error", error)
            intent.putExtra("timestamp", System.currentTimeMillis())
            intent.setPackage(packageName)
            sendBroadcast(intent)
            
            Log.d(TAG, "AI error response sent for action: $action, error: $error")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending AI error response for $action", e)
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        keyboardMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, KEYBOARD_CHANNEL)
        
        // Set up method call handler for Flutter-to-Android communication
        keyboardMethodChannel?.setMethodCallHandler { call, result ->
            handleFlutterMethodCall(call, result)
        }
        
        // Register broadcast receiver with proper flags for Android 12+
        val filter = IntentFilter().apply {
            addAction(ACTION_TEXT_FROM_KEYBOARD)
            addAction(ACTION_AI_REQUEST)
        }
        
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Android 13+ (API 33+)
                registerReceiver(keyboardCommunicationReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
            } else {
                // Older Android versions
                registerReceiver(keyboardCommunicationReceiver, filter)
            }
            Log.d(TAG, "Keyboard communication receiver registered successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error registering keyboard communication receiver", e)
        }
    }
    
    /**
     * Handle method calls from Flutter
     */
    private fun handleFlutterMethodCall(call: io.flutter.plugin.common.MethodCall, result: io.flutter.plugin.common.MethodChannel.Result) {
        try {
            when (call.method) {
                "sendTextToKeyboard" -> {
                    val text = call.arguments as? String ?: ""
                    sendTextToKeyboard(text)
                    result.success(true)
                }
                "sendAIResponse" -> {
                    val args = call.arguments as? Map<String, Any> ?: emptyMap()
                    val action = args["action"] as? String ?: ""
                    val success = args["success"] as? Boolean ?: false
                    val resultText = args["result"] as? String ?: ""
                    val error = args["error"] as? String ?: ""
                    
                    if (success) {
                        sendAISuccessResponse(action, resultText)
                    } else {
                        sendAIErrorResponse(action, error)
                    }
                    result.success(true)
                }
                "getKeyboardStatus" -> {
                    // Return keyboard service status
                    val status = mapOf(
                        "isServiceRunning" to isKeyboardServiceRunning(),
                        "timestamp" to System.currentTimeMillis()
                    )
                    result.success(status)
                }
                else -> {
                    Log.w(TAG, "Unknown method call from Flutter: ${call.method}")
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling Flutter method call: ${call.method}", e)
            result.error("ERROR", "Failed to handle method call: ${e.message}", null)
        }
    }
    
    /**
     * Send text to keyboard service
     */
    private fun sendTextToKeyboard(text: String) {
        try {
            val intent = Intent("com.nematiai.keytype.TEXT_TO_KEYBOARD")
            intent.putExtra("text", text)
            intent.setPackage(packageName)
            sendBroadcast(intent)
            
            Log.d(TAG, "Text sent to keyboard: ${text.take(100)}...")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending text to keyboard", e)
        }
    }
    
    /**
     * Check if keyboard service is running
     */
    private fun isKeyboardServiceRunning(): Boolean {
        return try {
            val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as android.view.inputmethod.InputMethodManager
            val enabledInputMethods = inputMethodManager.enabledInputMethodList
            enabledInputMethods.any { it.packageName == packageName }
        } catch (e: Exception) {
            Log.e(TAG, "Error checking keyboard service status", e)
            false
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(keyboardCommunicationReceiver)
            Log.d(TAG, "Keyboard communication receiver unregistered")
        } catch (e: Exception) {
            Log.w(TAG, "Error unregistering keyboard communication receiver", e)
        }
        
        // Clean up method channel
        keyboardMethodChannel?.setMethodCallHandler(null)
        keyboardMethodChannel = null
    }
}
