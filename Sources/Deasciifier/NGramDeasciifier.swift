//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 31.03.2021.
//

import Foundation
import NGram
import MorphologicalAnalysis
import Corpus
import Dictionary

public class NGramDeasciifier : SimpleDeasciifier{
    
    private var nGram : NGram<String>
    private var rootNGram: Bool = true
    private var threshold: Double = 0.0
    private var asciifiedSame: [String : String] = [:]
    
    /**
     * A constructor of {@link NGramDeasciifier} class which takes an {@link FsmMorphologicalAnalyzer} and an {@link NGram}
     * as inputs. It first calls it super class {@link SimpleDeasciifier} with given {@link FsmMorphologicalAnalyzer} input
     * then initializes nGram variable with given {@link NGram} input.
     - Parameters:
        - fsm:   {@link FsmMorphologicalAnalyzer} type input.
        - nGram: {@link NGram} type input.
        - rootNGram: True if the NGram have been constructed for the root words, false otherwise.
     */
    public init(fsm: FsmMorphologicalAnalyzer, nGram: NGram<String>, rootNGram: Bool){
        self.nGram = nGram
        self.rootNGram = rootNGram
        super.init(fsm: fsm)
        self.loadAsciifiedSameList()
    }
    
    /**
     * Checks the morphological analysis of the given word in the given index. If there is no misspelling, it returns
     * the longest root word of the possible analyses.
     - Parameters:
        - sentence: Sentence to be analyzed.
        - index: Index of the word
     - Returns: If the word is misspelled, null; otherwise the longest root word of the possible analyses.
     */
    private func checkAnalysisAndSetRoot(sentence: Sentence, index: Int) -> Word?{
        if index < sentence.wordCount() {
            let fsmParses = fsm.morphologicalAnalysis(surfaceForm: sentence.getWord(index: index).getName())
            if fsmParses.size() != 0 {
                if rootNGram{
                    return fsmParses.getParseWithLongestRootWord().getWord()
                } else {
                    return sentence.getWord(index: index)
                }
            }
        }
        return nil
    }
    
    public func setThreshold(threshold: Double){
        self.threshold = threshold
    }
    
    private func getProbability(word1: String, word2: String) -> Double{
        return nGram.getProbability(word1, word2)
    }
    
    /**
     * The deasciify method takes a {@link Sentence} as an input. First it creates a String {@link ArrayList} as candidates,
     * and a {@link Sentence} result. Then, loops i times where i ranges from 0 to words size of given sentence. It gets the
     * current word and generates a candidateList with this current word then, it loops through the candidateList. First it
     * calls morphologicalAnalysis method with current candidate and gets the first item as root word. If it is the first root,
     * it gets its N-gram probability, if there are also other roots, it gets probability of these roots and finds out the
     * best candidate, best root and the best probability. At the nd, it adds the bestCandidate to the bestCandidate {@link ArrayList}.
     - Parameters:
        - sentence: {@link Sentence} type input.
     - Returns: Sentence result as output.
     */
    public override func deasciify(sentence: Sentence) -> Sentence {
        let s : Sentence = sentence
        let result : Sentence = Sentence()
        var root : Word? = checkAnalysisAndSetRoot(sentence: s, index: 0)
        var previousRoot : Word? = nil
        var nextRoot = checkAnalysisAndSetRoot(sentence: s, index: 1)
        var previousProbability, nextProbability: Double
        var isAsciifiedSame: Bool
        var candidates: [String] = []
        for i in 0..<s.wordCount() {
            candidates = []
            isAsciifiedSame = false
            let word = s.getWord(index: i)
            if asciifiedSame[word.getName()] != nil{
                candidates.append(word.getName())
                candidates.append(asciifiedSame[word.getName()]!)
                isAsciifiedSame = true
            }
            if root == nil || isAsciifiedSame{
                if !isAsciifiedSame{
                    candidates = candidateList(word: word)
                }
                var bestCandidate : String = word.getName()
                var bestRoot : Word = word
                var bestProbability : Double = threshold
                for candidate in candidates {
                    let fsmParses = fsm.morphologicalAnalysis(surfaceForm: candidate)
                    if rootNGram && !isAsciifiedSame{
                        root = fsmParses.getParseWithLongestRootWord().getWord();
                    } else {
                        root = Word(name: candidate)
                    }
                    if previousRoot != nil {
                        previousProbability = getProbability(word1: previousRoot!.getName(), word2: root!.getName())
                    } else {
                        previousProbability = 0.0
                    }
                    if nextRoot != nil {
                        nextProbability = getProbability(word1: root!.getName(), word2: nextRoot!.getName())
                    } else {
                        nextProbability = 0.0
                    }
                    if max(previousProbability, nextProbability) > bestProbability {
                        bestCandidate = candidate
                        bestRoot = root!
                        bestProbability = max(previousProbability, nextProbability)
                    }
                }
                root = bestRoot
                result.addWord(word: Word(name: bestCandidate))
            } else {
                result.addWord(word: word)
            }
            previousRoot = root
            root = nextRoot!
            nextRoot = checkAnalysisAndSetRoot(sentence: s, index: i + 2)
        }
        return result
    }
    
    private func loadAsciifiedSameList(){
        let myUrl = Bundle.module.url(forResource: "asciified-same", withExtension: "txt")
        do{
            let fileContent = try String(contentsOf: myUrl!, encoding: .utf8)
            let lines : [String] = fileContent.split(whereSeparator: \.isNewline).map(String.init)
            for line in lines{
                let wordList : [String] = line.split(separator: " ").map(String.init)
                self.asciifiedSame[wordList[0]] = wordList[1]
            }
        }catch{
        }
    }
}
