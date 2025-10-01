package com.nematiai.keytype

import android.content.Context
import android.view.View
import android.view.accessibility.AccessibilityManager
import android.widget.LinearLayout
import android.widget.ImageButton
import android.util.Log

/**
 * Manages keyboard accessibility features
 */
class KeyboardAccessibilityManager(private val context: Context) {
    
    companion object {
        const val TAG = "KeyboardAccessibilityManager"
    }
    
    private val accessibilityManager = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
    
    /**
     * Initialize accessibility features
     */
    fun initialize() {
        Log.d(TAG, "Accessibility manager initialized")
    }
    
    /**
     * Check if haptic feedback is enabled
     */
    fun isHapticFeedbackEnabled(): Boolean {
        return true // Always enable haptic feedback for better UX
    }
    
    /**
     * Apply accessibility features to keyboard components
     */
    fun applyAccessibilityFeatures(
        mainLayout: LinearLayout,
        rewriteButton: LinearLayout,
        summarizeButton: LinearLayout,
        generateButton: LinearLayout,
        translateButton: LinearLayout,
        fixGrammarButton: LinearLayout,
        makeFormalButton: LinearLayout,
        makeInformalButton: LinearLayout,
        themeToggleButton: ImageButton
    ) {
        // Set content descriptions for AI buttons
        rewriteButton.contentDescription = "Rewrite text using AI"
        summarizeButton.contentDescription = "Summarize text using AI"
        generateButton.contentDescription = "Generate text using AI"
        translateButton.contentDescription = "Translate text using AI"
        fixGrammarButton.contentDescription = "Fix grammar and spelling using AI"
        makeFormalButton.contentDescription = "Make text formal using AI"
        makeInformalButton.contentDescription = "Make text casual using AI"
        themeToggleButton.contentDescription = "Toggle keyboard theme"
        
        // Make buttons focusable for accessibility
        rewriteButton.isFocusable = true
        summarizeButton.isFocusable = true
        generateButton.isFocusable = true
        translateButton.isFocusable = true
        fixGrammarButton.isFocusable = true
        makeFormalButton.isFocusable = true
        makeInformalButton.isFocusable = true
        themeToggleButton.isFocusable = true
        
        Log.d(TAG, "Accessibility features applied")
    }
    
    /**
     * Update AI button accessibility state
     */
    fun updateAIButtonAccessibilityState(button: LinearLayout, state: CustomKeyboardService.AIButtonState) {
        val description = when (state) {
            CustomKeyboardService.AIButtonState.IDLE -> "Ready"
            CustomKeyboardService.AIButtonState.PROCESSING -> "Processing"
            CustomKeyboardService.AIButtonState.SUCCESS -> "Completed successfully"
            CustomKeyboardService.AIButtonState.ERROR -> "Error occurred"
        }
        
        button.contentDescription = "${button.contentDescription} - $description"
    }
    
    /**
     * Announce theme change for accessibility
     */
    fun announceThemeChange(isDark: Boolean) {
        val announcement = if (isDark) "Dark theme enabled" else "Light theme enabled"
        Log.d(TAG, "Theme change announced: $announcement")
    }
    
    /**
     * Announce layout change for accessibility
     */
    fun announceLayoutChange(layout: CustomKeyboardService.KeyboardLayout) {
        val announcement = when (layout) {
            CustomKeyboardService.KeyboardLayout.LETTERS -> "Letters keyboard"
            CustomKeyboardService.KeyboardLayout.NUMBERS -> "Numbers keyboard"
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS -> "Special characters keyboard"
        }
        Log.d(TAG, "Layout change announced: $announcement")
    }
}