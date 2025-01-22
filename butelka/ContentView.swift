import SwiftUI


let backgroundColor = Color(red: 66 / 255, green: 66 / 255, blue: 66 / 255)

struct ContentView: View {
    var body: some View {
        if let gameData = loadGameData() {
            NavigationStack {
                ZStack {
                    backgroundColor
                        .ignoresSafeArea()
                    
                    ZStack(alignment: .topLeading) {
                       NavigationLink(destination: settingsView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                        }
                                VStack {
                                    HStack {
                                        Spacer()
                                        NavigationLink(destination: infoView().navigationBarBackButtonHidden(true)) {
                                            Image(systemName: "info.circle")
                                                .font(.system(size: 30))
                                                .fontWeight(.heavy)
                                                .foregroundStyle(.white)
                                                .padding()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                    
                    VStack(spacing: 150) {
                        
                        HStack {
                            Text("Butelka")
                                .foregroundStyle(.white)
                            
                            Image(systemName: "party.popper")
                                .foregroundStyle(.pink)
                        }
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        
                        VStack {
                            ForEach(gameData.categories, id: \.name) { category in
                                NavigationLink(destination: PlayView(selectedOption: category.name, categories: gameData.categories).navigationBarBackButtonHidden(true)) {
                                    Text(category.name)
                                        .foregroundStyle(.white)
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                        .frame(width: 300, height: 100)
                                        .foregroundColor(.white)
                                        .background(.pink)
                                        .cornerRadius(30)
                                }
                            }
                        }
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

struct infoView: View {
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
                                HStack {
                                    Spacer()
                                    //
                                }
                                Spacer()
                            }
                        }
                VStack {
                    
                        Text("Freaky")
                            .foregroundStyle(.pink)
                        
                        Text("To kategoria dla raczej singli i jest ona dość mocno zboczona.  ")
                    
                    Text("Freaky")
                        .foregroundStyle(.pink)
                    
                    Text("To kategoria dla raczej singli i jest ona dość mocno zboczona.  ")
                    
                    
                    Text("Freaky")
                        .foregroundStyle(.pink)
                    
                    Text("To kategoria dla raczej singli i jest ona dość mocno zboczona.  ")
                    
                }.font(.system(size: 25))
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .padding()
                
                
            }
        }
    }
}


struct settingsView: View {
    
    @State var isDarkModeEnabled: Bool = true
    @State var isTimerEnabled: Bool = false
    @State var downloadViaWifiEnabled: Bool = false
    
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
                                HStack {
                                    Spacer()
                                    //
                                }
                                Spacer()
                            }
                        }
                VStack {

                    Section(header: Text("PREFERENCES").foregroundColor(.white)) {

                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue) // Kolor ikony
                            Toggle(isOn: $isDarkModeEnabled) {
                                Text("Language")
                            }
                        }
                    
                        HStack {
                            Image(systemName: "gearshape")
                                .foregroundColor(.purple) // Kolor ikony
                            Toggle(isOn: $isDarkModeEnabled) {
                                Text("Dark Mode")
                            }
                        }
                        
                    }
                    
                    
                    
                    Section(header: Text("TIMER SETTINGS").foregroundColor(.white)) {
                        
                        
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.red) // Kolor ikony
                            Toggle(isOn: $isTimerEnabled) {
                                Text("Timer")
                            }
                        }
                        
                        
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.red) // Kolor ikony
                            Toggle(isOn: $isTimerEnabled) {
                                Text("Timer")
                            }
                        }

                    }
                                    
                    
                        
                    
                    
                }.font(.system(size: 25))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
                
                
            }
        }

        
    }
}



extension AnyTransition {
    static var flipFromRight: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .modifier(
                active: FlipEffect(angle: -90),
                identity: FlipEffect(angle: 0)
            ),
            removal: .modifier(
                active: FlipEffect(angle: 0),
                identity: FlipEffect(angle: 90)
            )
        )
    }
    
    static var flipFromLeft: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .modifier(
                active: FlipEffect(angle: 90),
                identity: FlipEffect(angle: 0)
            ),
            removal: .modifier(
                active: FlipEffect(angle: 0),
                identity: FlipEffect(angle: -90)
            )
        )
    }
}

struct FlipEffect: ViewModifier {
    let angle: Double
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.5
            )
    }
}

struct LineBreak: View {
    var body: some View {
        Spacer().frame(height: 10) // Odstęp w wysokości 10 punktów
    }
}

#Preview {
    ContentView()
}
