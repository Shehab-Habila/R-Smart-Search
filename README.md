### R-Smart-Search: Advanced Text Search Library for R
_____________________________________________________

**Overview**: R-Smart-Search is an advanced text search library written in R, designed to provide robust and flexible search capabilities for textual data.
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

**Primary Function: `smart_search()`**
The main function, `smart_search()`, takes the following inputs:
  - `string_to_find`: The target string to search for.
  - `string_or_vector_to_find_in`: The text or collection of texts to search within.
  - `min_word_matches`: The minimum percentage of words that must match to consider a result as valid (default is 0.3 or 30%).

**Supporting Functions:**
1. `split_words_into_letters_and_remove_special`
   - Splits a word into letters and removes special characters.
   - Input: A word as a string.
   - Output: A vector of letters without special characters.
2. `split_strings_into_letters(string_to_split)`
   - Splits a given string into a list of letters for each word.
   - Example: "hello world" becomes `list(c("h", "e", "l", "l", "o"), c("w", "o", "r", "l", "d"))`.
3. `match_word_to_word(wanted_word, ref_word)`
   - Compares a target word (wanted_word) to a reference word (ref_word).
   - Checks for exact matches and near matches (allowing for slight variations in letters number, order, or in the letters itself).
   - Returns a match accuracy score between 0 and 1, indicating how similar the two words are.
4. `start_search(string_to_find, string_or_vector_to_find_in)`
   - Iterates through each reference text to find matches for each word in the target string.
   - Uses `split_strings_into_letters()` and `match_word_to_word()` to compare words.
   - Returns a list of matches with details like the indices of the matched words and their match accuracy.
_____________________________________________________

**Main Function Workflow: `smart_search()`**
1. Input Validation:
   - Checks if the inputs are of the correct type (character and numeric).
   - Returns an error message if the inputs are invalid.
2. Finding Matches:
   - Calls `start_search()` to get all possible matches between the target string and the reference texts.
   - If no matches are found, returns `NULL`.
3. Scoring Matches:
   - Calculates scores for each matched reference text based on:
     - Number of word matches.
     - Percentage of unique matches.
     - Mean accuracy of the matches.
     - Order of the matched words in the reference string.
   - Scores are calculated only if the number of unique word matches meets the `min_word_matches` threshold.
4. Sorting and Returning Results:
   - Sorts the reference texts based on their scores in descending order.
   - Constructs the final output as a list containing:
     - The index of the reference text.
     - The score of the match.
     - The text of the matched reference.
_____________________________________________________
**Workflow of `match_word_to_word()` Function**

1. Initialization:
   - The function starts by setting the default output variable `match_accuracy` to `NULL`.

2. Symmetry Check:
   - If the `wanted_word` is exactly the same as the `ref_word`, the `match_accuracy` is set to `1`.

3. Character-wise Comparison:
   - If the words are not symmetrical, the function proceeds to compare the words at the character level.
   - **Split into Characters**:
     - Both `wanted_word` and `ref_word` are split into individual letters and cleaned of special characters using the `split_words_into_letters_and_remove_special()` function.
   - Check Length Difference:
     - If the length of `ref_word` is within ±1 to ±2 characters of `wanted_word`, the function proceeds to calculate the basic `inaccuracy`.

4. Calculate Basic Inaccuracy:
   - Basic inaccuracy is computed based on the difference in lengths between the `wanted_word` and the `ref_word`.

5. Character Matching:
   - A while loop iterates through each character in `wanted_word` and compares it with the corresponding character in `ref_word`.
   - Match Found:
     - If characters match, the function increments the `ref_letter_counter`.
   - Mismatch Handling:
     - If characters do not match, the function checks for possible alterations (like swapped characters or foreign characters).
     - Alteration Check:
       - The function examines adjacent characters to detect alterations and adjusts the `inaccuracy` accordingly.
     - If no alteration is found, `inaccuracy` is incremented.

6. Calculate Final Match Accuracy:
   - After iterating through the characters, the final `match_accuracy` is computed as the ratio of matched characters to the total length of `wanted_word`.

7. Threshold Check:
   - The function then assesses if the calculated `match_accuracy` meets predefined thresholds based on the length of `wanted_word`:
     - For words with less than 4 characters, the threshold is higher.
     - For words with 4 or more characters, the threshold is slightly lower.

8. Return Result:
   - If the `match_accuracy` meets the threshold, it is returned. Otherwise, the function returns `NULL`.
_____________________________________________________
**Example Usage:**
```r
results <- smart_search("Hello World, I'm New to You!",
                        c("hello world, i am new to you!", "Hello, Wolrd!", "Hello!", "helolo wordl", "Hello Worl! Iam New!", "World, Hello!"),
                        min_word_matches = 0.3)
print(results)
```
This example will search for the string "hello world" in the provided vector of strings and return the matches that meet the minimum word match threshold, sorted by their match accuracy.
