//
//  ViewController.swift
//  TypeErasure
//
//  Created by Siavash Abbasalipour on 2/09/2016.
//  Copyright © 2016 MobileDen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var transactionTV: TransactionTableView!
    @IBOutlet weak var MealTV: MealTableView!
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let grassEaterAnimals = [AnyAnimal(Cow()),AnyAnimal(Goat())]
        for animal in grassEaterAnimals {
            animal.feed(Grass())
        }
        transactionTV.dataSource = self
        transactionTV.delegate = self
        MealTV.dataSource = self
        MealTV.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if tableView is TransactionTableView {
            cell?.textLabel?.text = transactionTV.name
        } else {
            cell?.textLabel?.text = MealTV.name
        }
        cell?.backgroundColor = tableView.backgroundColor
        cell?.selectionStyle = .none
        return cell!
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        if tableView is TransactionTableView {
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailVC.delegate = AnyCellReloadable(transactionTV)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController2") as! DetailViewController2
            detailVC.delegate = AnyCellReloadable(MealTV)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
extension TransactionTableView: CellReloadable {
    func shouldShowLoading(_ isLoading: Bool, for dataType: Transaction) {
        backgroundColor = dataType.color
        name = dataType.name
        //color = dataType.color
        reloadData()
        
    }
}
extension MealTableView: CellReloadable {
    func shouldShowLoading(_ isLoading: Bool, for dataType: Meal) {
        backgroundColor = dataType.color
        name = dataType.name
        //color = dataType.color
        reloadData()
    }

}
class TransactionTableView: UITableView {
//    var title: String = "TransactionTableView"
    var name: String = ""
    var color: UIColor = UIColor.black()
}
class MealTableView: UITableView {
//    var title: String = "MealTableView"
    var name: String = ""
    var color: UIColor = UIColor.black()
}
protocol CellReloadable {
    associatedtype DataType
    var name: String {get set}
    var color: UIColor {get set}
    func shouldShowLoading(_ isLoading: Bool, for dataType: DataType)
}

struct Transaction {
    func shouldShowLoading(_ isLoading: Bool, for dataType: Transaction) {
        
    }
    let name: String
    let color: UIColor
}
struct Meal {
    func shouldShowLoading(_ isLoading: Bool, for dataType: Meal) {
        
    }
    let name: String
    let color: UIColor
}
class AnyCellReloadable<ErasedType>: CellReloadable {
    private let _shouldShowLoading: (Bool, ErasedType) -> Void
    var name: String
    var color: UIColor
    init<InjectedType: CellReloadable where ErasedType == InjectedType.DataType>(_ base: InjectedType) {
        _shouldShowLoading = base.shouldShowLoading
        name = base.name
        color = base.color
    }
    func shouldShowLoading(_ isLoading: Bool, for dataType: ErasedType) {
        _shouldShowLoading(isLoading, dataType)
    }
}

protocol Animal {
    associatedtype Food
    func feed(_ food: Food)
}

struct Grass {}
struct Meat {}
struct Worm {}

struct Cow: Animal {
    func feed(_ food: Grass) {
        print("Cow eating Grass")
    }
}

struct Goat: Animal {
    func feed(_ food: Grass) {
        print("Goat eating Grass")
    }
}

struct Bird: Animal {
    func feed(_ food: Worm) {
        
    }
}

struct AnyAnimal<Food>: Animal {
    private let _feed: (Food) -> Void
    init<Base: Animal where Food == Base.Food>(_ base: Base) {
        _feed = base.feed
    }
    func feed(_ food: Food) {
        _feed(food)
    }
}

