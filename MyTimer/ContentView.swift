//
//  ContentView.swift
//  MyTimer
//
//  Created by 김정원 on 2023/12/11.
//

import SwiftUI

let label = ["전파 탐지기(기본 설정)", "공상음", "공지음", "녹차", "놀이 시간", "느린 상승", "도입음", "물결", "반짝반짝", "실행 중단"]

//메인 뷰
struct TimerView: View {
    @State private var isPresented = false
    @State private var selectedOption = 0
    @State private var tmpOption = 0
    @State private var isStart = false
    @State private var isPause = true
    @State private var btnText = "시작"
    
    var body: some View {
        VStack {
            //버튼
            HStack {
                Spacer().frame(width: 20)
                Button(action: {
                    if isStart { isStart = false; isPause = true; btnText = "시작" }
                }) {
                    Text("취소")
                        .padding(0)
                        .frame(width: 80, height: 80)
                        .foregroundColor(isStart ? Color.white : Color("cancel_font"))
                        .background(Color("cancel_background"))
                        .clipShape(Circle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 43).stroke(Color("cancel_background"), lineWidth: 2).frame(width: 86, height: 86)
                        )
                }.buttonStyle(PlainButtonStyle())
                Spacer()
                Button(action: {
                    if !isStart { isStart.toggle(); isPause.toggle(); btnText = "일시 정지" }
                    else {
                        isPause.toggle()
                        if isPause { btnText = "재개" }
                        else { btnText = "일시 정지" }
                    }
                }) {
                    Text(btnText)
                        .padding(0)
                        .frame(width: 80, height: 80)
                        .foregroundColor(!isPause ? Color("check") : Color("start_font"))
                        .background(!isPause ? Color("stop_background") : Color("start_background"))
                        .clipShape(Circle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 43).stroke(!isPause ? Color("stop_background") : Color("start_background"), lineWidth: 2).frame(width: 86, height: 86)
                        )
                }.buttonStyle(PlainButtonStyle())
                Spacer().frame(width: 20)
            }
            
            //List 버튼
            List {
                Button(action: {
                    isPresented.toggle()
                }) {
                    HStack {
                        Text("타이머 종료 시").foregroundColor(.white)
                        Spacer()
                        Text(label[selectedOption]).foregroundColor(Color("button_font"))
                        Image(systemName: "chevron.right").foregroundColor(Color("chevron_right"))
                    }
                }
                .sheet(isPresented: $isPresented, content: {
                    PickerView(isPresented: $isPresented, selectedOption: $selectedOption, tmpOption: $tmpOption)
                })
                .listRowBackground(Color("button_background"))
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
        }.background(.black)
    }
}

//동작 선택 뷰
struct PickerView: View {
    @Binding var isPresented: Bool
    @Binding var selectedOption: Int
    @Binding var tmpOption: Int
    let checkmark = Image(systemName: "checkmark")
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach((0..<label.count-1), id: \.self) { index in
                        Button(action: {
                            tmpOption = index
                        }) {
                            HStack {
                                if tmpOption == index { checkmark.foregroundColor(Color("check")) }
                                else { checkmark.hidden() }
                                Text(label[index]).foregroundColor(.white)
                            }
                        }.listRowBackground(Color("rowColor"))
                    }
                }
                Section {
                    Button(action: {
                        tmpOption = label.count-1
                    }) {
                        HStack {
                            if tmpOption == label.count-1 {
                                checkmark.foregroundColor(Color("check"))
                            }
                            else { checkmark.hidden() }
                            Text(label.last!).foregroundColor(.white)
                        }
                    }.listRowBackground(Color("rowColor"))
                }
            }.background(Color("scroll_background"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        tmpOption = selectedOption
                        isPresented.toggle()
                    }) { Text("취소").foregroundColor(Color("check")) }
                }
                ToolbarItem(placement: .principal) { Text("타이머 종료 시").foregroundColor(Color.white) }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedOption = tmpOption
                        isPresented.toggle()
                    }) { Text("설정").foregroundColor(Color("check")) }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("tabbar"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()//.ignoresSafeArea()
    }
}
