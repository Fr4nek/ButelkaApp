import SwiftUI

struct Category: Codable {
    let name: String
    let questions: [String]
    let challenges: [String]
}

struct GameData: Codable {
    let categories: [Category]
}

// Funkcja wczytująca dane z pliku JSON
func loadGameData() -> GameData? {
    if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            return try? decoder.decode(GameData.self, from: data)
        }
    }
    return nil
}

// Funkcje losujące pytania i wyzwania
func getRandomQuestion(from category: Category) -> String {
    return category.questions.randomElement() ?? "Brak pytań"
}

func getRandomChallenge(from category: Category) -> String {
    return category.challenges.randomElement() ?? "Brak wyzwań"
}

struct PlayView: View {
    let selectedOption: String
    let categories: [Category]
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "xmark")
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Text(selectedOption)
                        }
                        .font(.system(size: 45))
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        
                        Spacer()
                        
                        VStack(spacing: 16) {
                            if let selectedCategory = categories.first(where: { $0.name == selectedOption }) {
                                NavigationLink(destination: QuestView(themeColor: .pink, content: getRandomQuestion(from: selectedCategory), potemToZmienie: selectedOption).navigationBarBackButtonHidden(true)) {
                                    Text("Pytanie")
                                        .font(.system(size: 50))
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(width: 330, height: 245)
                                        .padding()
                                        .background(.pink)
                                        .cornerRadius(20)
                                }
                                
                                NavigationLink(destination: QuestView(themeColor: .blue, content: getRandomChallenge(from: selectedCategory), potemToZmienie: selectedOption).navigationBarBackButtonHidden(true)) {
                                    Text("Wyzwanie")
                                        .font(.system(size: 50))
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(width: 330, height: 250)
                                        .padding()
                                        .background(.blue)
                                        .cornerRadius(20)
                                }
                            } else {
                                Text("Brak danych dla tej kategorii")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct QuestView: View {
    let themeColor: Color
    let content: String
    let potemToZmienie: String

    @AppStorage("selectedTime") var selectedTime: Int = 30
    @State private var timeRemaining: Int = 0
    @State private var timerRunning: Bool = false
    @AppStorage("isTimerEnabled") var isTimerEnabled: Bool = false

    @State private var fixedContent: String?  // Nowa zmienna do przechowywania treści pytania/wyzwania

    var body: some View {
        NavigationStack {
            ZStack {
                themeColor
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    if isTimerEnabled {
                        Text("\(timeRemaining) s")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Text(fixedContent ?? content) // Używamy zapamiętanej wartości
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()

                    NavigationLink(destination: PlayView(selectedOption: potemToZmienie, categories: loadGameData()?.categories ?? []).navigationBarBackButtonHidden(true)) {
                        Text("Next")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.heavy)
                            .frame(width: 120, height: 70)
                            .background(Color(red: 66 / 255, green: 66 / 255, blue: 66 / 255))
                            .cornerRadius(30)
                    }
                }
            }
            .onAppear {
                if fixedContent == nil { // Zapisujemy treść tylko raz!
                    fixedContent = content
                }
                timeRemaining = selectedTime
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
    }

    private func startTimer() {
        timerRunning = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                timerRunning = false
            }
        }
    }

    private func stopTimer() {
        timerRunning = false
    }
}

#Preview {
    ContentView()
}
