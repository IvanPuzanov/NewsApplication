//
//  NetworkManager.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import RxSwift

final class NetworkManager {
    
    static var shared = NetworkManager()
    private init() {}
    
    /// Fetch data from network
    /// - Parameters:
    ///   - ofType: Type of fetching data
    ///   - urlString: Network source
    /// - Returns: Observable fetch type
    func fetchData<T: Codable>(ofType: T.Type, from urlString: String) -> Observable<T> {
        return Observable.create { observer -> Disposable in
            
            guard let url = URL(string: urlString) else {
                observer.onError(NSError(domain: "No url", code: 0))
                return Disposables.create() }
            
            do {
                let decoder     = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let data        = try Data(contentsOf: url)
                let decodedData = try decoder.decode(T.self, from: data)
                
                observer.onNext(decodedData)
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    /// Fetching image from network
    /// - Parameter urlString: Network source
    /// - Returns: Observable image
    func fetchImage(from urlString: String?) -> Observable<UIImage> {
        return Observable.create { observer -> Disposable in
            
            guard let urlString = urlString, let url = URL(string: urlString) else { return Disposables.create() }
            
            do {
                let data    = try Data(contentsOf: url)
                let image   = UIImage(data: data)
                
                guard let image = image else { return Disposables.create() }
                observer.onNext(image)
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
}
