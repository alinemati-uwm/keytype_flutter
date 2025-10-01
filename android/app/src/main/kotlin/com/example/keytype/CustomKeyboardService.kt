package com.nematiai.keytype

import android.inputmethodservice.InputMethodService
import android.inputmethodservice.Keyboard
import android.inputmethodservice.KeyboardView
import android.view.View
import android.view.LayoutInflater
import android.view.ContextThemeWrapper
import android.widget.LinearLayout
import android.widget.ImageButton
import android.widget.ProgressBar
import android.widget.TextView
import android.util.Log
import android.view.HapticFeedbackConstants
import android.content.Context

class CustomKeyboardService : InputMethodService(), KeyboardView.OnKeyboardActionListener {
    
    companion object {
        const val TAG = "CustomKeyboard"
    }
    
    private lateinit var keyboardView: KeyboardView
    private lateinit var keyboard: Keyboard
    private lateinit var mainLayout: LinearLayout
    private lateinit var rewriteButton: LinearLayout
    private lateinit var summarizeButton: LinearLayout
    private lateinit var generateButton: LinearLayout
    private lateinit var translateButton: LinearLayout
    private lateinit var fixGrammarButton: LinearLayout
    private lateinit var makeFormalButton: LinearLayout
    private lateinit var makeInformalButton: LinearLayout
    private lateinit var themeToggleButton: ImageButton
    private lateinit var themeManager: KeyboardThemeManager
    private lateinit var animationManager: KeyboardAnimationManager
    private lateinit var accessibilityManager: KeyboardAccessibilityManager
    // Communication manager removed - using static cards only
    private lateinit var aiCardsManager: AICardsManager
    private var aiResponseReceiver: android.content.BroadcastReceiver? = null
    
    // Progress bars for AI buttons
    private lateinit var rewriteProgress: ProgressBar
    private lateinit var summarizeProgress: ProgressBar
    private lateinit var generateProgress: ProgressBar
    private lateinit var translateProgress: ProgressBar
    private lateinit var fixGrammarProgress: ProgressBar
    private lateinit var makeFormalProgress: ProgressBar
    private lateinit var makeInformalProgress: ProgressBar
    

    
    // Keyboard state
    private var isShifted = false
    private var currentKeyboardLayout = KeyboardLayout.LETTERS
    private var keyboardState = KeyboardState()
    
    // Keyboard layouts
    private lateinit var lettersKeyboard: Keyboard
    private lateinit var numbersKeyboard: Keyboard
    private lateinit var specialCharsKeyboard: Keyboard
    
    /**
     * Enum for AI button states
     */
    enum class AIButtonState {
        IDLE,
        PROCESSING,
        SUCCESS,
        ERROR
    }
    
    /**
     * Enum for AI action types
     */
    enum class AIAction {
        REWRITE,
        SUMMARIZE,
        GENERATE,
        TRANSLATE,
        FIX_GRAMMAR,
        MAKE_FORMAL,
        MAKE_INFORMAL
    }
    
    /**
     * Enum for keyboard layout types
     */
    enum class KeyboardLayout {
        LETTERS,
        NUMBERS,
        SPECIAL_CHARS
    }
    
    /**
     * Data class for keyboard state management
     */
    data class KeyboardState(
        val currentLayout: KeyboardLayout = KeyboardLayout.LETTERS,
        val isShiftPressed: Boolean = false,
        val isCapsLockOn: Boolean = false,
        val previousLayout: KeyboardLayout = KeyboardLayout.LETTERS
    )
    
    override fun onCreateInputView(): View {
        // Initialize managers
        themeManager = KeyboardThemeManager(this)
        animationManager = KeyboardAnimationManager()
        accessibilityManager = KeyboardAccessibilityManager(this)
        // Communication manager initialization removed - using static cards only
        aiCardsManager = AICardsManager(this)
        
        // Initialize accessibility features
        accessibilityManager.initialize()
        
        // Create themed context for proper theme attribute resolution
        val themedContext = createThemedContext()
        val themedInflater = LayoutInflater.from(themedContext)
        
        // Create the main keyboard layout with themed context
        mainLayout = themedInflater.inflate(R.layout.keyboard_layout_simple, null) as LinearLayout
        
        // Initialize keyboard view
        keyboardView = mainLayout.findViewById(R.id.keyboard_view)
        
        // Initialize all keyboard layouts
        lettersKeyboard = Keyboard(this, R.xml.keyboard_layout)
        numbersKeyboard = Keyboard(this, R.xml.numbers_keyboard)
        specialCharsKeyboard = Keyboard(this, R.xml.special_chars_keyboard)
        
        // Set initial keyboard and listener
        keyboard = lettersKeyboard
        keyboardView.keyboard = keyboard
        keyboardView.setOnKeyboardActionListener(this)
        
        // Initialize keyboard state
        keyboardState = KeyboardState()
        currentKeyboardLayout = KeyboardLayout.LETTERS
        
        // Initialize AI action buttons
        initializeAIButtons()
        
        // Initialize theme toggle button
        initializeThemeToggle()
        
        // Apply initial theme
        applyCurrentTheme(false)
        
        // Apply accessibility features
        accessibilityManager.applyAccessibilityFeatures(
            mainLayout,
            rewriteButton,
            summarizeButton,
            generateButton,
            translateButton,
            fixGrammarButton,
            makeFormalButton,
            makeInformalButton,
            themeToggleButton
        )
        

        
        // Communication manager removed - using static cards only
        
        // Initialize AI cards manager
        try {
            aiCardsManager.initialize(mainLayout)
            Log.d(TAG, "AI Cards Manager initialized successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize AI Cards Manager", e)
        }
        
        // Initialize AI response receiver
        initializeAIResponseReceiver()
        
        return mainLayout
    }
    
    /**
     * Initialize AI action buttons
     */
    private fun initializeAIButtons() {
        // Initialize rewrite button
        rewriteButton = mainLayout.findViewById(R.id.rewrite_button)
        rewriteProgress = mainLayout.findViewById(R.id.rewrite_progress)
        rewriteButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.REWRITE)
        }
        
        // Initialize summarize button
        summarizeButton = mainLayout.findViewById(R.id.summarize_button)
        summarizeProgress = mainLayout.findViewById(R.id.summarize_progress)
        summarizeButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.SUMMARIZE)
        }
        
        // Initialize generate button
        generateButton = mainLayout.findViewById(R.id.generate_button)
        generateProgress = mainLayout.findViewById(R.id.generate_progress)
        generateButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.GENERATE)
        }
        
        // Initialize translate button
        translateButton = mainLayout.findViewById(R.id.translate_button)
        translateProgress = mainLayout.findViewById(R.id.translate_progress)
        translateButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.TRANSLATE)
        }
        
        // Initialize fix grammar button
        fixGrammarButton = mainLayout.findViewById(R.id.fix_grammar_button)
        fixGrammarProgress = mainLayout.findViewById(R.id.fix_grammar_progress)
        fixGrammarButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.FIX_GRAMMAR)
        }
        
        // Initialize make formal button
        makeFormalButton = mainLayout.findViewById(R.id.make_formal_button)
        makeFormalProgress = mainLayout.findViewById(R.id.make_formal_progress)
        makeFormalButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.MAKE_FORMAL)
        }
        
        // Initialize make informal button
        makeInformalButton = mainLayout.findViewById(R.id.make_informal_button)
        makeInformalProgress = mainLayout.findViewById(R.id.make_informal_progress)
        makeInformalButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            handleAIButtonClick(AIAction.MAKE_INFORMAL)
        }
    }
    
    /**
     * Initialize theme toggle button
     */
    private fun initializeThemeToggle() {
        themeToggleButton = mainLayout.findViewById(R.id.theme_toggle)
        themeToggleButton.setOnClickListener {
            animationManager.animateKeyPress(it)
            toggleTheme()
        }
    }
    
    /**
     * Toggle keyboard theme
     */
    private fun toggleTheme() {
        Log.d(TAG, "Toggling theme")
        
        // Toggle theme in manager
        val newTheme = themeManager.toggleTheme()
        
        // Apply theme with animation
        applyCurrentTheme(true)
        
        // Announce theme change for accessibility
        accessibilityManager.announceThemeChange(newTheme.isDark)
    }
    
    /**
     * Create themed context based on current theme preference
     */
    private fun createThemedContext(): Context {
        val isDarkTheme = themeManager.isDarkTheme()
        val themeRes = if (isDarkTheme) {
            R.style.KeyboardDarkTheme
        } else {
            R.style.KeyboardLightTheme
        }
        return ContextThemeWrapper(this, themeRes)
    }
    
    /**
     * Apply current theme to all UI elements
     */
    private fun applyCurrentTheme(animate: Boolean = false) {
        // Recreate the view with proper theme context when theme changes
        if (animate) {
            // For theme changes, we need to recreate the view with new theme context
            recreateInputViewWithTheme()
        } else {
            // For initial setup, just apply the theme attributes
            applyThemeAttributes()
        }
    }
    
    /**
     * Recreate input view with new theme context
     */
    private fun recreateInputViewWithTheme() {
        // Save current state
        val currentLayout = currentKeyboardLayout
        
        // Recreate the view with new theme
        val newView = onCreateInputView()
        
        // Replace the current view
        setInputView(newView)
        
        // Restore state
        switchToKeyboardLayout(currentLayout)
        
        Log.d(TAG, "Input view recreated with new theme")
    }
    
    /**
     * Apply theme attributes to current views
     */
    private fun applyThemeAttributes() {
        // The theme attributes are automatically applied through the themed context
        // Just need to update the keyboard view colors
        keyboardView.invalidateAllKeys()
        
        // Update theme toggle icon
        updateThemeToggleIcon()
        
        Log.d(TAG, "Theme attributes applied")
    }
    
    /**
     * Update theme toggle icon based on current theme
     */
    private fun updateThemeToggleIcon() {
        val isDark = themeManager.isDarkTheme()
        val iconRes = if (isDark) {
            R.drawable.ic_theme_sun // Show sun icon in dark mode (to switch to light)
        } else {
            R.drawable.ic_theme_moon // Show moon icon in light mode (to switch to dark)
        }
        themeToggleButton.setImageResource(iconRes)
    }
    
    /**
     * Switch to a specific keyboard layout
     */
    private fun switchToKeyboardLayout(newLayout: KeyboardLayout, animate: Boolean = true) {
        if (currentKeyboardLayout == newLayout) {
            return
        }
        
        Log.d(TAG, "Switching keyboard layout to $newLayout")
        
        // Update state
        keyboardState = keyboardState.copy(
            previousLayout = currentKeyboardLayout,
            currentLayout = newLayout
        )
        currentKeyboardLayout = newLayout
        
        // Get the target keyboard
        val targetKeyboard = when (newLayout) {
            KeyboardLayout.LETTERS -> lettersKeyboard
            KeyboardLayout.NUMBERS -> numbersKeyboard
            KeyboardLayout.SPECIAL_CHARS -> specialCharsKeyboard
        }
        
        if (animate) {
            animationManager.animateKeyboardLayoutSwitch(keyboardView, targetKeyboard) {
                keyboard = targetKeyboard
            }
        } else {
            keyboard = targetKeyboard
            keyboardView.keyboard = keyboard
            keyboardView.invalidateAllKeys()
        }
        
        // Announce layout change for accessibility
        accessibilityManager.announceLayoutChange(newLayout)
    }
    

    
    /**
     * Handle AI button click - Show static cards and send request to Flutter
     */
    private fun handleAIButtonClick(action: AIAction) {
        Log.d(TAG, "AI button clicked: $action")
        
        // Capture text from current input field
        val inputText = captureInputText()
        
        if (inputText.trim().isEmpty()) {
            Log.w(TAG, "No text to process for AI action: $action")
            // Show a brief message or ignore
            return
        }
        
        Log.d(TAG, "Captured input text: ${inputText.take(100)}... (${inputText.length} chars)")
        
        // Show AI cards interface with shimmer animation
        if (::aiCardsManager.isInitialized) {
            Log.d(TAG, "AICardsManager is initialized, calling showAICards")
            try {
                aiCardsManager.showAICards(action, inputText)
                Log.d(TAG, "showAICards call completed")
                
                // Send AI request to Flutter via broadcast
                sendAIRequestToFlutter(inputText, action)
                
            } catch (e: Exception) {
                Log.e(TAG, "Error calling showAICards", e)
            }
        } else {
            Log.e(TAG, "AICardsManager is not initialized!")
        }
    }
    
    /**
     * Send AI request to Flutter app via broadcast
     */
    private fun sendAIRequestToFlutter(text: String, action: AIAction) {
        try {
            val intent = android.content.Intent("com.nematiai.keytype.AI_ACTION_REQUEST")
            intent.putExtra("text", text)
            intent.putExtra("action", action.name)
            intent.putExtra("timestamp", System.currentTimeMillis())
            intent.setPackage(packageName)
            
            sendBroadcast(intent)
            Log.d(TAG, "AI request sent to Flutter: ${action.name} with ${text.length} chars")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending AI request to Flutter", e)
            // Handle error - maybe show error in AI cards
        }
    }
    
    /**
     * Initialize AI response receiver
     */
    private fun initializeAIResponseReceiver() {
        aiResponseReceiver = object : android.content.BroadcastReceiver() {
            override fun onReceive(context: android.content.Context?, intent: android.content.Intent?) {
                when (intent?.action) {
                    "com.nematiai.keytype.AI_ACTION_RESPONSE" -> handleAIResponse(intent)
                    "com.nematiai.keytype.AI_ACTION_ERROR" -> handleAIError(intent)
                }
            }
        }
        
        val filter = android.content.IntentFilter().apply {
            addAction("com.nematiai.keytype.AI_ACTION_RESPONSE")
            addAction("com.nematiai.keytype.AI_ACTION_ERROR")
        }
        
        try {
            registerReceiver(aiResponseReceiver, filter)
            Log.d(TAG, "AI response receiver registered")
        } catch (e: Exception) {
            Log.e(TAG, "Error registering AI response receiver", e)
        }
    }
    
    /**
     * Handle AI success response
     */
    private fun handleAIResponse(intent: android.content.Intent) {
        try {
            val action = intent.getStringExtra("action") ?: ""
            val success = intent.getBooleanExtra("success", false)
            val outputs = intent.getStringArrayListExtra("outputs")
            val result = intent.getStringExtra("result") ?: ""
            
            Log.d(TAG, "AI response received: $action, success: $success")
            
            if (success && outputs != null && outputs.size >= 5) {
                // Update AI cards with the 5 outputs
                if (::aiCardsManager.isInitialized) {
                    aiCardsManager.showResultsInCards(outputs.take(5))
                }
            } else if (success && result.isNotEmpty()) {
                // Parse single result into multiple outputs
                val parsedOutputs = parseAIResult(result)
                if (::aiCardsManager.isInitialized) {
                    aiCardsManager.showResultsInCards(parsedOutputs)
                }
            } else {
                // Handle as error
                handleAIError(intent)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling AI response", e)
        }
    }
    
    /**
     * Handle AI error response
     */
    private fun handleAIError(intent: android.content.Intent) {
        try {
            val action = intent.getStringExtra("action") ?: "Unknown"
            val error = intent.getStringExtra("error") ?: "Unknown error occurred"
            
            Log.e(TAG, "AI error received: $action - $error")
            
            if (::aiCardsManager.isInitialized) {
                aiCardsManager.showErrorInCards(error)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling AI error", e)
        }
    }
    
    /**
     * Parse AI result into multiple outputs
     */
    private fun parseAIResult(result: String): List<String> {
        try {
            // Split by newline and filter non-empty lines
            val lines = result.split("\n")
                .filter { it.trim().isNotEmpty() }
                .map { it.trim() }
            
            val outputs = mutableListOf<String>()
            
            // Extract up to 5 meaningful outputs
            for (line in lines) {
                // Remove numbering if present (1., 2., etc.)
                val cleanLine = line.replaceFirst(Regex("^\\d+\\.\\s*"), "")
                
                // Skip very short lines
                if (cleanLine.length > 10) {
                    outputs.add(cleanLine)
                    if (outputs.size >= 5) break
                }
            }
            
            // If we don't have 5 outputs, pad with variations
            while (outputs.size < 5) {
                if (outputs.isNotEmpty()) {
                    outputs.add("${outputs.first()} (Alternative ${outputs.size + 1})")
                } else {
                    outputs.add("Processing completed successfully")
                }
            }
            
            return outputs.take(5)
        } catch (e: Exception) {
            Log.w(TAG, "Error parsing AI result: $e")
            // Return fallback outputs
            return listOf(
                "AI processing completed",
                "Response generated successfully",
                "Task finished with results",
                "Operation completed successfully",
                "Processing finalized"
            )
        }
    }
    
    /**
     * Test method to manually show AI cards
     */
    fun testShowAICards() {
        Log.d(TAG, "Test: Manually showing AI cards")
        handleAIButtonClick(AIAction.REWRITE)
    }
    

    
    /**
     * Capture text from current input field
     */
    private fun captureInputText(): String {
        val inputConnection = currentInputConnection
        return if (inputConnection != null) {
            try {
                val extractRequest = android.view.inputmethod.ExtractedTextRequest()
                extractRequest.flags = 0
                extractRequest.hintMaxChars = 10000
                
                val extractedText = inputConnection.getExtractedText(extractRequest, 0)
                extractedText?.text?.toString() ?: ""
            } catch (e: Exception) {
                Log.w(TAG, "Failed to extract text", e)
                ""
            }
        } else {
            ""
        }
    }
    
    // AI operation handlers removed - using static cards only
    
    // KeyboardView.OnKeyboardActionListener implementation
    
    override fun onPress(primaryCode: Int) {
        Log.d(TAG, "Key pressed: $primaryCode")
    }
    
    override fun onRelease(primaryCode: Int) {
        Log.d(TAG, "Key released: $primaryCode")
    }
    
    override fun onKey(primaryCode: Int, keyCodes: IntArray?) {
        Log.d(TAG, "Key action: $primaryCode")
        
        when (primaryCode) {
            // Layout switching keys
            -10 -> { // Numbers mode (123)
                switchToKeyboardLayout(KeyboardLayout.NUMBERS, true)
            }
            -11 -> { // Special characters mode (#+=)
                switchToKeyboardLayout(KeyboardLayout.SPECIAL_CHARS, true)
            }
            -12 -> { // Letters mode (ABC)
                switchToKeyboardLayout(KeyboardLayout.LETTERS, true)
            }
            
            // Action keys
            -1 -> { // Shift key
                handleShiftKey()
            }
            -4 -> { // Enter/Return key
                handleEnterKey()
            }
            -5 -> { // Backspace key
                handleBackspaceKey()
            }
            32 -> { // Space key
                handleSpaceKey()
            }
            
            // Period key (handle popup selections)
            46 -> { // Period key
                handlePeriodKey()
            }
            
            // Domain extension keys from popup
            -100 -> { // .com
                handleDomainExtension(".com")
            }
            -101 -> { // .org
                handleDomainExtension(".org")
            }
            -102 -> { // .net
                handleDomainExtension(".net")
            }
            -103 -> { // .edu
                handleDomainExtension(".edu")
            }
            
            // Regular character keys
            else -> {
                if (primaryCode > 0) {
                    handleCharacterKey(primaryCode)
                }
            }
        }
    }
    
    override fun onText(text: CharSequence?) {
        Log.d(TAG, "Text input: $text")
        text?.let {
            val inputConnection = currentInputConnection
            if (inputConnection != null) {
                // Commit the text and ensure it's properly sent
                inputConnection.commitText(it, 1)
                inputConnection.finishComposingText()
                Log.d(TAG, "Text committed: $it")
            }
        }
    }
    
    override fun swipeLeft() {
        Log.d(TAG, "Swipe left detected")
    }
    
    override fun swipeRight() {
        Log.d(TAG, "Swipe right detected")
    }
    
    override fun swipeDown() {
        Log.d(TAG, "Swipe down detected")
    }
    
    override fun swipeUp() {
        Log.d(TAG, "Swipe up detected")
    }
    
    /**
     * Handle shift key press
     */
    private fun handleShiftKey() {
        isShifted = !isShifted
        keyboardState = keyboardState.copy(isShiftPressed = isShifted)
        
        // Update keyboard to show uppercase/lowercase letters
        updateKeyboardCase()
        
        keyboardView.invalidateAllKeys()
        Log.d(TAG, "Shift key toggled: isShifted=$isShifted")
    }
    
    /**
     * Update keyboard case based on shift state
     */
    private fun updateKeyboardCase() {
        if (currentKeyboardLayout == KeyboardLayout.LETTERS) {
            // Recreate the letters keyboard with proper case
            lettersKeyboard = if (isShifted) {
                Keyboard(this, R.xml.keyboard_layout_uppercase)
            } else {
                Keyboard(this, R.xml.keyboard_layout)
            }
            
            // Update the keyboard view
            keyboardView.keyboard = lettersKeyboard
            keyboard = lettersKeyboard
        }
    }
    
    /**
     * Handle enter/return key press
     */
    private fun handleEnterKey() {
        val inputConnection = currentInputConnection
        if (inputConnection != null) {
            inputConnection.sendKeyEvent(
                android.view.KeyEvent(
                    android.view.KeyEvent.ACTION_DOWN,
                    android.view.KeyEvent.KEYCODE_ENTER
                )
            )
            inputConnection.sendKeyEvent(
                android.view.KeyEvent(
                    android.view.KeyEvent.ACTION_UP,
                    android.view.KeyEvent.KEYCODE_ENTER
                )
            )
        }
        performHapticFeedback()
        Log.d(TAG, "Enter key pressed")
    }
    
    /**
     * Handle backspace key press
     */
    private fun handleBackspaceKey() {
        val inputConnection = currentInputConnection
        if (inputConnection != null) {
            inputConnection.deleteSurroundingText(1, 0)
        }
        performHapticFeedback()
        Log.d(TAG, "Backspace key pressed")
    }
    
    /**
     * Handle space key press
     */
    private fun handleSpaceKey() {
        val inputConnection = currentInputConnection
        if (inputConnection != null) {
            inputConnection.commitText(" ", 1)
        }
        performHapticFeedback()
        Log.d(TAG, "Space key pressed")
    }
    
    /**
     * Handle period key press
     */
    private fun handlePeriodKey() {
        val inputConnection = currentInputConnection
        if (inputConnection != null) {
            inputConnection.commitText(".", 1)
        }
        performHapticFeedback()
        Log.d(TAG, "Period key pressed")
    }
    
    /**
     * Handle domain extension selection from popup
     */
    private fun handleDomainExtension(extension: String) {
        val inputConnection = currentInputConnection
        if (inputConnection != null) {
            // Commit the domain extension
            inputConnection.commitText(extension, 1)
            // Ensure the text is properly sent to the text field
            inputConnection.finishComposingText()
            Log.d(TAG, "Domain extension committed: $extension")
        }
        performHapticFeedback()
    }
    
    /**
     * Handle regular character key press
     */
    private fun handleCharacterKey(primaryCode: Int) {
        val inputConnection = currentInputConnection
        if (inputConnection != null) {
            val char = primaryCode.toChar()
            
            // The character case is already handled by the keyboard layout
            inputConnection.commitText(char.toString(), 1)
            
            // Reset shift after character input (unless caps lock)
            if (isShifted && currentKeyboardLayout == KeyboardLayout.LETTERS && !keyboardState.isCapsLockOn) {
                isShifted = false
                keyboardState = keyboardState.copy(isShiftPressed = false)
                updateKeyboardCase()
                keyboardView.invalidateAllKeys()
            }
        }
        
        performHapticFeedback()
        Log.d(TAG, "Character key pressed: ${primaryCode.toChar()}")
    }
    
    /**
     * Perform haptic feedback
     */
    private fun performHapticFeedback() {
        try {
            mainLayout.performHapticFeedback(HapticFeedbackConstants.KEYBOARD_TAP)
        } catch (e: Exception) {
            Log.w(TAG, "Could not perform haptic feedback", e)
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        
        // Cleanup resources
        if (::animationManager.isInitialized) {
            animationManager.cleanup()
        }
        
        // Communication manager cleanup removed - using static cards only
        
        if (::aiCardsManager.isInitialized) {
            aiCardsManager.cleanup()
        }
        
        // Cleanup AI response receiver
        try {
            aiResponseReceiver?.let {
                unregisterReceiver(it)
                aiResponseReceiver = null
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error unregistering AI response receiver", e)
        }
        
        Log.d(TAG, "CustomKeyboardService destroyed")
    }
}