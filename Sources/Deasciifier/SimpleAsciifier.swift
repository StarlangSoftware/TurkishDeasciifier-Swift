//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 31.03.2021.
//

import Foundation
import Dictionary
import Corpus

public class SimpleAsciifier : Asciifier{
    
    /**
     * Another asciify method which takes a {@link Sentence} as an input. It loops i times where i ranges form 0 to number of
     * words in the given sentence. First it gets each word and calls asciify with current word and creates {@link Word}
     * with returned String. At the and, adds each newly created ascified words to the result {@link Sentence}.
     - Parameters:
        - sentence: {@link Sentence} type input.
     - Returns: Sentence output which is asciified.
     */
    func asciify(sentence: Sentence) -> Sentence {
        let result : Sentence = Sentence()
        for i in 0..<sentence.wordCount() {
            let word = sentence.getWord(index: i)
            let newWord = Word(name: asciify(word: word))
            result.addWord(word: newWord)
        }
        return result
    }
    
    /**
     * The asciify method takes a {@link Word} as an input and converts it to a char {@link java.lang.reflect.Array}. Then,
     * loops i times where i ranges from 0 to length of the char {@link java.lang.reflect.Array} and substitutes Turkish
     * characters with their corresponding Latin versions and returns it as a new {@link String}.
     - Parameters:
        - word: {@link Word} type input to asciify.
     - Returns: String output which is asciified.
     */
    public func asciify(word: Word) -> String{
        var result : String = ""
        for i in 0..<word.charCount(){
            switch Word.charAt(s: word.getName(), i: i) {
                case "ç":
                    result += "c"
                case "ö":
                    result += "o"
                case "ğ":
                    result += "g"
                case "ü":
                    result += "u"
                case "ş":
                    result += "s"
                case "ı":
                    result += "i"
                case "Ç":
                    result += "C"
                case "Ö":
                    result += "O"
                case "Ğ":
                    result += "G"
                case "Ü":
                    result += "U"
                case "Ş":
                    result += "S"
                case "İ":
                    result += "I"
                default:
                    result += String(Word.charAt(s: word.getName(), i: i))
            }
        }
        return result
    }
    
}
