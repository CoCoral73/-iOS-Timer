//
//  ContentView.swift
//  MyTimer
//
//  Created by 김정원 on 2023/12/11.
//

import SwiftUI
import UIKit

let label = ["전파 탐지기(기본 설정)", "공상음", "공지음", "녹차", "놀이 시간", "느린 상승", "도입음", "물결", "반짝반짝", "실행 중단"]

//메인 뷰
struct TimerView: View {
    @State var viewSize = CGSize()
    
    @State private var hour = 1
    @State private var min = 0
    @State private var sec = 0
    
    @State private var isStart = false
    @State private var isPause = true
    @State private var btnText = "시작"
    
    @State private var isPresented = false
    @State private var selectedOption = 0
    @State private var tmpOption = 0

    var body: some View {
        VStack {
            //휠 피커
            SelectTimeView(selectedHour: $hour, selectedMin: $min, selectedSec: $sec, viewSize: $viewSize)
            
            Spacer().frame(height: 100)
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
                    isStart = true
                    isPause.toggle()
                    if isPause { btnText = "재개" }
                    else { btnText = "일시 정지" }
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
                }
                .buttonStyle(PlainButtonStyle())
                .disabled((hour == 0 && min == 0 && sec == 0) ?  true : false)
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
        }
        .background(.black)
    }
}

extension UIPickerView {
    func setPickerLabels(labels: [String]) { // [component number:label]
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = (UIScreen.main.bounds.size.width - 40) / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        var UILabels = [UILabel]()
        for i in 0..<self.numberOfComponents {
            let label = UILabel()
            label.text = labels[i]
            
            if self.subviews.contains(label) {
                label.removeFromSuperview()
            }
            
            label.font = UIFont.boldSystemFont(ofSize: fontSize)
            label.backgroundColor = .clear
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            UILabels.append(label)
        }
        
        UILabels[0].frame = CGRect(x: x + labelWidth * CGFloat(0.27), y: y, width: labelWidth, height: fontSize)
        UILabels[1].frame = CGRect(x: x + labelWidth * CGFloat(1.07), y: y, width: labelWidth, height: fontSize)
        UILabels[2].frame = CGRect(x: x + labelWidth * CGFloat(1.97), y: y, width: labelWidth, height: fontSize)
        self.addSubview(UILabels[0])
        self.addSubview(UILabels[1])
        self.addSubview(UILabels[2])
    }
}

//피커 뷰
struct SelectTimeView: UIViewRepresentable {
    typealias UIViewType = UIPickerView
    
    @Binding var selectedHour: Int
    @Binding var selectedMin: Int
    @Binding var selectedSec: Int
    @Binding var viewSize: CGSize
    
    let hour = [Int](0...23)
    let minute = [Int](0...59)
    let sec = [Int](0...59)
    
    func makeUIView(context: Context) -> UIPickerView {
        let view = UIPickerView()
        view.delegate = context.coordinator
        view.selectRow(1, inComponent: 0, animated: false)
        view.selectRow(0, inComponent: 1, animated: false)
        view.selectRow(0, inComponent: 2, animated: false)
        view.backgroundColor = .clear
        view.subviews[1].backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.25)
        view.setPickerLabels(labels: ["시간", "분", "초"])
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: SelectTimeView

        init(_ pickerView: SelectTimeView) {
            self.parent = pickerView
        }

        // UIPickerView의 컴포넌트 수를 반환합니다.
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            // 필요한 컴포넌트 수를 반환해주세요.
            return 3
        }

        // 각 컴포넌트의 항목 수를 반환합니다.
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            // 필요한 항목 수를 반환해주세요.
            if component == 0 { return 24 }
            else if component == 1 { return 60 }
            else { return 60 }
        }

        // 각 항목의 내용을 반환합니다.
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            // 필요한 항목의 내용을 반환해주세요.
            if component == 0 { return String(parent.hour[row]) }
            else if component == 1 { return String(parent.minute[row]) }
            return String(parent.sec[row])
        }
        
        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let title: String
            switch component {
            case 0:
                title = String(parent.hour[row])
            case 1:
                title = String(parent.minute[row])
            default:
                title = String(parent.sec[row])
            }
            
            let attributes: [NSAttributedString.Key: Any] = [ .foregroundColor: UIColor.white ]
            return NSAttributedString(string: title, attributes: attributes)
        }
        
        // 항목이 선택되었을 때 호출되는 메서드입니다.
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 { parent.selectedHour = parent.hour[row] }
            else if component == 1 { parent.selectedMin = parent.minute[row] }
            else { parent.selectedSec = parent.sec[row] }
        }
        
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

