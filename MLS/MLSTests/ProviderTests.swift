import XCTest

import Core
import Data
import DomainInterface

import RxSwift

// Post Model
struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

// Post Request Body
struct PostBody: Encodable {
    let title: String
    let body: String
    let userId: Int
}

class ProviderTests: XCTestCase {
    var provider: NetworkProvider?
    var disposeBag: DisposeBag?

    override func setUp() {
        super.setUp()
        provider = NetworkProviderImpl()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        provider = nil
        disposeBag = nil
        super.tearDown()
    }

    func testRequestableEndPoint() {
        guard let provider = provider,
              let disposeBag = disposeBag else {
            XCTFail("provider or disposeBag is nil")
            return
        }

        let expectation = XCTestExpectation(description: "Request data success")
        let request = ResponsableEndPoint<[Post]>(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/posts",
            method: .GET
        )

        provider.requestData(endPoint: request, interceptor: nil)
            .subscribe(onNext: { (posts: [Post]) in
                XCTAssertFalse(posts.isEmpty, "Posts should not be empty")
                XCTAssertEqual(posts.first?.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected success, but got error: \(error)")
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func testEndPoint() {
        guard let provider = provider,
              let disposeBag = disposeBag else {
            XCTFail("provider or disposeBag is nil")
            return
        }

        let expectation = XCTestExpectation(description: "Request completable success")
        let request = EndPoint(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/posts",
            method: .POST,
            body: PostBody(title: "Test Title", body: "Test Body", userId: 1)
        )

        provider.requestData(endPoint: request, interceptor: nil)
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected completion, but got error: \(error)")
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func test404Error() {
        guard let provider = provider,
              let disposeBag = disposeBag else {
            XCTFail("provider or disposeBag is nil")
            return
        }

        let expectation = XCTestExpectation(description: "Request 404 error")
        let request = ResponsableEndPoint<Post>(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/posts/999",
            method: .GET
        )

        provider.requestData(endPoint: request, interceptor: nil)
            .subscribe(onNext: { _ in
                XCTFail("Expected error, but got success")
            }, onError: { error in
                if case NetworkError.statusError(let code, let message) = error {
                    XCTAssertEqual(code, 404, "Expected 404 status code")
                    XCTAssertEqual(message, "{}", "Expected empty JSON object")
                    expectation.fulfill()
                } else {
                    XCTFail("Expected statusError, but got \(error)")
                }
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func testInvalidURL() {
        guard let provider = provider,
              let disposeBag = disposeBag else {
            XCTFail("provider or disposeBag is nil")
            return
        }

        let expectation = XCTestExpectation(description: "Invalid URL error")
        let request = ResponsableEndPoint<Post>(
            baseURL: "url",
            path: "/posts",
            method: .GET
        )

        provider.requestData(endPoint: request, interceptor: nil)
            .subscribe(onNext: { _ in
                XCTFail("Expected error, but got success")
            }, onError: { error in
                if case NetworkError.urlRequest(_) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected urlRequest error, but got \(error)")
                }
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func testDecodeError() {
        guard let provider = provider,
              let disposeBag = disposeBag else {
            XCTFail("provider or disposeBag is nil")
            return
        }

        struct DecodeFailResponse: Decodable {
            let invalidKey: String // API 응답에 없는 키
        }

        let expectation = XCTestExpectation(description: "Decode error")
        let request = ResponsableEndPoint<DecodeFailResponse>(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/posts/1",
            method: .GET
        )

        provider.requestData(endPoint: request, interceptor: nil)
            .subscribe(onNext: { (_: DecodeFailResponse) in
                XCTFail("Expected error, but got success")
            }, onError: { error in
                if case NetworkError.decodeError(_) = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected decodeError, but got \(error)")
                }
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func testProviderDeallocated() {
        guard let disposeBag = disposeBag else {
            XCTFail("disposeBag is nil")
            return
        }

        let expectation = XCTestExpectation(description: "Provider deallocated error")
        let request = ResponsableEndPoint<[Post]>(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/posts",
            method: .GET
        )

        var localProvider: NetworkProviderImpl? = NetworkProviderImpl()
        localProvider?.requestData(endPoint: request, interceptor: nil)
            .subscribe(onNext: { (_: [Post]) in
                XCTFail("Expected error, but got success")
            }, onError: { error in
                if case NetworkError.providerDeallocated = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected providerDeallocated, but got \(error)")
                }
            })
            .disposed(by: disposeBag)

        localProvider = nil
        wait(for: [expectation], timeout: 5.0)
    }
}
