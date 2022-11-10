//
//  NetworkManager.swift
//  NewsApplication
//
//  Created by Ivan Puzanov on 20.08.2022.
//

import RxSwift

class NetworkManager {
    
    static var shared = NetworkManager()
    private init() {}
    
    /// Получение данных из сети
    /// - Parameters:
    ///   - ofType: Тип запрашиваемых данных
    ///   - urlString: Источник получения данных
    /// - Returns: Наблюдаемый тип запрошенных данных
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
    
    /// Получение изображения из сети
    /// - Parameter urlString: Источник получения данных
    /// - Returns: Наблюдаемый тип изображения
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
