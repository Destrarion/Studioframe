//
//  FileDownloadingView.swift
//  Studioframe
//
//  Created by Sylvain Dietrich on 26/04/2022.
//

import Foundation
import SwiftUI

struct FileDownloadingView: View {
    
    @ObservedObject var viewModel: LibraryObjectViewModel
    
    var body: some View {
        VStack {
            ProgressView(value: Double(viewModel.downloadProgress) / 100.0)
                .progressViewStyle(.linear)
            Button("Stop") {
                viewModel.didTapStopDownload()
            }
        }
    }
}
