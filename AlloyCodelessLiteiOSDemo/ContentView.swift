//
//  ContentView.swift
//  AlloyCodelessLiteiOSDemo
//

import alloy_codeless_lite_ios
import SwiftUI

struct ContentView: View {

    @State private var startAlloy = false
    @State private var resumeJourney = false
    @State private var textResul: String?
    @State private var resultJourney: JourneyDataResponse?
    @State private var showResultJourney: Bool = false
    @State private var disabledResume: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("Logo")
                .renderingMode(.original)
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical, 32)

            Text("**Alloy Codeless Demo**")
                .font(.system(size: 24))
            Spacer()
            VStack (spacing: 24) {
                Button {
                    Task {



                        let theme = CustomTheme(
                            primaryColor: "#0000FF",
                            backgroundColor: "#000000",
                            textColor: "#FFFFFF"
                        )

                        let alloySettings = AlloySettings(
                            // *** this key is part of a working example ***
                            // You should obtain your key from the alloy dashboard
                            // On settings > SDK Config
                            apiKey: "679663b8-d73a-423b-80e9-3ac8ec698c3c",
                            production: false,
                            realProduction: true,
                            codelessFinalValidation: false,
                            showHeader: false,
                            showDebugInfo: true,
                            journeyToken: "J-72ADYuJif7FOiDsYZoRE",
                            journeyApplicationToken: "JA-pY7VpIPaWddItw2QfIpp",
                            appUrl: "https://corekube-dev-alloysdk.app.alloy.com",
                            apiUrl: "https://corekube-dev-alloysdk.api.alloy.com",
                            entityToken: "P-99ipW7Xtx88RdxfN2Rpr",
                            isSingleEntity: true,
                            customTheme: theme
                        )

                        let authInitResult: AuthInitResult = try await AlloyCodelessLiteiOS.shared.authInit(alloySettings: alloySettings)
                        if authInitResult.resultCode == AuthInitResultErrorCode.RESULT_ERROR {
                            textResul = "Result SDK init: \(authInitResult.resultMessage)"
                            print("Init SDK ERROR: \(authInitResult.resultMessage)")
                        } else {
                            startAlloy.toggle()
                            print("Init SDK OK: \(authInitResult)")
                        }
                    }
                } label: {
                    HStack() {
                        Image(systemName: "play.circle")
                            .padding(.leading, 16)
                        Text("Start Alloy")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 64, alignment: .leading)
                    }
                }
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))

                Button {
                    Task {
                        if !resumeJourney {
                            resumeJourney.toggle()

                            let journeySettings = JourneySettings(
                                journeyToken: "J-72ADYuJif7FOiDsYZoRE",
                                journeyApplicationToken: "JA-pY7VpIPaWddItw2QfIpp",
                                production: false,
                                showDebugInfo: true
                            )
                            let journeyResult = try await AlloyCodelessLiteiOS.shared.startJourney(journeySettings: journeySettings, onFinish: { data in
                                print("Journey status: \(data?.finishResultMessage ?? "")")
                                showResultJourney.toggle()
                            })
                            if let resultJourney = journeyResult?.journeyResultData {
                                self.resultJourney = resultJourney
                            }
                            if journeyResult?.resultCode == StartJourneyResultErrorCode.RESULT_ERROR {
                                textResul = "\(journeyResult?.resultMessage ?? "")"
                                print ("\(journeyResult?.resultMessage ?? "")")
                            } else {
                                if let journeyResult = journeyResult {
                                    print("Result: The Journey has been init sucessfull \(journeyResult)")
                                }
                            }
                        } else {
                            try await AlloyCodelessLiteiOS.shared.checkStatusJourney(onFinish: { result in
                                showResultJourney.toggle()
                            })
                        }
                    }
                } label: {
                    HStack() {
                        Image(systemName: "point.3.connected.trianglepath.dotted")
                            .padding(.leading, 16)
                            .tint( startAlloy ? .black : .white)
                        Text(resumeJourney ? "Resume Journey" : "Start Journey")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 64, alignment: .leading)
                    }
                }
                .background(startAlloy ? .white : Color(uiColor: UIColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 1.00)))
                .foregroundColor(startAlloy ? .black : .white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray))
                .disabled(!startAlloy)
            }

            Spacer()

        }
        .padding(.horizontal, 32)

        .onChange(of: showResultJourney) { _ in
            Task {
                do {
                    print(" --- JOURNEY IN PROGESS ----------")
                    guard let data = try await AlloyCodelessLiteiOS.shared.getJourneyData() else { return }
                    print("\(data)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    
