//
//  AddPostViewController.swift
//  MentorsHakaton
//
//  Created by Aida Moldaly on 13.07.2022.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postTitleLabel: UITextField!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var publishButton: UIButton!
    
    var myImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(publishButton)
        
        postTextView.font = UIFont(name: "verdana", size: 16.5)
        postTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        postTextView.layer.borderWidth = 0.5
        postTextView.clipsToBounds = true
        postTextView.textColor = UIColor.systemGray3
        postTextView.becomeFirstResponder()
        postTextView.selectedTextRange = postTextView.textRange(from: postTextView.beginningOfDocument, to: postTextView.beginningOfDocument)
        postTextView.delegate = self
    }
    
    @IBAction func userImageTapped(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
        
        guard let postTitle = postTitleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let postText = postTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        transitionToHome()
//        let publish =
        
//        networkManager.postPost(credentials: publish) { [weak self] result in
//            guard self != nil else { return }
//            switch result {
//            case let .success(message):
//                self!.transitionToHome()
//                // some toastview to show that user is registered
//                print("\(String(describing: message)): 123")
//            case let .failure(error):
//                self!.showError("This email has already registered!")
//                print("\(error): 456")
//            }
//        }
        
        guard let image = postImageView.image  else { return }
        
        let uploader = PostImageUploader(uploadImage: image, number: 1)
        uploader.uploadImage { result in
            switch result {
            case .success(let response):
//                    NotificationCenter.default.post(name: "ProfileEdited", object: nil)
                print("SUCCESS!")
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
    
    func transitionToHome() {
        self.navigationController?.popViewController(animated: true)
        view.window?.makeKeyAndVisible()
    }
}

extension AddPostViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Additional information about yourself"
            textView.textColor = UIColor.systemGray3
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

         else if textView.textColor == UIColor.systemGray3 && !text.isEmpty {
            textView.font = UIFont(name: "verdana", size: 16.0)
            textView.textColor = UIColor.black
            textView.text = text
         }
        else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.systemGray3 {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}


extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            postImageView.image = image
            myImage = "\(image)"
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
