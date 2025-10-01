package com.nematiai.keytype

import android.content.Context
import android.content.SharedPreferences
import android.animation.ValueAnimator
import android.animation.ArgbEvaluator
import android.animation.ObjectAnimator
import android.animation.AnimatorSet
import android.view.View
import android.widget.LinearLayout
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.TextView
import android.util.Log
import androidx.core.content.ContextCompat

/**
 * Manages keyboard theme switching with smooth animations
 */
class KeyboardThemeManager(private val context: Context) {
    
    companion object {
        const val TAG = "KeyboardThemeManager"
        const val PREFS_NAME = "keyboard_theme_prefs"
        const val KEY_IS_DARK_THEME = "is_dark_theme"
        const val THEME_ANIMATION_DURATION = 300L
        const val THEME_TOGGLE_ROTATION = 180f
    }
    
    private val sharedPreferences: SharedPreferences = 
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    
    private var currentTheme: KeyboardTheme = loadThemeFromPreferences()
    
    /**
     * Data class representing a keyboard theme
     */
    data class KeyboardTheme(
        val backgroundColor: Int,
        val keyBackgroundColor: Int,
        val keyTextColor: Int,
        val actionKeyBackgroundColor: Int,
        val borderColor: Int,
        val aiButtonTextColor: Int,
        val themeToggleIconColor: Int,
        val keyShadowColor: Int,
        val isDark: Boolean
    )
    
    /**
     * Get current theme
     */
    fun getCurrentTheme(): KeyboardTheme = currentTheme
    
    /**
     * Check if current theme is dark
     */
    fun isDarkTheme(): Boolean = currentTheme.isDark
    
    /**
     * Toggle between light and dark themes
     */
    fun toggleTheme(): KeyboardTheme {
        currentTheme = if (currentTheme.isDark) getLightTheme() else getDarkTheme()
        saveThemeToPreferences()
        Log.d(TAG, "Theme toggled to ${if (currentTheme.isDark) "dark" else "light"}")
        return currentTheme
    }
    
    /**
     * Apply theme to keyboard layout with optional animation
     */
    fun applyThemeToLayout(
        mainLayout: LinearLayout,
        themeToggleButton: ImageButton,
        rewriteButton: LinearLayout,
        summarizeButton: LinearLayout,
        generateButton: LinearLayout,
        animate: Boolean = false
    ) {
        if (animate) {
            animateThemeTransition(
                mainLayout,
                themeToggleButton,
                rewriteButton,
                summarizeButton,
                generateButton
            )
        } else {
            applyThemeDirectly(
                mainLayout,
                themeToggleButton,
                rewriteButton,
                summarizeButton,
                generateButton
            )
        }
    }
    
    /**
     * Apply theme directly without animation
     */
    private fun applyThemeDirectly(
        mainLayout: LinearLayout,
        themeToggleButton: ImageButton,
        rewriteButton: LinearLayout,
        summarizeButton: LinearLayout,
        generateButton: LinearLayout
    ) {
        // Apply background color
        mainLayout.setBackgroundColor(currentTheme.backgroundColor)
        
        // Update theme toggle icon
        updateThemeToggleIcon(themeToggleButton)
        
        // Update AI button text colors
        updateAIButtonTextColors(rewriteButton)
        updateAIButtonTextColors(summarizeButton)
        updateAIButtonTextColors(generateButton)
        
        Log.d(TAG, "Theme applied directly")
    }
    
    /**
     * Animate theme transition with color interpolation
     */
    private fun animateThemeTransition(
        mainLayout: LinearLayout,
        themeToggleButton: ImageButton,
        rewriteButton: LinearLayout,
        summarizeButton: LinearLayout,
        generateButton: LinearLayout
    ) {
        val previousTheme = if (currentTheme.isDark) getLightTheme() else getDarkTheme()
        
        // Animate background color
        val backgroundColorAnimator = ValueAnimator.ofObject(
            ArgbEvaluator(),
            previousTheme.backgroundColor,
            currentTheme.backgroundColor
        )
        backgroundColorAnimator.duration = THEME_ANIMATION_DURATION
        backgroundColorAnimator.addUpdateListener { animator ->
            val color = animator.animatedValue as Int
            mainLayout.setBackgroundColor(color)
        }
        
        // Animate theme toggle button rotation
        val rotationAnimator = ObjectAnimator.ofFloat(
            themeToggleButton,
            "rotation",
            0f,
            THEME_TOGGLE_ROTATION
        )
        rotationAnimator.duration = THEME_ANIMATION_DURATION
        rotationAnimator.addUpdateListener {
            // Update icon at halfway point
            if (it.animatedFraction >= 0.5f && themeToggleButton.tag != "icon_updated") {
                updateThemeToggleIcon(themeToggleButton)
                themeToggleButton.tag = "icon_updated"
            }
        }
        
        // Reset rotation after animation
        rotationAnimator.addListener(object : android.animation.AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: android.animation.Animator) {
                themeToggleButton.rotation = 0f
                themeToggleButton.tag = null
            }
        })
        
        // Animate AI button text colors
        animateAIButtonTextColors(rewriteButton, previousTheme)
        animateAIButtonTextColors(summarizeButton, previousTheme)
        animateAIButtonTextColors(generateButton, previousTheme)
        
        // Start all animations together
        val animatorSet = AnimatorSet()
        animatorSet.playTogether(backgroundColorAnimator, rotationAnimator)
        animatorSet.start()
        
        Log.d(TAG, "Theme transition animation started")
    }
    
    /**
     * Animate AI button text color changes
     */
    private fun animateAIButtonTextColors(
        button: LinearLayout,
        previousTheme: KeyboardTheme
    ) {
        val textView = button.findViewById<TextView>(
            when (button.id) {
                R.id.rewrite_button -> R.id.rewrite_text
                R.id.summarize_button -> R.id.summarize_text
                R.id.generate_button -> R.id.generate_text
                else -> return
            }
        )
        
        val iconView = button.findViewById<ImageView>(
            when (button.id) {
                R.id.rewrite_button -> R.id.rewrite_icon
                R.id.summarize_button -> R.id.summarize_icon
                R.id.generate_button -> R.id.generate_icon
                else -> return
            }
        )
        
        // Animate text color
        val textColorAnimator = ValueAnimator.ofObject(
            ArgbEvaluator(),
            previousTheme.aiButtonTextColor,
            currentTheme.aiButtonTextColor
        )
        textColorAnimator.duration = THEME_ANIMATION_DURATION
        textColorAnimator.addUpdateListener { animator ->
            val color = animator.animatedValue as Int
            textView?.setTextColor(color)
            iconView?.setColorFilter(color)
        }
        textColorAnimator.start()
    }
    
    /**
     * Update theme toggle icon based on current theme
     */
    private fun updateThemeToggleIcon(themeToggleButton: ImageButton) {
        val iconRes = if (currentTheme.isDark) {
            R.drawable.ic_theme_sun // Show sun icon in dark mode (to switch to light)
        } else {
            R.drawable.ic_theme_moon // Show moon icon in light mode (to switch to dark)
        }
        
        themeToggleButton.setImageResource(iconRes)
        themeToggleButton.setColorFilter(currentTheme.themeToggleIconColor)
    }
    
    /**
     * Update AI button text colors
     */
    private fun updateAIButtonTextColors(button: LinearLayout) {
        val textView = button.findViewById<TextView>(
            when (button.id) {
                R.id.rewrite_button -> R.id.rewrite_text
                R.id.summarize_button -> R.id.summarize_text
                R.id.generate_button -> R.id.generate_text
                else -> return
            }
        )
        
        val iconView = button.findViewById<ImageView>(
            when (button.id) {
                R.id.rewrite_button -> R.id.rewrite_icon
                R.id.summarize_button -> R.id.summarize_icon
                R.id.generate_button -> R.id.generate_icon
                else -> return
            }
        )
        
        textView?.setTextColor(currentTheme.aiButtonTextColor)
        iconView?.setColorFilter(currentTheme.aiButtonTextColor)
    }
    
    /**
     * Get light theme configuration
     */
    private fun getLightTheme(): KeyboardTheme {
        return KeyboardTheme(
            backgroundColor = ContextCompat.getColor(context, R.color.keyboard_bg_light),
            keyBackgroundColor = ContextCompat.getColor(context, R.color.key_bg_light),
            keyTextColor = ContextCompat.getColor(context, R.color.key_text_light),
            actionKeyBackgroundColor = ContextCompat.getColor(context, R.color.action_key_bg_light),
            borderColor = ContextCompat.getColor(context, R.color.border_light),
            aiButtonTextColor = ContextCompat.getColor(context, R.color.ai_button_text_light),
            themeToggleIconColor = ContextCompat.getColor(context, R.color.theme_toggle_icon_light),
            keyShadowColor = ContextCompat.getColor(context, R.color.key_shadow_light),
            isDark = false
        )
    }
    
    /**
     * Get dark theme configuration
     */
    private fun getDarkTheme(): KeyboardTheme {
        return KeyboardTheme(
            backgroundColor = ContextCompat.getColor(context, R.color.keyboard_bg_dark),
            keyBackgroundColor = ContextCompat.getColor(context, R.color.key_bg_dark),
            keyTextColor = ContextCompat.getColor(context, R.color.key_text_dark),
            actionKeyBackgroundColor = ContextCompat.getColor(context, R.color.action_key_bg_dark),
            borderColor = ContextCompat.getColor(context, R.color.border_dark),
            aiButtonTextColor = ContextCompat.getColor(context, R.color.ai_button_text_dark),
            themeToggleIconColor = ContextCompat.getColor(context, R.color.theme_toggle_icon_dark),
            keyShadowColor = ContextCompat.getColor(context, R.color.key_shadow_dark),
            isDark = true
        )
    }
    
    /**
     * Save theme preference to SharedPreferences
     */
    private fun saveThemeToPreferences() {
        sharedPreferences.edit()
            .putBoolean(KEY_IS_DARK_THEME, currentTheme.isDark)
            .apply()
        Log.d(TAG, "Theme preference saved: ${if (currentTheme.isDark) "dark" else "light"}")
    }
    
    /**
     * Load theme preference from SharedPreferences
     */
    private fun loadThemeFromPreferences(): KeyboardTheme {
        val isDark = sharedPreferences.getBoolean(KEY_IS_DARK_THEME, true) // Default to dark
        val theme = if (isDark) getDarkTheme() else getLightTheme()
        Log.d(TAG, "Theme preference loaded: ${if (isDark) "dark" else "light"}")
        return theme
    }
}