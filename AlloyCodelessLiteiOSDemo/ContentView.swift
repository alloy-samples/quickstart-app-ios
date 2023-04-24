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
                            // *** this key is part of a working example ***
                            // You should obtain your key from the alloy dashboard
                            // On settings > SDK Config
                            apiKey: "7db38092-3df1-4e56-8d01-3a92478485ba", 
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
                            // We are creating 2 entities for the journey application using only first and last name.
                            // The Entity data needed will vary depending on the services associated to your workflows.
                            let entityDataPerson = Entity.EntityData(nameFirst: "John", nameLast: "Doe")
                            let entityDataPerson2 = Entity.EntityData(nameFirst: "Julie", nameLast: "Tam")
                            // We add the entity data to an entity structure. Entity type can be person or business
                            // The branch name needs to match the branch names on your journey.
                            // If you only have one branch, you don't need to pass a branch name.
                            let entityPerson = Entity(entityData: entityDataPerson, entityType: "person", branchName: "vouched")
                            let entityPerson2 = Entity(entityData: entityDataPerson2, entityType: "person", branchName: "vouched")
                            let entities = EntityData(entities: [entityPerson, entityPerson2], additionalEntities: false)

                            // *** this key is part of a working example ***
                            // You should obtain your journey token from the journey's list
                            let journeySettings = JourneySettings(journeyToken: "J-UMEhLDP3p759425pz1uP", entities: entities)
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
