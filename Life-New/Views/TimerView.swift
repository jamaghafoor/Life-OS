//
//  TimerView.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 05/02/24.
//

import SwiftUI


struct TimerView: View {
    @AppStorage(SessionKeys.language) var language = LocalizationService.shared.language
    @AppStorage(SessionKeys.selectedTime) var selectedTime = 0.0
    @EnvironmentObject var player : PlayerViewModel
    @StateObject var vm = TimerViewModel()
    var onClose: ()->() = {}
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 15) {
                CommonTopView(title: .setTimer)
                Text(String.minutes.localized(language))
                    .poppinsRegular(16)
                    .foregroundColor(.mySecondary)
                GeometryReader { geo in
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 0) {
                            ForEach(times,id: \.self) { time in
                                let size = geo.size.width / 5
                                Text("\(Int(time)/60)")
                                    .poppinsMedium(20)
                                    .foregroundColor(.mySecondary)
                                    .maxFrame()
                                    .addDarkBackGround()
                                    .clipShape(.circle)
                                    .padding(2)
                                    .background(vm.preferredTime == time ? Color.customBlue : Color.myLightText)
                                    .clipShape(.circle)
                                    .onTap {
                                        vm.preferredTime = time
                                        vm.showTimerPicker = false
                                        print(vm.preferredTime)
                                    }
                                    .padding(2)
                                    .frame(width: size,height: size)
                            }
                        }
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.darkBlue, Color.customBlue, Color.darkBlue]),
                                startPoint: .leading,
                                endPoint: .trailing))
                            .frame(maxWidth: .infinity)
                            .frame(height: 1.5)
                        HStack {
                            Text(String.customTimer.localized(language))
                                .poppinsRegular(14)
                                .foregroundColor(.mySecondary)
                            Spacer()
                            if !vm.showTimerPicker {
                                Image.addWithCircle
                                    .resizeFitTo(renderingMode: .template,height: 25)
                                    .foregroundColor(.mySecondary)
                                    .onTap {
                                        vm.showTimerPicker = true
                                    }
                            } else {
                                Image.minusWithCircle
                                    .resizeFitTo(renderingMode: .template,height: 25)
                                    .foregroundColor(.mySecondary)
                                    .onTap {
                                        vm.showTimerPicker = false
                                    }
                            }
                        }
                        if vm.showTimerPicker {
                            CustomTimePicker(hourSelection: $vm.hourSelection, minuteSelection: $vm.minuteSelection)
                                .frame(height: 150)
                                .onChange(of: [vm.hourSelection, vm.minuteSelection]) { values in
                                    let hour = Double(values.first ?? 0) * 3600
                                    let minute = Double(values.last ?? 0) * 60
                                    vm.preferredTime = hour + minute
                                }
                        }
                    }
                }
                Spacer()
                timerBottomSetButton(vm: vm)
            }
            .maxFrame()
        }
        .onAppear(perform: {
            if player.isTimerOn == true {
                vm.preferredTime = selectedTime
            } else {
                vm.preferredTime = 0.0
            }
        })
        .padding(.bottom,Device.bottomSafeArea)
        .padding(.top,Device.topSafeArea)
        .ignoresSafeArea()
        .padding(.horizontal)
        .hideNavigationbar()
        .addDarkBackGround()
    }

}

#Preview {
    TimerView()
}

struct timerBottomSetButton : View {
    
    @EnvironmentObject var player: PlayerViewModel
    @StateObject var vm: TimerViewModel
    @AppStorage(SessionKeys.selectedTime) var selectedTime = 0.0

    var body: some View {
        if vm.preferredTime != selectedTime && vm.preferredTime != 0.0 {
            CustomGradientButton(title: .setTimer){
                player.isTimerOn = true
                player.timerTime = 0.0
                player.timerTime = vm.preferredTime
                selectedTime = vm.preferredTime
                Navigation.pop()
            }
            .padding(.bottom,10)
        } else if vm.preferredTime != 0.0 && player.isTimerOn == false {
            CustomGradientButton(title: .setTimer){
                player.isTimerOn = true
                player.timerTime = 0.0
                player.timerTime = vm.preferredTime
                selectedTime = vm.preferredTime
                Navigation.pop()
            }
            .padding(.bottom,10)
        } else {
            CustomGradientButton(title: .setTimer,backgroundColor: LinearGradient(colors: [.darkBlueThree], startPoint: .top, endPoint: .bottom),textColor: .myLightText,borderColor: .lightBorder)
                .padding(.bottom,10)
        }
    }
}

struct CustomTimePicker: View {
    @Binding var hourSelection: Int
    @Binding var minuteSelection: Int
    
    static private let maxHours = 23
    static private let maxMinutes = 59
    private let hours = [Int](0...Self.maxHours)
    private let minutes = [Int](0...Self.maxMinutes)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: .zero) {
                HStack {
                    Picker(selection: $hourSelection, label: Text("")) {
                        ForEach(hours, id: \.self) { value in
                            Text("\(value)")
                                .tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width / 2 - 40, alignment: .center)
                    Text("hr")
                        .poppinsMedium(20)
                        .foregroundColor(.mySecondary)
                }
                HStack {
                    Picker(selection: $minuteSelection, label: Text("")) {
                        ForEach(minutes, id: \.self) { value in
                            Text("\(value)")
                                .tag(value)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width / 2 - 40, alignment: .center)
                    Text("min")
                        .poppinsMedium(20)
                        .foregroundColor(.mySecondary)
                }
            }
            
        }
    }
}
