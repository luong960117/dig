defmodule Boggle do
defmodule Boggle do

    @moduledoc """
        Add your boggle function below. You may add additional helper functions if you desire.
        Test your code by running 'mix test' from the tester_ex_simple directory.
    """

    #Check if board point is early visited or not.
    #If then skip the comparison operation, else do it
    def check_visited_point(visit_point_list, i, j) do
        Enum.any?(visit_point_list, fn(point) -> 
            point == {i, j}
        end)
    end
    

    # Find a word in the board.
    # If a word is not exist, then return false, else  return the list of point tuples.
    def find_a_word(board, word, i, j, row, idx, visit_point_list) do       
        if i < 0 || i >= row || j < 0 || j >= row do
            false
        else
            if check_visited_point(visit_point_list, i, j) do
                false
            else
                if String.slice(word, idx, 1) != board |> elem(i) |> elem(j) do
                    List.delete(visit_point_list, {i, j})
                    false
                else
                    visit_point_list = List.insert_at(visit_point_list, -1, {i, j})
                    if idx + 1 == String.length(word) do
                        visit_point_list
                    else
                        a = find_a_word(board, word, i, j+1, row, idx + 1, visit_point_list)
                        b = find_a_word(board, word, i, j-1, row, idx + 1, visit_point_list)
                        c = find_a_word(board, word, i+1, j, row, idx + 1, visit_point_list)
                        d = find_a_word(board, word, i-1, j, row, idx + 1, visit_point_list)
                        e = find_a_word(board, word, i+1, j+1, row, idx + 1, visit_point_list)
                        f = find_a_word(board, word, i-1, j+1, row, idx + 1, visit_point_list)
                        g = find_a_word(board, word, i+1, j-1, row, idx + 1, visit_point_list)
                        h = find_a_word(board, word, i-1, j-1, row, idx + 1, visit_point_list)
                        
                        a||b||c||d||e||f||g||h
                    end
                end
            end 
        end
        
    end

    # Check if the first letter of given word is existed on the board.
    # If true then return true, else return false.
    def get_first_letter_position(board, row_count, letter) do
        Enum.any?(0..row_count-1, fn(i)-> 
            Enum.any?(0..row_count-1, fn(j)-> 
                board |> elem(i) |> elem(j) == letter
            end)
        end)
    end

    #Find a word according to column axis.
    #This recursion funtion is finished with either "false" return value when there is no word in the board
    #or list of point tuples when that word is in the board.
    def search_a_word_with_column(board, word, row, i, j) do
        if j == row do
            false
        else
            res = find_a_word(board, word, i, j, row, 0, [])
            if res != false do
                res
            else
                search_a_word_with_column(board, word, row, i, j+1)
            end
        end
    end

    #Find a word according to row axis.
    #This recursion funtion is finished with either "false" return value when there is no word in the board
    #or list of point tuples when that word is in the board.
    def search_a_word_with_row(board, word, row, i) do
        if i == row do
            false
        else
            res = search_a_word_with_column(board, word, row, i, 0)
            if res != false do
                res
            else
                search_a_word_with_row(board, word, row, i+1)
            end
        end
    end

    #Search a word.
    def search_a_word(board, word) do
        row = tuple_size(board)
        res = search_a_word_with_row(board, word, row, 0)
        if res != false do
            res
        else
            false
        end
    end

    # Check if each of given words are exist in the board.
    def wordBoggle(board, words, word_map) do
        row = tuple_size(board)
        if length(words) == 0 do
            word_map
        else
            word = hd(words)
            if get_first_letter_position(board, row, String.first(word)) >= 1 do
                res = search_a_word(board, word)
                if res != false do
                    new_map = Map.put(word_map, to_string(word), res)
                    wordBoggle(board, tl(words), new_map)
                else
                    wordBoggle(board, tl(words), word_map)
                end
            else
                wordBoggle(board, tl(words), word_map)
            end
        end
    end
    
    def boggle(board, words) do
        wordBoggle(board, words, %{})
    end
    
end