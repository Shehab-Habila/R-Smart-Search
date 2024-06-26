
# Smart Search Library by Shehab Habila
# Main Function: smart_search(string_to_find, string_or_vector_to_find_in, min_word_matches = 0.3)
#   string_to_find must be a string
#   string_or_vector_to_find_in must be a string or vector of string
#   min_word_matches is the minimum percentage of words that must be found to consider a match







split_strings_into_letters <- function(string_to_split) {
  
  # Define the empty output variable
  letters_of_the_string   <- list(NULL)
  # Split the string into words
  words_of_the_string     <- unlist(strsplit(string_to_split, " "))
  
  # Split every word into letters
  for (current_word in words_of_the_string) {
    
    letters_vector <- list(unlist(strsplit(current_word, NULL)))
    letters_of_the_string <- append(letters_of_the_string, letters_vector)
    
  }
  
  # Return the output variable
  return(letters_of_the_string[2:length(letters_of_the_string)])
  
}


start_search <- function (string_to_find, string_or_vector_to_find_in) {
  
  # Get the wanted string in words/letters
  string_to_find__in_words    <- unlist(strsplit(string_to_find, " "))
  string_to_find__in_letters  <- split_strings_into_letters(string_to_find)
  
  # Set the output variable of the list [Will be used to sort the matched reference items according to accuracy of the match]
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
    for ( wanted_index_counter in 1:length(string_to_find__in_letters) ) {
      
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
        matched <- FALSE
        
        # Check if the two words are symmetrical
        if ( current_wanted_word == current_reference_word ) {
          matched <- TRUE
          # Setting the matches parameters up
          wanted_word_index <- wanted_index_counter
          ref_word_index    <- reference_words_index_counter
          ref_item_index    <- reference_index_counter
          letters_matched_percentage <- 1
        }
        
        else {
          
          # Get the two words in letters
          current_wanted_word__in_letters     <- unlist(string_to_find__in_letters[wanted_index_counter])
          current_reference_word__in_letters  <- unlist(strsplit(current_reference_word, NULL))
          
          # Number of characters in the two words is assumed to be the same
          if ( length(current_wanted_word__in_letters) == length(current_reference_word__in_letters) ) {

            # Start smart comparing by letter
            num_matched_letters <- 0
            letters_counter     <- 1
            for ( letters_counter in 1:length(current_wanted_word__in_letters) ) {
              # Compare
              if ( current_wanted_word__in_letters[letters_counter] == current_reference_word__in_letters[letters_counter] ) {
                num_matched_letters <- num_matched_letters + 1
              }
            }
            
            # Results of comparison
            if ( length(current_wanted_word__in_letters) < 4 ) {
              if ( num_matched_letters >= length(current_wanted_word__in_letters)-1 ) {
                matched <- TRUE
                # Setting the matches parameters up
                wanted_word_index           <- wanted_index_counter
                ref_word_index              <- reference_words_index_counter
                ref_item_index              <- reference_index_counter
                letters_matched_percentage  <- num_matched_letters/length(current_wanted_word__in_letters)
              }
            }
            else {
              if ( num_matched_letters >= length(current_wanted_word__in_letters)-2 ) {
                matched <- TRUE
                # Setting the matches parameters up
                wanted_word_index           <- wanted_index_counter
                ref_word_index              <- reference_words_index_counter
                ref_item_index              <- reference_index_counter
                letters_matched_percentage  <- num_matched_letters/length(current_wanted_word__in_letters)
              }
            }
            
          }
        }
        
        
        # Check if its already matched, no need to continue with this wanted word
        if (isTRUE(matched) == TRUE) {
          current_match_parameters  <- list(c(wanted_word_index, ref_word_index, ref_item_index, letters_matched_percentage))
          matches_parameters        <- append(matches_parameters, current_match_parameters)
          break
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


# The main function
smart_search <- function (string_to_find, string_or_vector_to_find_in, min_word_matches = 0.3) {
  
  if ( is.character(string_to_find) == FALSE | string_to_find == "" ) {
    return("ERROR: string_to_find must be a character.")
  }
  if ( is.character(string_or_vector_to_find_in) == FALSE ) {
    return("ERROR: string_or_vector_to_find_in must be a character.")
  }
  if ( is.numeric(min_word_matches) == FALSE ) {
    return("ERROR: string_or_vector_to_find_in must be numeric.")
  }
  
  num_words_to_find <- length(unlist(strsplit(string_to_find, " ")))
  
  # Get the matches
  # matches_parameters <- list( c(wanted_word_index, ref_word_index, ref_item_index, letters_matched_percentage) )
  matches        <- start_search(string_to_find, string_or_vector_to_find_in)
  total_matches  <- length(matches)
  
  if (is.null(unlist(matches[1])) == TRUE) {
    return(NULL)
  }
  
  
  # Extract and calculate the score for all matches
  matched_ref_indices <- NULL
  final_scores <- list(NULL)
  
  # Extract the parameters for each reference item and calculate the score
  current_reference <- 1
  for ( current_reference in 1:length(string_or_vector_to_find_in) ) {

    current_score <- 0
    current_item_matches <- 0
    
    # 4 checks will be done for every item: number of matches, unique matches percentage, successive or not, accuracy of the match
    # Resitting all variables for each reference item
    words_matches   <- NULL
    num_matches     <- 0
    unique_matches  <- NULL
    num_unique_matches <- 0
    matches_percent <- 0
    # successive      <- 0
    total_accuracies<- 0
    mean_accuracies <- 0
    
    for (matches_counter in 1:total_matches) {
      
      matched_ref_item_index <- unlist(matches[matches_counter])[3]
      if ( current_reference == matched_ref_item_index ) {
        # Add to matches
        words_matches <- c(words_matches, unlist(matches[matches_counter])[1])
        # Add to total accuracies
        total_accuracies <- total_accuracies + unlist(matches[matches_counter])[4]
        # Check if they are successives [not implemented now]
      }
    }
    num_matches         <- length(words_matches)
    unique_matches      <- unique(words_matches)
    num_unique_matches  <- length(unique_matches)
    mean_accuracies     <- total_accuracies/num_matches
    
    # Calculate the score
    if ( num_unique_matches >= min_word_matches*num_words_to_find ) {
      current_score <- num_unique_matches + (num_matches/num_words_to_find) + (num_matches/length(unlist(strsplit(string_or_vector_to_find_in[current_reference], " ")))) + mean_accuracies
    }
    
    # Add to final scores
    if ( current_score > 0 ) {
      matched_ref_indices <- c(matched_ref_indices, current_reference)
      final_scores <- append(final_scores, current_score)
    }
    
  }
  
  # Start sorting the matched reference items according to the score
  final_scores  <- final_scores[2:length(final_scores)]
  names(final_scores) <- matched_ref_indices
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

