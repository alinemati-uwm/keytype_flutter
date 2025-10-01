package com.nematiai.keytype

import android.content.Context
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.ImageButton
import android.inputmethodservice.KeyboardView
import android.inputmethodservice.Keyboard
import android.animation.ObjectAnimator
import android.animation.ValueAnimator
import android.animation.Animator
import android.view.View

/**
 * Helper classes and data structures for testing
 */

/**
 * Data class representing keyboard theme
 */
data class KeyboardTheme(
    val backgroundColor: Int,
    val keyBackgroundColor: Int,
    val keyTextColor: Int,
    val actionKeyBackgroundColor: Int,
    val borderColor: Int,
    val isDark: Boolean
)

/**
 * Mock KeyboardThemeManager for testing
 */
class KeyboardThemeManager(private val context: Context) {
    
    companion object {
        const val PREF_IS_DARK_THEME = "is_dark_theme"
    }
    
    private var currentTheme: KeyboardTheme = getDarkTheme()
    
    fun isDarkTheme(): Boolean = currentTheme.isDark
    
    fun getCurrentTheme(): KeyboardTheme = currentTheme
    
    fun toggleTheme(): KeyboardTheme {
        currentTheme = if (currentTheme.isDark) getLightTheme() else getDarkTheme()
        saveThemePreference()
        return currentTheme
    }
    
    fun getLightTheme(): KeyboardTheme {
        return KeyboardTheme(
            backgroundColor = 0xFFF5F5F5.toInt(),
            keyBackgroundColor = 0xFFFFFFFF.toInt(),
            keyTextColor = 0xFF2C2C2C.toInt(),
            actionKeyBackgroundColor = 0xFFE8E8E8.toInt(),
            borderColor = 0xFFE0E0E0.toInt(),
            isDark = false
        )
    }
    
    fun getDarkTheme(): KeyboardTheme {
        return KeyboardTheme(
            backgroundColor = 0xFF1A1A1A.toInt(),
            keyBackgroundColor = 0xFF2D2D2D.toInt(),
            keyTextColor = 0xFFFFFFFF.toInt(),
            actionKeyBackgroundColor = 0xFF404040.toInt(),
            borderColor = 0xFF404040.toInt(),
            isDark = true
        )
    }
    
    fun applyThemeToLayout(
        mainLayout: LinearLayout,
        themeToggleButton: ImageButton,
        rewriteButton: LinearLayout,
        summarizeButton: LinearLayout,
        generateButton: LinearLayout,
        animate: Boolean
    ) {
        mainLayout.setBackgroundColor(currentTheme.backgroundColor)
        // Apply theme to other components
    }
    
    private fun saveThemePreference() {
        val prefs = context.getSharedPreferences("keyboard_prefs", Context.MODE_PRIVATE)
        prefs.edit().putBoolean(PREF_IS_DARK_THEME, currentTheme.isDark).apply()
    }
}

/**
 * Mock AIButtonManager for testing
 */
class AIButtonManager(private val context: Context) {
    
    private val buttonStates = mutableMapOf<CustomKeyboardService.AIAction, CustomKeyboardService.AIButtonState>()
    private val stateHistory = mutableMapOf<CustomKeyboardService.AIAction, MutableList<CustomKeyboardService.AIButtonState>>()
    private var stateChangeCallback: ((CustomKeyboardService.AIAction, CustomKeyboardService.AIButtonState) -> Unit)? = null
    
    private lateinit var rewriteButton: LinearLayout
    private lateinit var summarizeButton: LinearLayout
    private lateinit var generateButton: LinearLayout
    private lateinit var rewriteProgress: ProgressBar
    private lateinit var summarizeProgress: ProgressBar
    private lateinit var generateProgress: ProgressBar
    
    fun initialize(
        rewriteBtn: LinearLayout, rewriteProg: ProgressBar,
        summarizeBtn: LinearLayout, summarizeProg: ProgressBar,
        generateBtn: LinearLayout, generateProg: ProgressBar
    ) {
        rewriteButton = rewriteBtn
        summarizeButton = summarizeBtn
        generateButton = generateBtn
        rewriteProgress = rewriteProg
        summarizeProgress = summarizeProg
        generateProgress = generateProg
        
        // Initialize all states to IDLE
        CustomKeyboardService.AIAction.values().forEach { action ->
            buttonStates[action] = CustomKeyboardService.AIButtonState.IDLE
            stateHistory[action] = mutableListOf()
        }
    }
    
    fun getButtonState(action: CustomKeyboardService.AIAction): CustomKeyboardService.AIButtonState {
        return buttonStates[action] ?: CustomKeyboardService.AIButtonState.IDLE
    }
    
    fun setButtonState(action: CustomKeyboardService.AIAction, state: CustomKeyboardService.AIButtonState) {
        buttonStates[action] = state
        stateHistory[action]?.add(state)
        
        updateButtonUI(action, state)
        stateChangeCallback?.invoke(action, state)
    }
    
    fun canButtonBeClicked(action: CustomKeyboardService.AIAction): Boolean {
        return getButtonState(action) != CustomKeyboardService.AIButtonState.PROCESSING
    }
    
    fun resetAllStates() {
        CustomKeyboardService.AIAction.values().forEach { action ->
            setButtonState(action, CustomKeyboardService.AIButtonState.IDLE)
        }
    }
    
    fun setStateChangeCallback(callback: (CustomKeyboardService.AIAction, CustomKeyboardService.AIButtonState) -> Unit) {
        stateChangeCallback = callback
    }
    
    fun getStateHistory(action: CustomKeyboardService.AIAction): List<CustomKeyboardService.AIButtonState> {
        return stateHistory[action]?.toList() ?: emptyList()
    }
    
    private fun updateButtonUI(action: CustomKeyboardService.AIAction, state: CustomKeyboardService.AIButtonState) {
        val (button, progressBar) = when (action) {
            CustomKeyboardService.AIAction.REWRITE -> Pair(rewriteButton, rewriteProgress)
            CustomKeyboardService.AIAction.SUMMARIZE -> Pair(summarizeButton, summarizeProgress)
            CustomKeyboardService.AIAction.GENERATE -> Pair(generateButton, generateProgress)
        }
        
        when (state) {
            CustomKeyboardService.AIButtonState.IDLE -> {
                button.isEnabled = true
                progressBar.visibility = View.GONE
            }
            CustomKeyboardService.AIButtonState.PROCESSING -> {
                button.isEnabled = false
                progressBar.visibility = View.VISIBLE
            }
            CustomKeyboardService.AIButtonState.SUCCESS -> {
                button.isEnabled = true
                progressBar.visibility = View.GONE
            }
            CustomKeyboardService.AIButtonState.ERROR -> {
                button.isEnabled = true
                progressBar.visibility = View.GONE
            }
        }
    }
}

/**
 * Mock KeyboardLayoutManager for testing
 */
class KeyboardLayoutManager(private val context: Context) {
    
    private var currentLayout = CustomKeyboardService.KeyboardLayout.LETTERS
    private var previousLayout = CustomKeyboardService.KeyboardLayout.LETTERS
    private var isShiftPressed = false
    private var isCapsLockOn = false
    private var layoutSwitchAnimationCallback: (() -> Unit)? = null
    
    private lateinit var keyboardView: KeyboardView
    private lateinit var lettersKeyboard: Keyboard
    private lateinit var numbersKeyboard: Keyboard
    private lateinit var specialCharsKeyboard: Keyboard
    
    fun initialize(
        kbView: KeyboardView,
        lettersKb: Keyboard,
        numbersKb: Keyboard,
        specialCharsKb: Keyboard
    ) {
        keyboardView = kbView
        lettersKeyboard = lettersKb
        numbersKeyboard = numbersKb
        specialCharsKeyboard = specialCharsKb
        
        restoreKeyboardState()
    }
    
    fun getCurrentLayout(): CustomKeyboardService.KeyboardLayout = currentLayout
    fun getPreviousLayout(): CustomKeyboardService.KeyboardLayout = previousLayout
    fun isShiftPressed(): Boolean = isShiftPressed
    fun isCapsLockOn(): Boolean = isCapsLockOn
    
    fun switchToLayout(layout: CustomKeyboardService.KeyboardLayout, animate: Boolean = true) {
        if (currentLayout == layout) return
        
        previousLayout = currentLayout
        currentLayout = layout
        
        val targetKeyboard = when (layout) {
            CustomKeyboardService.KeyboardLayout.LETTERS -> lettersKeyboard
            CustomKeyboardService.KeyboardLayout.NUMBERS -> numbersKeyboard
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS -> specialCharsKeyboard
        }
        
        keyboardView.keyboard = targetKeyboard
        keyboardView.invalidateAllKeys()
        
        if (animate) {
            layoutSwitchAnimationCallback?.invoke()
        }
        
        persistKeyboardState()
    }
    
    fun switchToPreviousLayout() {
        switchToLayout(previousLayout)
    }
    
    fun switchToNextLayout() {
        val nextLayout = when (currentLayout) {
            CustomKeyboardService.KeyboardLayout.LETTERS -> CustomKeyboardService.KeyboardLayout.NUMBERS
            CustomKeyboardService.KeyboardLayout.NUMBERS -> CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS -> CustomKeyboardService.KeyboardLayout.LETTERS
        }
        switchToLayout(nextLayout)
    }
    
    fun setShiftState(shifted: Boolean) {
        isShiftPressed = shifted
    }
    
    fun setCapsLockState(capsLock: Boolean) {
        isCapsLockOn = capsLock
    }
    
    fun getKeyboardState(): CustomKeyboardService.KeyboardState {
        return CustomKeyboardService.KeyboardState(
            currentLayout = currentLayout,
            isShiftPressed = isShiftPressed,
            isCapsLockOn = isCapsLockOn,
            previousLayout = previousLayout
        )
    }
    
    fun getCharacterForKeyCode(keyCode: Int): String {
        return when (keyCode) {
            33 -> "!"
            64 -> "@"
            35 -> "#"
            36 -> "$"
            37 -> "%"
            94 -> "^"
            38 -> "&"
            42 -> "*"
            40 -> "("
            41 -> ")"
            else -> ""
        }
    }
    
    fun setLayoutSwitchAnimationCallback(callback: () -> Unit) {
        layoutSwitchAnimationCallback = callback
    }
    
    private fun persistKeyboardState() {
        val prefs = context.getSharedPreferences("keyboard_prefs", Context.MODE_PRIVATE)
        prefs.edit()
            .putString("current_layout", currentLayout.name)
            .putString("previous_layout", previousLayout.name)
            .putBoolean("is_shifted", isShiftPressed)
            .putBoolean("is_caps_lock", isCapsLockOn)
            .apply()
    }
    
    private fun restoreKeyboardState() {
        val prefs = context.getSharedPreferences("keyboard_prefs", Context.MODE_PRIVATE)
        
        val currentLayoutName = prefs.getString("current_layout", CustomKeyboardService.KeyboardLayout.LETTERS.name)
        val previousLayoutName = prefs.getString("previous_layout", CustomKeyboardService.KeyboardLayout.LETTERS.name)
        
        currentLayout = try {
            CustomKeyboardService.KeyboardLayout.valueOf(currentLayoutName ?: CustomKeyboardService.KeyboardLayout.LETTERS.name)
        } catch (e: IllegalArgumentException) {
            CustomKeyboardService.KeyboardLayout.LETTERS
        }
        
        previousLayout = try {
            CustomKeyboardService.KeyboardLayout.valueOf(previousLayoutName ?: CustomKeyboardService.KeyboardLayout.LETTERS.name)
        } catch (e: IllegalArgumentException) {
            CustomKeyboardService.KeyboardLayout.LETTERS
        }
        
        isShiftPressed = prefs.getBoolean("is_shifted", false)
        isCapsLockOn = prefs.getBoolean("is_caps_lock", false)
    }
}

/**
 * Mock KeyboardAnimationManager for testing
 */
class KeyboardAnimationManager {
    
    private val activeAnimations = mutableMapOf<View, List<Animator>>()
    private var performanceMetrics = PerformanceMetrics()
    
    data class PerformanceMetrics(
        val averageAnimationDuration: Long = 250,
        val frameDropRate: Double = 0.05
    )
    
    fun createKeyPressAnimation(view: View): ObjectAnimator {
        val animator = ObjectAnimator.ofFloat(view, "scaleX", 1.0f, 0.95f, 1.0f)
        animator.duration = 150
        return animator
    }
    
    fun createThemeTransitionAnimation(view: View, fromColor: Int, toColor: Int): ValueAnimator {
        val animator = ValueAnimator.ofArgb(fromColor, toColor)
        animator.duration = 300
        return animator
    }
    
    fun startAIButtonProcessingAnimation(button: LinearLayout, progressBar: ProgressBar) {
        button.isEnabled = false
        progressBar.visibility = View.VISIBLE
    }
    
    fun showAIButtonSuccessAnimation(button: LinearLayout, progressBar: ProgressBar) {
        button.isEnabled = true
        progressBar.visibility = View.GONE
    }
    
    fun showAIButtonErrorAnimation(button: LinearLayout, progressBar: ProgressBar) {
        button.isEnabled = true
        progressBar.visibility = View.GONE
    }
    
    fun stopAIButtonAnimations(button: LinearLayout, progressBar: ProgressBar) {
        button.isEnabled = true
        progressBar.visibility = View.GONE
    }
    
    fun startRotatingSparkleAnimation(button: LinearLayout) {
        // Mock rotating sparkle animation
    }
    
    fun animateKeyboardLayoutSwitch(keyboardView: KeyboardView, targetKeyboard: Keyboard, callback: () -> Unit) {
        // Mock layout switch animation
        callback()
    }
    
    fun isAnimationRunning(view: View): Boolean {
        return activeAnimations.containsKey(view)
    }
    
    fun getActiveAnimationCount(): Int = activeAnimations.size
    
    fun stopAllAnimations() {
        activeAnimations.clear()
    }
    
    fun hasActiveAnimations(): Boolean = activeAnimations.isNotEmpty()
    
    fun getPerformanceMetrics(): PerformanceMetrics = performanceMetrics
    
    fun getResourceCount(): Int = activeAnimations.size
    
    fun cleanup() {
        activeAnimations.clear()
    }
    
    fun animateKeyPress(view: View) {
        // Mock key press animation
    }
    
    fun performHapticFeedback(view: View) {
        // Mock haptic feedback
    }
}

/**
 * Mock KeyboardCommunicationManager for testing
 */
class KeyboardCommunicationManager(private val context: Context) {
    
    private var isInitialized = false
    private var requestIdCounter = 1L
    private val pendingRequests = mutableSetOf<CustomKeyboardService.AIAction>()
    private var aiResponseCallback: ((CustomKeyboardService.AIAction, String) -> Unit)? = null
    private var aiErrorCallback: ((CustomKeyboardService.AIAction, String) -> Unit)? = null
    private var timeoutCallback: ((CustomKeyboardService.AIAction) -> Unit)? = null
    
    fun initialize() {
        isInitialized = true
    }
    
    fun isReady(): Boolean = isInitialized
    
    fun sendAIRequest(text: String?, action: CustomKeyboardService.AIAction): Boolean {
        if (text.isNullOrEmpty()) return false
        
        pendingRequests.add(action)
        
        // Mock sending broadcast
        try {
            val intent = android.content.Intent("com.nematiai.keytype.AI_ACTION_REQUEST")
            intent.putExtra("text", text)
            intent.putExtra("action", action.name)
            intent.setPackage("com.nematiai.keytype")
            context.sendBroadcast(intent)
            return true
        } catch (e: Exception) {
            return false
        }
    }
    
    fun sendDebugInfo(debugInfo: Map<String, Any>) {
        val intent = android.content.Intent("com.nematiai.keytype.DEBUG_INFO")
        debugInfo.forEach { (key, value) ->
            when (value) {
                is String -> intent.putExtra(key, value)
                is Int -> intent.putExtra(key, value)
                is Long -> intent.putExtra(key, value)
                is Boolean -> intent.putExtra(key, value)
                else -> intent.putExtra(key, value.toString())
            }
        }
        context.sendBroadcast(intent)
    }
    
    fun generateRequestId(): Long = requestIdCounter++
    
    fun hasPendingRequest(action: CustomKeyboardService.AIAction): Boolean {
        return pendingRequests.contains(action)
    }
    
    fun handleAIResponse(intent: android.content.Intent) {
        val actionName = intent.getStringExtra("action") ?: return
        val action = try {
            CustomKeyboardService.AIAction.valueOf(actionName)
        } catch (e: IllegalArgumentException) {
            return
        }
        
        pendingRequests.remove(action)
        
        val success = intent.getBooleanExtra("success", false)
        if (success) {
            val result = intent.getStringExtra("result") ?: ""
            aiResponseCallback?.invoke(action, result)
        } else {
            val error = intent.getStringExtra("error") ?: "Unknown error"
            aiErrorCallback?.invoke(action, error)
        }
    }
    
    fun handleRequestTimeout(action: CustomKeyboardService.AIAction) {
        pendingRequests.remove(action)
        timeoutCallback?.invoke(action)
    }
    
    fun setAIResponseCallback(callback: (CustomKeyboardService.AIAction, String) -> Unit) {
        aiResponseCallback = callback
    }
    
    fun setAIErrorCallback(callback: (CustomKeyboardService.AIAction, String) -> Unit) {
        aiErrorCallback = callback
    }
    
    fun setTimeoutCallback(callback: (CustomKeyboardService.AIAction) -> Unit) {
        timeoutCallback = callback
    }
    
    fun cleanup() {
        isInitialized = false
        pendingRequests.clear()
    }
}