package com.nematiai.keytype

import android.content.Context
import android.content.Intent
import android.content.BroadcastReceiver
import android.content.IntentFilter
import android.util.Log

/**
 * Manages communication between keyboard service and Flutter app
 */
class KeyboardCommunicationManager(private val keyboardService: CustomKeyboardService) {
    
    companion object {
        const val TAG = "KeyboardCommunicationManager"
        const val AI_ACTION_REQUEST = "com.nematiai.keytype.AI_ACTION_REQUEST"
        const val AI_ACTION_RESPONSE = "com.nematiai.keytype.AI_ACTION_RESPONSE"
        const val DEBUG_INFO_BROADCAST = "com.nematiai.keytype.DEBUG_INFO"
    }
    
    private var communicationReceiver: BroadcastReceiver? = null
    private var isInitialized = false
    
    /**
     * Initialize communication receiver
     */
    fun initialize() {
        if (isInitialized) return
        
        try {
            communicationReceiver = object : BroadcastReceiver() {
                override fun onReceive(context: Context?, intent: Intent?) {
                    when (intent?.action) {
                        AI_ACTION_RESPONSE -> handleAIResponse(intent)
                    }
                }
            }
            
            val filter = IntentFilter().apply {
                addAction(AI_ACTION_RESPONSE)
            }
            
            keyboardService.registerReceiver(communicationReceiver, filter)
            isInitialized = true
            
            Log.d(TAG, "Communication manager initialized")
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing communication manager", e)
        }
    }
    
    /**
     * Check if communication manager is ready
     */
    fun isReady(): Boolean = isInitialized
    
    /**
     * Send AI request to Flutter app
     */
    fun sendAIRequest(text: String, action: CustomKeyboardService.AIAction): Boolean {
        return try {
            val intent = Intent(AI_ACTION_REQUEST)
            intent.putExtra("text", text)
            intent.putExtra("action", action.name)
            intent.putExtra("timestamp", System.currentTimeMillis())
            intent.setPackage("com.nematiai.keytype")
            
            keyboardService.sendBroadcast(intent)
            Log.d(TAG, "AI request sent: ${action.name} with ${text.length} chars")
            true
        } catch (e: Exception) {
            Log.e(TAG, "Error sending AI request", e)
            false
        }
    }
    
    /**
     * Handle AI response from Flutter app
     */
    private fun handleAIResponse(intent: Intent) {
        try {
            val actionName = intent.getStringExtra("action") ?: return
            val success = intent.getBooleanExtra("success", false)
            val result = intent.getStringExtra("result") ?: ""
            val error = intent.getStringExtra("error") ?: ""
            
            val action = try {
                CustomKeyboardService.AIAction.valueOf(actionName)
            } catch (e: IllegalArgumentException) {
                Log.e(TAG, "Unknown AI action: $actionName")
                return
            }
            
            // AI operation handlers removed - using static cards only
            Log.d(TAG, "AI response received but not processed (static mode)")
            
            Log.d(TAG, "AI response handled: $actionName, success: $success")
        } catch (e: Exception) {
            Log.e(TAG, "Error handling AI response", e)
        }
    }
    
    /**
     * Send debug information to Flutter app
     */
    fun sendDebugInfo(info: Map<String, Any>) {
        try {
            val intent = Intent(DEBUG_INFO_BROADCAST)
            info.forEach { (key, value) ->
                when (value) {
                    is String -> intent.putExtra(key, value)
                    is Int -> intent.putExtra(key, value)
                    is Long -> intent.putExtra(key, value)
                    is Boolean -> intent.putExtra(key, value)
                    is Float -> intent.putExtra(key, value)
                    else -> intent.putExtra(key, value.toString())
                }
            }
            intent.putExtra("timestamp", System.currentTimeMillis())
            intent.setPackage("com.nematiai.keytype")
            
            keyboardService.sendBroadcast(intent)
            Log.d(TAG, "Debug info sent: ${info.keys}")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending debug info", e)
        }
    }
    
    /**
     * Cleanup communication resources
     */
    fun cleanup() {
        try {
            communicationReceiver?.let {
                keyboardService.unregisterReceiver(it)
                communicationReceiver = null
            }
            isInitialized = false
            Log.d(TAG, "Communication manager cleaned up")
        } catch (e: Exception) {
            Log.e(TAG, "Error cleaning up communication manager", e)
        }
    }
}