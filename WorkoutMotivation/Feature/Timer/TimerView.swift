//
//  TimerView.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 6/7/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerViewModel = TimerViewModel()
    
    var body: some View {
      if timerViewModel.isDisplaySetTimeView {
        SetTimerView(timerViewModel: timerViewModel)
              .background(CustomColor.SwiftUI.customBackgrond)
      } else {
        TimerOperationView(timerViewModel: timerViewModel)
              .background(CustomColor.SwiftUI.customBackgrond)
      }
        
    }
  }

  // MARK: - 타이머 설정 뷰
  private struct SetTimerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
      self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
      VStack {
//        TitleView()
          CustomHeaderView(title: "타이머") {
              EmptyView()
          }
          
//        Spacer()
//          .frame(height: 50)
        
        TimePickerView(timerViewModel: timerViewModel)
        
        Spacer()
//          .frame(height: 30)
        
        TimerCreateBtnView(timerViewModel: timerViewModel)
        
        Spacer()
      }
    }
  }

  // MARK: - 타이틀 뷰
  private struct TitleView: View {
    fileprivate var body: some View {
      HStack {
        Text("타이머")
          .font(.largeTitle)
          .fontWeight(.bold)
          .foregroundColor(CustomColor.SwiftUI.customBlack)
          .padding()
        
        Spacer()
      }
//      .padding(.horizontal, 10)
      .padding(.top, 0)
    }
  }

  // MARK: - 타이머 피커 뷰
  private struct TimePickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
      self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
      VStack {
//        Rectangle()
//          .fill(Color.customNavy3)
//          .frame(height: 1)
        
        HStack {
          Picker("Hour", selection: $timerViewModel.time.hours) {
            ForEach(0..<24) { hour in
              Text("\(hour)시")
            }
          }
          
          Picker("Minute", selection: $timerViewModel.time.minutes) {
            ForEach(0..<60) { minute in
              Text("\(minute)분")
            }
          }
          
          Picker("Second", selection: $timerViewModel.time.seconds) {
            ForEach(0..<60) { second in
              Text("\(second)초")
            }
          }
        }
        .labelsHidden()
        .pickerStyle(.wheel)
        
//        Rectangle()
//          .fill(Color.customNavy3)
//          .frame(height: 1)
      }
    }
  }

  // MARK: - 타이머 생성 버튼 뷰
  private struct TimerCreateBtnView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
      self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
      Button(
        action: {
          timerViewModel.settingBtnTapped()
        },
        label: {
          Text("시작")
                .frame(width: 140, height: 60)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(CustomColor.SwiftUI.customBlack)
                .background(CustomColor.SwiftUI.customGreen3)
                .cornerRadius(40)
        }
      )
    }
  }

  // MARK: - 타이머 작동 뷰
  private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
      self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
      VStack {
        ZStack {
          VStack {
            Text("\(timerViewModel.timeRemaining.formattedTimeString)")
              .font(.system(size: 28))
              .foregroundColor(CustomColor.SwiftUI.customBlack)
              .monospaced()
            
            HStack(alignment: .bottom) {
              Image(systemName: "bell.fill")
                    .foregroundColor(CustomColor.SwiftUI.customBlack)
              
              Text("\(timerViewModel.time.convertedSeconds.formattedSettingTime)")
                .font(.system(size: 16))
                .foregroundColor(CustomColor.SwiftUI.customBlack)
                .padding(.top, 10)
            }
          }
          
//          Circle()
//            .stroke(CustomColor.SwiftUI.customGreen, lineWidth: 6)
//            .frame(width: 350)
        }
        
        Spacer()
          .frame(height: 10)
        
        HStack {
          Button(
            action: {
              timerViewModel.cancelBtnTapped()
            },
            label: {
              Text("취소")
                .font(.system(size: 16))
                .foregroundColor(.pink)
                .padding(.vertical, 25)
                .padding(.horizontal, 22)
                .background(
                  Circle()
                    .fill(CustomColor.SwiftUI.customGreen3)
                )
            }
          )
          
          Spacer()
          
          Button(
            action: {
              timerViewModel.pauseOrRestartBtnTapped()
            },
            label: {
              Text(timerViewModel.isPaused ? "계속진행" : "일시정지")
                .font(.system(size: 14))
                .foregroundColor(CustomColor.SwiftUI.customBlack)
                .padding(.vertical, 25)
                .padding(.horizontal, 7)
                .background(
                  Circle()
                    .fill(CustomColor.SwiftUI.customGreen3)
                )
            }
          )
        }
        .padding(.horizontal, 20)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 화면을 채우기 위해 최대 크기로 설정
      .background(CustomColor.SwiftUI.customBackgrond) // 전체 View의 백그라운드 색상을 파란색으로 설정
      .edgesIgnoringSafeArea(.all) // safe area를 무시하여 전체 화면에 백그라운드 색상을 적용
    }
}

#Preview {
    TimerView()
}
