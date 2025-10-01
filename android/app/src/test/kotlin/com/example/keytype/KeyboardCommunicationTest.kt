package com.nematiai.keytype

import android.content.Context
import android.content.Intent
import android.content.BroadcastReceiver
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import org.junit.Assert.*
import org.mockito.ArgumentCaptor

/**
 * Unit tests for keyboard communication with Flutter app
 * Tests broadcast communication, message handling, and integration
 */
@RunWith(MockitoJUnitRunner::class)
class KeyboardCommunicationTest {
    
    @Mock
    private lateinit var mockContext: Context
    
    @Mock
    private lateinit var mockBroadcastReceiver: BroadcastReceiver
    
    private lateinit var communicationManager: KeyboardCommunicationManager
    
    @Before
    fun setup() {
        communicationManager = KeyboardCommunicationManager(mockContext)
    }
    
    @Test
    fun testInitialization() {
        // Test that communication manager initializes properly
        communicationManager.initialize()
        
        assertTrue("Communication manager should be ready after initialization", 
            communicationManager.isReady())
    }
    
    @Test
    fun testSendAIRequest() {
        // Test sending AI request broadcast
        val testText = "This is test text for AI processing"
        val action = CustomKeyboardService.AIAction.REWRITE
        
        val result = communicationManager.sendAIRequest(testText, action)
        
        assertTrue("AI request should be sent successfully", result)
        
        // Verify broadcast intent was sent
        val intentCaptor = ArgumentCaptor.forClass(Intent::class.java)
        verify(mockContext).sendBroadcast(intentCaptor.capture())
        
        val capturedIntent = intentCaptor.value
        assertEquals("Intent action should be correct", 
            "com.nematiai.keytype.AI_ACTION_REQUEST", capturedIntent.action)
        assertEquals("Intent should contain text", 
            testText, capturedIntent.getStringExtra("text"))
        assertEquals("Intent should contain action", 
            action.name, capturedIntent.getStringExtra("action"))
        assertEquals("Intent should target correct package", 
            "com.nematiai.keytype", capturedIntent.`package`)
    }
    
    @Test
    fun testSendAIRequestWithEmptyText() {
        // Test sending AI request with empty text
        val result = communicationManager.sendAIRequest("", CustomKeyboardService.AIAction.SUMMARIZE)
        
        assertFalse("AI request with empty text should fail", result)
        
        // Verify no broadcast was sent
        verify(mockContext, never()).sendBroadcast(any())
    }
    
    @Test
    fun testSendAIRequestWithNullText() {
        // Test sending AI request with null text
        val result = communicationManager.sendAIRequest(null, CustomKeyboardService.AIAction.GENERATE)
        
        assertFalse("AI request with null text should fail", result)
        
        // Verify no broadcast was sent
        verify(mockContext, never()).sendBroadcast(any())
    }
    
    @Test
    fun testSendDebugInfo() {
        // Test sending debug information
        val debugInfo = mapOf(
            "event" to "test_event",
            "timestamp" to System.currentTimeMillis(),
            "data" to "test_data"
        )
        
        communicationManager.sendDebugInfo(debugInfo)
        
        // Verify debug broadcast was sent
        val intentCaptor = ArgumentCaptor.forClass(Intent::class.java)
        verify(mockContext).sendBroadcast(intentCaptor.capture())
        
        val capturedIntent = intentCaptor.value
        assertEquals("Debug intent action should be correct", 
            "com.nematiai.keytype.DEBUG_INFO", capturedIntent.action)
        assertEquals("Debug intent should contain event", 
            "test_event", capturedIntent.getStringExtra("event"))
    }
    
    @Test
    fun testReceiveAIResponse() {
        // Test receiving AI response
        var responseReceived = false
        var receivedAction: CustomKeyboardService.AIAction? = null
        var receivedResult: String? = null
        
        communicationManager.setAIResponseCallback { action, result ->
            responseReceived = true
            receivedAction = action
            receivedResult = result
        }
        
        // Simulate receiving AI response
        val responseIntent = Intent("com.nematiai.keytype.AI_ACTION_RESPONSE")
        responseIntent.putExtra("action", CustomKeyboardService.AIAction.REWRITE.name)
        responseIntent.putExtra("result", "Rewritten text result")
        responseIntent.putExtra("success", true)
        
        communicationManager.handleAIResponse(responseIntent)
        
        assertTrue("AI response callback should be called", responseReceived)
        assertEquals("Received action should match", 
            CustomKeyboardService.AIAction.REWRITE, receivedAction)
        assertEquals("Received result should match", 
            "Rewritten text result", receivedResult)
    }
    
    @Test
    fun testReceiveAIError() {
        // Test receiving AI error response
        var errorReceived = false
        var receivedAction: CustomKeyboardService.AIAction? = null
        var receivedError: String? = null
        
        communicationManager.setAIErrorCallback { action, error ->
            errorReceived = true
            receivedAction = action
            receivedError = error
        }
        
        // Simulate receiving AI error
        val errorIntent = Intent("com.nematiai.keytype.AI_ACTION_RESPONSE")
        errorIntent.putExtra("action", CustomKeyboardService.AIAction.SUMMARIZE.name)
        errorIntent.putExtra("error", "AI service unavailable")
        errorIntent.putExtra("success", false)
        
        communicationManager.handleAIResponse(errorIntent)
        
        assertTrue("AI error callback should be called", errorReceived)
        assertEquals("Received action should match", 
            CustomKeyboardService.AIAction.SUMMARIZE, receivedAction)
        assertEquals("Received error should match", 
            "AI service unavailable", receivedError)
    }
    
    @Test
    fun testBroadcastReceiverRegistration() {
        // Test that broadcast receiver is properly registered
        communicationManager.initialize()
        
        // Verify receiver registration
        verify(mockContext).registerReceiver(any(), any())
    }
    
    @Test
    fun testBroadcastReceiverUnregistration() {
        // Test that broadcast receiver is properly unregistered
        communicationManager.initialize()
        communicationManager.cleanup()
        
        // Verify receiver unregistration
        verify(mockContext).unregisterReceiver(any())
    }
    
    @Test
    fun testMultipleAIRequests() {
        // Test sending multiple AI requests
        val requests = listOf(
            Pair("Text 1", CustomKeyboardService.AIAction.REWRITE),
            Pair("Text 2", CustomKeyboardService.AIAction.SUMMARIZE),
            Pair("Text 3", CustomKeyboardService.AIAction.GENERATE)
        )
        
        for ((text, action) in requests) {
            val result = communicationManager.sendAIRequest(text, action)
            assertTrue("Each AI request should be sent successfully", result)
        }
        
        // Verify all broadcasts were sent
        verify(mockContext, times(3)).sendBroadcast(any())
    }
    
    @Test
    fun testRequestIdGeneration() {
        // Test that unique request IDs are generated
        val requestId1 = communicationManager.generateRequestId()
        val requestId2 = communicationManager.generateRequestId()
        
        assertNotEquals("Request IDs should be unique", requestId1, requestId2)
        assertTrue("Request IDs should be positive", requestId1 > 0)
        assertTrue("Request IDs should be positive", requestId2 > 0)
    }
    
    @Test
    fun testRequestTracking() {
        // Test that requests are properly tracked
        val text = "Test text"
        val action = CustomKeyboardService.AIAction.REWRITE
        
        communicationManager.sendAIRequest(text, action)
        
        assertTrue("Request should be tracked as pending", 
            communicationManager.hasPendingRequest(action))
        
        // Simulate response
        val responseIntent = Intent("com.nematiai.keytype.AI_ACTION_RESPONSE")
        responseIntent.putExtra("action", action.name)
        responseIntent.putExtra("result", "Result")
        responseIntent.putExtra("success", true)
        
        communicationManager.handleAIResponse(responseIntent)
        
        assertFalse("Request should no longer be pending after response", 
            communicationManager.hasPendingRequest(action))
    }
    
    @Test
    fun testRequestTimeout() {
        // Test request timeout handling
        val text = "Test text"
        val action = CustomKeyboardService.AIAction.GENERATE
        
        var timeoutCalled = false
        communicationManager.setTimeoutCallback { timeoutAction ->
            timeoutCalled = true
            assertEquals("Timeout action should match", action, timeoutAction)
        }
        
        communicationManager.sendAIRequest(text, action)
        
        // Simulate timeout
        communicationManager.handleRequestTimeout(action)
        
        assertTrue("Timeout callback should be called", timeoutCalled)
        assertFalse("Request should no longer be pending after timeout", 
            communicationManager.hasPendingRequest(action))
    }
    
    @Test
    fun testCommunicationStatus() {
        // Test communication status tracking
        assertFalse("Should not be ready before initialization", 
            communicationManager.isReady())
        
        communicationManager.initialize()
        
        assertTrue("Should be ready after initialization", 
            communicationManager.isReady())
        
        communicationManager.cleanup()
        
        assertFalse("Should not be ready after cleanup", 
            communicationManager.isReady())
    }
    
    @Test
    fun testErrorHandling() {
        // Test error handling for broadcast failures
        `when`(mockContext.sendBroadcast(any())).thenThrow(SecurityException("Permission denied"))
        
        val result = communicationManager.sendAIRequest("Test", CustomKeyboardService.AIAction.REWRITE)
        
        assertFalse("Should handle broadcast errors gracefully", result)
    }
    
    @Test
    fun testMessageSerialization() {
        // Test that complex data is properly serialized
        val debugInfo = mapOf(
            "nested_object" to mapOf(
                "key1" to "value1",
                "key2" to 123,
                "key3" to true
            ),
            "array" to listOf("item1", "item2", "item3"),
            "timestamp" to System.currentTimeMillis()
        )
        
        communicationManager.sendDebugInfo(debugInfo)
        
        // Verify broadcast was sent (serialization didn't fail)
        verify(mockContext).sendBroadcast(any())
    }
    
    @Test
    fun testConcurrentRequests() {
        // Test handling concurrent AI requests
        val actions = listOf(
            CustomKeyboardService.AIAction.REWRITE,
            CustomKeyboardService.AIAction.SUMMARIZE,
            CustomKeyboardService.AIAction.GENERATE
        )
        
        // Send concurrent requests
        for (action in actions) {
            val result = communicationManager.sendAIRequest("Text for $action", action)
            assertTrue("Concurrent request should be sent successfully", result)
        }
        
        // Verify all requests are tracked
        for (action in actions) {
            assertTrue("Each action should have pending request", 
                communicationManager.hasPendingRequest(action))
        }
        
        // Handle responses
        for (action in actions) {
            val responseIntent = Intent("com.nematiai.keytype.AI_ACTION_RESPONSE")
            responseIntent.putExtra("action", action.name)
            responseIntent.putExtra("result", "Result for $action")
            responseIntent.putExtra("success", true)
            
            communicationManager.handleAIResponse(responseIntent)
        }
        
        // Verify all requests are completed
        for (action in actions) {
            assertFalse("Each action should no longer have pending request", 
                communicationManager.hasPendingRequest(action))
        }
    }
}