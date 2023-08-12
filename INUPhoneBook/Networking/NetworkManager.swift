import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
    
    // 여러 화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    static let shared = NetworkManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    typealias NetworkCompletion = (Result<UserData, NetworkError>) -> Void
    
    // 네트워킹 요청하는 함수
    func fetchUser(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "https://b05abb42-ed16-4e8f-a034-39ce4655c5e5.mock.pstmn.io/api/employee/1"
        getMethod(with: urlString) { result in
            switch result {
            case .success(let userData):
                completion(.success(userData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getMethod(with urlString: String, completion: @escaping (Result<UserData, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(.failure(.networkingError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Networking Error:", error)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                print("No Data")
                completion(.failure(.dataError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid Response")
                completion(.failure(.networkingError))
                return
            }
            
            print("Response Status Code:", httpResponse.statusCode)
            
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: safeData)
                completion(.success(userData))
            } catch {
                print("JSON Parsing Error:", error)
                completion(.failure(.parseError))
            }
        }.resume()
    }
}