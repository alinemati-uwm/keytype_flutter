package com.nematiai.keytype

import android.content.Context
import android.content.SharedPreferences
import android.inputmethodservice.Keyboard
import android.inputmethodservice.KeyboardView
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import org.junit.Assert.*

/**
 * Unit tests for keyboard layout switching and special character input
 * Tests layout transitions, state management, and character input validation
 */
@RunWith(MockitoJUnitRunner::class)
class KeyboardLayoutTest {
    
    @Mock
    private lateinit var mockContext: Context
    
    @Mock
    private lateinit var mockSharedPreferences: SharedPreferences
    
    @Mock
    private lateinit var mockEditor: SharedPreferences.Editor
    
    @Mock
    private lateinit var mockKeyboardView: KeyboardView
    
    @Mock
    private lateinit var mockLettersKeyboard: Keyboard
    
    @Mock
    private lateinit var mockNumbersKeyboard: Keyboard
    
    @Mock
    private lateinit var mockSpecialCharsKeyboard: Keyboard
    
    private lateinit var keyboardLayoutManager: KeyboardLayoutManager
    
    @Before
    fun setup() {
        // Setup mock context and preferences
        `when`(mockContext.getSharedPreferences(anyString(), anyInt())).thenReturn(mockSharedPreferences)
        `when`(mockSharedPreferences.edit()).thenReturn(mockEditor)
        `when`(mockEditor.putString(anyString(), anyString())).thenReturn(mockEditor)
        `when`(mockEditor.putBoolean(anyString(), anyBoolean())).thenReturn(mockEditor)
        
        // Setup default preferences
        `when`(mockSharedPreferences.getString(eq("current_layout"), anyString()))
            .thenReturn(CustomKeyboardService.KeyboardLayout.LETTERS.name)
        `when`(mockSharedPreferences.getString(eq("previous_layout"), anyString()))
            .thenReturn(CustomKeyboardService.KeyboardLayout.LETTERS.name)
        `when`(mockSharedPreferences.getBoolean(eq("is_shifted"), anyBoolean())).thenReturn(false)
        `when`(mockSharedPreferences.getBoolean(eq("is_caps_lock"), anyBoolean())).thenReturn(false)
        
        keyboardLayoutManager = KeyboardLayoutManager(mockContext)
        keyboardLayoutManager.initialize(
            mockKeyboardView,
            mockLettersKeyboard,
            mockNumbersKeyboard,
            mockSpecialCharsKeyboard
        )
    }
    
    @Test
    fun testInitialLayout() {
        // Test that keyboard starts with LETTERS layout
        assertEquals("Should start with LETTERS layout", 
            CustomKeyboardService.KeyboardLayout.LETTERS, 
            keyboardLayoutManager.getCurrentLayout())
    }
    
    @Test
    fun testLayoutSwitchToNumbers() {
        // Test switching from LETTERS to NUMBERS
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        assertEquals("Should switch to NUMBERS layout", 
            CustomKeyboardService.KeyboardLayout.NUMBERS, 
            keyboardLayoutManager.getCurrentLayout())
        
        // Verify keyboard view is updated
        verify(mockKeyboardView).setKeyboard(mockNumbersKeyboard)
        verify(mockKeyboardView).invalidateAllKeys()
    }
    
    @Test
    fun testLayoutSwitchToSpecialChars() {
        // Test switching from LETTERS to SPECIAL_CHARS
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        
        assertEquals("Should switch to SPECIAL_CHARS layout", 
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS, 
            keyboardLayoutManager.getCurrentLayout())
        
        // Verify keyboard view is updated
        verify(mockKeyboardView).setKeyboard(mockSpecialCharsKeyboard)
        verify(mockKeyboardView).invalidateAllKeys()
    }
    
    @Test
    fun testLayoutSwitchBackToLetters() {
        // Switch to numbers first
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        // Then switch back to letters
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.LETTERS)
        
        assertEquals("Should switch back to LETTERS layout", 
            CustomKeyboardService.KeyboardLayout.LETTERS, 
            keyboardLayoutManager.getCurrentLayout())
        
        // Verify keyboard view is updated
        verify(mockKeyboardView).setKeyboard(mockLettersKeyboard)
    }
    
    @Test
    fun testPreviousLayoutTracking() {
        // Start with LETTERS, switch to NUMBERS
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        assertEquals("Previous layout should be LETTERS", 
            CustomKeyboardService.KeyboardLayout.LETTERS, 
            keyboardLayoutManager.getPreviousLayout())
        
        // Switch to SPECIAL_CHARS
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        
        assertEquals("Previous layout should be NUMBERS", 
            CustomKeyboardService.KeyboardLayout.NUMBERS, 
            keyboardLayoutManager.getPreviousLayout())
    }
    
    @Test
    fun testSwitchToPreviousLayout() {
        // Switch to numbers
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        
        // Switch to special chars
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        
        // Switch back to previous (numbers)
        keyboardLayoutManager.switchToPreviousLayout()
        
        assertEquals("Should switch back to NUMBERS layout", 
            CustomKeyboardService.KeyboardLayout.NUMBERS, 
            keyboardLayoutManager.getCurrentLayout())
    }
    
    @Test
    fun testNextLayoutCycling() {
        // Test cycling through layouts: LETTERS -> NUMBERS -> SPECIAL_CHARS -> LETTERS
        
        // Start with LETTERS, switch to next
        keyboardLayoutManager.switchToNextLayout()
        assertEquals("Should switch to NUMBERS", 
            CustomKeyboardService.KeyboardLayout.NUMBERS, 
            keyboardLayoutManager.getCurrentLayout())
        
        // Switch to next again
        keyboardLayoutManager.switchToNextLayout()
        assertEquals("Should switch to SPECIAL_CHARS", 
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS, 
            keyboardLayoutManager.getCurrentLayout())
        
        // Switch to next again (should cycle back to LETTERS)
        keyboardLayoutManager.switchToNextLayout()
        assertEquals("Should cycle back to LETTERS", 
            CustomKeyboardService.KeyboardLayout.LETTERS, 
            keyboardLayoutManager.getCurrentLayout())
    }
    
    @Test
    fun testShiftStateHandling() {
        // Test that shift state is preserved for LETTERS layout
        keyboardLayoutManager.setShiftState(true)
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.LETTERS)
        
        assertTrue("Shift state should be preserved for LETTERS layout", 
            keyboardLayoutManager.isShiftPressed())
        
        // Test that shift state is cleared for non-letter layouts
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        assertFalse("Shift state should be cleared for NUMBERS layout", 
            keyboardLayoutManager.isShiftPressed())
    }
    
    @Test
    fun testCapsLockHandling() {
        // Test caps lock state
        keyboardLayoutManager.setCapsLockState(true)
        assertTrue("Caps lock should be enabled", keyboardLayoutManager.isCapsLockOn())
        
        // Test that caps lock is preserved across letter layout switches
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.LETTERS)
        
        assertTrue("Caps lock should be preserved for LETTERS layout", 
            keyboardLayoutManager.isCapsLockOn())
    }
    
    @Test
    fun testLayoutPersistence() {
        // Switch to a different layout
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        
        // Verify that the layout is persisted
        verify(mockEditor).putString("current_layout", 
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS.name)
        verify(mockEditor).apply()
    }
    
    @Test
    fun testLayoutRestoration() {
        // Setup preferences to return NUMBERS layout
        `when`(mockSharedPreferences.getString(eq("current_layout"), anyString()))
            .thenReturn(CustomKeyboardService.KeyboardLayout.NUMBERS.name)
        `when`(mockSharedPreferences.getString(eq("previous_layout"), anyString()))
            .thenReturn(CustomKeyboardService.KeyboardLayout.LETTERS.name)
        
        // Create new layout manager instance
        val newLayoutManager = KeyboardLayoutManager(mockContext)
        newLayoutManager.initialize(
            mockKeyboardView,
            mockLettersKeyboard,
            mockNumbersKeyboard,
            mockSpecialCharsKeyboard
        )
        
        assertEquals("Should restore NUMBERS layout from preferences", 
            CustomKeyboardService.KeyboardLayout.NUMBERS, 
            newLayoutManager.getCurrentLayout())
        
        assertEquals("Should restore LETTERS as previous layout", 
            CustomKeyboardService.KeyboardLayout.LETTERS, 
            newLayoutManager.getPreviousLayout())
    }
    
    @Test
    fun testInvalidLayoutHandling() {
        // Setup preferences to return invalid layout
        `when`(mockSharedPreferences.getString(eq("current_layout"), anyString()))
            .thenReturn("INVALID_LAYOUT")
        
        // Create new layout manager instance
        val newLayoutManager = KeyboardLayoutManager(mockContext)
        newLayoutManager.initialize(
            mockKeyboardView,
            mockLettersKeyboard,
            mockNumbersKeyboard,
            mockSpecialCharsKeyboard
        )
        
        // Should fallback to default LETTERS layout
        assertEquals("Should fallback to LETTERS layout for invalid preference", 
            CustomKeyboardService.KeyboardLayout.LETTERS, 
            newLayoutManager.getCurrentLayout())
    }
    
    @Test
    fun testSpecialCharacterInput() {
        // Switch to special characters layout
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        
        // Test special character key codes
        val specialChars = mapOf(
            33 to "!",
            64 to "@",
            35 to "#",
            36 to "$",
            37 to "%",
            94 to "^",
            38 to "&",
            42 to "*",
            40 to "(",
            41 to ")"
        )
        
        for ((keyCode, expectedChar) in specialChars) {
            val result = keyboardLayoutManager.getCharacterForKeyCode(keyCode)
            assertEquals("Key code $keyCode should produce character '$expectedChar'", 
                expectedChar, result)
        }
    }
    
    @Test
    fun testLayoutStateConsistency() {
        // Test that layout state remains consistent across multiple operations
        val initialState = keyboardLayoutManager.getKeyboardState()
        
        // Perform multiple layout switches
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS)
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS)
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.LETTERS)
        
        val finalState = keyboardLayoutManager.getKeyboardState()
        
        assertEquals("Current layout should match", 
            CustomKeyboardService.KeyboardLayout.LETTERS, finalState.currentLayout)
        assertEquals("Previous layout should be updated", 
            CustomKeyboardService.KeyboardLayout.SPECIAL_CHARS, finalState.previousLayout)
    }
    
    @Test
    fun testLayoutSwitchAnimation() {
        // Test that layout switch triggers animation
        var animationTriggered = false
        
        keyboardLayoutManager.setLayoutSwitchAnimationCallback { 
            animationTriggered = true 
        }
        
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS, true)
        
        assertTrue("Layout switch animation should be triggered", animationTriggered)
    }
    
    @Test
    fun testLayoutSwitchWithoutAnimation() {
        // Test that layout switch can be done without animation
        var animationTriggered = false
        
        keyboardLayoutManager.setLayoutSwitchAnimationCallback { 
            animationTriggered = true 
        }
        
        keyboardLayoutManager.switchToLayout(CustomKeyboardService.KeyboardLayout.NUMBERS, false)
        
        assertFalse("Layout switch animation should not be triggered", animationTriggered)
        
        // But layout should still be switched
        assertEquals("Layout should still be switched", 
            CustomKeyboardService.KeyboardLayout.NUMBERS, 
            keyboardLayoutManager.getCurrentLayout())
    }
}