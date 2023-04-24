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
                        let alloySettings = AlloySettings(
                            apiKey: "a3cbb53c-8fae-409c-9ee1-35bb60bd6107",
                            production: true,
                            realProduction: false,
                            codelessFinalValidation: false
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
                            
                            let entityDataPerson = Entity.EntityData(nameFirst: "Mary", nameLast: "Vouched")
                            let entityPerson = Entity(entityData: entityDataPerson, entityType: "person", branchName: "vouched")
                            
                            let entityDataPerson2 = Entity.EntityData(nameFirst: "Katelyn", nameLast: "Veriff")
                            let entityPerson2 = Entity(entityData: entityDataPerson2, entityType: "person", branchName: "veriff")
                        
                            let entityDataPerson3 = Entity.EntityData(nameFirst: "Radhika", nameLast: "Socure")
                            let entityPerson3 = Entity(entityData: entityDataPerson3, entityType: "person", branchName: "socure")
                        
                            let entityDataPerson4 = Entity.EntityData(nameFirst: "Erik", nameLast: "Persona")
                            let entityPerson4 = Entity(entityData: entityDataPerson4, entityType: "person", branchName: "persona")
                            
                            let entityDataPerson5 = Entity.EntityData(nameFirst: "Philip", nameLast: "Sumsub")
                            let entityPerson5 = Entity(entityData: entityDataPerson5, entityType: "person", branchName: "sumsub")

                            let entities = EntityData(entities: [entityPerson, entityPerson2, entityPerson3, entityPerson4, entityPerson5], additionalEntities: false)
                            let journeySettings = JourneySettings(journeyToken: "J-72ADYuJif7FOiDsYZoRE", entities: entities)
                            let journeyResult = try await AlloyCodelessLiteiOS.shared.startJourney(journeySettings: journeySettings, onFinish: { _ in
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
