//
//  MockData.swift
//  TaskApp
//
//  Created by Lala on 10.02.26.
//

import Foundation

enum MockData {

    static let pages: [PageData] = [
        PageData(
            imageName: AppImage.Carousel.natureHeader,
            items: [
                Item(
                    imageName: AppImage.ListItem.forest,
                    title: Localization.forestTitle,
                    subtitle: Localization.forestSubtitle
                ),
                Item(
                    imageName: AppImage.ListItem.mountain,
                    title: Localization.mountainTitle,
                    subtitle: Localization.mountainSubtitle
                ),
                Item(
                    imageName: AppImage.ListItem.river,
                    title: Localization.riverTitle,
                    subtitle: Localization.riverSubtitle
                ),
                Item(
                    imageName: AppImage.ListItem.sea,
                    title: Localization.seaTitle,
                    subtitle: Localization.seaSubtitle
                )
            ]
        ),
        PageData(
            imageName: AppImage.Carousel.fruitHeader,
            items: [
                Item(
                    imageName: AppImage.ListItem.apple,
                    title: Localization.appleTitle,
                    subtitle: Localization.appleSubtitle
                ),
                Item(
                    imageName: AppImage.ListItem.blueberry,
                    title: Localization.blueberryTitle,
                    subtitle: Localization.blueberrySubtitle
                ),
                Item(
                    imageName: AppImage.ListItem.orange,
                    title: Localization.orangeTitle,
                    subtitle: Localization.orangeSubtitle
                )
            ]
        )
    ]
}
