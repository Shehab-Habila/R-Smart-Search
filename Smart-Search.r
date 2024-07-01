
# Smart Search Library by Shehab Habila
# 
#
#
# Primary Function: smart_search(string_to_find, string_or_vector_to_find_in, min_word_matches = 0.3)
# 
# Parameters:
#   string_to_find (string): The target string to search for.
#   string_or_vector_to_find_in (string or vector of strings): The text or collection of texts to search within.
#   min_word_matches (numeric, default = 0.3): The minimum percentage of word matches required to consider a result as a match.
# 
# Returns:
#   A vector containing:
#     - The index of the reference element in the provided vector.
#     - The accuracy score of the match.
#     - The matched text.







# Helper function to split words into letters and remove special characters
split_words_into_letters_and_remove_special <- function(word) {
  
  # Split into letters
  word__in_letters <- unlist(strsplit(word, NULL))
  # Remove special characters
  special <- c("`", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "-", "=", "+", "'", '"', "?", ">", "<", ":", ",", "{", "}", ";", "[", "]", " ")
  word_clean <- word__in_letters[! word__in_letters%in% special]
  
  # Return the clean output in letters
  return(word_clean)
}


# Helper function to split strings into letters
split_strings_into_letters <- function(string_to_split) {
  
  # Define the empty output variable
  letters_of_the_string   <- list(NULL)
  
  # Split the string into words
  words_of_the_string     <- unlist(strsplit(string_to_split, " "))
  
  # Split every word into letters
  for (current_word in words_of_the_string) {
    
    letters_vector <- list( split_words_into_letters_and_remove_special(current_word) )
    letters_of_the_string <- append(letters_of_the_string, letters_vector)
    
  }
  
  # Return the output variable
  return(letters_of_the_string[2:length(letters_of_the_string)])
  
}


# Function to match two words and calculate match accuracy
match_word_to_word <- function(wanted_word, ref_word) {
  
  # Set up the default output
  match_accuracy <- NULL
  
  # Check if the two words are completely symmetrical
  if ( wanted_word == ref_word ) {
    match_accuracy <- 1
  } else { # Check if they are alike
    
    wanted_word__in_letters <- split_words_into_letters_and_remove_special(wanted_word)
    ref_word__in_letters    <- split_words_into_letters_and_remove_special(ref_word)
    
    # Equality in number of characters is no longer assumed
    inaccuracy <- NULL
    
    # If the length of reference word is greater than the length of the wanted word
    if ( length(ref_word__in_letters) %in% (length(wanted_word__in_letters) - 1):(length(wanted_word__in_letters) + 2) ) {
      # Setting the default basic inaccuracy
      if ( length(ref_word__in_letters) > length(wanted_word__in_letters) ) {
        inaccuracy <- ( length(ref_word__in_letters) - length(wanted_word__in_letters) ) / 2
      }
      if ( length(ref_word__in_letters) < length(wanted_word__in_letters) ) {
        inaccuracy <- ( length(wanted_word__in_letters) - length(ref_word__in_letters) ) / 2
      }
      if ( length(ref_word__in_letters) == length(wanted_word__in_letters) ) {
        inaccuracy <- 0
      }
      
      # Match every character in the wanted word with its corresponding in the reference one
      ref_letter_counter <- 1
      wanted_letter_counter <- 1
      while ( wanted_letter_counter <= length(wanted_word__in_letters) ) {
        if ( ref_word__in_letters[ref_letter_counter] == wanted_word__in_letters[wanted_letter_counter] ) {
          ref_letter_counter <- ref_letter_counter + 1
        }
        else {
          if ( wanted_letter_counter == length(wanted_word__in_letters) ) {
            inaccuracy <- inaccuracy + 1
          }
          else {
            # Check for alteration with the next char
            if ( ref_letter_counter < length(ref_word__in_letters) ) {
              if ( wanted_word__in_letters[wanted_letter_counter] == ref_word__in_letters[ref_letter_counter + 1] ) {
                if ( wanted_word__in_letters[wanted_letter_counter + 1] == ref_word__in_letters[ref_letter_counter] ) {
                  # There is alteration
                  inaccuracy <- inaccuracy + 1
                  # Skip the next letter because it is already checked
                  ref_letter_counter <- ref_letter_counter + 2
                  wanted_letter_counter <- wanted_letter_counter + 1
                } else {
                  # There is alteration, but there is a foreign char in between
                  inaccuracy <- inaccuracy + 1
                  ref_letter_counter <- ref_letter_counter + 2
                }
              } else { # There is no alteration or foreign char, two letters simply don't match
                inaccuracy <- inaccuracy + 1
                ref_letter_counter <- ref_letter_counter + 1
              }
            } else { # There is no alteration or foreign char, two letters simply don't match
              inaccuracy <- inaccuracy + 1
              ref_letter_counter <- ref_letter_counter + 1
            }
          }
        }
        
        if ( ref_letter_counter > length(ref_word__in_letters) ) { # You've checked all the letters in the ref word
          break
        }
        
        wanted_letter_counter <- wanted_letter_counter + 1
      }
      
      # Calculating the final match accuracy
      match_accuracy <- ( length(wanted_word__in_letters) - inaccuracy ) / length(wanted_word__in_letters)
    }
    
    # If the length of the reference word is too smaller or too larger than the wanted word
    else {
      match_accuracy <- 0
    }
    
    
    # Assess findings
    if ( length(wanted_word__in_letters) < 4 ) {
      if ( match_accuracy < ( (length(wanted_word__in_letters) - 1) / length(wanted_word__in_letters) ) ) {
        match_accuracy <- NULL
      }
    }
    if ( length(wanted_word__in_letters) >= 4 ) {
      if ( match_accuracy < ( (length(wanted_word__in_letters) - 2.5) / length(wanted_word__in_letters) ) ) {
        match_accuracy <- NULL
      }
    }
    
  } # End of matching
  
  
  return(match_accuracy)
  
}


# Function to start the search process
start_search <- function (string_to_find, string_or_vector_to_find_in) {
  
  # Get the wanted string in words/letters
  string_to_find__in_words  <- unlist(strsplit(string_to_find, " "))
  num_wanted_words          <- length(string_to_find__in_words)
  
  # Set the output variable of the list [Will be used to sort the matched reference elements according to accuracy of the match]
  # its format will be: [vector for each match]
  # matches_parameters <- list( c(wanted_word_index, ref_word_index, ref_item_index, letters_matched_percentage) )
  matches_parameters <- list(NULL)
  
  # Start a loop to check in every item in the reference vector
  reference_index_counter <- 1
  for ( reference_index_counter in 1:length(string_or_vector_to_find_in) ) {
    # Get the current item in the reference vector
    current_reference_item <- string_or_vector_to_find_in[reference_index_counter]
    # Start a loop to search for every word in the wanted string
    wanted_index_counter <- 1
    for ( wanted_index_counter in 1:num_wanted_words ) {
      
      # Getting the current wanted word
      current_wanted_word <- string_to_find__in_words[wanted_index_counter]
      # Get current reference string in words
      current_reference_item__in_words <- unlist(strsplit(current_reference_item, " "))
      
      # Start comparing current wanted word to every word in the current item in the reference vector
      reference_words_index_counter <- 1
      for (reference_words_index_counter in 1:length(current_reference_item__in_words)) {
        
        # Getting the current reference word
        current_reference_word <- current_reference_item__in_words[reference_words_index_counter]
        
        # Start the actual comparing of a word to word
        match_accuracy <- match_word_to_word(current_wanted_word, current_reference_word)
        
        
        # Check if its already matched, no need to continue with this wanted word
        if (is.null(match_accuracy) == FALSE) {
          
          wanted_word_index <- wanted_index_counter
          ref_word_index    <- reference_words_index_counter
          ref_item_index    <- reference_index_counter
          
          current_match_parameters  <- list(c(wanted_word_index, ref_item_index, ref_word_index, match_accuracy))
          matches_parameters        <- append(matches_parameters, current_match_parameters)
          
          # Will not break, to return if a word were found more than one time
          # break
          
        }
        
      } # End of comparing one wanted word with all words of one reference string
      
    } # End of comparing all wanted words with all words in one reference string
  } # End of searching for all wanted word in all reference strings
  
  
  
  # Return the matches
  matches_parameters <- matches_parameters[2:length(matches_parameters)] # Remove the first NULL value
  return(matches_parameters)
  
  # Final output format will be:
  # all_matches <- list( c(ref_str_index, ref_str_text) ) [sorted according to the previously calculated score]
  
  
}


# Main function to perform smart search
smart_search <- function (string_to_find, string_or_vector_to_find_in, min_word_matches = 0.3) {
  
  # Doing some validations
  if ( is.character(string_to_find) == FALSE | string_to_find == "" ) {
    return("ERROR: string_to_find must be a character.")
  }
  if ( is.character(string_or_vector_to_find_in) == FALSE ) {
    return("ERROR: string_or_vector_to_find_in must be a character.")
  }
  if ( is.numeric(min_word_matches) == FALSE ) {
    return("ERROR: string_or_vector_to_find_in must be numeric.")
  }
  
  
  # GET THE MATCHES
  # matches_parameters <- list( c(wanted_word_index, ref_word_index, ref_item_index, letters_matched_percentage) )
  matches <- start_search(string_to_find, string_or_vector_to_find_in)
  
  # If there is no any matches
  if (is.null(unlist(matches[1])) == TRUE) {
    return(NULL)
  }
  
  # Extract and calculate the score for all matched reference elements
  total_matches <- length(matches) # Getting the number of matches
  # Remember: matches are returned in a list composed of vectors for every match
  #   Every vector contains c(wanted_word_index, ref_item_index, ref_word_index, match_accuracy)
  matched_ref_items_indices <- NULL
  
  # Get the matched reference elements to check the only instead of checking all items like in the previous versions
  for ( matches_counter in 1:total_matches ) {
    # Getting the parameters of the current match
    current_match_ref_item_index  <- unlist(matches[matches_counter])[2]
    matched_ref_items_indices     <- c(matched_ref_items_indices, current_match_ref_item_index)
  }
  
  
  # CALCULATE THE SCORES
  final_scores <- list(NULL)
  # Extract the parameters for each reference element and calculate the score
  matched_ref_items_indices <- unique(matched_ref_items_indices)
  for ( current_reference_index in matched_ref_items_indices ) {
    
    # 4 checks will be done for every item: number of matches, unique matches percentage, successive or not, accuracy of the match
    # Resitting all variables for each reference element
    
    # Set the default placeholders
    words_matched     <- NULL
    total_accuracies  <- 0
    
    matched_words_indices_in_ref_item <- NULL
    
    for (matches_counter in 1:total_matches) {
      
      matched_ref_item_index <- unlist(matches[matches_counter])[2]
      if ( current_reference_index == matched_ref_item_index ) {
        # Add to matches
        words_matched    <- c(words_matched, unlist(matches[matches_counter])[1])
        # Add to total accuracies
        total_accuracies <- total_accuracies + unlist(matches[matches_counter])[4]
        # Check if they are successives [not implemented yet]
        matched_words_indices_in_ref_item <- c(matched_words_indices_in_ref_item, unlist(matches[matches_counter])[3])
      }
      
    }
    
    # Calculate some parameters for this reference element
    num_matches         <- length(words_matched)
    unique_matches      <- unique(words_matched)
    num_unique_matches  <- length(unique_matches)
    mean_accuracies     <- total_accuracies/num_matches
    
    # Check if the matched words are successive in the matched reference element or not
    num_successive_matches <- 0
    if ( num_unique_matches > 1 ) {
      for ( matched_word_counter in 1:(length(words_matched)-1) ) {
        # Getting some parameters
        current_word_index__in_wanted_string  <- words_matched[matched_word_counter]
        current_word_index__in_ref_item       <- matched_words_indices_in_ref_item[matched_word_counter]
        next_word_index__in_wanted_string     <- words_matched[matched_word_counter+1]
        next_word_index__in_ref_item          <- matched_words_indices_in_ref_item[matched_word_counter+1]
        # Calculating
        if ( (next_word_index__in_wanted_string - current_word_index__in_wanted_string) == (next_word_index__in_ref_item - current_word_index__in_ref_item) ) {
          num_successive_matches <- num_successive_matches + 1
        }
      } 
    } # Getting the percentage of successive matches
    percent_successive_matches <- num_successive_matches / (num_matches/2)
    
    # Calculate the score
    current_score     <- 0 # Default
    num_words_to_find <- length(unlist(strsplit(string_to_find, " ")))
    if ( num_unique_matches >= min_word_matches*num_words_to_find ) {
      current_score <-  (num_unique_matches/num_words_to_find) +
                        (num_matches/num_unique_matches) +
                        (num_matches/length(unlist(strsplit(string_or_vector_to_find_in[current_reference_index], " ")))) + 
                        (num_unique_matches/length(unlist(strsplit(string_or_vector_to_find_in[current_reference_index], " ")))) + 
                        mean_accuracies + 
                        percent_successive_matches
    }
    
    # Add to final scores
    if ( current_score > 0 ) {
      final_scores  <- append(final_scores, current_score)
    }
    if ( current_score == 0 ) { 
      matched_ref_items_indices <- matched_ref_items_indices[-match(current_reference_index, matched_ref_items_indices)]
    }
    
  }
  
  
  # SORT THE SCORES
  if ( length(final_scores) == 1 ) { # Contains only the NULL placeholder
    return(NULL)
  }
  
  final_scores  <- final_scores[2:length(final_scores)]
  names(final_scores) <- matched_ref_items_indices
  final_scores  <- as.list(sort(unlist(final_scores), decreasing = TRUE))
  
  # Returning the final output
  num_final_scores    <- length(final_scores)
  sorted_ref_indices  <- as.numeric(names(final_scores))
  
  output <- list(NULL)
  
  for (counter in 1:num_final_scores) {
    current_output_element <- list(c(sorted_ref_indices[counter], as.numeric(final_scores[counter]), string_or_vector_to_find_in[sorted_ref_indices[counter]]))
    output <- append(output, current_output_element)
  }
  
  output <- output[2:length(output)]
  return(output)
  
}


