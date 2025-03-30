//
//  View+ReaderStyles.swift
//  MVP
//
//  Created by Daniela Caiceros on 30/03/25.
//

import Foundation
import SwiftUI

extension View {
    func readerContentStyle(viewModel: BookReaderViewModel) -> some View {
        self
            .font(viewModel.fontType.font)
            .font(.system(size: viewModel.fontSize))
            .foregroundColor(viewModel.selectedTheme.textColor)
            .lineSpacing(viewModel.lineSpacing)
           
    }
    
    }
