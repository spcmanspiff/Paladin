//
//  ContentView.swift
//  Paladin
//
//  Created by Brad Scott on 9/29/20.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var tappedSpell = TappedSpell()
    @State private var results = [Result]()
    @State private var spellName = "aid"
    @State private var  spellDetails = SpellDetails(index: "", name: "", desc: [], higherLevel: [], range: "", components: [], material: "", ritual: true, duration: "", concentration: false, castingTime: "", level: 0, school: School(name: "", url: ""), classes: [], subclasses: [], url: "")
    @State private var searchText: String = ""
    @State private var iconString: String = "wizard"
    
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                Text("Spells")
                    .font(.largeTitle)
                    // .fontWeight(.heavy)
                    .padding(.leading, 10).padding(.top, 10)
                SearchBar(text: $searchText, placeholder: "Search").onAppear() {
                    print("loading")
                }
                List {
                    //  if SpellDetails.CodingKeys.classes.stringValue.contains("Paladin") {
                    ForEach(self.results.filter {
                        self.searchText.isEmpty ? true : $0.name.lowercased().contains("\(self.searchText.lowercased())")
                    }, id: \.name) { spells in
                        HStack {
                            Image("\(spells.iconName.lowercased())")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(spells.name)")
                                .font(.headline)
                                .fontWeight(.light)
                                .onTapGesture(count: 1) {
                                    self.tappedSpell.tappedSpell = spells.index
                                    
                                    self.spellName = spells.index
                                    print("Spell Tapped: \(self.tappedSpell.tappedSpell)")
                                    
                                    self.loadDataList(spellName: self.spellName)
                                }
                        }
                    }
                    //    }
                }.onAppear() {
                    loadData()
                    print("loading")
                    print(SpellDetails.CodingKeys.classes.stringValue)
                }
            }.frame(width: 300)
            
            Spacer()
            VStack {
                Form {
                    Section(header: Text("Spell Info")) {
                        Text("Spell Name: \(spellDetails.name)")
                            .font(.headline).fontWeight(.light)
                        Text("Range: \(spellDetails.range)")
                            .font(.headline).fontWeight(.light)
                        Text("Level: \(spellDetails.level!)")
                            .font(.headline).fontWeight(.light)
                        Text("Casting Time: \(spellDetails.castingTime ?? "-")")
                            .font(.headline).fontWeight(.light)
                        Text("Duration: \(spellDetails.duration ?? "-")")
                            .font(.headline).fontWeight(.light)
                        Text("Materials: \(spellDetails.material ?? "-")")
                            .font(.headline).fontWeight(.light)
                        
                    }
                    Section {
                        HStack {
                            Text("School:")
                                .fontWeight(.light)
                            Image("\(spellDetails.school?.name.lowercased() ?? "wizard")")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(spellDetails.school?.name ?? "-")")
                                .fontWeight(.light)
                            
                        }
                        HStack {
                            Text("Class:")
                                .fontWeight(.light)
                            Image("\(spellDetails.classes!.first?.name.lowercased() ?? "")")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(spellDetails.classes?.first?.name ?? "-")")
                                .fontWeight(.light)
                        }
                        Text("Subclass: \(spellDetails.subclasses?.first?.name ?? "-")")
                            .fontWeight(.light)
                    }.font(.headline)
                    
                    Section(header: Text("Description")) {
                        Text("\(spellDetails.desc?.first ?? "-")" + " \(spellDetails.desc?.last ?? "-")")
                            .font(.headline).fontWeight(.light)
                        Text(spellDetails.higherLevel?.first ?? "")
                            .font(.headline).fontWeight(.light)
                    }
                    
                }
                
            }
            Spacer()
        }.onAppear(perform: loadData)
    }
    func loadData() {
        guard let urlTop = URL(string: "http://dnd5eapi.co/api/spells/") else {
            print("invalid")
            return
        }
        
        var request = URLRequest(url: urlTop)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                print(data)
                if let decodedResponse = try? JSONDecoder().decode(Spells.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                        
                    }
                    return
                    
                }
            }
        }.resume()
    }
    
    func loadDataList(spellName: String) {
        guard let urlSpell = URL(string: "http://dnd5eapi.co/api/spells/\(spellName)") else {
            print("invalid")
            return
        }
        
        let request = URLRequest(url: urlSpell)
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(SpellDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.spellDetails = jsonResponse
                        self.iconString = jsonResponse.school?.name ?? ""
                        self.tappedSpell.tappedSpell = jsonResponse.index
                        print(jsonResponse)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
    
}
