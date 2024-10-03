// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation

struct PostmanGenerator: ParsableCommand {
    // Define default paths
     var defaultCollectionPath: String {
         return "./Whereto API.json"  // Default collection file path in the current directory
     }

     var defaultOutputDirectory: String {
         return "./output"  // Default output directory
     }

     @Argument(help: "The path to the Postman collection JSON file.")
     var collectionPath: String?

     @Argument(help: "The output directory where generated files will be stored.")
     var outputDirectory: String?

     func run() throws {
         // Use default paths if arguments are not provided
         let collectionPath = self.collectionPath ?? defaultCollectionPath
         let outputDirectory = self.outputDirectory ?? defaultOutputDirectory

         // Read and parse the Postman collection file
         let data = try Data(contentsOf: URL(fileURLWithPath: collectionPath))
         let collection = try JSONDecoder().decode(PostmanCollection.self, from: data)

         // Generate API files from the Postman collection
         // Initialize the FileGenerator and generate API files from the Postman collection
         let generator = FileGenerator(outputDirectory: outputDirectory)
         try generator.generateAPICode(from: collection)

         print("API files generated successfully at \(outputDirectory).")
     }
 }

 PostmanGenerator.main()
