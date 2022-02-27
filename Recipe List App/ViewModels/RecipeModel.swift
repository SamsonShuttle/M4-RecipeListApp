//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Christopher Ching on 2021-01-14.
//

import Foundation

class RecipeModel: ObservableObject {
    
    @Published var recipes = [Recipe]()
    
    init() {
        // Create an instance of data service and get the data
        self.recipes = DataService.getLocalData()
    }
    
    static func getPortion(ingredient:Ingredient, recipeServings:Int, targetServings:Int) -> String {
        
        var portion = ""
        var numerator = ingredient.num ?? 1
        var denominator = ingredient.denom ?? 1
        var wholePortion = 0
        
        if ingredient.num != nil {
            // Get a single serving size by multiply denominator by the recipe servings
            denominator *= recipeServings  // denominator = denominator * recipeServings
            
            
            // Get target portion by multiplying numerator bu target servings
            numerator *= targetServings
            
            // Reduce fraction by greatest common divisor
            let divisor = Rational.greatestCommonDivisor(numerator, denominator)
            numerator /= divisor
            denominator /= divisor
            
            // Get the whole portion if numerator > denominator
            if numerator >= denominator {
                
                wholePortion = numerator / denominator
                
                numerator = numerator % denominator
                
                portion += String(wholePortion)
                
            }
            
            // Express the remainder as a fraction
            if numerator > 0 {
                // Assign remainder as a fraction to the portion
                portion += wholePortion > 0 ? " " : ""
                portion += "\(numerator)/\(denominator)"
            }
        }
        

        if var unit = ingredient.unit {
            
            
            // if we nned to pluralize
            if wholePortion > 1 {
                // Calculate appropriate suffix
                if unit.suffix(2) == "ch" {
                    unit += "es"
                }
                else if unit.suffix(1) == "f" {
                    unit = String(unit.dropLast())
                    unit += "ves"
                }
                else {
                    unit += "s"
                }
                
                
            }
            
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            return portion + unit
        }
        
        return portion
    }
    
}
