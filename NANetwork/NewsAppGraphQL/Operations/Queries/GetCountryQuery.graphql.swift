// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension NewsAppGraphQL {
  class GetCountryQuery: GraphQLQuery {
    static let operationName: String = "GetCountry"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCountry($code: ID!) { country(code: $code) { __typename name continent { __typename name } states { __typename name } emoji } }"#
      ))

    public var code: ID

    public init(code: ID) {
      self.code = code
    }

    public var __variables: Variables? { ["code": code] }

    struct Data: NewsAppGraphQL.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { NewsAppGraphQL.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("country", Country?.self, arguments: ["code": .variable("code")]),
      ] }

      var country: Country? { __data["country"] }

      /// Country
      ///
      /// Parent Type: `Country`
      struct Country: NewsAppGraphQL.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { NewsAppGraphQL.Objects.Country }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String.self),
          .field("continent", Continent.self),
          .field("states", [State].self),
          .field("emoji", String.self),
        ] }

        var name: String { __data["name"] }
        var continent: Continent { __data["continent"] }
        var states: [State] { __data["states"] }
        var emoji: String { __data["emoji"] }

        /// Country.Continent
        ///
        /// Parent Type: `Continent`
        struct Continent: NewsAppGraphQL.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { NewsAppGraphQL.Objects.Continent }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String.self),
          ] }

          var name: String { __data["name"] }
        }

        /// Country.State
        ///
        /// Parent Type: `State`
        struct State: NewsAppGraphQL.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { NewsAppGraphQL.Objects.State }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String.self),
          ] }

          var name: String { __data["name"] }
        }
      }
    }
  }

}