//
//  Helpers.swift
//  FiveETab
//
//  Created by Brad Scott on 3/12/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI
import Foundation


// MARK: - Spell
struct Spell: Codable {
    let slug, name, desc, higherLevel: String
    let page, range: String
    let components: Components
    let material: String
    let ritual: Concentration
    let duration: String
    let concentration: Concentration
    let castingTime: String
    let level: Level
    let levelInt: Int
    let schools: Schools
    let dndClass, archetype, circles: String
    let documentSlug: DocumentSlug
    let documentTitle: DocumentTitle
    let documentLicenseURL: String

    enum CodingKeys: String, CodingKey {
        case slug, name, desc
        case higherLevel = "higher_level"
        case page, range, components, material, ritual, duration, concentration
        case castingTime = "casting_time"
        case level
        case levelInt = "level_int"
        case schools
        case dndClass = "dnd_class"
        case archetype, circles
        case documentSlug = "document__slug"
        case documentTitle = "document__title"
        case documentLicenseURL = "document__license_url"
    }
}

enum Components: String, Codable {
    case s = "S"
    case v = "V"
    case vS = "V, S"
    case vSM = "V, S, M"
}

enum Concentration: String, Codable {
    case no = "no"
    case yes = "yes"
}

enum DocumentSlug: String, Codable {
    case wotcSrd = "wotc-srd"
}

enum DocumentTitle: String, Codable {
    case systemsReferenceDocument = "Systems Reference Document"
}

enum Level: String, Codable {
    case the1StLevel = "1st-level"
    case the2NdLevel = "2nd-level"
    case the3RDLevel = "3rd-level"
    case the4ThLevel = "4th-level"
    case the5ThLevel = "5th-level"
}

enum Schools: String, Codable {
    case abjuration = "Abjuration"
    case conjuration = "Conjuration"
    case divination = "Divination"
    case enchantment = "Enchantment"
    case evocation = "Evocation"
    case necromancy = "Necromancy"
    case transmutation = "Transmutation"
}


class TappedSpell : ObservableObject {
    @Published var tappedSpell = "acid-arrow"
    @Published var className = ""
}


struct SearchBar: UIViewRepresentable{
@Binding var text: String
var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

// MARK: - SpellDetails
struct SpellDetails : Codable {
    let index, name: String
    let desc, higherLevel: [String]?
    let range: String?
    let components: [String]?
    let material: String?
    let ritual: Bool?
    let duration: String?
    let concentration: Bool?
    let castingTime: String?
    let level: Int?
    let healAtSlotLevel: [String: String]?
    let school: School?
    let classes, subclasses: [School]?
    let url: String?
}

// MARK: - School
struct School : Codable {
    let index, name, url: String
}
