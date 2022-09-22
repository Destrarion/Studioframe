//
//  OnboardingView.swift
//  Studioframe
//
//  Created by Fabien Dietrich on 18/08/2022.
//

import AVKit
import Foundation
import SwiftUI
//
//struct OnboardingPageView: View {
//    let viewModel: OnboardingPageViewModel
//
//
//
//    var body: some View {
//        VStack {
//            Spacer(minLength: 225)
//            Text(viewModel.title)
//                .font(.system(size: 40))
//            Spacer()
//            Text(viewModel.subtitle)
//            Spacer(minLength: 200)
//            Button(viewModel.buttonTitle) {
//                viewModel.onButtonTap()
//            }
//            Spacer(minLength: 50)
//        }
//        .tag(viewModel.tag)
//    }
//}
//
//
//struct OnboardingPageViewModel {
//    let tag: Int
//    let title: String
//    let subtitle: String
//    let buttonTitle: String
//    let onButtonTap: () -> Void
//}
//
//
//final class OnboardingViewModel: ObservableObject {
//    @Published var selectedOnboardingTag = 0
//
//    private func increaseTag() {
//        selectedOnboardingTag += 1
//    }
//
//    lazy var onboardingPageViewModels: [OnboardingPageViewModel] = [
//        .init(tag: 0, title: "Title 0", subtitle: "subtitle 0", buttonTitle: "Button 0", onButtonTap: { [weak self] in self?.increaseTag()}),
//        .init(tag: 1, title: "Title 1", subtitle: "subtitle 1", buttonTitle: "Button 1", onButtonTap: { [weak self] in self?.increaseTag()})
//    ]
//}

struct OnboardingView: View {
    
    @Binding var hasSeenOnboarding: Bool
    @State var selectedOnboardingTag = 0 // to be commented if viewmodel

    // @StateObject var viewModel = OnboardingViewModel()
    
    var body: some View {
        TabView(selection: $selectedOnboardingTag) {
//            ForEach(viewModel.onboardingPageViewModels, id: \.tag) { onboardingPageViewModel in
//                OnboardingPageView(viewModel: onboardingPageViewModel)
//            }
            
            
            

            VStack {
                Spacer(minLength: 225)
                Text("Welcome to StudioFrame!")
                    .font(.system(size: 40))
                Spacer()
                Text("An Augmented Reality app for your house !")
                Spacer(minLength: 200)
                Button("Continue") {
                    selectedOnboardingTag = 1
                }
                Spacer(minLength: 50)
            }
            .tag(0)

            VStack {
                Spacer(minLength: 225)
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 200, height: 150)
                    .foregroundColor(.gray)
                Spacer()
                Text("Set 3D model in your room !")
                Spacer()
                Button("Continue") {
                    selectedOnboardingTag = 2
                }
                Spacer(minLength: 50)
            }
            .tag(1)


            VStack {
                Spacer(minLength: 225)
                Image(systemName: "text.book.closed.fill")
                    .resizable()
                    .frame(width: 145, height: 145)
                    .foregroundColor(.orange)
                Spacer()
                Text("Download and set your favorite 3D objets !")
                Spacer()
                Button("Continue") {
                    selectedOnboardingTag = 3
                }
                Spacer(minLength: 50)
            }
            .tag(2)

            VStack {
                Spacer()
                //let url = URL(fileURLWithPath: Bundle.main.path(forResource: "OnboardingLibraryPress", ofType: "mp4")!)
                //VideoPlayer(player: AVPlayer(url: url))
                Spacer()
                Text("Open the Library for more Object !")
                Spacer()
                Button("Start") {
                    hasSeenOnboarding = true
                }
                Spacer(minLength: 50)
            }
            .tag(3)
        }
        .tabViewStyle(.page)
    }
}
