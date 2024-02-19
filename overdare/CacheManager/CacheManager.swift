//
//  CacheManager.swift
//  overdare
//
//  Created by Eddie on 2/19/24.
//

import Foundation

final actor CacheManager {
    static let shared = CacheManager()

    private let cache: URLCache

    init() {
        // URLCache 인스턴스 생성
        self.cache = URLCache(memoryCapacity: 100 * 1024 * 1024, // 100 MB 메모리 캐시
                              diskCapacity: 500 * 1024 * 1024, // 500 MB 디스크 캐시
                              diskPath: "githubCache")
    }

    // 캐시에 데이터 저장
    func storeToCache(data: Data, response: URLResponse, for request: URLRequest) {
        guard let httpResponse = response as? HTTPURLResponse else { return }

        let cachedResponse = CachedURLResponse(response: httpResponse, data: data, userInfo: nil, storagePolicy: .allowed)
        self.cache.storeCachedResponse(cachedResponse, for: request)
    }

    // 캐시에서 데이터 가져오기
    func loadFromCache(for request: URLRequest) -> Data? {
        // 1시간 주기로 캐시 삭제
        let oneHourAgo = Date().addingTimeInterval(-3600) // 1시간 전 시간
        self.cache.removeCachedResponses(since: oneHourAgo)
        
        if let cachedResponse = self.cache.cachedResponse(for: request) {
            return cachedResponse.data
        }
        return nil
    }
}
