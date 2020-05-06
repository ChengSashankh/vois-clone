//
//  APIInterface.swift
//  Vois
//
//  Copyright © 2020 Vois. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(toMerge: [Key: Value]) {
        for (newKey, newValue) in toMerge {
            updateValue(newValue, forKey: newKey)
        }
    }
}

class LastFMAPInterface {
    var baseParams = [
        "api_key": "5a83c80e13a39002a4c841b72cf8427d",
        "format": "json"
    ]
    var rootUrl = "https://ws.audioscrobbler.com/2.0/"

    func setBaseParams(newParams: [String: String]) {
        baseParams = newParams
    }

    func parseTopTracksResponse(asString: String) -> TopTracksAPIResponse? {
        let stringData = asString.data(using: .utf8)
        let apiResponse: TopTracksAPIResponse?

        do {
            apiResponse = try JSONDecoder().decode(TopTracksAPIResponse.self, from: stringData!)
        } catch {
            return nil
        }

        return apiResponse
    }

    func parseTopArtistsResponse(asString: String) -> TopArtistsAPIResponse? {
        let stringData = asString.data(using: .utf8)
        let apiResponse: TopArtistsAPIResponse?

        do {
            apiResponse = try JSONDecoder().decode(TopArtistsAPIResponse.self, from: stringData!)
        } catch {
            return nil
        }

        return apiResponse
    }

    func parseRegionalTopArtistsResponse(asString: String) -> TopRegionalArtistsAPIResponse? {
        let stringData = asString.data(using: .utf8)
        let apiResponse: TopRegionalArtistsAPIResponse?

        do {
            apiResponse = try JSONDecoder().decode(TopRegionalArtistsAPIResponse.self, from: stringData!)
        } catch {
            return nil
        }

        return apiResponse
    }



    func getTopTracks(completionHandler: @escaping (_ response: TopTracksAPIResponse?) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/"
        var options = [
            "method": "chart.gettoptracks"
        ]
        options.merge(toMerge: baseParams)

        var completeRequestString = url + "?"

        for (key, value) in options {
            completeRequestString += (key + "=" + value + "&")
        }

        if completeRequestString.last == Character("&") {
            completeRequestString = String(completeRequestString.dropLast())
        }

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = self.parseTopTracksResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopArtists(completionHandler: @escaping (_ response: TopArtistsAPIResponse?) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/"
        var options = [
            "method": "chart.gettopartists"
        ]
        options.merge(toMerge: baseParams)

        var completeRequestString = url + "?"

        for (key, value) in options {
            completeRequestString += (key + "=" + value + "&")
        }

        if completeRequestString.last == Character("&") {
            completeRequestString = String(completeRequestString.dropLast())
        }

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = self.parseTopArtistsResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopTracksByRegion(country: String, completionHandler: @escaping (_ response: TopTracksAPIResponse?) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/"
        var options = [
            "country": country,
            "method": "geo.gettoptracks"
        ]
        options.merge(toMerge: baseParams)

        var completeRequestString = url + "?"

        for (key, value) in options {
            completeRequestString += (key + "=" + value + "&")
        }

        if completeRequestString.last == Character("&") {
            completeRequestString = String(completeRequestString.dropLast())
        }

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = self.parseTopTracksResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

    func getTopArtistsByRegion(country: String, completionHandler: @escaping (_ response: TopRegionalArtistsAPIResponse?) -> Void) {
        let url = "https://ws.audioscrobbler.com/2.0/"
        var options = [
            "country": country,
            "method": "geo.gettopartists"
        ]
        options.merge(toMerge: baseParams)
        
        var completeRequestString = url + "?"

        for (key, value) in options {
            completeRequestString += (key + "=" + value + "&")
        }

        if completeRequestString.last == Character("&") {
            completeRequestString = String(completeRequestString.dropLast())
        }

        if let url = URL(string: completeRequestString) {
           URLSession.shared.dataTask(with: url) { data, _, _ in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    let apiResponse = self.parseRegionalTopArtistsResponse(asString: jsonString)
                    completionHandler(apiResponse)
                 }
              }
           }.resume()
        }
    }

}
