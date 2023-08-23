//
//  StringExtension.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/22.
//

import Foundation

extension String {
  // MARK: - 휴대폰 번호 하이픈 추가
  public var withHypen: String {
    var stringWithHypen: String = self
    
    stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
    stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
    
    return stringWithHypen
  }
}