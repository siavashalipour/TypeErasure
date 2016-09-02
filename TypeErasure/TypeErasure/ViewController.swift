//
//  ViewController.swift
//  TypeErasure
//
//  Created by Siavash Abbasalipour on 2/09/2016.
//  Copyright © 2016 MobileDen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let grassEaterAnimals = [AnyAnimal(Cow()),AnyAnimal(Goat())]
        for animal in grassEaterAnimals {
            animal.feed(Grass())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

protocol Animal {
    associatedtype Food
    func feed(food: Food)
}

struct Grass {}
struct Meat {}
struct Worm {}

struct Cow: Animal {
    func feed(food: Grass) {
        print("Cow eating Grass")
    }
}

struct Goat: Animal {
    func feed(food: Grass) {
        print("Goat eating Grass")
    }
}

struct Bird: Animal {
    func feed(food: Worm) {
        
    }
}

struct AnyAnimal<Food>: Animal {
    private let _feed: (Food) -> Void
    init<Base: Animal where Food == Base.Food>(_ base: Base) {
        _feed = base.feed
    }
    func feed(food: Food) {
        _feed(food)
    }
}

