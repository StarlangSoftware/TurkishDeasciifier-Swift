//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 31.03.2021.
//

import Foundation
import Dictionary
import Corpus
import MorphologicalAnalysis

public class SimpleDeasciifier : Deasciifier{
    
    var fsm: FsmMorphologicalAnalyzer
    
    /**
     * A constructor of {@link SimpleDeasciifier} class which takes a {@link FsmMorphologicalAnalyzer} as an input and
     * initializes fsm variable with given {@link FsmMorphologicalAnalyzer} input.
     - Parameters:
        - fsm {@link FsmMorphologicalAnalyzer} type input.
     */
    public init(fsm: FsmMorphologicalAnalyzer){
        self.fsm = fsm
    }
    
    /**
     * The deasciify method takes a {@link Sentence} as an input and loops i times where i ranges from 0 to number of
     * words in the given {@link Sentence}. First it gets ith word from given {@link Sentence} and calls candidateList with
     * ith word and assigns the returned {@link ArrayList} to the newly created candidates {@link ArrayList}. And if the size of
     * candidates {@link ArrayList} is greater than 0, it generates a random number and gets the item of candidates {@link ArrayList}
     * at the index of random number and assigns it as a newWord. If the size of candidates {@link ArrayList} is 0, it then
     * directly assigns ith word as the newWord. At the end, it adds newWord to the result {@link Sentence}.
     - Parameters:
        - sentence: {@link Sentence} type input.
     - Returns: result {@link Sentence}.
     */
    func deasciify(sentence: Sentence) -> Sentence {
        let result : Sentence = Sentence()
        for i in 0..<sentence.wordCount() {
            let word = sentence.getWord(index: i)
            var newWord : Word
            let fsmParseList = fsm.morphologicalAnalysis(surfaceForm: word.getName())
            if fsmParseList.size() == 0{
                let candidates = candidateList(word: word)
                if candidates.count > 0 {
                    newWord = Word(name: candidates[Int.random(in: 0..<candidates.count)])
                } else {
                    newWord = word;
                }
            } else {
                newWord = word;
            }
            result.addWord(word: newWord);
        }
        return result;
    }
    
    /**
     * The candidateList method takes a {@link Word} as an input and creates new candidates {@link ArrayList}. First it
     * adds given word to this {@link ArrayList} and calls generateCandidateList method with candidates, given word and
     * index 0. Then, loops i times where i ranges from 0 to size of candidates {@link ArrayList} and calls morphologicalAnalysis
     * method with ith item of candidates {@link ArrayList}. If it does not return any analysis for given item, it removes
     * the item from candidates {@link ArrayList}.
     - Parameters:
        - word: {@link Word} type input.
     - Returns: ArrayList candidates.
     */
    public func candidateList(word: Word) -> [String]{
        var candidates: [String] = []
        candidates.append(word.getName())
        generateCandidateList(candidates: &candidates, word: word.getName(), index: 0)
        var i : Int = 0
        while i < candidates.count {
            let fsmParseList = fsm.morphologicalAnalysis(surfaceForm: candidates[i])
            if fsmParseList.size() == 0 {
                candidates.remove(at: i)
                i -= 1
            }
            i += 1
        }
        return candidates
    }
    
    private func replaceChar(word: String, index: Int, char: String) -> String{
        if index > 0{
            return String(word.prefix(index)) + char + word.dropFirst(index + 1)
        } else {
            return char + word.dropFirst()
        }
    }
    
    /**
     * The generateCandidateList method takes an {@link ArrayList} candidates, a {@link String}, and an integer index as inputs.
     * First, it creates a {@link String} which consists of corresponding Latin versions of special Turkish characters. If given index
     * is less than the length of given word and if the item of word's at given index is one of the chars of {@link String}, it loops
     * given candidates {@link ArrayList}'s size times and substitutes Latin characters with their corresponding Turkish versions
     * and put them to newly created char {@link java.lang.reflect.Array} modified. At the end, it adds each modified item to the candidates
     * {@link ArrayList} as a {@link String} and recursively calls generateCandidateList with next index.
     - Parameters:
        - candidates: {@link ArrayList} type input.
        - word :      {@link String} input.
        - index:      {@link Integer} input.
     */
    private func generateCandidateList(candidates: inout [String], word: String, index: Int){
        let s = "ıiougcsİIOUGCS"
        if index < word.count {
            if s.contains(Word.charAt(s: word, i: index)) {
                let size = candidates.count
                for i in 0..<size {
                    var modified : String = candidates[i]
                    switch Word.charAt(s: word, i: index) {
                        case "ı":
                            modified = replaceChar(word: modified, index: index, char: "i")
                        case "i":
                            modified = replaceChar(word: modified, index: index, char: "ı")
                        case "o":
                            modified = replaceChar(word: modified, index: index, char: "ö")
                        case "u":
                            modified = replaceChar(word: modified, index: index, char: "ü")
                        case "g":
                            modified = replaceChar(word: modified, index: index, char: "ğ")
                        case "c":
                            modified = replaceChar(word: modified, index: index, char: "ç")
                        case "s":
                            modified = replaceChar(word: modified, index: index, char: "ş")
                        case "I":
                            modified = replaceChar(word: modified, index: index, char: "İ")
                        case "İ":
                            modified = replaceChar(word: modified, index: index, char: "I")
                        case "O":
                            modified = replaceChar(word: modified, index: index, char: "Ö")
                        case "U":
                            modified = replaceChar(word: modified, index: index, char: "Ü")
                        case "G":
                            modified = replaceChar(word: modified, index: index, char: "Ğ")
                        case "C":
                            modified = replaceChar(word: modified, index: index, char: "Ç")
                        case "S":
                            modified = replaceChar(word: modified, index: index, char: "Ş")
                        default:
                            break
                    }
                    candidates.append(modified)
                }
            }
            if candidates.count < 10000{
                generateCandidateList(candidates: &candidates, word: word, index: index + 1)
            }
        }
    }
    
}
