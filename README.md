### R-Smart-Search: Advanced Text Search Function for R
_____________________________________________________
Sure! Here's a comprehensive documentation for the latest version of your Smart Search Library:

---

## Overview
The Smart Search Library is a powerful tool designed to find words or sentences within paragraphs, even if the words are slightly different or separated. The library provides customizable fuzzy matching, allowing for a flexible search experience. This documentation covers the main functions, their parameters, and usage examples.

---

## Functions

### `split_and_remove_special(word)`
**Description:** 
Helper function to split a word into letters and remove special characters.

**Parameters:**
- `word` (character): The word to be split and cleaned.

**Returns:**
- A character vector containing the cleaned letters of the word.

**Example:**
```R
clean_letters <- split_and_remove_special("hello!")
# Returns: "h" "e" "l" "l" "o"

# Output
# [1] "h" "e" "l" "l" "o"
```

### `match_string_to_string(wanted_word, ref_word, fuzzy = TRUE, char_range = 2)`
**Description:**
Matches two words and calculates the match accuracy, with optional fuzzy matching.

**Parameters:**
- `wanted_word` (character): The word to find.
- `ref_word` (character): The reference word to match against.
- `fuzzy` (logical): Whether to use fuzzy matching (default is TRUE).
- `char_range` (integer): The allowable difference difference in character difference for fuzzy matching (default is 2).

**Returns:**
- A numeric value representing the match accuracy (1 for exact match, less than 1 for fuzzy match).

**Example:**
```R
accuracy <- match_string_to_string("hello", "helo", TRUE, 1)

# Output
# [1] 0.7
```

### `start_search(string_to_find, string_or_vector_to_find_in, fuzzy = TRUE, char_range = 2)`
**Description:**
Initiates the search process for a string within a vector of strings, utilizing fuzzy matching if specified.

**Parameters:**
- `string_to_find` (character): The string to search for.
- `string_or_vector_to_find_in` (character vector): The vector of strings to search within.
- `fuzzy` (logical): Whether to use fuzzy matching (default is TRUE).
- `char_range` (integer): The allowable character difference for fuzzy matching (default is 2).

**Returns:**
- A list of vectors containing the matches' parameters: `[wanted_word_index, ref_item_index, ref_word_index, match_accuracy]`.


### `smart_search(string_to_find, string_or_vector_to_find_in, min_word_matches = 0.3, fuzzy = TRUE, char_range = 2)`
**Description:**
Performs a smart search to find a string within a vector of strings, and returns the results sorted by accuracy.

**Parameters:**
- `string_to_find` (character): The string to search for.
- `string_or_vector_to_find_in` (character vector): The vector of strings to search within.
- `min_word_matches` (numeric): The minimum proportion of words that must match (default is 0.3).
- `fuzzy` (logical): Whether to use fuzzy matching (default is TRUE).
- `char_range` (integer): The allowable character difference for fuzzy matching (default is 2).

**Returns:**
- A data frame with columns "Index", "Score", and "Text", representing the matched strings, their scores, and the text of the matched reference elements.

**Example:**
```R
results <- smart_search("hello world", c("hi there", "hello universe", "world hello"), 0.3, TRUE, 2)
# Returns:
#   Index  Score              Text
# 1     3      5       world hello
# 2     2    3.5    hello universe
```

## Usage Examples

### Basic Usage
```R
# Define the string to find and the vector to search within
string_to_find <- "hello world"
reference_strings <- c("hi there", "hello universe", "world hello")

# Perform the smart search
results <- smart_search(string_to_find, reference_strings)

# View the results
print(results)
```

### Custom Fuzzy Matching
```R
# Define the string to find and the vector to search within
string_to_find <- "example search"
reference_strings <- c("sample searching", "example of search", "search example")

# Perform the smart search with custom fuzzy matching
results <- smart_search(string_to_find, reference_strings, min_word_matches = 0.5, fuzzy = TRUE, char_range = 3)

# View the results
print(results)
```

### Exact Matching
```R
# Define the string to find and the vector to search within
string_to_find <- "exact match"
reference_strings <- c("this is an exact match", "no match here", "exact matching example")

# Perform the smart search with exact matching
results <- smart_search(string_to_find, reference_strings, fuzzy = FALSE)

# View the results
print(results)
```

## Notes
- The `smart_search` function is the main function to use for performing searches.
- Adjust the `min_word_matches`, `fuzzy`, and `char_range` parameters to fine-tune the search behavior according to your needs.
- Ensure that the input strings and vectors are of character type to avoid errors.

## Conclusion
The Smart Search Library provides a flexible and powerful way to search for words and sentences within text, offering customizable fuzzy matching to handle variations in the text. With its advanced scoring mechanism and comprehensive matching logic, it ensures accurate, efficient, and reliable search results.

---
