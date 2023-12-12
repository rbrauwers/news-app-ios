//
//  ArticlesRepositoryMock.swift
//  TestUtils
//
//  Created by Rodrigo Brauwers on 07/12/23.
//

import Foundation
import NAData
import NADatabase
import NANetwork

public let stableArticlesRepository = ArticlesRepository(
    networkDataSource: NetworkDataSourceMock.stableNetworkDataSource,
    articlesDAO: ArticlesDAOMock()
)

public let unstableArticlesRepository = ArticlesRepository(
    networkDataSource: NetworkDataSourceMock.unstableNetworkDataSource,
    articlesDAO: ArticlesDAOMock()
)
