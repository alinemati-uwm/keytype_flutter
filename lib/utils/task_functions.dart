class TaskSystemController {
  static String modelName = 'openai/gpt-4o-mini';
  static Map<String, dynamic> meta = {"Tone": "Normal", "formality": "formal"};

  String getTaskSystemPrompt({required String type}) {
    switch (type.toLowerCase()) {
      case 'generate':
        return "Generate the rest of this sentence in 1 line. Create 5 different outputs without any repeated topics. Requirements: 1) Each output must explore a completely different theme or aspect 2) Maximum 1 line per completion 3) Ensure diversity in topics - no overlapping themes 4) Make each completion meaningful and contextually relevant 5) Vary the tone and approach across all outputs";
      
      case 'rewrite':
        return "Rewrite the given text in 5 different ways while preserving the original meaning. Requirements: 1) Each version must use different vocabulary and sentence structure 2) Maintain the core message and intent 3) Vary the tone from formal to casual across versions 4) Keep the same information level - don't add or remove key details 5) Each rewrite should feel fresh and distinct from others";
      
      case 'translate':
        return "Translate the given text accurately while providing 5 different translation variations. Requirements: 1) Each translation must be grammatically correct and culturally appropriate 2) Vary the formality level and register across versions 3) Preserve the original meaning and context 4) Consider different ways to express the same concept in the target language 5) Maintain natural flow and readability in each version";
      
      case 'summerize':
      case 'summarize':
        return "Summarize the given text in 5 different styles and lengths. Requirements: 1) Cover all key points and main ideas 2) Each summary should use a different approach (bullet points, paragraph, executive summary, key highlights, brief overview) 3) Vary the length from concise to comprehensive 4) Maintain accuracy and don't add information not in the original 5) Make each summary useful for different reading purposes";
      
      case 'fix_grammer':
      case 'fix_grammar':
        return "Fix all grammar, spelling, and punctuation errors in the given text. Provide 5 corrected versions with different levels of improvement. Requirements: 1) Correct all grammatical mistakes while preserving original meaning 2) Fix spelling and punctuation errors 3) Improve sentence clarity and flow 4) Vary the level of editing from minimal fixes to enhanced readability 5) Keep the original tone and style as much as possible";
      
      case 'make_formal':
        return "Transform the given text into formal language. Provide 5 different formal versions with varying degrees of formality. Requirements: 1) Use professional and sophisticated vocabulary 2) Employ proper grammar and sentence structure 3) Remove colloquialisms and casual expressions 4) Vary from business formal to academic formal across versions 5) Maintain the original message while elevating the tone and presentation";
      
      case 'make_informal':
        return "Convert the given text into informal, native conversational and slang language. Create 5 different casual versions. Requirements: 1) Use everyday vocabulary and casual expressions 2) Make the tone friendly and approachable 3) Incorporate contractions, slangs, idioms and colloquial language where appropriate 4) Vary from slightly casual to very conversational across versions 5) Keep the core message while making it more relatable and easy to understand";
      
      default:
        return "Process the given text according to the specified action. Create 5 different variations that are distinct from each other. Requirements: 1) Each output should be meaningfully different 2) Maintain quality and relevance 3) Vary the approach, tone, or structure 4) Ensure all outputs serve the intended purpose 5) Keep consistency with the requested action while providing diversity";
    }
  }
}
