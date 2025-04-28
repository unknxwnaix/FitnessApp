//
//  TrainingActivityWIdgetBundle.swift
//  TrainingActivityWIdget
//
//  Created by Maxim Dmitrochenko on 4/27/25.
//

import WidgetKit
import SwiftUI

@main
struct TrainingActivityWIdgetBundle: WidgetBundle {
    var body: some Widget {
        TrainingActivityWIdget()
        TrainingActivityWIdgetControl()
        TrainingActivityWIdgetLiveActivity()
    }
}
