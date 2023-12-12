//
//  ContentView.swift
//  MyTimer
//
//  Created by 김정원 on 2023/12/11.
//

import SwiftUI

let label = ["전파 탐지기(기본 설정)", "공상음", "공지음", "녹차", "놀이 시간", "느린 상승", "도입음", "물결", "반짝반짝", "실행 중단"]

struct TimerView: View {
    @State private var isPresented = false
    @State private var selectedOption = 0
    @State private var tmpOption = 0
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                Button(action: {
                    
                }) {
                    Text("취소")
                        .padding(25)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("cancel_font"))
                        .background(Color("cancel_background"))
                        .clipShape(Circle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 43).stroke(Color("cancel_background"), lineWidth: 2).frame(width: 86, height: 86)
                        )
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Text("시작")
                        .padding(25)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color("start_font"))
                        .background(Color("start_background"))
                        .clipShape(Circle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 43).stroke(Color("start_background"), lineWidth: 2).frame(width: 86, height: 86)
                        )
                }
                Spacer().frame(width: 20)
            }
            List {
                Button(action: {
                    isPresented.toggle()
                }) {
                    HStack {
                        Text("타이머 종료 시").foregroundColor(.black)
                        Spacer()
                        Text(label[selectedOption]).foregroundColor(Color(uiColor: UIColor.darkGray))
                        Image(systemName: "chevron.right").foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $isPresented, content: {
                    PickerView(isPresented: $isPresented, selectedOption: $selectedOption, tmpOption: $tmpOption)
                })
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
        }.background(.black)
    }
}

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
                                if tmpOption == index { checkmark.foregroundColor(.orange) }
                                else { checkmark.hidden() }
                                Text(label[index]).foregroundColor(.black)
                            }
                        }
                    }
                }
                Section {
                    Button(action: {
                        tmpOption = label.count-1
                    }) {
                        HStack {
                            if tmpOption == label.count-1 {
                                checkmark.foregroundColor(.orange)
                            }
                            else { checkmark.hidden() }
                            Text(label.last!).foregroundColor(.black)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        tmpOption = selectedOption
                        isPresented.toggle()
                    }) { Text("취소") }
                }
                ToolbarItem(placement: .principal) { Text("타이머 종료 시") }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedOption = tmpOption
                        isPresented.toggle()
                    }) { Text("설정") }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(uiColor: UIColor.white), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()//.ignoresSafeArea()
    }
}
