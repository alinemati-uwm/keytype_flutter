package com.nematiai.keytype

import android.content.Context
import android.content.SharedPreferences
import android.content.res.Configuration
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import org.junit.Assert.*

/**
 * Unit tests for KeyboardAccessibilityManager
 */
@RunWith(MockitoJUnitRunner::class)
class AccessibilityManagerTest {
    
    @Mock
    private lateinit var mockContext: Context
    
    @Mock
    private lateinit var mockSharedPreferences: SharedPreferences
    
    @Mock
    private lateinit var mockEditor: SharedPreferences.Editor
    
    private lateinit var accessibilityManager: KeyboardAccessibilityManager
    
    @Before
    fun setup() {
        // Setup mock context
        `when`(mockContext.getSharedPreferences(anyString(), anyInt())).thenReturn(mockSharedPreferences)
        `when`(mockSharedPreferences.edit()).thenReturn(mockEditor)
        `when`(mockEditor.putBoolean(anyString(), anyBoolean())).thenReturn(mockEditor)
        `when`(mockEditor.putString(anyString(), anyString())).thenReturn(mockEditor)
        `when`(mockEditor.putLong(anyString(), anyLong())).thenReturn(mockEditor)
        
        // Setup default preferences
        `when`(mockSharedPreferences.getBoolean(eq(KeyboardAccessibilityManager.PREF_HIGH_CONTRAST_MODE), anyBoolean()))
            .thenReturn(KeyboardAccessibilityManager.DEFAULT_HIGH_CONTRAST)
        `when`(mockSharedPreferences.getString(eq(KeyboardAccessibilityManager.PREF_KEYBOARD_SIZE), anyString()))
            .thenReturn(KeyboardAccessibilityManager.DEFAULT_KEYBOARD_SIZE.name)
        `when`(mockSharedPreferences.getLong(eq(KeyboardAccessibilityManager.PREF_LONG_PRESS_DELAY), anyLong()))
            .thenReturn(KeyboardAccessibilityManager.DEFAULT_LONG_PRESS_DELAY)
        `when`(mockSharedPreferences.getBoolean(eq(KeyboardAccessibilityManager.PREF_HAPTIC_FEEDBACK), anyBoolean()))
            .thenReturn(KeyboardAccessibilityManager.DEFAULT_HAPTIC_FEEDBACK)
        `when`(mockSharedPreferences.getBoolean(eq(KeyboardAccessibilityManager.PREF_AUDIO_FEEDBACK), anyBoolean()))
            .thenReturn(KeyboardAccessibilityManager.DEFAULT_AUDIO_FEEDBACK)
        `when`(mockSharedPreferences.getBoolean(eq(KeyboardAccessibilityManager.PREF_COLOR_BLIND_MODE), anyBoolean()))
            .thenReturn(KeyboardAccessibilityManager.DEFAULT_COLOR_BLIND_MODE)
        
        accessibilityManager = KeyboardAccessibilityManager(mockContext)
    }
    
    @Test
    fun testInitialization() {
        // Test that initialization loads default values
        accessibilityManager.initialize()
        
        val config = accessibilityManager.getAccessibilityConfig()
        
        assertEquals(KeyboardAccessibilityManager.DEFAULT_HIGH_CONTRAST, config.isHighContrastMode)
        assertEquals(KeyboardAccessibilityManager.DEFAULT_KEYBOARD_SIZE, config.keyboardSize)
        assertEquals(KeyboardAccessibilityManager.DEFAULT_LONG_PRESS_DELAY, config.longPressDelay)
        assertEquals(KeyboardAccessibilityManager.DEFAULT_HAPTIC_FEEDBACK, config.isHapticFeedbackEnabled)
        assertEquals(KeyboardAccessibilityManager.DEFAULT_AUDIO_FEEDBACK, config.isAudioFeedbackEnabled)
        assertEquals(KeyboardAccessibilityManager.DEFAULT_COLOR_BLIND_MODE, config.isColorBlindFriendlyMode)
    }
    
    @Test
    fun testKeyboardSizeMultipliers() {
        // Test that keyboard size multipliers are correct
        assertEquals(KeyboardAccessibilityManager.SIZE_SMALL_MULTIPLIER, 
            KeyboardAccessibilityManager.KeyboardSize.SMALL.multiplier, 0.01f)
        assertEquals(KeyboardAccessibilityManager.SIZE_MEDIUM_MULTIPLIER, 
            KeyboardAccessibilityManager.KeyboardSize.MEDIUM.multiplier, 0.01f)
        assertEquals(KeyboardAccessibilityManager.SIZE_LARGE_MULTIPLIER, 
            KeyboardAccessibilityManager.KeyboardSize.LARGE.multiplier, 0.01f)
        assertEquals(KeyboardAccessibilityManager.SIZE_XLARGE_MULTIPLIER, 
            KeyboardAccessibilityManager.KeyboardSize.XLARGE.multiplier, 0.01f)
    }
    
    @Test
    fun testConfigurationUpdate() {
        accessibilityManager.initialize()
        
        val newConfig = KeyboardAccessibilityManager.AccessibilityConfig(
            isHighContrastMode = true,
            keyboardSize = KeyboardAccessibilityManager.KeyboardSize.LARGE,
            longPressDelay = 1000L,
            isHapticFeedbackEnabled = false,
            isAudioFeedbackEnabled = true,
            isColorBlindFriendlyMode = true
        )
        
        accessibilityManager.updateAccessibilityConfig(newConfig)
        
        val updatedConfig = accessibilityManager.getAccessibilityConfig()
        assertEquals(true, updatedConfig.isHighContrastMode)
        assertEquals(KeyboardAccessibilityManager.KeyboardSize.LARGE, updatedConfig.keyboardSize)
        assertEquals(1000L, updatedConfig.longPressDelay)
        assertEquals(false, updatedConfig.isHapticFeedbackEnabled)
        assertEquals(true, updatedConfig.isAudioFeedbackEnabled)
        assertEquals(true, updatedConfig.isColorBlindFriendlyMode)
    }
    
    @Test
    fun testConfigurationPersistence() {
        accessibilityManager.initialize()
        
        val newConfig = KeyboardAccessibilityManager.AccessibilityConfig(
            isHighContrastMode = true,
            keyboardSize = KeyboardAccessibilityManager.KeyboardSize.XLARGE,
            longPressDelay = 750L,
            isHapticFeedbackEnabled = true,
            isAudioFeedbackEnabled = false,
            isColorBlindFriendlyMode = true
        )
        
        accessibilityManager.updateAccessibilityConfig(newConfig)
        
        // Verify that preferences are saved
        verify(mockEditor).putBoolean(KeyboardAccessibilityManager.PREF_HIGH_CONTRAST_MODE, true)
        verify(mockEditor).putString(KeyboardAccessibilityManager.PREF_KEYBOARD_SIZE, 
            KeyboardAccessibilityManager.KeyboardSize.XLARGE.name)
        verify(mockEditor).putLong(KeyboardAccessibilityManager.PREF_LONG_PRESS_DELAY, 750L)
        verify(mockEditor).putBoolean(KeyboardAccessibilityManager.PREF_HAPTIC_FEEDBACK, true)
        verify(mockEditor).putBoolean(KeyboardAccessibilityManager.PREF_AUDIO_FEEDBACK, false)
        verify(mockEditor).putBoolean(KeyboardAccessibilityManager.PREF_COLOR_BLIND_MODE, true)
        verify(mockEditor).apply()
    }
    
    @Test
    fun testConfigurationChangeHandling() {
        accessibilityManager.initialize()
        
        val newConfig = Configuration()
        newConfig.orientation = Configuration.ORIENTATION_LANDSCAPE
        
        accessibilityManager.onConfigurationChanged(newConfig)
        
        val config = accessibilityManager.getAccessibilityConfig()
        assertEquals(Configuration.ORIENTATION_LANDSCAPE, config.currentOrientation)
    }
    
    @Test
    fun testAccessibilityFeatureFlags() {
        accessibilityManager.initialize()
        
        // Test default values
        assertFalse(accessibilityManager.isHighContrastModeEnabled())
        assertTrue(accessibilityManager.isHapticFeedbackEnabled())
        assertEquals(KeyboardAccessibilityManager.KeyboardSize.MEDIUM, accessibilityManager.getCurrentKeyboardSize())
        assertEquals(KeyboardAccessibilityManager.DEFAULT_LONG_PRESS_DELAY, accessibilityManager.getLongPressDelay())
        
        // Update configuration
        val newConfig = KeyboardAccessibilityManager.AccessibilityConfig(
            isHighContrastMode = true,
            keyboardSize = KeyboardAccessibilityManager.KeyboardSize.LARGE,
            longPressDelay = 800L,
            isHapticFeedbackEnabled = false
        )
        
        accessibilityManager.updateAccessibilityConfig(newConfig)
        
        // Test updated values
        assertTrue(accessibilityManager.isHighContrastModeEnabled())
        assertFalse(accessibilityManager.isHapticFeedbackEnabled())
        assertEquals(KeyboardAccessibilityManager.KeyboardSize.LARGE, accessibilityManager.getCurrentKeyboardSize())
        assertEquals(800L, accessibilityManager.getLongPressDelay())
    }
    
    @Test
    fun testInvalidKeyboardSizeHandling() {
        // Setup invalid keyboard size in preferences
        `when`(mockSharedPreferences.getString(eq(KeyboardAccessibilityManager.PREF_KEYBOARD_SIZE), anyString()))
            .thenReturn("INVALID_SIZE")
        
        accessibilityManager.initialize()
        
        val config = accessibilityManager.getAccessibilityConfig()
        // Should fallback to default size
        assertEquals(KeyboardAccessibilityManager.DEFAULT_KEYBOARD_SIZE, config.keyboardSize)
    }
    
    @Test
    fun testKeyboardSizeDisplayNames() {
        // Test that all keyboard sizes have proper display names
        val sizes = KeyboardAccessibilityManager.KeyboardSize.values()
        
        for (size in sizes) {
            assertNotNull(size.displayName)
            assertTrue(size.displayName.isNotEmpty())
        }
        
        // Test specific display names
        assertEquals("Small", KeyboardAccessibilityManager.KeyboardSize.SMALL.displayName)
        assertEquals("Medium", KeyboardAccessibilityManager.KeyboardSize.MEDIUM.displayName)
        assertEquals("Large", KeyboardAccessibilityManager.KeyboardSize.LARGE.displayName)
        assertEquals("Extra Large", KeyboardAccessibilityManager.KeyboardSize.XLARGE.displayName)
    }
}