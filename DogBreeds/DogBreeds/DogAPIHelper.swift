//
//  DogAPIHelper.swift
//  DogBreeds
//
//  Created by mac on 2022-02-06.
//

import Foundation


enum DogImageResult{
    case success(UIImage)
    case failure(Error)
}

enum DogInfoResult{
    case success(Dog)
    case failure(Error)
}




struct DogAPIHelper{
    private static let baseURL = "https://dog.ceo/api/breeds/list/all"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func fetch(/* url: String */ callback: @escaping ([Dog]) -> Void){
        guard
            let url = URL(string: baseURL)
        else{return}
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, request, error in
            
            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    guard
                        let jsonDictionary = jsonObject as? [AnyHashable: Any],
                        let results = jsonDictionary["message"] as? [String:Any]
                    else{preconditionFailure("was not able to parse JSON data")}
                    
                    //print(results.first!)
                    var dogList = [Dog]()
                    
                    for (key , value) in results{
                        let newDog = Dog(name: "\(key)", url: "\(value)" )
                        dogList.append(newDog)
                    }
                    
                    OperationQueue.main.addOperation {
                                            callback(dogList)
                                            }
                    
                    
                } catch let e {
                    print("could not serialize json data \(e)")
                }
            }else if let error = error {
                print("something went wrong when fetching. ERROR \(error)")
            }else {
                print("unknown error has occured")
            }
        }
        task.resume()

        
    }
    
    
    static func getDogInfo(url: String, callback: @escaping (DogInfoResult)->Void){
           fetch(url: url) { dogfetchresult in
               switch dogfetchresult {
               case .success(let data):
                   do {
                       let decoder = JSONDecoder()
                       let dog = try decoder.decode(Dog.self, from: data)
                       callback(.success(pokemon))
                   }catch let e {
                       callback(.failure(e))
                   }
               case .failure(let error):
                   callback(.failure(error))
               }
           }
       }
    
    
    static func fetchImage(url: String, callback: @escaping (DogImageResult)->Void){
            getDogInfo(url: url) { DogInfoResult in
                switch DogInfoResult {
                case .success(let dog):
                    DogAPIHelper.fetch(url: dog.sprites.front_default) { imageResult in
                        switch imageResult {
                        case .success(let data):
                            guard
                                let image = UIImage(data: data)
                            else{return}
                            callback(.success(image))
                        case .failure(let error):
                            callback(.failure(error))
                        }
                    }
                case .failure(let error):
                    callback(.failure(error))
                }
            }
        }
}
