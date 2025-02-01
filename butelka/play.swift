import SwiftUI

struct Category: Codable {
    let name: String
    let questions: [String]
    let challenges: [String]
}

struct GameData: Codable {
    let categories: [Category]
}

// Wczytywanie danych JSON
func loadGameData() -> GameData? {
    guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let decodedData = try? JSONDecoder().decode(GameData.self, from: data) else {
        return nil
    }
    return decodedData
}

func getRandomElement(from array: [String]) -> String {
    array.randomElement() ?? "Brak danych"
}

// Ekran gry
struct PlayView: View {
    let selectedOption: String
    let categories: [Category]
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack {
                    CloseButton()
                    Spacer()
                    Text(selectedOption)
                        .font(.system(size: 45, weight: .heavy))
                        .foregroundStyle(.white)
                    Spacer()
                    
                    if let category = categories.first(where: { $0.name == selectedOption }) {
                        TruthOrDareButton(title: "Pytanie", color: .pink) {
                            TruthOrDarePlay(themeColor: .pink, content: getRandomElement(from: category.questions), category: selectedOption)
                        }
                        TruthOrDareButton(title: "Wyzwanie", color: .blue) {
                            TruthOrDarePlay(themeColor: .blue, content: getRandomElement(from: category.challenges), category: selectedOption)
                        }
                    } else {
                        Text("Brak danych dla tej kategorii").foregroundColor(.white)
                    }
                }
            }
        }
    }
}

// Widok pytania lub wyzwania
struct TruthOrDarePlay: View {
    
    let themeColor: Color
    let content: String
    let category: String

    @AppStorage("selectedTime") var selectedTime: Int = 30
    @AppStorage("isTimerEnabled") var isTimerEnabled: Bool = false
    
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            ZStack {
                themeColor.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if isTimerEnabled {
                        Text("Pozostały czas: \(timeRemaining) s")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                    Text(content)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding()
                    NavigationLink(destination: PlayView(selectedOption: category, categories: loadGameData()?.categories ?? []).navigationBarBackButtonHidden(true)) {
                        Text("Next")
                            .font(.title.bold())
                            .frame(width: 120, height: 70)
                            .background(backgroundColor)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                }
            }
            .onAppear {
                timeRemaining = selectedTime
                if isTimerEnabled {
                    startTimer()
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}



// Komponent przycisku kategorii
struct TruthOrDareButton<Destination: View>: View {
    let title: String
    let color: Color
    let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination().navigationBarBackButtonHidden(true)) {
            Text(title)
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(width: 330, height: 250)
                .padding()
                .background(color)
                .cornerRadius(20)
        }
    }
}
