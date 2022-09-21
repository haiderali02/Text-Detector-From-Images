//
//  MediaPicker.swift
//  GoogleMLDemo
//
//  Created by Haider Ali on 21/09/2022.
//

import Foundation
import YPImagePicker

class MediaPicker {
    
    private var picker: YPImagePicker
    
    public typealias DidFinishPickingCompletion = (_ items: [YPMediaItem], _ cancelled: Bool) -> Void
    
    init(numberOfItemsToBeSelected: Int = 1, mediaPickerType: YPlibraryMediaType = .photo) {
        
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = numberOfItemsToBeSelected
        config.screens = mediaPickerType == .photo ? [.photo, .library] : [.photo, .library, .video]
        config.library.mediaType = mediaPickerType
        
        config.shouldSaveNewPicturesToAlbum = false
        config.library.preSelectItemOnMultipleSelection = false
        config.library.defaultMultipleSelection = false
        
        // config.showsCrop = .rectangle(ratio: 1/1)
        
        picker = YPImagePicker(configuration: config)
        
    }
    
    func showPicker(_ viewController: UIViewController, completion: @escaping DidFinishPickingCompletion) {
        
        picker.didFinishPicking { items, cancelled in
            
            completion(items, cancelled)
            
            self.picker.dismiss(animated: true)
        }
        
        viewController.present(picker, animated: true, completion: nil)
    }
    
}
