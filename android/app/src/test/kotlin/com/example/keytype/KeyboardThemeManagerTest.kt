package com.nematiai.keytype

import android.content.Context
import android.content.SharedPreferences
import android.widget.LinearLayout
import android.widget.ImageButton
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.junit.MockitoJUnitRunner
import org.junit.Assert.*

/**
 * Unit tests for KeyboardThemeManager
 * Tests theme switching functionality, persistence, and UI updates
 */
@RunWith(MockitoJUnitRunner::class)
class KeyboardThemeManagerTest {
    
    @Mock
    private lateinit var mockContext: Context
    
    @Mock
    private lateinit var mockSharedPreferences: SharedPreferences
    
    @Mock
    private lateinit var mockEditor: SharedPreferences.Editor
    
    @Mock
    private lateinit var mockMainLayout: LinearLayout
    
    @Mock
    private lateinit var mockThemeToggleButton: ImageButton
    
    @Mock
    private lateinit var mockRewriteButton: LinearLayout
    
    @Mock
    private lateinit var mockSummarizeButton: LinearLayout
    
    @Mock
    private lateinit var mockGenerateButton: LinearLayout
    
    private lateinit var themeManager: KeyboardThemeManager
    
    @Before
    fun setup() {
        // Setup mock context and preferences
        `when`(mockContext.getSharedPreferences(anyString(), anyInt())).thenReturn(mockSharedPreferences)
        `when`(mockSharedPreferences.edit()).thenReturn(mockEditor)
        `when`(mockEditor.putBoolean(anyString(), anyBoolean())).thenReturn(mockEditor)
        
        // Setup default theme preference (dark theme)
        `when`(mockSharedPreferences.getBoolean(eq("is_dark_theme"), anyBoolean())).thenReturn(true)
        
        themeManager = KeyboardThemeManager(mockContext)
    }
    
    @Test
    fun testInitialization() {
        // Test that theme manager initializes with correct default values
        assertTrue("Theme manager should initialize with dark theme by default", themeManager.isDarkTheme())
        
        val currentTheme = themeManager.getCurrentTheme()
        assertNotNull("Current theme should not be null", currentTheme)
        assertTrue("Current theme should be dark by default", currentTheme.isDark)
    }
    
    @Test
    fun testThemeToggling() {
        // Start with dark theme
        assertTrue("Should start with dark theme", themeManager.isDarkTheme())
        
        // Toggle to light theme
        val lightTheme = themeManager.toggleTheme()
        assertFalse("Should switch to light theme", lightTheme.isDark)
        assertFalse("isDarkTheme should return false", themeManager.isDarkTheme())
        
        // Toggle back to dark theme
        val darkTheme = themeManager.toggleTheme()
        assertTrue("Should switch back to dark theme", darkTheme.isDark)
        assertTrue("isDarkTheme should return true", themeManager.isDarkTheme())
    }
    
    @Test
    fun testThemePersistence() {
        // Toggle theme and verify persistence
        themeManager.toggleTheme()
        
        // Verify that the preference is saved
        verify(mockEditor).putBoolean("is_dark_theme", false)
        verify(mockEditor).apply()
    }
    
    @Test
    fun testLightThemeColors() {
        // Switch to light theme
        themeManager.toggleTheme()
        val lightTheme = themeManager.getCurrentTheme()
        
        assertFalse("Light theme should not be dark", lightTheme.isDark)
        
        // Verify light theme colors are different from dark theme colors
        val darkTheme = themeManager.toggleTheme()
        
        assertNotEquals("Background colors should be different", 
            lightTheme.backgroundColor, darkTheme.backgroundColor)
        assertNotEquals("Key background colors should be different", 
            lightTheme.keyBackgroundColor, darkTheme.keyBackgroundColor)
        assertNotEquals("Text colors should be different", 
            lightTheme.keyTextColor, darkTheme.keyTextColor)
    }
    
    @Test
    fun testDarkThemeColors() {
        // Verify dark theme colors
        val darkTheme = themeManager.getCurrentTheme()
        
        assertTrue("Dark theme should be dark", darkTheme.isDark)
        assertNotEquals("Background color should not be zero", 0, darkTheme.backgroundColor)
        assertNotEquals("Key background color should not be zero", 0, darkTheme.keyBackgroundColor)
        assertNotEquals("Text color should not be zero", 0, darkTheme.keyTextColor)
    }
    
    @Test
    fun testThemeLoadingFromPreferences() {
        // Setup preferences to return light theme
        `when`(mockSharedPreferences.getBoolean(eq("is_dark_theme"), anyBoolean())).thenReturn(false)
        
        // Create new theme manager instance
        val newThemeManager = KeyboardThemeManager(mockContext)
        
        assertFalse("Should load light theme from preferences", newThemeManager.isDarkTheme())
    }
    
    @Test
    fun testApplyThemeToLayout() {
        // Test applying theme without animation
        themeManager.applyThemeToLayout(
            mockMainLayout,
            mockThemeToggleButton,
            mockRewriteButton,
            mockSummarizeButton,
            mockGenerateButton,
            false
        )
        
        // Verify that layout methods are called (would need to verify actual color setting in integration tests)
        verify(mockMainLayout, atLeastOnce()).setBackgroundColor(anyInt())
    }
    
    @Test
    fun testApplyThemeToLayoutWithAnimation() {
        // Test applying theme with animation
        themeManager.applyThemeToLayout(
            mockMainLayout,
            mockThemeToggleButton,
            mockRewriteButton,
            mockSummarizeButton,
            mockGenerateButton,
            true
        )
        
        // Verify that layout methods are called
        verify(mockMainLayout, atLeastOnce()).setBackgroundColor(anyInt())
    }
    
    @Test
    fun testGetLightTheme() {
        val lightTheme = themeManager.getLightTheme()
        
        assertFalse("Light theme should not be dark", lightTheme.isDark)
        assertNotEquals("Light theme background should not be zero", 0, lightTheme.backgroundColor)
        assertNotEquals("Light theme key background should not be zero", 0, lightTheme.keyBackgroundColor)
        assertNotEquals("Light theme text color should not be zero", 0, lightTheme.keyTextColor)
    }
    
    @Test
    fun testGetDarkTheme() {
        val darkTheme = themeManager.getDarkTheme()
        
        assertTrue("Dark theme should be dark", darkTheme.isDark)
        assertNotEquals("Dark theme background should not be zero", 0, darkTheme.backgroundColor)
        assertNotEquals("Dark theme key background should not be zero", 0, darkTheme.keyBackgroundColor)
        assertNotEquals("Dark theme text color should not be zero", 0, darkTheme.keyTextColor)
    }
    
    @Test
    fun testThemeConsistency() {
        // Test that theme properties remain consistent across multiple toggles
        val originalTheme = themeManager.getCurrentTheme()
        
        // Toggle twice to return to original state
        themeManager.toggleTheme()
        val returnedTheme = themeManager.toggleTheme()
        
        assertEquals("Background color should be consistent", 
            originalTheme.backgroundColor, returnedTheme.backgroundColor)
        assertEquals("Key background color should be consistent", 
            originalTheme.keyBackgroundColor, returnedTheme.keyBackgroundColor)
        assertEquals("Text color should be consistent", 
            originalTheme.keyTextColor, returnedTheme.keyTextColor)
        assertEquals("Dark mode flag should be consistent", 
            originalTheme.isDark, returnedTheme.isDark)
    }
    
    @Test
    fun testPreferenceKeyConstants() {
        // Test that preference keys are properly defined
        assertEquals("Theme preference key should be correct", 
            "is_dark_theme", KeyboardThemeManager.PREF_IS_DARK_THEME)
    }
    
    @Test
    fun testThemeManagerSingleton() {
        // Test that theme manager maintains state correctly
        val theme1 = themeManager.getCurrentTheme()
        val theme2 = themeManager.getCurrentTheme()
        
        assertEquals("Theme should be consistent across calls", theme1.isDark, theme2.isDark)
        assertEquals("Background color should be consistent", theme1.backgroundColor, theme2.backgroundColor)
    }
}