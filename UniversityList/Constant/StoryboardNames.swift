//  StoryboardNames.swift

import Foundation
import UIKit

struct Storyboards {
    static let UniversityList = (UIStoryboard(name: "UniversityList", bundle: nil).instantiateViewController(withIdentifier: "UniversityListViewController") as? UniversityListViewController)
}
