//
//  PopUpViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/19.
//

import UIKit

import SnapKit
import DropDown

class MyPopupViewController: UIViewController {
  private let userManager = UserManager.shared
  private let popupView: MyPopupView
  private var user: User?
  private var senderCell: CustomCell?
    

  init(title: String, desc: String, user: User?, senderCell: CustomCell?) {
    self.popupView = MyPopupView(title: title, desc: desc)
    super.init(nibName: nil, bundle: nil)
    
    self.user = user
    self.senderCell = senderCell
    
    self.view.backgroundColor = .clear
    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
      guard let self = self else { return }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [unowned self] in
        guard let user = self.user else { return }
        self.userManager.saveUserData(with: user) {
            self.user?.isSaved = true
            DispatchQueue.main.async { [weak senderCell] in
                senderCell?.setButtonStatus()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    self.popupView.selectButtonAction = { [weak self] in
      self?.showCategoryList(sender: self?.popupView.selectButton ?? UIButton())
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  @objc func showCategoryList(sender: UIButton) {
    let categories = CategoryManager.shared.fetchCategories()
    var categoryNames: [String] = ["기본"]
    
    for category in categories {
      if let categoryName = category.cellCategory{ // categoryName에 옵셔널 값이 들어있는 경우
        categoryNames.append(categoryName) // 옵셔널 값을 제거한 후 배열에 추가합니다.
      }
    }
    
    let dropDown = DropDown()
    dropDown.anchorView = sender
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = categoryNames
    dropDown.selectionAction = { [weak self] (index, item) in
      // DropDown의 항목 선택 시의 동작을 구현합니다.
      guard let self = self else { return }
      // 선택된 항목(item)을 사용하여 원하는 동작을 수행합니다.
      self.user?.category = item
    }
    dropDown.show()
    
  }
}
