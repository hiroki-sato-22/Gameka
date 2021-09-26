//
//  MyFunc.swift
//  prototype
//
//  Created by hiroki sato on 2021/09/26.
//

import Foundation
import RealmSwift


class MyFunc {
    
    func showDeleteWarning(for indexPath: IndexPath) {

        let alert = UIAlertController(title: "タスクを完了しますか？", message: "OKを選択するとポイントが加算されます", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.Calculation(for: indexPath)
            }
        }
        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
    }
    
    func Calculation(for indexPath: IndexPath) {
       
    }

}
