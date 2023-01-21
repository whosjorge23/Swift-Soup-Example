//
//  ContentView.swift
//  Swift Soup Example
//
//  Created by Giorgio Giannotta on 19/01/23.
//

import SwiftUI
import SwiftSoup

struct ContentView: View {
    @State private var searchTerm: String = ""
    @State private var searchResult: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter a word to search on Wikipedia", text: $searchTerm).padding()
            Button(action: {
                self.scrapeData(from: self.searchTerm)
            }) {
                Text("Search")
            }
            if !searchResult.isEmpty {
                Text(searchResult)
            } else {
                Text("Enter a word and tap the button to search on Wikipedia")
            }
        }
    }
    
    func scrapeData(from searchTerm: String) {
        let url = "https://en.wikipedia.org/wiki/\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error!)")
                return
            }
            let html = String(data: data, encoding: .utf8)
            do {
                let doc = try SwiftSoup.parse(html!)
                let firstParagraph = try doc.select("p:contains(\(searchTerm)").first()?.text()
                self.searchResult = firstParagraph ?? "No result found"
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
