package com.nematiai.keytype

import android.animation.*
import android.view.View
import android.view.HapticFeedbackConstants
import android.widget.LinearLayout
import android.widget.ImageView
import android.widget.ProgressBar
import android.util.Log
import android.os.Handler
import android.os.Looper

/**
 * Manages all keyboard animations including key press effects, AI button animations,
 * layout transitions, and haptic feedback
 */
class KeyboardAnimationManager {
    
    companion object {
        const val TAG = "KeyboardAnimationManager"
        
        // Animation durations
        const val KEY_PRESS_DURATION = 150L
        const val AI_BUTTON_PULSE_DURATION = 1000L
        const val AI_BUTTON_SUCCESS_DURATION = 400L
        const val AI_BUTTON_ERROR_DURATION = 500L
        const val LAYOUT_SWITCH_DURATION = 200L
        const val SHIMMER_DURATION = 1500L
        const val SPARKLE_ROTATION_DURATION = 2000L
        
        // Animation scales and values
        const val KEY_PRESS_SCALE_DOWN = 0.95f
        const val KEY_PRESS_SCALE_NORMAL = 1.0f
        const val AI_BUTTON_SUCCESS_SCALE = 1.1f
        const val AI_BUTTON_PULSE_ALPHA_MIN = 0.6f
        const val AI_BUTTON_PULSE_ALPHA_MAX = 0.8f
        const val SHAKE_AMPLITUDE = 10f
    }
    
    private val mainHandler = Handler(Looper.getMainLooper())
    private val activeAnimators = mutableMapOf<View, Animator>()
    
    /**
     * Animate key press with scale effect and haptic feedback
     * Scale: 1.0 → 0.95 → 1.0
     */
    fun animateKeyPress(view: View) {
        // Perform haptic feedback first
        performHapticFeedback(view)
        
        // Cancel any existing animation on this view
        cancelAnimation(view)
        
        // Create scale down animation
        val scaleDownX = ObjectAnimator.ofFloat(view, "scaleX", KEY_PRESS_SCALE_NORMAL, KEY_PRESS_SCALE_DOWN)
        val scaleDownY = ObjectAnimator.ofFloat(view, "scaleY", KEY_PRESS_SCALE_NORMAL, KEY_PRESS_SCALE_DOWN)
        
        // Create scale up animation
        val scaleUpX = ObjectAnimator.ofFloat(view, "scaleX", KEY_PRESS_SCALE_DOWN, KEY_PRESS_SCALE_NORMAL)
        val scaleUpY = ObjectAnimator.ofFloat(view, "scaleY", KEY_PRESS_SCALE_DOWN, KEY_PRESS_SCALE_NORMAL)
        
        // Create animator sets
        val scaleDown = AnimatorSet()
        scaleDown.playTogether(scaleDownX, scaleDownY)
        scaleDown.duration = KEY_PRESS_DURATION / 2
        
        val scaleUp = AnimatorSet()
        scaleUp.playTogether(scaleUpX, scaleUpY)
        scaleUp.duration = KEY_PRESS_DURATION / 2
        
        // Combine animations
        val finalAnimator = AnimatorSet()
        finalAnimator.playSequentially(scaleDown, scaleUp)
        
        // Add cleanup listener
        finalAnimator.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                activeAnimators.remove(view)
            }
        })
        
        // Store and start animation
        activeAnimators[view] = finalAnimator
        finalAnimator.start()
        
        Log.d(TAG, "Key press animation started for view: ${view.javaClass.simpleName}")
    }
    
    /**
     * Start AI button processing animation with pulse effect
     */
    fun startAIButtonProcessingAnimation(button: LinearLayout, progressBar: ProgressBar) {
        // Cancel any existing animation
        cancelAnimation(button)
        
        // Show progress bar with fade in
        progressBar.visibility = View.VISIBLE
        progressBar.alpha = 0f
        progressBar.animate()
            .alpha(1f)
            .setDuration(200)
            .start()
        
        // Create pulse animation
        val pulseAnimator = ObjectAnimator.ofFloat(
            button, 
            "alpha", 
            AI_BUTTON_PULSE_ALPHA_MAX, 
            AI_BUTTON_PULSE_ALPHA_MIN, 
            AI_BUTTON_PULSE_ALPHA_MAX
        )
        pulseAnimator.duration = AI_BUTTON_PULSE_DURATION
        pulseAnimator.repeatCount = ObjectAnimator.INFINITE
        pulseAnimator.interpolator = android.view.animation.AccelerateDecelerateInterpolator()
        
        // Store and start animation
        activeAnimators[button] = pulseAnimator
        pulseAnimator.start()
        
        // Start shimmer effect on the button
        startShimmerEffect(button)
        
        Log.d(TAG, "AI button processing animation started")
    }
    
    /**
     * Start shimmer effect for AI buttons during processing
     */
    private fun startShimmerEffect(button: LinearLayout) {
        val shimmerAnimator = ObjectAnimator.ofFloat(button, "translationX", -50f, 50f, -50f)
        shimmerAnimator.duration = SHIMMER_DURATION
        shimmerAnimator.repeatCount = ObjectAnimator.INFINITE
        shimmerAnimator.interpolator = android.view.animation.LinearInterpolator()
        
        // Store shimmer animator with a different key
        activeAnimators[button.findViewById<View>(android.R.id.content) ?: button] = shimmerAnimator
        shimmerAnimator.start()
    }
    
    /**
     * Start rotating sparkle animation for generate button
     */
    fun startRotatingSparkleAnimation(generateButton: LinearLayout) {
        val iconView = generateButton.findViewById<ImageView>(R.id.generate_icon)
        if (iconView != null) {
            cancelAnimation(iconView)
            
            val rotationAnimator = ObjectAnimator.ofFloat(iconView, "rotation", 0f, 360f)
            rotationAnimator.duration = SPARKLE_ROTATION_DURATION
            rotationAnimator.repeatCount = ObjectAnimator.INFINITE
            rotationAnimator.interpolator = android.view.animation.LinearInterpolator()
            
            activeAnimators[iconView] = rotationAnimator
            rotationAnimator.start()
            
            Log.d(TAG, "Rotating sparkle animation started")
        }
    }
    
    /**
     * Show AI button success animation
     */
    fun showAIButtonSuccessAnimation(button: LinearLayout, progressBar: ProgressBar) {
        // Cancel processing animations
        cancelAnimation(button)
        
        // Hide progress bar with fade out
        progressBar.animate()
            .alpha(0f)
            .setDuration(200)
            .withEndAction {
                progressBar.visibility = View.GONE
                progressBar.alpha = 1f
            }
            .start()
        
        // Reset button alpha
        button.alpha = 1.0f
        
        // Create success scale animation
        val scaleUpX = ObjectAnimator.ofFloat(button, "scaleX", KEY_PRESS_SCALE_NORMAL, AI_BUTTON_SUCCESS_SCALE)
        val scaleUpY = ObjectAnimator.ofFloat(button, "scaleY", KEY_PRESS_SCALE_NORMAL, AI_BUTTON_SUCCESS_SCALE)
        val scaleDownX = ObjectAnimator.ofFloat(button, "scaleX", AI_BUTTON_SUCCESS_SCALE, KEY_PRESS_SCALE_NORMAL)
        val scaleDownY = ObjectAnimator.ofFloat(button, "scaleY", AI_BUTTON_SUCCESS_SCALE, KEY_PRESS_SCALE_NORMAL)
        
        val scaleUp = AnimatorSet()
        scaleUp.playTogether(scaleUpX, scaleUpY)
        scaleUp.duration = AI_BUTTON_SUCCESS_DURATION / 2
        
        val scaleDown = AnimatorSet()
        scaleDown.playTogether(scaleDownX, scaleDownY)
        scaleDown.duration = AI_BUTTON_SUCCESS_DURATION / 2
        
        val successAnimator = AnimatorSet()
        successAnimator.playSequentially(scaleUp, scaleDown)
        
        // Add haptic feedback
        successAnimator.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationStart(animation: Animator) {
                performHapticFeedback(button)
            }
            override fun onAnimationEnd(animation: Animator) {
                activeAnimators.remove(button)
            }
        })
        
        activeAnimators[button] = successAnimator
        successAnimator.start()
        
        Log.d(TAG, "AI button success animation started")
    }
    
    /**
     * Show AI button error animation with shake effect
     */
    fun showAIButtonErrorAnimation(button: LinearLayout, progressBar: ProgressBar) {
        // Cancel processing animations
        cancelAnimation(button)
        
        // Hide progress bar with fade out
        progressBar.animate()
            .alpha(0f)
            .setDuration(200)
            .withEndAction {
                progressBar.visibility = View.GONE
                progressBar.alpha = 1f
            }
            .start()
        
        // Reset button alpha
        button.alpha = 1.0f
        
        // Create shake animation
        val shakeAnimator = ObjectAnimator.ofFloat(
            button, 
            "translationX", 
            0f, -SHAKE_AMPLITUDE, SHAKE_AMPLITUDE, -SHAKE_AMPLITUDE/2, SHAKE_AMPLITUDE/2, 0f
        )
        shakeAnimator.duration = AI_BUTTON_ERROR_DURATION
        shakeAnimator.interpolator = android.view.animation.AccelerateDecelerateInterpolator()
        
        // Add haptic feedback
        shakeAnimator.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationStart(animation: Animator) {
                performHapticFeedback(button, HapticFeedbackConstants.LONG_PRESS)
            }
            override fun onAnimationEnd(animation: Animator) {
                activeAnimators.remove(button)
            }
        })
        
        activeAnimators[button] = shakeAnimator
        shakeAnimator.start()
        
        Log.d(TAG, "AI button error animation started")
    }
    
    /**
     * Stop all animations for AI button and reset to idle state
     */
    fun stopAIButtonAnimations(button: LinearLayout, progressBar: ProgressBar) {
        // Cancel all animations for this button
        cancelAnimation(button)
        
        // Cancel shimmer animation
        val shimmerView = button.findViewById<View>(android.R.id.content) ?: button
        cancelAnimation(shimmerView)
        
        // Cancel icon rotation for generate button
        val iconView = button.findViewById<ImageView>(R.id.generate_icon)
        if (iconView != null) {
            cancelAnimation(iconView)
            iconView.rotation = 0f
        }
        
        // Hide progress bar immediately
        progressBar.visibility = View.GONE
        progressBar.alpha = 1f
        
        // Reset button state
        button.alpha = 1.0f
        button.scaleX = KEY_PRESS_SCALE_NORMAL
        button.scaleY = KEY_PRESS_SCALE_NORMAL
        button.translationX = 0f
        
        Log.d(TAG, "AI button animations stopped and reset to idle")
    }
    
    /**
     * Animate keyboard layout switching with slide transition
     */
    fun animateKeyboardLayoutSwitch(
        keyboardView: android.inputmethodservice.KeyboardView,
        targetKeyboard: android.inputmethodservice.Keyboard,
        onComplete: () -> Unit
    ) {
        // Slide out current keyboard to the left
        val slideOut = ObjectAnimator.ofFloat(keyboardView, "translationX", 0f, -keyboardView.width.toFloat())
        slideOut.duration = LAYOUT_SWITCH_DURATION
        slideOut.interpolator = android.view.animation.AccelerateInterpolator()
        
        slideOut.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                // Switch keyboard layout
                keyboardView.keyboard = targetKeyboard
                
                // Position keyboard off-screen to the right
                keyboardView.translationX = keyboardView.width.toFloat()
                
                // Slide in new keyboard from the right
                val slideIn = ObjectAnimator.ofFloat(keyboardView, "translationX", keyboardView.width.toFloat(), 0f)
                slideIn.duration = LAYOUT_SWITCH_DURATION
                slideIn.interpolator = android.view.animation.DecelerateInterpolator()
                
                slideIn.addListener(object : AnimatorListenerAdapter() {
                    override fun onAnimationEnd(animation: Animator) {
                        keyboardView.invalidateAllKeys()
                        onComplete()
                    }
                })
                
                slideIn.start()
            }
        })
        
        slideOut.start()
        
        Log.d(TAG, "Keyboard layout switch animation started")
    }
    
    /**
     * Perform haptic feedback with specified type
     */
    fun performHapticFeedback(
        view: View, 
        feedbackType: Int = HapticFeedbackConstants.KEYBOARD_TAP
    ) {
        try {
            view.performHapticFeedback(
                feedbackType,
                HapticFeedbackConstants.FLAG_IGNORE_GLOBAL_SETTING
            )
        } catch (e: Exception) {
            Log.w(TAG, "Could not perform haptic feedback", e)
        }
    }
    
    /**
     * Cancel animation for a specific view
     */
    private fun cancelAnimation(view: View) {
        activeAnimators[view]?.let { animator ->
            animator.cancel()
            activeAnimators.remove(view)
        }
    }
    
    /**
     * Cancel all active animations
     */
    fun cancelAllAnimations() {
        activeAnimators.values.forEach { it.cancel() }
        activeAnimators.clear()
        Log.d(TAG, "All animations cancelled")
    }
    
    /**
     * Clean up resources
     */
    fun cleanup() {
        cancelAllAnimations()
        mainHandler.removeCallbacksAndMessages(null)
        Log.d(TAG, "Animation manager cleaned up")
    }
}