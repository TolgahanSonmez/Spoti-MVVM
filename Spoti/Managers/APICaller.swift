//
//  APICaller.swift
//  Spoti
//
//  Created by Tolgahan Sonmez on 24.09.2022.
//

import Foundation
final class APICaller {
    //singleton
    static let shared = APICaller()
    private init() {
        
    }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
        
    }
    
    enum APIError : Error {
        case failedToGetData
    }
    
    
    enum HTTPMethod : String {
        case GET
        case PUT
        case POST
        case DELETE
        
    }
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void)
    {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            print(token)
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            type: .GET
        )
        { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do {
                    
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    //compactmap nil değerleri atarak array döner
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))

                    completion(.success(searchResults))
                    print(searchResults)
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategories(completion: @escaping(Result<[Category],Error>)-> Void) {
        
        createRequest(
            with: URL(string: Constants.baseAPIURL+"/browse/categories?limit=30"),
            type: .GET
        )
        { request in
            
            let task = URLSession.shared.dataTask(with:request) {(data, _, error) in
                guard let data = data , error == nil
                else
                {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do
                {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                    
                }
                catch
                {
                    completion(.failure(error))
                    
                }
            }
            task.resume()
        }
    }
    
    public func getAlbumDetails (for album:Album ,completion: @escaping(Result<AlbumDetailsResponse, Error>)-> Void) {
        
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/" + album.id), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil
                else
                {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do
                {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                }
                catch
                {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    
}
