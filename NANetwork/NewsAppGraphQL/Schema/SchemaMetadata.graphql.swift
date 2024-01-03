// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol NewsAppGraphQL_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == NewsAppGraphQL.SchemaMetadata {}

protocol NewsAppGraphQL_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == NewsAppGraphQL.SchemaMetadata {}

protocol NewsAppGraphQL_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == NewsAppGraphQL.SchemaMetadata {}

protocol NewsAppGraphQL_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == NewsAppGraphQL.SchemaMetadata {}

extension NewsAppGraphQL {
  typealias ID = String

  typealias SelectionSet = NewsAppGraphQL_SelectionSet

  typealias InlineFragment = NewsAppGraphQL_InlineFragment

  typealias MutableSelectionSet = NewsAppGraphQL_MutableSelectionSet

  typealias MutableInlineFragment = NewsAppGraphQL_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Query": return NewsAppGraphQL.Objects.Query
      case "Country": return NewsAppGraphQL.Objects.Country
      case "Continent": return NewsAppGraphQL.Objects.Continent
      case "State": return NewsAppGraphQL.Objects.State
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}