//
//  SpellVIew.swift
//  Paladin
//
//  Created by Brad Scott on 9/30/20.
//

import SwiftUI

struct SpellView: View {
    
    let spellsList = Bundle.main.decode("Spells.json")
    @State var searchText = ""
    @ObservedObject var tappedSpell = TappedSpell()
    @State private var spellName = "aid"
    @State private var  spellDetails = SpellDetails(index: "", name: "", desc: [], higherLevel: [], range: "", components: [], material: "", ritual: true, duration: "", concentration: true, castingTime: "", level: 0, healAtSlotLevel: [:], school: School(index: "", name: "", url: ""), classes: [], subclasses: [], url: "")
    
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .clear
       UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
       
        HStack {
            VStack(alignment: .leading) {
                Text("Spells")
                    .font(.largeTitle)
                    .padding(10)
                List {
                    ForEach(self.spellsList.sorted {
                       // self.searchText.isEmpty ? true : $0.name.lowercased().contains("\(self.searchText.lowercased())")
                        $0.levelInt < $1.levelInt
                    }, id: \.name) { spells in
                        HStack {
                            Text("\(spells.name)")    .onTapGesture(count: 1) {
                                print("tapped")
                                self.tappedSpell.tappedSpell = spells.name
                                self.spellName = spells.slug
                                print("Spell Tapped: \(self.tappedSpell.tappedSpell)")
                                self.loadDataList(spellName: self.spellName)
                            }
                            Spacer()
                            Text("Level: \(spells.levelInt)")
                            
                        }
                    }
                    .listRowBackground(Color.clear)
                }

            }.frame(width: 300)
            Spacer()
          
                VStack {
                     Form {
                         Section(header: Text("Spell Info")) {
                             Text("Spell Name: \(spellDetails.name)")
                                 .font(.headline).fontWeight(.light)
                             Text("Range: \(spellDetails.range ?? "-")")
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
                         
                         Section(header: Text("Description")) {
                             Text("\(spellDetails.desc?.first ?? "-")" + " \(spellDetails.desc?.last ?? "-")")
                                 .font(.headline).fontWeight(.light)
                             Text(spellDetails.higherLevel?.first ?? "")
                                 .font(.headline).fontWeight(.light)
                         }
   
                 }
                }.offset(y: 75)
        }.background(
        Image("paper")
            .resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/).rotationEffect(.degrees(-90))
        )
        
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


struct SpellView_Previews: PreviewProvider {
    static var previews: some View {
        SpellView()
    }
}


extension Bundle {
    func decode(_ file: String) -> [Spell] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode([Spell].self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
