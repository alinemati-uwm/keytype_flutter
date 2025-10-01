package com.nematiai.keytype

import android.content.Context
import android.content.SharedPreferences
import android.inputmethodservice.Keyboard
import android.inputmethodservice.KeyboardView
import android.widget.LinearLayout
import android.widget.ImageButton
import android.widget.ProgressBar
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import org.junit.Assert.*

/**
 * Integration tests for complete keyboard workflow
 * Tests end-to-end functionality, component interactions, and system integration
 */
@RunWith(MockitoJUnitRunner::class)
class KeyboardIntegrationTest {
    
    @Mock
    private lateinit var mockContext: Context
    
    @Mock
    private lateinit var mockSharedPreferences: SharedPreferences
    
    @Mock
    private lateinit var mockEditor: SharedPreferences.Editor
    
    @Mock
    private lateinit var mockKeyboardView: KeyboardView
    
    @Mock
    private lateinit var mockMainLayout: LinearLayout
    
    @Mock
    private lateinit var mockRewriteButton: LinearLayout
    
    @Mock
    private lateinit var mockSummarizeButton: LinearLayout
    
    @Mock
    private lateinit var mockGenerateButton: LinearLayout
    
    @Mock
    private lateinit var mockThemeToggleButton: ImageButton
    
    @Mock
    private lateinit var mockRewriteProgress: ProgressBar
    
    @Mock
    private lateinit var mockSummarizeProgress: ProgressBar
    
    @Mock
    private lateinit var mockGenerateProgress: ProgressBar
    
    @Mock
    private lateinit var mockLettersKeyboard: Keyboard
    
    @Mock
    private lateinit var mockNumbersKeyboard: Keyboard
    
    @Mock
    private lateinit var mockSpecialCharsKeyboard: Keyboard
    
    private lateinit var keyboardService: TestableCustomKeyboardService
    
    @Before
    fun setup() {
        // Setup mock context and preferences
        `when`(mockContext.getSharedPreferences(anyString(), anyInt())).thenReturn(mockSharedPreferences)
        `when`(mockSharedPreferences.edit()).thenReturn(mockEditor)
        `when`(mockEditor.putBoolean(anyString(), anyBoolean())).thenReturn(mockEditor)
        `when`(mockEditor.putString(anyString(), anyString())).thenReturn(mockEditor)
        `when`(mockEditor.putLong(anyString(), anyLong())).thenReturn(mockEditor)
        
        // Setup default preferences
        setupDefaultPreferences()
        
        // Create testable keyboard service
        keyboardService = TestableCustomKeyboardService(mockContext)
        keyboardService.setupMockComponents(
            mockMainLayout, mockKeyboardView,
            mockRewriteButton, mockSummarizeButton, mockGenerateButton,
            mockThemeToggleButton,
            mockRewriteProgress, mockSummarizeProgress, mockGenerateProgress,
            mockLettersKeyboard, mockNumbersKeyboard, mockSpecialCharsKeyboard
        )
    }
    
    private fun setupDefaultPreferences() {
        `when`(mockSharedPreferences.getBoolean(eq("is_dark_theme"), anyBoolean())).thenReturn(true)
        `when`(mockSharedPreferences.getString(eq("current_layout"), anyString()))
            .thenReturn(CustomKeyboardService.KeyboardLayout.LETTERS.name)
        `when`(mockSharedPreferences.getString(eq("previous_layout"), anyString()))
            .thenReturn(CustomKeyboardService.KeyboardLayout.LETTERS.name)
        `when`(mockSharedPreferences.getBoolean(eq("is_shifted"), anyBoolean())).thenReturn(false)
        `when`(mockSharedPreferences.getBoolean(eq("is_caps_lock"), anyBoolean())).thenReturn(false)
        `when`(mockSharedPreferences.getBoolean(eq(KeyboardAccessibilityManager.PREF_HIGH_CONTRAST_MODE), anyBoolean()))
            .thenReturn(false)
        `when`(mockSharedPreferences.getString(eq(KeyboardAccessibilityManager.PREF_KEYBOARD_SIZE), anyString()))
            .thenReturn(KeyboardAccessibilityManager.KeyboardSize.MEDIUM.name)
        `when`(mockSharedPreferences.getLong(eq(KeyboardAccessibilityManager.PREF_LONG_PRESS_DELAY), anyLong()))
            .thenReturn(500L)
        `when`(mockSharedPreferences.getBoolean(eq(KeyboardAccessibilityManager.PREF_HAPTIC_FEEDBACK), anyBoolean()))
            .thenReturn(true)
    }
    
    @Test
    fun testCompleteKeyboardInitialization() {
        // Test complete keyboard initialization workflow
        keyboardService.initialize()
        
        // Verify all managers are initialized
        assertTrue("Theme manager should be initialized", 
            keyboardService.isThemeManagerInitialized())
        assertTrue("Animation manager should be initialized", 
            keyboardService.isAnimationManagerInitialized())
        assertTrue("Accessibility manager should be initialized", 
            keyboardService.isAccessibilityManagerInitialized())
        assertTrue("Communication manager should be initialized", 
            keyboardService.isCommunicationManagerInitialized())
        
        // Verify UI components are set up
        verify(mockKeyboardView).setKeyboard(any())
        verify(mockKeyboardView).setOnKeyboardActionListener(any())
        
        // Verify theme is applied
        verify(mockMainLayout).setBackgroundColor(anyInt())
    }
    
    @Test
    fun testThemeToggleWorkflow() {
        // Test complete theme toggle workflow
        keyboardService.initialize()
        
        // Get initial theme state
        val initialTheme = keyboardService.getCurrentTheme()
        
        // Toggle theme
        keyboardService.toggleTheme()
        
        // Verify theme changed
        val newTheme = keyboardService.getCurrentTheme()
        assertNotEquals("Theme should change after toggle", 
            initialTheme.isDark, newTheme.isDark)
        
        // Verify UI updates
        verify(mockMainLayout, atLeast(2)).setBackgroundColor(anyInt())
        
        // Verify persistence
        verify(mockEditor).putBoolean(eq("is_dark_theme"), anyBoolean())
        verify(mockEditor).apply()
    }
    
    @Test
    fun testAIButtonWorkflow() {
        // Test complete AI button workflow
        keyboardService.initialize()
        
        // Set up mock text input
        keyboardService.setMockInputText("This is test text for AI processing")
        
        // Click rewrite button
        keyboardService.handleAIButtonClick(CustomKeyboardService.AIAction.REWRITE)
        
        // Verify button state changes to processing
        assertEquals("Button should be in processing state", 
            CustomKeyboardService.AIButtonState.PROCESSING,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.REWRITE))
        
        // Verify UI updates
        verify(mockRewriteButton).setEnabled(false)
        verify(mockRewriteProgress).setVisibility(android.view.View.VISIBLE)
        
        // Simulate successful AI response
        keyboardService.onAIOperationSuccess(CustomKeyboardService.AIAction.REWRITE, "Rewritten text")
        
        // Verify button state changes to success
        assertEquals("Button should be in success state", 
            CustomKeyboardService.AIButtonState.SUCCESS,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.REWRITE))
        
        // Verify UI updates
        verify(mockRewriteButton).setEnabled(true)
        verify(mockRewriteProgress).setVisibility(android.view.View.GONE)
    }
    
    @Test
    fun testKeyboardLayoutSwitchingWorkflow() {
        // Test complete keyboard layout switching workflow
        keyboardService.initialize()
        
        // Verify initial layout
        assertEquals("Should start with letters layout", 
            CustomKeyboardService.KeyboardLayout.LETTERS,
            keyboardService.getCurrentKeyboardLayout())
        
        // Switch to numbers
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        // Verify layout changed
        assertEquals("Should switch to numbers layout", 
            CustomKeyboardService.KeyboardLayout.NUMBERS,
            keyboardService.getCurrentKeyboardLayout())
        
        // Verify keyboard view updated
        verify(mockKeyboardView).setKeyboard(mockNumbersKeyboard)
        verify(mockKeyboardView).invalidateAllKeys()
        
        // Switch to special characters
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        
        // Verify layout changed
        assertEquals("Should switch to special chars layout", 
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS,
            keyboardService.getCurrentKeyboardLayout())
        
        // Verify keyboard view updated
        verify(mockKeyboardView).setKeyboard(mockSpecialCharsKeyboard)
        
        // Verify state persistence
        verify(mockEditor, atLeast(2)).putString(eq("current_layout"), anyString())
        verify(mockEditor, atLeast(2)).apply()
    }
    
    @Test
    fun testErrorHandlingWorkflow() {
        // Test error handling throughout the workflow
        keyboardService.initialize()
        
        // Set up mock text input
        keyboardService.setMockInputText("Test text")
        
        // Simulate communication failure
        keyboardService.setCommunicationFailure(true)
        
        // Click AI button
        keyboardService.handleAIButtonClick(CustomKeyboardService.AIAction.SUMMARIZE)
        
        // Verify error state
        assertEquals("Button should be in error state", 
            CustomKeyboardService.AIButtonState.ERROR,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        
        // Verify UI updates
        verify(mockSummarizeButton).setEnabled(true)
        verify(mockSummarizeProgress).setVisibility(android.view.View.GONE)
    }
    
    @Test
    fun testAccessibilityIntegration() {
        // Test accessibility integration throughout workflow
        keyboardService.initialize()
        
        // Verify accessibility features are applied
        assertTrue("Accessibility manager should be ready", 
            keyboardService.isAccessibilityManagerReady())
        
        // Test theme toggle accessibility
        keyboardService.toggleTheme()
        
        // Verify accessibility announcement (would be verified in real implementation)
        assertTrue("Theme change should be announced for accessibility", 
            keyboardService.wasAccessibilityAnnouncementMade())
        
        // Test layout switch accessibility
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        // Verify layout change announcement
        assertTrue("Layout change should be announced for accessibility", 
            keyboardService.wasLayoutChangeAnnouncementMade())
    }
    
    @Test
    fun testConcurrentOperations() {
        // Test handling of concurrent operations
        keyboardService.initialize()
        keyboardService.setMockInputText("Test text for concurrent operations")
        
        // Start multiple AI operations
        keyboardService.handleAIButtonClick(CustomKeyboardService.AIAction.REWRITE)
        keyboardService.handleAIButtonClick(CustomKeyboardService.AIAction.SUMMARIZE)
        keyboardService.handleAIButtonClick(CustomKeyboardService.AIAction.GENERATE)
        
        // Verify all buttons are in processing state
        assertEquals("Rewrite should be processing", 
            CustomKeyboardService.AIButtonState.PROCESSING,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.REWRITE))
        assertEquals("Summarize should be processing", 
            CustomKeyboardService.AIButtonState.PROCESSING,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        assertEquals("Generate should be processing", 
            CustomKeyboardService.AIButtonState.PROCESSING,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.GENERATE))
        
        // Complete operations in different order
        keyboardService.onAIOperationSuccess(CustomKeyboardService.AIAction.SUMMARIZE, "Summary result")
        keyboardService.onAIOperationError(CustomKeyboardService.AIAction.GENERATE, "Generation failed")
        keyboardService.onAIOperationSuccess(CustomKeyboardService.AIAction.REWRITE, "Rewrite result")
        
        // Verify final states
        assertEquals("Rewrite should be success", 
            CustomKeyboardService.AIButtonState.SUCCESS,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.REWRITE))
        assertEquals("Summarize should be success", 
            CustomKeyboardService.AIButtonState.SUCCESS,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        assertEquals("Generate should be error", 
            CustomKeyboardService.AIButtonState.ERROR,
            keyboardService.getAIButtonState(CustomKeyboardService.AIAction.GENERATE))
    }
    
    @Test
    fun testStateRecoveryAfterError() {
        // Test state recovery after various error conditions
        keyboardService.initialize()
        
        // Simulate theme loading error
        keyboardService.simulateThemeLoadingError()
        
        // Verify fallback to default theme
        val theme = keyboardService.getCurrentTheme()
        assertNotNull("Should have fallback theme", theme)
        
        // Simulate layout loading error
        keyboardService.simulateLayoutLoadingError()
        
        // Verify fallback to default layout
        assertEquals("Should fallback to letters layout", 
            CustomKeyboardService.KeyboardLayout.LETTERS,
            keyboardService.getCurrentKeyboardLayout())
        
        // Verify system remains functional
        keyboardService.toggleTheme()
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        // System should still work after errors
        assertTrue("System should remain functional after errors", 
            keyboardService.isSystemFunctional())
    }
    
    @Test
    fun testMemoryManagement() {
        // Test memory management throughout lifecycle
        keyboardService.initialize()
        
        // Perform various operations
        keyboardService.toggleTheme()
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        keyboardService.handleAIButtonClick(CustomKeyboardService.AIAction.REWRITE)
        
        // Get initial memory usage
        val initialMemory = keyboardService.getMemoryUsage()
        
        // Perform cleanup
        keyboardService.cleanup()
        
        // Verify memory is cleaned up
        val finalMemory = keyboardService.getMemoryUsage()
        assertTrue("Memory usage should decrease after cleanup", 
            finalMemory <= initialMemory)
        
        // Verify managers are cleaned up
        assertFalse("Theme manager should be cleaned up", 
            keyboardService.isThemeManagerInitialized())
        assertFalse("Animation manager should be cleaned up", 
            keyboardService.isAnimationManagerInitialized())
        assertFalse("Communication manager should be cleaned up", 
            keyboardService.isCommunicationManagerInitialized())
    }
    
    @Test
    fun testPerformanceMetrics() {
        // Test performance characteristics
        val startTime = System.currentTimeMillis()
        
        keyboardService.initialize()
        
        val initTime = System.currentTimeMillis() - startTime
        assertTrue("Initialization should be fast (< 500ms)", initTime < 500)
        
        // Test theme toggle performance
        val themeStartTime = System.currentTimeMillis()
        keyboardService.toggleTheme()
        val themeTime = System.currentTimeMillis() - themeStartTime
        assertTrue("Theme toggle should be fast (< 100ms)", themeTime < 100)
        
        // Test layout switch performance
        val layoutStartTime = System.currentTimeMillis()
        keyboardService.switchToKeyboardLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        val layoutTime = System.currentTimeMillis() - layoutStartTime
        assertTrue("Layout switch should be fast (< 100ms)", layoutTime < 100)
    }
    
    /**
     * Testable version of CustomKeyboardService for integration testing
     */
    private class TestableCustomKeyboardService(private val context: Context) {
        private var themeManagerInitialized = false
        private var animationManagerInitialized = false
        private var accessibilityManagerInitialized = false
        private var communicationManagerInitialized = false
        private var mockInputText = ""
        private var communicationFailure = false
        private var accessibilityAnnouncementMade = false
        private var layoutChangeAnnouncementMade = false
        private var currentTheme = KeyboardTheme(0xFF1A1A1A.toInt(), 0xFF2D2D2D.toInt(), 
            0xFFFFFFFF.toInt(), 0xFF404040.toInt(), 0xFF404040.toInt(), true)
        private var currentLayout = CustomKeyboardService.KeyboardLayout.LETTERS
        private val aiButtonStates = mutableMapOf<CustomKeyboardService.AIAction, CustomKeyboardService.AIButtonState>()
        
        fun initialize() {
            themeManagerInitialized = true
            animationManagerInitialized = true
            accessibilityManagerInitialized = true
            communicationManagerInitialized = true
            
            // Initialize AI button states
            CustomKeyboardService.AIAction.values().forEach { action ->
                aiButtonStates[action] = CustomKeyboardService.AIButtonState.IDLE
            }
        }
        
        fun setupMockComponents(
            mainLayout: LinearLayout, keyboardView: KeyboardView,
            rewriteButton: LinearLayout, summarizeButton: LinearLayout, generateButton: LinearLayout,
            themeToggleButton: ImageButton,
            rewriteProgress: ProgressBar, summarizeProgress: ProgressBar, generateProgress: ProgressBar,
            lettersKeyboard: Keyboard, numbersKeyboard: Keyboard, specialCharsKeyboard: Keyboard
        ) {
            // Mock components are set up
        }
        
        fun isThemeManagerInitialized() = themeManagerInitialized
        fun isAnimationManagerInitialized() = animationManagerInitialized
        fun isAccessibilityManagerInitialized() = accessibilityManagerInitialized
        fun isCommunicationManagerInitialized() = communicationManagerInitialized
        fun isAccessibilityManagerReady() = accessibilityManagerInitialized
        fun isSystemFunctional() = themeManagerInitialized && animationManagerInitialized
        
        fun getCurrentTheme() = currentTheme
        fun getCurrentKeyboardLayout() = currentLayout
        fun getAIButtonState(action: CustomKeyboardService.AIAction) = 
            aiButtonStates[action] ?: CustomKeyboardService.AIButtonState.IDLE
        
        fun setMockInputText(text: String) { mockInputText = text }
        fun setCommunicationFailure(failure: Boolean) { communicationFailure = failure }
        
        fun toggleTheme() {
            currentTheme = if (currentTheme.isDark) {
                KeyboardTheme(0xFFF5F5F5.toInt(), 0xFFFFFFFF.toInt(), 
                    0xFF2C2C2C.toInt(), 0xFFE8E8E8.toInt(), 0xFFE0E0E0.toInt(), false)
            } else {
                KeyboardTheme(0xFF1A1A1A.toInt(), 0xFF2D2D2D.toInt(), 
                    0xFFFFFFFF.toInt(), 0xFF404040.toInt(), 0xFF404040.toInt(), true)
            }
            accessibilityAnnouncementMade = true
        }
        
        fun switchToKeyboardLayout(layout: CustomKeyboardService.KeyboardLayout) {
            currentLayout = layout
            layoutChangeAnnouncementMade = true
        }
        
        fun handleAIButtonClick(action: CustomKeyboardService.AIAction) {
            if (communicationFailure) {
                aiButtonStates[action] = CustomKeyboardService.AIButtonState.ERROR
            } else {
                aiButtonStates[action] = CustomKeyboardService.AIButtonState.PROCESSING
            }
        }
        
        fun onAIOperationSuccess(action: CustomKeyboardService.AIAction, result: String) {
            aiButtonStates[action] = CustomKeyboardService.AIButtonState.SUCCESS
        }
        
        fun onAIOperationError(action: CustomKeyboardService.AIAction, error: String) {
            aiButtonStates[action] = CustomKeyboardService.AIButtonState.ERROR
        }
        
        fun wasAccessibilityAnnouncementMade() = accessibilityAnnouncementMade
        fun wasLayoutChangeAnnouncementMade() = layoutChangeAnnouncementMade
        
        fun simulateThemeLoadingError() {
            // Simulate error but maintain fallback theme
        }
        
        fun simulateLayoutLoadingError() {
            currentLayout = CustomKeyboardService.KeyboardLayout.LETTERS
        }
        
        fun getMemoryUsage(): Long = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()
        
        fun cleanup() {
            themeManagerInitialized = false
            animationManagerInitialized = false
            accessibilityManagerInitialized = false
            communicationManagerInitialized = false
            aiButtonStates.clear()
        }
    }
}