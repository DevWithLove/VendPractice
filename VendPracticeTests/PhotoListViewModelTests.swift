//
//  VendPracticeTests.swift
//  VendPracticeTests
//
//  Created by Tony Mu on 25/06/21.
//

import XCTest
@testable import VendPractice

class PhotoListViewModelTests: XCTestCase {
    
    let timeout: TimeInterval = 5
    var textExpectation: XCTestExpectation?
    
    override func setUp() {
        textExpectation = self.expectation(description: "WebServiceCallback")
    }

    // MARK: - LoadPhoto
    
    /*
     *  - WHEN: PhotoWebSerivce has an error
     *  - THEN: A client error has been passed to the view
     */
    func testViewModelPresentError_WHEN_WebServiceHasError() {
        // Arrange
        let photoWebService = MockPhotoWebService()
        photoWebService.expectedResult = .failure(.invalidResponse)
        let photoRepository = MockPhotoRepository()
        let viewModel = PhotoListViewModel(photoWebService: photoWebService,
                                           photoRepository: photoRepository)
        
        let view = MockView(viewModel: viewModel, textExpectation: textExpectation!)
        
        // Act
        viewModel.loadPhoto()
        
        // Assert
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertEqual(view.error?.localizedMessage, "Unable to load photos remotely")
    }
    
    /*
     *  - WHEN: PhotoRepository has an error
     *  - THEN: A client error has been passed to the view
     */
    func testViewModelPresentError_WHEN_PhotoRepositoryHasError() {
        // Arrange
        let photoWebService = MockPhotoWebService()
        photoWebService.expectedResult = .success([])
        let photoRepository = MockPhotoRepository()
        photoRepository.expectedError = .failedGetData
        
        let viewModel = PhotoListViewModel(photoWebService: photoWebService,
                                           photoRepository: photoRepository)
        
        let view = MockView(viewModel: viewModel, textExpectation: textExpectation!)
        
        // Act
        viewModel.loadPhoto()
        
        // Assert
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertEqual(view.error?.localizedMessage, "Unable to get photos from storage")
    }
    
    /*
     *  - AFTER: data has been loaded in the viewModel
     *  - THEN: 'didLoadData' is called from the view
     */
    func testDidLoadDataIsCalled_AFTER_data_has_been_loaded() {
        // Arrange
        let photoWebService = MockPhotoWebService()
        photoWebService.expectedResult = .success([])
        let photoRepository = MockPhotoRepository()
        photoRepository.expectedResult = [Photo(id: "01", author: "author01", downloadUrl: "https//01", displayOrder: 1),
                                          Photo(id: "02", author: "author02", downloadUrl: "https//02", displayOrder: 2)]
        
        let viewModel = PhotoListViewModel(photoWebService: photoWebService,
                                           photoRepository: photoRepository)
        
        let view = MockView(viewModel: viewModel, textExpectation: textExpectation!)
        
        // Act
        viewModel.loadPhoto()
        
        // Assert
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertEqual(viewModel.photos.first, photoRepository.expectedResult.first)
        XCTAssertEqual(viewModel.photos.last, photoRepository.expectedResult.last)
        XCTAssertTrue(view.didLoadDataCalled)
        XCTAssertNil(view.error)
    }
    
    /*
     *  - WHEN: data is not ordered in PhotoRepository
     *  - THEN: data is ordered in ViewModel
     */
    func testDataIsOrdered_in_ViewModel() {
        // Arrange
        let photoWebService = MockPhotoWebService()
        photoWebService.expectedResult = .success([])
        let photoRepository = MockPhotoRepository()
        photoRepository.expectedResult = [Photo(id: "01", author: "author01", downloadUrl: "https//01", displayOrder: 3),
                                          Photo(id: "02", author: "author02", downloadUrl: "https//02", displayOrder: 1),
                                          Photo(id: "03", author: "author03", downloadUrl: "https//03", displayOrder: 2)]
        
        let viewModel = PhotoListViewModel(photoWebService: photoWebService,
                                           photoRepository: photoRepository)
        
        let view = MockView(viewModel: viewModel, textExpectation: textExpectation!)
        
        // Act
        viewModel.loadPhoto()
        
        // Assert
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertEqual(viewModel.photos[0].displayOrder, 1)
        XCTAssertEqual(viewModel.photos[1].displayOrder, 2)
        XCTAssertEqual(viewModel.photos[2].displayOrder, 3)
        XCTAssertTrue(view.didLoadDataCalled)
    }
}


// MARK: - Mocks

class MockView: PhotoViewModelDelegate {
    private let testExpectation: XCTestExpectation
    private var viewModel: PhotoListViewModelProtocol
    
    // Does the didLoadData method has been called?
    var didLoadDataCalled = false
    // Error is passed from viewModel
    var error: PhotoListError?

    
    init(viewModel: PhotoListViewModelProtocol, textExpectation: XCTestExpectation) {
        self.testExpectation = textExpectation
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    func displayError(_ error: PhotoListError) {
        self.error = error
        self.testExpectation.fulfill()
    }
    
    func didLoadData() {
        didLoadDataCalled = true
        self.testExpectation.fulfill()
    }
}

class MockPhotoWebService: PhotoWebServiceProtocol {
    var expectedResult: Result<[PhotoDto]?, ApiError>?
    
    func getPhotos(completion: @escaping (Result<[PhotoDto]?, ApiError>) -> Void) {
        guard let result = expectedResult else { return }
        completion(result)
    }
}

class MockPhotoRepository: PhotoRepositoryProtocol {
    enum RepositoryError: Error {
        case failedGetData
        case failedSaveData
        case failedDeleteData
    }
    
    var expectedResult: [Photo] = []
    var expectedError: RepositoryError?
    
    func get() throws -> [Photo] {
        if let error = expectedError {
            throw error
        }
        return expectedResult
    }
    
    func save(_ photo: Photo) throws {
        if let error = expectedError {
            throw error
        }
    }
    
    func delete(_ photo: Photo) throws {
        if let error = expectedError {
            throw error
        }
    }
}


