import XCTest
import Dictionary
import Corpus
import MorphologicalAnalysis
@testable import Deasciifier

final class SimpleDeasciifierTest: XCTestCase {
    
    func testDeasciify() {
        let fsm = FsmMorphologicalAnalyzer()
        let simpleDeasciifier = SimpleDeasciifier(fsm: fsm)
        let simpleAsciifier = SimpleAsciifier()
        for i in 0..<fsm.getDictionary().size(){
            let word = fsm.getDictionary().getWordWithIndex(index: i) as! TxtWord
            var count : Int = 0
            for j in 0..<word.getName().count {
                switch Word.charAt(s: word.getName(), i: j){
                    case "ç", "ö", "ğ", "ü", "ş", "ı":
                        count += 1
                    default:
                        break
                }
            }
            if count > 0 && !word.getName().hasSuffix("fulü") && (word.isNominal() || word.isAdjective() || word.isAdverb() || word.isVerb()){
                let asciified = simpleAsciifier.asciify(word: word)
                if simpleDeasciifier.candidateList(word: Word(name: asciified)).count == 1{
                    let deasciified = simpleDeasciifier.deasciify(sentence: Sentence(sentence: asciified)).description()
                    XCTAssertEqual(word.getName(), deasciified)
                }
            }
        }
    }

    static var allTests = [
        ("testExample", testDeasciify),
    ]
}
