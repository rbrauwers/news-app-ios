//
//  ArticlesRepositoryMock.swift
//  TestUtils
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Foundation
import NAData
import NANetwork

public let stableArticlesRepository = ArticlesRepository(
    networkDataSource: NetworkDataSourceMock.stableNetworkDataSource
)

public let unstableArticlesRepository = ArticlesRepository(
    networkDataSource: NetworkDataSourceMock.unstableNetworkDataSource
)
