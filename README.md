### R-Smart-Search: Advanced Text Search Library for R
_____________________________________________________

**Overview**
R-Smart-Search is an advanced text search library written in R, designed to provide robust and flexible search capabilities for textual data.
This library excels in finding words or sentences within paragraphs, even when the words are slightly different or the sentence structure is disrupted.
It also performs accurate searches across multiple paragraphs, ranking results based on match accuracy.

**Features**
  - Fuzzy Matching: Identify words or sentences even when there are slight variations in spelling or word order.
  - Contextual Search: Locate target phrases within paragraphs, maintaining high accuracy even with separated words.
  - Multi-Paragraph Analysis: Search across a group of paragraphs, ensuring comprehensive text analysis.
  - Match Accuracy Sorting: Results are sorted based on the accuracy of the matches, providing the most relevant findings first.
  - Customization: Highly customizable settings to adjust search sensitivity and behavior.
  - Readable Code: Clean, well-documented, and easy-to-read code for straightforward integration and modification.
_____________________________________________________

### Primary Function: `smart_search()`
The main function, `smart_search()`, takes the following inputs:
  - `string_to_find`: The target string to search for.
  - `string_or_vector_to_find_in`: The text or collection of texts to search within.
  - `min_word_matches`: The minimum percentage of words that must match to consider a result as valid (default is 0.3 or 30%).

### Supporting Functions:
1. **`split_strings_into_letters(string_to_split)`**
   - Splits a given string into a list of letters for each word.
   - Example: "hello world" becomes `list(c("h", "e", "l", "l", "o"), c("w", "o", "r", "l", "d"))`.
2. **`match_word_to_word(wanted_word, ref_word)`**
   - Compares two words to determine their match accuracy.
   - If the words are identical, the match accuracy is 1.
   - If the words are similar in length, it calculates the percentage of matching characters, considering near matches based on the word length.
3. **`start_search(string_to_find, string_or_vector_to_find_in)`**
   - Iterates through each reference text to find matches for each word in the target string.
   - Uses `split_strings_into_letters()` and `match_word_to_word()` to compare words.
   - Returns a list of matches with details like the indices of the matched words and their match accuracy.
_____________________________________________________

### Main Function Workflow: `smart_search()`
1. **Input Validation:**
   - Checks if the inputs are of the correct type (character and numeric).
   - Returns an error message if the inputs are invalid.
2. **Finding Matches:**
   - Calls `start_search()` to get all possible matches between the target string and the reference texts.
   - If no matches are found, returns `NULL`.
3. **Scoring Matches:**
   - Calculates scores for each matched reference text based on:
     - Number of word matches.
     - Percentage of unique matches.
     - Mean accuracy of the matches.
   - Scores are calculated only if the number of unique word matches meets the `min_word_matches` threshold.
4. **Sorting and Returning Results:**
   - Sorts the reference texts based on their scores in descending order.
   - Constructs the final output as a list containing:
     - The index of the reference text.
     - The score of the match.
     - The text of the matched reference.
_____________________________________________________

### Example Usage:
```r
results <- smart_search("hello world", c("hello", "world hello", "hi there", "hello world!"), min_word_matches = 0.5)
print(results)
```
This example will search for the string "hello world" in the provided vector of strings and return the matches that meet the minimum word match threshold, sorted by their match accuracy.
