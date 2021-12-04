This tool is used to turn Turkish text written in ASCII characters, which do not include some letters of the Turkish alphabet, into correctly written text with the appropriate Turkish characters (such as ı, ş, and so forth). It can also do the opposite, turning Turkish input into ASCII text, for the purpose of processing.

For Developers
============

You can also see [Java](https://github.com/starlangsoftware/TurkishDeasciifier), [Python](https://github.com/starlangsoftware/TurkishDeasciifier-Py), [Cython](https://github.com/starlangsoftware/TurkishDeasciifier-Cy), [C++](https://github.com/starlangsoftware/TurkishDeasciifier-CPP), [Js](https://github.com/starlangsoftware/TurkishDeasciifier-Js), or [C#](https://github.com/starlangsoftware/TurkishDeasciifier-CS) repository.

## Requirements

* Xcode Editor
* [Git](#git)

### Git

Install the [latest version of Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Download Code

In order to work on code, create a fork from GitHub page. 
Use Git for cloning the code to your local or below line for Ubuntu:

	git clone <your-fork-git-link>

A directory called NGram-Swift will be created. Or you can use below link for exploring the code:

	git clone https://github.com/starlangsoftware/TurkishDeasciifier-Swift.git

## Open project with XCode

To import projects from Git with version control:

* XCode IDE, select Clone an Existing Project.

* In the Import window, paste github URL.

* Click Clone.

Result: The imported project is listed in the Project Explorer view and files are loaded.


## Compile

**From IDE**

After being done with the downloading and opening project, select **Build** option from **Product** menu. After compilation process, user can run TurkishDeasciifier-Swift.

Detailed Description
============

+ [Asciifier](#using-asciifier)
+ [Deasciifier](#using-deasciifier)

## Using Asciifier

Asciifier converts text to a format containing only ASCII letters. This can be instantiated and used as follows:

      Asciifier asciifier = SimpleAsciifier()
      Sentence sentence = Sentence("çocuk"")
      Sentence asciified = asciifier.asciify(sentence)

Output:
    
    cocuk      

## Using Deasciifier

Deasciifier converts text written with only ASCII letters to its correct form using corresponding letters in Turkish alphabet. There are two types of `Deasciifier`:


* `SimpleDeasciifier`

    The instantiation can be done as follows:  
    
        let fsm = FsmMorphologicalAnalyzer()
        let deasciifier = SimpleDeasciifier(fsm)
     
* `NGramDeasciifier`
    
    * To create an instance of this, both a `FsmMorphologicalAnalyzer` and a `NGram` is required. 
    
    * `FsmMorphologicalAnalyzer` can be instantiated as follows:
        
            let fsm = FsmMorphologicalAnalyzer()
    
    * `NGram` can be either trained from scratch or loaded from an existing model.
        
        * Training from scratch:
                
                let corpus = Corpus("corpus.txt"); 
                let ngram = NGram(corpus.getAllWordsAsArrayList(), 1)
                ngram.calculateNGramProbabilities(LaplaceSmoothing())
                
        *There are many smoothing methods available. For other smoothing methods, check [here](https://github.com/StarlangSoftware/NGram-CS).*       
        * Loading from an existing model:
     
                    let ngram = NGram("ngram.txt")

	*For further details, please check [here](https://github.com/StarlangSoftware/NGram-CS).*        
            
    * Afterwards, `NGramDeasciifier` can be created as below:
        
            let deasciifier = NGramDeasciifier(fsm, ngram)
     
A text can be deasciified as follows:
     
    Sentence sentence = Sentence("cocuk")
    Sentence deasciified = deasciifier.deasciify(sentence)
    
Output:

    çocuk
