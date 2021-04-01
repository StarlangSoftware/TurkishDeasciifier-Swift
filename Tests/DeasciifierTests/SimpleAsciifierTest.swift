import XCTest
import Dictionary
import Corpus
@testable import Deasciifier

final class SimpleAsciifierTest: XCTestCase {
    
    var simpleAsciifier : SimpleAsciifier = SimpleAsciifier()
  
    func testWordAsciify() {
        XCTAssertEqual("cogusiCOGUSI", simpleAsciifier.asciify(word: Word(name: "çöğüşıÇÖĞÜŞİ")))
        XCTAssertEqual("sogus", simpleAsciifier.asciify(word: Word(name: "söğüş")))
        XCTAssertEqual("uckagitcilik", simpleAsciifier.asciify(word: Word(name: "üçkağıtçılık")))
        XCTAssertEqual("akiskanlistiricilik", simpleAsciifier.asciify(word: Word(name: "akışkanlıştırıcılık")))
        XCTAssertEqual("citcitcilik", simpleAsciifier.asciify(word: Word(name: "çıtçıtçılık")))
        XCTAssertEqual("duskirikligi", simpleAsciifier.asciify(word: Word(name: "düşkırıklığı")))
        XCTAssertEqual("yuzgorumlugu", simpleAsciifier.asciify(word: Word(name: "yüzgörümlüğü")))
    }

    func testSentenceAsciify() {
        XCTAssertEqual(Sentence(sentence: "cogus iii COGUSI").description(), simpleAsciifier.asciify(sentence: Sentence(sentence: "çöğüş ııı ÇÖĞÜŞİ")).description())
        XCTAssertEqual(Sentence(sentence: "uckagitcilik akiskanlistiricilik").description(), simpleAsciifier.asciify(sentence: Sentence(sentence: "üçkağıtçılık akışkanlıştırıcılık")).description())
        XCTAssertEqual(Sentence(sentence: "citcitcilik duskirikligi yuzgorumlugu").description(), simpleAsciifier.asciify(sentence: Sentence(sentence: "çıtçıtçılık düşkırıklığı yüzgörümlüğü")).description())
    }

    static var allTests = [
        ("testExample", testWordAsciify),
    ]
}
