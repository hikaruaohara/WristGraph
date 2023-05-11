//
//  ListItem.swift
//  WristGraph
//
//  Created by 青原光 on 2023/05/10.
//

import SwiftUI

struct ListItem: View {
    private let userName: String

    init(userName: String) {
        self.userName = userName
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(userName)
                .bold()
            GraphView(userName: userName)
        }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(userName: "hikaruaohara")
    }
}
