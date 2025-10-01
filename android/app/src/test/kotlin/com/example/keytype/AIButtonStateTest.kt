package com.nematiai.keytype

import android.content.Context
import android.widget.LinearLayout
import android.widget.ProgressBar
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import org.junit.Assert.*

/**
 * Unit tests for AI button state management and interactions
 * Tests state transitions, validation, and error handling
 */
@RunWith(MockitoJUnitRunner::class)
class AIButtonStateTest {
    
    @Mock
    private lateinit var mockContext: Context
    
    @Mock
    private lateinit var mockRewriteButton: LinearLayout
    
    @Mock
    private lateinit var mockSummarizeButton: LinearLayout
    
    @Mock
    private lateinit var mockGenerateButton: LinearLayout
    
    @Mock
    private lateinit var mockRewriteProgress: ProgressBar
    
    @Mock
    private lateinit var mockSummarizeProgress: ProgressBar
    
    @Mock
    private lateinit var mockGenerateProgress: ProgressBar
    
    private lateinit var aiButtonManager: AIButtonManager
    
    @Before
    fun setup() {
        aiButtonManager = AIButtonManager(mockContext)
        aiButtonManager.initialize(
            mockRewriteButton, mockRewriteProgress,
            mockSummarizeButton, mockSummarizeProgress,
            mockGenerateButton, mockGenerateProgress
        )
    }
    
    @Test
    fun testInitialState() {
        // Test that all buttons start in IDLE state
        assertEquals("Rewrite button should start in IDLE state", 
            CustomKeyboardService.AIButtonState.IDLE, 
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.REWRITE))
        
        assertEquals("Summarize button should start in IDLE state", 
            CustomKeyboardService.AIButtonState.IDLE, 
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        
        assertEquals("Generate button should start in IDLE state", 
            CustomKeyboardService.AIButtonState.IDLE, 
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.GENERATE))
    }
    
    @Test
    fun testStateTransitionToProcessing() {
        // Test transition from IDLE to PROCESSING
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        assertEquals("Button state should be PROCESSING", 
            CustomKeyboardService.AIButtonState.PROCESSING,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.REWRITE))
        
        // Verify UI updates
        verify(mockRewriteButton).setEnabled(false)
        verify(mockRewriteProgress).setVisibility(android.view.View.VISIBLE)
    }
    
    @Test
    fun testStateTransitionToSuccess() {
        // Test transition from PROCESSING to SUCCESS
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.SUCCESS)
        
        assertEquals("Button state should be SUCCESS", 
            CustomKeyboardService.AIButtonState.SUCCESS,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        
        // Verify UI updates
        verify(mockSummarizeButton).setEnabled(true)
    }
    
    @Test
    fun testStateTransitionToError() {
        // Test transition from PROCESSING to ERROR
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.GENERATE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.GENERATE, 
            CustomKeyboardService.AIButtonState.ERROR)
        
        assertEquals("Button state should be ERROR", 
            CustomKeyboardService.AIButtonState.ERROR,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.GENERATE))
        
        // Verify UI updates
        verify(mockGenerateButton).setEnabled(true)
    }
    
    @Test
    fun testMultipleButtonStatesIndependent() {
        // Test that different buttons can have different states simultaneously
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.SUCCESS)
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.GENERATE, 
            CustomKeyboardService.AIButtonState.ERROR)
        
        assertEquals("Rewrite should be PROCESSING", 
            CustomKeyboardService.AIButtonState.PROCESSING,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.REWRITE))
        
        assertEquals("Summarize should be SUCCESS", 
            CustomKeyboardService.AIButtonState.SUCCESS,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        
        assertEquals("Generate should be ERROR", 
            CustomKeyboardService.AIButtonState.ERROR,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.GENERATE))
    }
    
    @Test
    fun testResetAllStates() {
        // Set all buttons to different states
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.ERROR)
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.GENERATE, 
            CustomKeyboardService.AIButtonState.SUCCESS)
        
        // Reset all states
        aiButtonManager.resetAllStates()
        
        // Verify all states are IDLE
        assertEquals("Rewrite should be IDLE after reset", 
            CustomKeyboardService.AIButtonState.IDLE,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.REWRITE))
        
        assertEquals("Summarize should be IDLE after reset", 
            CustomKeyboardService.AIButtonState.IDLE,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.SUMMARIZE))
        
        assertEquals("Generate should be IDLE after reset", 
            CustomKeyboardService.AIButtonState.IDLE,
            aiButtonManager.getButtonState(CustomKeyboardService.AIAction.GENERATE))
    }
    
    @Test
    fun testButtonClickValidation() {
        // Test that processing buttons cannot be clicked again
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        val canClick = aiButtonManager.canButtonBeClicked(CustomKeyboardService.AIAction.REWRITE)
        assertFalse("Processing button should not be clickable", canClick)
        
        // Test that idle buttons can be clicked
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.IDLE)
        
        val canClickIdle = aiButtonManager.canButtonBeClicked(CustomKeyboardService.AIAction.SUMMARIZE)
        assertTrue("Idle button should be clickable", canClickIdle)
    }
    
    @Test
    fun testStateChangeCallbacks() {
        var callbackCalled = false
        var callbackAction: CustomKeyboardService.AIAction? = null
        var callbackState: CustomKeyboardService.AIButtonState? = null
        
        aiButtonManager.setStateChangeCallback { action, state ->
            callbackCalled = true
            callbackAction = action
            callbackState = state
        }
        
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        assertTrue("State change callback should be called", callbackCalled)
        assertEquals("Callback should receive correct action", 
            CustomKeyboardService.AIAction.REWRITE, callbackAction)
        assertEquals("Callback should receive correct state", 
            CustomKeyboardService.AIButtonState.PROCESSING, callbackState)
    }
    
    @Test
    fun testProgressBarVisibility() {
        // Test progress bar visibility for PROCESSING state
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        verify(mockRewriteProgress).setVisibility(android.view.View.VISIBLE)
        
        // Test progress bar hidden for IDLE state
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.IDLE)
        
        verify(mockRewriteProgress).setVisibility(android.view.View.GONE)
    }
    
    @Test
    fun testButtonEnabledState() {
        // Test button disabled during processing
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        
        verify(mockSummarizeButton).setEnabled(false)
        
        // Test button enabled after processing
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.SUMMARIZE, 
            CustomKeyboardService.AIButtonState.SUCCESS)
        
        verify(mockSummarizeButton).setEnabled(true)
    }
    
    @Test
    fun testInvalidStateTransition() {
        // Test that invalid state transitions are handled gracefully
        try {
            aiButtonManager.setButtonState(CustomKeyboardService.AIAction.GENERATE, 
                CustomKeyboardService.AIButtonState.SUCCESS)
            
            // This should work fine - direct transition to SUCCESS is allowed
            assertEquals("Direct transition to SUCCESS should be allowed", 
                CustomKeyboardService.AIButtonState.SUCCESS,
                aiButtonManager.getButtonState(CustomKeyboardService.AIAction.GENERATE))
        } catch (e: Exception) {
            fail("Valid state transition should not throw exception: ${e.message}")
        }
    }
    
    @Test
    fun testStateHistory() {
        // Test that state history is maintained
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.PROCESSING)
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.SUCCESS)
        aiButtonManager.setButtonState(CustomKeyboardService.AIAction.REWRITE, 
            CustomKeyboardService.AIButtonState.IDLE)
        
        val history = aiButtonManager.getStateHistory(CustomKeyboardService.AIAction.REWRITE)
        
        assertTrue("State history should contain PROCESSING", 
            history.contains(CustomKeyboardService.AIButtonState.PROCESSING))
        assertTrue("State history should contain SUCCESS", 
            history.contains(CustomKeyboardService.AIButtonState.SUCCESS))
        assertTrue("State history should contain IDLE", 
            history.contains(CustomKeyboardService.AIButtonState.IDLE))
    }
}