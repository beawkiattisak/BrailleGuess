import AVFoundation
import SwiftUI

struct BrailleKeyboardView: View {
    @State private var dot1: Bool = false
    @State private var dot2: Bool = false
    @State private var dot3: Bool = false
    @State private var dot4: Bool = false
    @State private var dot5: Bool = false
    @State private var dot6: Bool = false
    @State private var txt: String = ""
    @State private var word: String = ""
    @State private var synth = AVSpeechSynthesizer()
    @State private var utterance = AVSpeechUtterance()
    @State private var speakTxt: String = ""
    @State private var isLongPressed = false
    @State private var myWord: String = ""
    @State private var score = 0
    @State private var begin = false
    
    var totalPlay = 0
    
    let answer = [
        "CAT",
        "ANT",
        "DOG",
        "BIRD",
        "BEE",
    ]
    let hint = [
        "Animal has four legs and a tail and love to play with toys, start with the letter C",
        "Tiny animal, an insect, is known for its ability to carry many times its own weight, starts with the letter A",
        "Furry animal known for its loyalty and affection towards humans, starting with the letter D",
        "This animal is known for its ability to fly through the air, start with the letter B",
        "This animal is known for its ability they can produce honey, start with letter B",
    ]
    var randomIndex = -1
    @State private var answerRandom = ""
    @State private var hintRandom: String = ""
    
    init() {
        selectRandomHintAndAnswer()
    }
    
    
    func selectRandomHintAndAnswer() {
        let randomIndex = Int.random(in: 0..<answer.count)
            hintRandom = hint[randomIndex]
            answerRandom = answer[randomIndex]
    }
    
    let brailleCodes: [String: String] = [
        "1": "A",
        "12": "B",
        "14": "C",
        "145": "D",
        "15": "E",
        "124": "F",
        "1245": "G",
        "125": "H",
        "24": "I",
        "245": "J",
        "13": "K",
        "123": "L",
        "134": "M",
        "1345": "N",
        "135": "O",
        "1234": "P",
        "12345": "Q",
        "1235": "R",
        "234": "S",
        "2345": "T",
        "136": "U",
        "1236": "V",
        "2456": "W",
        "1346": "X",
        "13456": "Y",
        "1356": "Z",
    ]
    // Start Game
    
    func startGame() {
        selectRandomHintAndAnswer()
        let utterance = AVSpeechUtterance(string: "Now the game has begin the first hint is, \(hintRandom)")
        utterance.rate = 0.39
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    // Update Text
    func updateText() {
        let dotString =
        "\(dot1 ? "1" : "")\(dot2 ? "2" : "")\(dot3 ? "3" : "")\(dot4 ? "4" : "")\(dot5 ? "5" : "")\(dot6 ? "6" : "")"
        if let letter = self.brailleCodes[dotString] {
            self.txt = letter
        } else {
            self.txt = ""
        }
        
        if dotString == "123456" {
            if begin == false {
                startGame()
                resetDots()
                
                self.begin = true
            }
            
        }
    }
    
    // Speak Text
    func speakText() {
        let utterance = AVSpeechUtterance(string: self.speakTxt.lowercased())
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    // Reset Dots
    func resetDots() {
        self.dot1 = false
        self.dot2 = false
        self.dot3 = false
        self.dot4 = false
        self.dot5 = false
        self.dot6 = false
        self.updateText()
    }
    
    // Save Letter
    func saveLetter() {
        self.word += self.txt
        self.speakTxt = self.txt
        
        self.resetDots()
        
        self.speakText()
    }
    
    // Delete Letter
    func deleteLetter() {
        if !self.word.isEmpty {
            self.word.removeLast()
        }
    }
    
    func speakHint() {
        let utterance = AVSpeechUtterance(string: "The hint is \(self.hintRandom)")
        utterance.rate = 0.39
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    func speakScore() {
        let utterance = AVSpeechUtterance(string: "now you have score \(self.score) point.")
        utterance.rate = 0.39
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    func checkAnswer() {
        
        let utterance = AVSpeechUtterance(string: "Your answer is \(self.word) ")
        utterance.rate = 0.39
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
        
        if self.word.lowercased() == self.answerRandom.lowercased() {
            let utterance = AVSpeechUtterance(string: "your answer is correct")
            utterance.rate = 0.39
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
            self.score += 1
            speakScore()
            resetGame()
            
        } else {
            let utterance = AVSpeechUtterance(
                string: "your answer is incorrect please try again the hint is \(self.hintRandom)")
            utterance.rate = 0.39
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
            
            self.word = ""
            
        }
    }
    
    func resetGame() {
        self.word = ""
        selectRandomHintAndAnswer()
        let utterance = AVSpeechUtterance(string: "the next question is \(self.hintRandom)")
        utterance.rate = 0.39
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synth.speak(utterance)
    }
    
    
    var body: some View {
        

        
        VStack {
            Spacer()
            VStack {
                HStack {
                    
                    // 4
                    Button(action: {
                        self.dot4.toggle()
                        self.updateText()
                    }) {
                        Image(systemName: "4.circle.fill")
                            .font(.system(size: 90))
                            .foregroundColor(self.dot4 ? .red : .blue)
                    }.padding(.horizontal, 40)
                    
                    // Game View (Text Field)
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue, lineWidth: 4)
                            .frame(width: 350, height: 60)
                        Text(word)
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .frame(width: 350, height: 60)
                    }
                    
                    // 1
                    Button(action: {
                        self.dot1.toggle()
                        self.updateText()
                    }) {
                        Image(systemName: "1.circle.fill")
                            .font(.system(size: 90))
                            .foregroundColor(self.dot1 ? .red : .blue)
                    }.padding(.horizontal, 40)
                    
                }  // END HSTACK
                
                HStack {
                    
                    // 5
                    Button(action: {
                        self.dot5.toggle()
                        self.updateText()
                        
                    }) {
                        Image(systemName: "5.circle.fill")
                            .font(.system(size: 90))
                            .foregroundColor(self.dot5 ? .red : .blue)
                    }.padding(.horizontal, 130)
                    
                    HStack {
                        ZStack {
                            
                            // Enter Button
                            Button(action: {
                                saveLetter()
                                
                            }) {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.black, lineWidth: 8)
                                    .frame(width: 150, height: 80)
                                    .background(.green)
                                    .cornerRadius(16)
                            }
                            Text("Enter")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 1)
                                .onEnded { _ in
                                    self.isLongPressed = true
                                    checkAnswer()
                                    
                                }
                        )
                        
                        ZStack {
                            
                            // Remove
                            Button(action: {
                                deleteLetter()
                                let utterance = AVSpeechUtterance(string: "Remove")
                                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                                synth.speak(utterance)
                                resetDots()
                            }) {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.black, lineWidth: 8)
                                    .frame(width: 150, height: 80)
                                    .background(.red)
                                    .cornerRadius(16)
                            }
                            Text("Remove")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }.frame(width: 30)
                    
                    // 2
                    Button(action: {
                        self.dot2.toggle()
                        self.updateText()
                        
                    }) {
                        Image(systemName: "2.circle.fill")
                            .font(.system(size: 90))
                            .foregroundColor(self.dot2 ? .red : .blue)
                    }.padding(.horizontal, 130)
                }
                
                
                HStack {
                    
                    // 6
                    Button(action: {
                        self.dot6.toggle()
                        self.updateText()
                        
                    }) {
                        Image(systemName: "6.circle.fill")
                            .font(.system(size: 90))
                            .foregroundColor(self.dot6 ? .red : .blue)
                    }.padding(.horizontal, 180)
                    
                    // Preview Text at the bottom
                    Text("\(self.txt)")
                        .fontWeight(.regular)
                        .font(.system(size: 60))
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    
                    // 3
                    Button(action: {
                        self.dot3.toggle()
                        self.updateText()
                    }) {
                        Image(systemName: "3.circle.fill")
                            .font(.system(size: 90))
                            .foregroundColor(self.dot3 ? .red : .blue)
                    }.padding(.horizontal, 180)
                }
            }  // VSTACK
        }.frame(width: 400, height: 150, alignment: .center)
        
    }
}

struct BrailleKeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        BrailleKeyboardView()
    }
}
