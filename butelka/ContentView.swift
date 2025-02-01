import SwiftUI

// Kolor tła aplikacji
let backgroundColor = Color(red: 66 / 255, green: 66 / 255, blue: 66 / 255)

struct ContentView: View {
    var body: some View {
        if let gameData = loadGameData() {
            NavigationStack {
                ZStack {
                    backgroundColor.ignoresSafeArea()
                    
                    VStack(spacing: 80) {
                        HStack {
                            Text("Butelka")
                                .foregroundStyle(.white)
                            Image(systemName: "party.popper")
                                .foregroundStyle(.pink)
                        }
                        .font(.system(size: 50, weight: .heavy))
                        
                        VStack {
                            // Generowanie kategorii z pliku JSON
                            ForEach(gameData.categories, id: \.name) { category in
                                CategoryButton(title: category.name, color: .pink) {
                                    PlayView(selectedOption: category.name, categories: gameData.categories)
                                }
                            }
                            
                            // Tymczasowy przycisk dla "Never Have I Ever"
                            CategoryButton(title: "Never have I ever", color: .blue) {
                                settingsView()
                            }
                        }
                    }
                    
                    // Ikony ustawień i informacji
                    VStack {
                        HStack {
                            NavigationLink(destination: settingsView().navigationBarBackButtonHidden(true)) {
                                IconButton(systemName: "gearshape")
                            }
                            Spacer()
                            NavigationLink(destination: infoView().navigationBarBackButtonHidden(true)) {
                                IconButton(systemName: "info.circle")
                            }
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        } else {
            Text("Nie udało się wczytać danych.")
                .font(.largeTitle)
                .foregroundColor(.red)
        }
    }
}

// Komponent ikony
struct IconButton: View {
    let systemName: String
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 30, weight: .heavy))
            .foregroundStyle(.white)
    }
}

// Komponent przycisku kategorii
struct CategoryButton<Destination: View>: View {
    let title: String
    let color: Color
    let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination().navigationBarBackButtonHidden(true)) {
            Text(title)
                .font(.largeTitle.bold())
                .frame(width: 300, height: 100)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(30)
        }
    }
}

// Widok informacji
struct infoView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                VStack(alignment: .leading){
                    HStack {
                        CloseButton()
                        Text("Settings")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Spacer()
                            .ignoresSafeArea()
                    }

                    Text("Zboczone").foregroundStyle(.pink)
                    Text("To kategoria dla raczej singli i jest ona dość mocno zboczona.")
                    
                    Text("Uczuciowe").foregroundStyle(.pink)
                    Text("To kategoria dla raczej singli i jest ona dość mocno zboczona.")

                    Text("Zabawne").foregroundStyle(.pink)
                    Text("To kategoria dla raczej singli i jest ona dość mocno zboczona.")
                    Spacer()

                }
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

// Komponent przycisku zamykania
struct CloseButton: View {
    var body: some View {
        HStack {
            NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                IconButton(systemName: "xmark")
            }
            Spacer()
        }
        .padding()
    }
}


struct settingsView: View {
    
    @AppStorage("isDarkModeEnabled") var isDarkModeEnabled: Bool = true
    @AppStorage("isTimerEnabled") var isTimerEnabled: Bool = false
    @AppStorage("selectedTime") var selectedTime: Int = 30
    @AppStorage("selectedLanguage") var selectedLanguage: String = "Polish"
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                                
                VStack {
                                        
                    // Pasek nagłówkowy z przyciskiem zamknięcia
                    HStack {
                        CloseButton()
                        Text("Settings")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Spacer()
                            .ignoresSafeArea()
                    }
                    
                    // Ustawienia aplikacji
                    SettingsSection(title: "PREFERENCES") {
                        SettingsRow(icon: "globe", text: "Language") {
                            Menu(selectedLanguage) {
                                ForEach(["Polish", "English", "French", "German"], id: \.self) { lang in
                                    Button(lang) { selectedLanguage = lang }
                                }
                            }
                            .foregroundStyle(.white)
                            .buttonStyle(.bordered)
                        }
                    }
                    
                    SettingsSection(title: "TIMER SETTINGS") {
                        ToggleSetting(icon: "timer", text: "Enable Timer", isOn: $isTimerEnabled)
                        
                        if isTimerEnabled {
                            SettingsRow(icon: "clock", text: "Time") {
                                Menu("\(selectedTime) s") {
                                    ForEach([15, 30, 60, 180], id: \.self) { time in
                                        Button("\(time) s") { selectedTime = time }
                                    }
                                }
                                .foregroundStyle(.white)
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

// Komponent sekcji ustawień
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .foregroundStyle(.white)
                .font(.headline)
            content
        }
        .padding(.vertical, 10)
    }
}

// Komponent pojedynczego wiersza w ustawieniach
struct SettingsRow<Content: View>: View {
    let icon: String
    let text: String
    let content: Content
    
    init(icon: String, text: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.text = text
        self.content = content()
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
            Spacer()
            content
        }
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(.white)
    }
}

// Komponent dla przełączników (Toggle)
struct ToggleSetting: View {
    let icon: String
    let text: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.red)
            Toggle(isOn: $isOn) {
                Text(text)
            }
        }
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(.white)
    }
}
