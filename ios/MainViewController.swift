//
//  MainViewController.swift
//  ImageEditor
//
//  Created by Apple on 05/02/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit
import MobileCoreServices

@objc class MainViewController: UIViewController, PhotoEditorDelegate {

  private var selectedImage : UIImage?
  private var selectedOption : Int = 0

  @objc var selectedData : NSArray?

  override func viewDidLoad() {
    super.viewDidLoad()
    print("MyViewController loaded...")
    
    selectedOption = (selectedData?[0] as? Int) ?? 0
    selectedImage =  RCTConvert.uiImage(selectedData?[1])
    
    
    if selectedOption == 1 {
      self.openCamera()
    } else if selectedOption == 2 {
      self.openGallery()
    } else {
      openImageEditorWith(image: selectedImage!)
    }
  }


//  @IBAction func startAction(sender: UIButton) {
//     let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
//     //PhotoEditorDelegate
//     photoEditor.photoEditorDelegate = self
//
//     //The image to be edited
//     photoEditor.image = selectedImage! // #imageLiteral(resourceName: "apple")
//
//     //Stickers that the user will choose from to add on the image
//     //photoEditor.stickers.append(UIImage(named: "sticker" )!)
//
//     //Optional: To hide controls - array of enum control
//     photoEditor.hiddenControls = [.crop, .draw, .share]
//
//     //Optional: Colors for drawing and Text, If not set default values will be used
//     photoEditor.colors = [.red,.blue,.green]
//
//     //Present the View Controller
//     self.navigationController?.pushViewController(photoEditor, animated: true)
////         present(photoEditor, animated: true, completion: nil)
//   }
     
  
  private func openImageEditorWith(image: UIImage) {
    let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        //PhotoEditorDelegate
        photoEditor.photoEditorDelegate = self

        //The image to be edited
        photoEditor.image = image

        //Stickers that the user will choose from to add on the image
        //photoEditor.stickers.append(UIImage(named: "sticker" )!)

        //Optional: To hide controls - array of enum control
        photoEditor.hiddenControls = [.crop, .draw, .share]

        //Optional: Colors for drawing and Text, If not set default values will be used
        photoEditor.colors = [.red,.blue,.green]

        //Present the View Controller
        self.navigationController?.pushViewController(photoEditor, animated: true)
  }
  
     
     func doneEditing(image: UIImage) {
         // the edited image
        print(image)
        self.navigationController?.popViewController(animated: true)
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.completedEditing(with: image)
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
     }
         
     func canceledEditing() {
        print("Canceled")
        self.navigationController?.popViewController(animated: true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.completedEditing(with: nil)
//        self.navigationController?.popViewController(animated: true)
      self.dismiss(animated: true, completion: nil)

     }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   private func openCamera() {
       if UIImagePickerController.isSourceTypeAvailable(.camera) {
        showImagePicker(withSource: .camera)
       }
   }
  
  private func openGallery() {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
       showImagePicker(withSource: .photoLibrary)
      }
  }
     
  private func showImagePicker(withSource source: UIImagePickerController.SourceType) {
       let mediaTypes = [kUTTypeImage] as [String]
       let imagePicker = UIImagePickerController()
       imagePicker.delegate = self
       imagePicker.sourceType = source
       imagePicker.mediaTypes = mediaTypes
       imagePicker.allowsEditing = true
       
       self.present(imagePicker, animated: true, completion: nil)
  }
     
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage: UIImage = (info[.editedImage] as! UIImage)
    print(selectedImage)
    
    picker.dismiss(animated: true, completion: {
      self.openImageEditorWith(image: selectedImage)
    });
  }
       
       //-----------------------------------------------------------------------------------------------------------
   public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: {
      self.navigationController?.popViewController(animated: true)
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.completedEditing(with: nil)
    });
    
    
   }
}
