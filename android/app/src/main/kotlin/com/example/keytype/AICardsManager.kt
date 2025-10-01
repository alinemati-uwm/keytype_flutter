package com.nematiai.keytype

import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.animation.ValueAnimator
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import android.view.animation.AccelerateDecelerateInterpolator
import android.view.animation.LinearInterpolator
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.TextView
import java.util.*

/**
 * Manages the AI cards interface with beautiful animations and shimmer effects
 */
class AICardsManager(private val context: Context) {
    
    companion object {
        const val TAG = "AICardsManager"
        const val SHIMMER_DURATION = 1200L
        const val CARD_ANIMATION_DURATION = 400L
        const val TEXT_REVEAL_DELAY = 3000L
        // Removed AUTO_HIDE_DELAY - no more auto-hide
    }
    
    private var aiCardsContainer: LinearLayout? = null
    private var keyboardView: View? = null
    private var closeButton: ImageButton? = null
    private var isShowing = false
    private var shimmerAnimators = mutableListOf<ValueAnimator>()
    private val handler = Handler(Looper.getMainLooper())
    private var currentAction: CustomKeyboardService.AIAction? = null
    private var currentInputText: String = ""
    private var cardOutputs = mutableListOf<String>() // Store the outputs for each card
    
    // Card views
    private val cardViews = mutableListOf<LinearLayout>()
    private val cardTitles = mutableListOf<TextView>()
    private val shimmerViews = mutableListOf<View>()
    
    // Sample AI responses for different actions
    private val sampleResponses = mapOf(
        CustomKeyboardService.AIAction.REWRITE to listOf(
            "Enhanced clarity achieved",
            "Professional tone applied", 
            "Grammar optimized",
            "Style improved",
            "Readability enhanced"
        ),
        CustomKeyboardService.AIAction.SUMMARIZE to listOf(
            "Key points extracted",
            "Main ideas condensed",
            "Essential info highlighted",
            "Brief overview ready",
            "Summary completed"
        ),
        CustomKeyboardService.AIAction.GENERATE to listOf(
            "Creative content generated",
            "Fresh ideas developed",
            "Original text created",
            "Unique perspective added",
            "Innovation delivered"
        )
    )
    
    private val loadingTexts = listOf(
        "Analyzing your text...",
        "Processing with AI...",
        "Applying language models...",
        "Optimizing output...",
        "Crafting response...",
        "Thinking deeply...",
        "Working on it...",
        "Almost ready..."
    )
    
    /**
     * Initialize the AI cards manager
     */
    fun initialize(mainLayout: LinearLayout) {
        try {
            // Find views directly in main layout (no more include)
            aiCardsContainer = mainLayout.findViewById(R.id.ai_cards_container)
            keyboardView = mainLayout.findViewById(R.id.keyboard_view)
            closeButton = mainLayout.findViewById(R.id.close_ai_cards)
            
            Log.d(TAG, "Found aiCardsContainer: ${aiCardsContainer != null}")
            Log.d(TAG, "Found keyboardView: ${keyboardView != null}")
            Log.d(TAG, "Found closeButton: ${closeButton != null}")
            
            // Initialize card views
            cardViews.clear()
            cardTitles.clear()
            shimmerViews.clear()
            
            val card1 = mainLayout.findViewById<LinearLayout>(R.id.ai_card_1)
            val card2 = mainLayout.findViewById<LinearLayout>(R.id.ai_card_2)
            val card3 = mainLayout.findViewById<LinearLayout>(R.id.ai_card_3)
            val card4 = mainLayout.findViewById<LinearLayout>(R.id.ai_card_4)
            val card5 = mainLayout.findViewById<LinearLayout>(R.id.ai_card_5)
            
            Log.d(TAG, "Found cards: ${card1 != null}, ${card2 != null}, ${card3 != null}, ${card4 != null}, ${card5 != null}")
            
            if (card1 != null) cardViews.add(card1)
            if (card2 != null) cardViews.add(card2)
            if (card3 != null) cardViews.add(card3)
            if (card4 != null) cardViews.add(card4)
            if (card5 != null) cardViews.add(card5)
            
            val title1 = mainLayout.findViewById<TextView>(R.id.card_1_title)
            val title2 = mainLayout.findViewById<TextView>(R.id.card_2_title)
            val title3 = mainLayout.findViewById<TextView>(R.id.card_3_title)
            val title4 = mainLayout.findViewById<TextView>(R.id.card_4_title)
            val title5 = mainLayout.findViewById<TextView>(R.id.card_5_title)
            
            Log.d(TAG, "Found titles: ${title1 != null}, ${title2 != null}, ${title3 != null}, ${title4 != null}, ${title5 != null}")
            
            if (title1 != null) cardTitles.add(title1)
            if (title2 != null) cardTitles.add(title2)
            if (title3 != null) cardTitles.add(title3)
            if (title4 != null) cardTitles.add(title4)
            if (title5 != null) cardTitles.add(title5)
            
            val shimmer1 = mainLayout.findViewById<View>(R.id.shimmer_1)
            val shimmer2 = mainLayout.findViewById<View>(R.id.shimmer_2)
            val shimmer3 = mainLayout.findViewById<View>(R.id.shimmer_3)
            val shimmer4 = mainLayout.findViewById<View>(R.id.shimmer_4)
            val shimmer5 = mainLayout.findViewById<View>(R.id.shimmer_5)
            
            Log.d(TAG, "Found shimmers: ${shimmer1 != null}, ${shimmer2 != null}, ${shimmer3 != null}, ${shimmer4 != null}, ${shimmer5 != null}")
            
            if (shimmer1 != null) shimmerViews.add(shimmer1)
            if (shimmer2 != null) shimmerViews.add(shimmer2)
            if (shimmer3 != null) shimmerViews.add(shimmer3)
            if (shimmer4 != null) shimmerViews.add(shimmer4)
            if (shimmer5 != null) shimmerViews.add(shimmer5)
            
            closeButton?.setOnClickListener {
                hideAICards()
            }
            
            // Setup card click listeners
            setupCardClickListeners()
            
            Log.d(TAG, "AI Cards Manager initialized successfully - Cards: ${cardViews.size}, Titles: ${cardTitles.size}, Shimmers: ${shimmerViews.size}")
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing AI Cards Manager", e)
        }
    }
    
    /**
     * Setup click listeners for all cards
     */
    private fun setupCardClickListeners() {
        cardViews.forEachIndexed { index, cardView ->
            cardView.setOnClickListener {
                handleCardClick(index)
            }
        }
    }
    
    /**
     * Handle card click - replace or continue input text based on AI action
     */
    private fun handleCardClick(cardIndex: Int) {
        if (cardIndex >= cardOutputs.size || cardOutputs[cardIndex].isEmpty()) {
            Log.w(TAG, "No output available for card $cardIndex")
            return
        }
        
        val selectedOutput = cardOutputs[cardIndex]
        val action = currentAction ?: return
        val inputText = currentInputText
        
        Log.d(TAG, "Card $cardIndex clicked with output: ${selectedOutput.take(50)}...")
        
        // Determine the replacement behavior based on AI action type
        val finalText = when (action) {
            CustomKeyboardService.AIAction.REWRITE,
            CustomKeyboardService.AIAction.SUMMARIZE,
            CustomKeyboardService.AIAction.FIX_GRAMMAR,
            CustomKeyboardService.AIAction.MAKE_FORMAL,
            CustomKeyboardService.AIAction.MAKE_INFORMAL,
            CustomKeyboardService.AIAction.TRANSLATE -> {
                // Replace actions: replace the original text completely
                selectedOutput
            }
            CustomKeyboardService.AIAction.GENERATE -> {
                // Continue action: append to the original text
                "$inputText $selectedOutput"
            }
        }
        
        // Send the final text back to the input field
        replaceInputText(finalText)
        
        // Hide the AI cards after selection
        hideAICards()
    }
    
    /**
     * Replace input text with the selected output
     */
    private fun replaceInputText(newText: String) {
        try {
            if (context is CustomKeyboardService) {
                val inputConnection = context.currentInputConnection
                if (inputConnection != null) {
                    // Clear current text
                    val extractRequest = android.view.inputmethod.ExtractedTextRequest()
                    extractRequest.flags = 0
                    extractRequest.hintMaxChars = 10000
                    
                    val extractedText = inputConnection.getExtractedText(extractRequest, 0)
                    val currentLength = extractedText?.text?.length ?: 0
                    
                    // Delete all current text
                    if (currentLength > 0) {
                        inputConnection.deleteSurroundingText(currentLength, 0)
                    }
                    
                    // Insert new text
                    inputConnection.commitText(newText, 1)
                    inputConnection.finishComposingText()
                    
                    Log.d(TAG, "Text replaced successfully: ${newText.take(100)}...")
                } else {
                    Log.w(TAG, "No input connection available")
                }
            } else {
                Log.w(TAG, "Context is not CustomKeyboardService")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error replacing input text", e)
        }
    }
    
    /**
     * Show AI cards with beautiful entrance animation
     */
    fun showAICards(action: CustomKeyboardService.AIAction, inputText: String = "") {
        Log.d(TAG, "showAICards called for action: $action")
        Log.d(TAG, "isShowing: $isShowing, aiCardsContainer: ${aiCardsContainer != null}, keyboardView: ${keyboardView != null}")
        
        if (aiCardsContainer == null || keyboardView == null) {
            Log.e(TAG, "Cannot show AI cards - missing views")
            return
        }
        
        if (isShowing) {
            Log.d(TAG, "AI cards already showing")
            return
        }
        
        Log.d(TAG, "Showing AI cards for action: $action")
        isShowing = true
        
        // Store current action and input text for later use
        currentAction = action
        currentInputText = inputText
        cardOutputs.clear()
        
        // Hide keyboard and show AI cards
        keyboardView?.visibility = View.GONE
        aiCardsContainer?.visibility = View.VISIBLE
        
        Log.d(TAG, "Visibility changed - keyboard: GONE, cards: VISIBLE")
        
        // Setup random loading texts
        setupRandomTexts()
        
        // Start entrance animations
        animateCardsEntrance()
        startShimmerAnimations()
        
        // Schedule text reveal after 3 seconds (for demo purposes only)
        handler.postDelayed({
            revealFinalTexts(action)
        }, TEXT_REVEAL_DELAY)
        
        // No auto-hide - wait for user interaction or real results
        
        Log.d(TAG, "AI cards setup complete")
    }
    
    /**
     * Hide AI cards with exit animation
     */
    fun hideAICards() {
        if (!isShowing || aiCardsContainer == null || keyboardView == null) {
            return
        }
        
        Log.d(TAG, "Hiding AI cards")
        isShowing = false
        
        // Stop all animations
        stopShimmerAnimations()
        handler.removeCallbacksAndMessages(null)
        
        // Animate cards exit
        animateCardsExit {
            // Show keyboard and hide AI cards
            aiCardsContainer?.visibility = View.GONE
            keyboardView?.visibility = View.VISIBLE
        }
    }
    
    /**
     * Animate cards entrance with staggered effect
     */
    private fun animateCardsEntrance() {
        cardViews.forEachIndexed { index, cardView ->
            // Start from scaled down and transparent
            cardView.scaleX = 0.8f
            cardView.scaleY = 0.8f
            cardView.alpha = 0f
            cardView.translationY = 50f
            
            // Animate to normal size with stagger
            val delay = index * 100L
            
            cardView.animate()
                .scaleX(1f)
                .scaleY(1f)
                .alpha(1f)
                .translationY(0f)
                .setDuration(CARD_ANIMATION_DURATION)
                .setStartDelay(delay)
                .setInterpolator(AccelerateDecelerateInterpolator())
                .start()
        }
    }
    
    /**
     * Animate cards exit with staggered effect
     */
    private fun animateCardsExit(onComplete: () -> Unit) {
        var completedAnimations = 0
        val totalAnimations = cardViews.size
        
        cardViews.forEachIndexed { index, cardView ->
            val delay = index * 50L
            
            cardView.animate()
                .scaleX(0.8f)
                .scaleY(0.8f)
                .alpha(0f)
                .translationY(-30f)
                .setDuration(CARD_ANIMATION_DURATION)
                .setStartDelay(delay)
                .setInterpolator(AccelerateDecelerateInterpolator())
                .withEndAction {
                    completedAnimations++
                    if (completedAnimations == totalAnimations) {
                        onComplete()
                    }
                }
                .start()
        }
    }
    
    /**
     * Start enhanced shimmer animations
     */
    private fun startShimmerAnimations() {
        shimmerViews.forEachIndexed { index, shimmerView ->
            val animator = ValueAnimator.ofFloat(-1f, 2f)
            animator.duration = SHIMMER_DURATION
            animator.repeatCount = ValueAnimator.INFINITE
            animator.interpolator = LinearInterpolator()
            animator.startDelay = index * 200L // Stagger the shimmer start
            
            animator.addUpdateListener { animation ->
                val progress = animation.animatedValue as Float
                shimmerView.translationX = progress * (shimmerView.parent as View).width
                
                // Add pulsing alpha effect
                val alpha = 0.3f + 0.4f * Math.sin(progress * Math.PI * 2).toFloat()
                shimmerView.alpha = Math.max(0.1f, Math.min(1f, alpha))
            }
            
            animator.start()
            shimmerAnimators.add(animator)
        }
    }
    
    /**
     * Stop all shimmer animations
     */
    private fun stopShimmerAnimations() {
        shimmerAnimators.forEach { animator ->
            animator.cancel()
        }
        shimmerAnimators.clear()
        
        // Reset shimmer views
        shimmerViews.forEach { shimmerView ->
            shimmerView.translationX = 0f
            shimmerView.alpha = 0.6f
        }
    }
    
    /**
     * Setup random processing texts
     */
    private fun setupRandomTexts() {
        val shuffledTexts = loadingTexts.shuffled()
        
        cardTitles.forEachIndexed { index, titleView ->
            titleView.text = shuffledTexts.getOrNull(index) ?: "Processing..."
        }
    }
    
    /**
     * Reveal final texts with animation
     */
    private fun revealFinalTexts(action: CustomKeyboardService.AIAction) {
        val responses = sampleResponses[action] ?: return
        val shuffledResponses = responses.shuffled()
        
        // Store outputs for card clicks
        cardOutputs.clear()
        cardOutputs.addAll(shuffledResponses)
        
        // Stop shimmer animations first
        stopShimmerAnimations()
        
        // Hide shimmer views with fade out
        shimmerViews.forEach { shimmerView ->
            shimmerView.animate()
                .alpha(0f)
                .setDuration(300)
                .start()
        }
        
        // Reveal final texts with typewriter effect
        cardTitles.forEachIndexed { index, titleView ->
            val finalText = shuffledResponses.getOrNull(index) ?: "Task completed successfully"
            
            // Fade out current text
            titleView.animate()
                .alpha(0f)
                .setDuration(200)
                .setStartDelay(index * 100L)
                .withEndAction {
                    // Change text and fade in
                    titleView.text = finalText
                    titleView.animate()
                        .alpha(1f)
                        .setDuration(300)
                        .start()
                }
                .start()
        }
        
        // Do NOT auto-hide - wait for user to click cards or close button
    }
    
    /**
     * Show AI results in cards
     */
    fun showResultsInCards(results: List<String>) {
        if (!isShowing || results.size < 5) {
            Log.w(TAG, "Cannot show results - not showing or insufficient results (need 5, got ${results.size})")
            return
        }
        
        Log.d(TAG, "Showing AI results in cards: ${results.size} results")
        
        // Store outputs for card clicks
        cardOutputs.clear()
        cardOutputs.addAll(results)
        
        // Stop shimmer animations
        stopShimmerAnimations()
        
        // Hide shimmer views with fade out
        shimmerViews.forEach { shimmerView ->
            shimmerView.animate()
                .alpha(0f)
                .setDuration(300)
                .start()
        }
        
        // Update card texts with results
        cardTitles.forEachIndexed { index, titleView ->
            val resultText = results.getOrNull(index) ?: "Result ${index + 1}"
            
            // Fade out current text
            titleView.animate()
                .alpha(0f)
                .setDuration(200)
                .setStartDelay(index * 100L)
                .withEndAction {
                    // Change text and fade in
                    titleView.text = resultText
                    titleView.animate()
                        .alpha(1f)
                        .setDuration(300)
                        .start()
                }
                .start()
        }
        
        // Do NOT auto-hide - wait for user to click cards or close button
    }
    
    /**
     * Show error message in cards
     */
    fun showErrorInCards(errorMessage: String) {
        if (!isShowing) {
            Log.w(TAG, "Cannot show error - not showing")
            return
        }
        
        Log.d(TAG, "Showing AI error in cards: $errorMessage")
        
        // Stop shimmer animations
        stopShimmerAnimations()
        
        // Hide shimmer views with fade out
        shimmerViews.forEach { shimmerView ->
            shimmerView.animate()
                .alpha(0f)
                .setDuration(300)
                .start()
        }
        
        // Show error message in first card, others show generic error
        val errorMessages = listOf(
            errorMessage,
            "Processing failed",
            "Please try again",
            "Error occurred",
            "Operation failed"
        )
        
        // Update card texts with error messages
        cardTitles.forEachIndexed { index, titleView ->
            val message = errorMessages.getOrNull(index) ?: "Error"
            
            // Fade out current text
            titleView.animate()
                .alpha(0f)
                .setDuration(200)
                .setStartDelay(index * 100L)
                .withEndAction {
                    // Change text and fade in
                    titleView.text = message
                    titleView.animate()
                        .alpha(1f)
                        .setDuration(300)
                        .start()
                }
                .start()
        }
        
        // Do NOT auto-hide - let user manually close or retry
    }
    
    /**
     * Check if AI cards are currently showing
     */
    fun isShowingCards(): Boolean = isShowing
    
    /**
     * Cleanup resources
     */
    fun cleanup() {
        stopShimmerAnimations()
        handler.removeCallbacksAndMessages(null)
        isShowing = false
        Log.d(TAG, "AI Cards Manager cleaned up")
    }
}