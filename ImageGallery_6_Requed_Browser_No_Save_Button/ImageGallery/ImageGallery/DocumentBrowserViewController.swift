//
//  DocumentBrowserViewController.swift
//  ImageGallery
//
//  Created by Tatiana Kornilova on 22/09/2018.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
          //      ).appendingPathComponent("Untitled.json")
                ).appendingPathComponent("Untitled.imagegallery")
            if template != nil {
                allowsDocumentCreation =
                    FileManager.default.createFile(atPath: template!.path,
                                                   contents: Data())
            }
        }
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    var template: URL? // blank template for new documents
    
    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        didRequestDocumentCreationWithHandler importHandler:
        @escaping (URL?, UIDocumentBrowserViewController.ImportMode
        ) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        didImportDocumentAt sourceURL: URL,
        toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(
        _ controller: UIDocumentBrowserViewController,
        failedToImportDocumentAt documentURL: URL,
        error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC =
            storyBoard.instantiateViewController(withIdentifier: "DocumentMVC")
        if let imageGalleryCollectionViewController = documentVC.contents as? ImageGalleryCollectionViewController {
            imageGalleryCollectionViewController.document =
                                      ImageGalleryDocument(fileURL: documentURL)
        }
        present(documentVC, animated: true)
    }
}

