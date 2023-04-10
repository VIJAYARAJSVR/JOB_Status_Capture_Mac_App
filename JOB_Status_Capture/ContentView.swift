//
//  ContentView.swift
//  JOB_Status_Capture
//
//  Created by Web_Dev on 4/10/23.



//    company --->  Command + O
//
//    Designation--->  Command + D
//
//    URL--->  Command + U
//
//    Experience--->  Command + E
//
//    Salary--->  Command + L
//
//    Email--->  Command + M
//
//    Website--->  Command + B
//
//    Skills --->  Command + I
//
//    Description --->  Command + R

//    Save --->  Command + S
//
//    Clear --->  Command + K



import SwiftUI
import CoreData

struct MainView: View {
    
    @State var aniAttempts: Int = 0
    @State var aniStatusInfo: Int = 0
    @State private var isPresented: Bool = false
    
    
    @State var Company:String = ""
    @State var Designation:String = ""
    @State var Status:String = ""
    @State var StatusID:String = ""
    @State var Source:String = ""
    
    
    //    @State var JOBSource:String = "Others"
    //    @State var JOBStatus:String = "Viewed"
    //    @State var JOBFrom:String = "Outlook"
    
    @State var JOBSource:String = ""
    @State var JOBStatus:String = ""
    @State var JOBFrom:String = ""
    
    @State var Email:String = ""
    @State var Website:String = ""
    @State var Skills:String = ""
    @State var Description:String = ""
    //@State var PostedDate:String = ""
    
    
    @State var AppliedDate:String=""
    @State var AppliedTime:String=""
    
    
    
    let arrJobSource = ["Linkedin","Bayt","Glassdoor","Indeed","Naukri","Monster","Others"]
    
    let arrJobStatus = ["Viewed","MyEffort","Phone","Interview","Rejected"]
    
    let arrJobFrom = ["Outlook","Website","Manually"]
    
    
    enum CopyContent:Error {
        case notExist
    }
    enum SaveStatus:Error {
        case Success
        case Failure
    }
    //    let jobsource_columns = [
    //        GridItem(.flexible()),
    //        GridItem(.flexible()),
    //        GridItem(.flexible()),
    //        GridItem(.flexible()),
    //    ]
    
    let jobsource_columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    let jobstatus_columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    let jobfrom_columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    
    
    func CopyFromClipboard_Paste() throws -> String {
        let p = NSPasteboard.general
        let x = p.readObjects(forClasses: [NSString.self], options: nil)
        let s = x as! [NSString]
        
        if 0 < s.count {
            return s[0] as String
        }
        throw CopyContent.notExist
        
        
    }
    
    @State var bwidth:Int = 0
    
    @State var selectedPortalButtonIndex:Int = -1
    @State var selectedStatusButtonIndex:Int = -1
    @State var selectedFromButtonIndex:Int = -1
    
    @State var statusInfo = "Not Yet Saved"
    @State var status = SaveStatus.Failure
    
    func ClearAllState() {
        
        Company = ""
        Designation = ""
        Status = ""
        StatusID = ""
        Source = ""
        
        Description = ""
        JOBSource = ""
        JOBStatus = ""
        JOBFrom = ""
        
        selectedPortalButtonIndex = -1
        selectedStatusButtonIndex = -1
        selectedFromButtonIndex = -1
    }
    
    
    func save_From_JSON_Object(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
    
    func save_From_JSON_Data(data: Data, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            try data.write(to: fileURL, options: [.atomicWrite])
            statusInfo = "Saved Successfully"
            ClearAllState()
            return true
        }
        
        return false
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        print(documentsDirectory)
        
        return documentsDirectory
    }
    
    func Get_Current_DateTime_forFileName() -> String {
        let dt = Date()
        let dateFormatter = DateFormatter()
        // Set Date/Time Style
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "dd_MM_YYYY"
        let currentDate = dateFormatter.string(from: dt)
        
        
        dateFormatter.dateFormat = "hh:mm:ss"
        let time = dateFormatter.string(from: dt)
        
        //         let AMPM = hrs >= 12 ? `PM` : `AM`;
        //         hrs = (hrs - 12 * parseInt(hrs / 12));
        //         hrs = hrs ? hrs : 12;
        //         mnts = mnts < 10 ? `0` + mnts : mnts;
        
        let arrTime = time.components(separatedBy: ":")
        var hrs = Int(arrTime[0])!
        let mnts = Int(arrTime[1])!
        let sec = Int(arrTime[2])!
        
        let AMPM = (hrs >= 12) ? "PM": "AM";
        hrs = hrs - 12 * (hrs / 12)
        hrs = (hrs != 0) ? hrs : 12
        
        let minutes = (mnts < 10) ? "0" + String(mnts) : String(mnts)
        
        //Applied_JOB_info 28_01_2023  2_24 AM  45 sec
        
        let current_DateTime = currentDate+"  "+String(hrs)+"_"+minutes+" "+AMPM+"  "+String(sec)+" sec"
        
        return current_DateTime
        
    }
    
    
    
    
    
    
    func ReadFromClipboard() -> String {
        do {
            if let result =  try? CopyFromClipboard_Paste() {
                return result
            }
            throw CopyContent.notExist
        }
        catch let error {
            switch error{
                
            case CopyContent.notExist :
                print("not Exist")
                return ""
            default:
                print("default")
                return ""
            }
        }
    }
    
    
    
    
    var body: some View {
        VStack
        {
            ScrollView {
                VStack {

                    VStack {

                        HStack{
                            Text(JOBSource=="" ? "" : "You have selected : \(JOBSource)  \(JOBStatus.uppercased())  \(JOBFrom) " ).font(.largeTitle).foregroundColor(.yellow) .modifier(Shake(animatableData: CGFloat(aniAttempts)))

                            Spacer()
                        }


                    } .padding()

                    Spacer()

                    Group {

                        ScrollView {
                            LazyVGrid(columns: jobsource_columns, spacing: 13) {

                                ForEach(arrJobSource.indices, id: \.self) { index in

                                    let item = arrJobSource[index]


                                    Text(item)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 7)
                                        .frame(minWidth: 30)
                                        .clipped()
                                        .background(Color(item).opacity(0.5))
                                        .foregroundColor(.primary)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        }
                                        .padding(.bottom, 0)
                                        .font(.largeTitle)
                                        .border(.red, width: CGFloat(bwidth))
                                        .border(.red, width: CGFloat((selectedPortalButtonIndex == index) ? 4 : 0))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            print(" jobsource pressed \(item)")
                                            JOBSource = item
                                            bwidth = 0
                                            selectedPortalButtonIndex = index
                                            withAnimation(.default) {self.aniAttempts += 1}
                                        }


                                }

                            }
                            .padding(.horizontal)
                        }

                        Divider()
                        
                        

                        HStack {

                            let kequi:KeyEquivalent = "o"
                            PasteButtonView(keyshortcut: kequi,stateVariable:$Company,kkey:"O")


                            Spacer()
                                .frame(width: 10)
                                .clipped()

                            Text("Company")
                                .frame(width: 150, alignment: .leading)
                                .clipped()
                                .font(.largeTitle)


                            Spacer()
                                .frame(width: 10)
                                .clipped()

                            TextField("Company", text: $Company).textFieldStyle(CustomTextFieldStyle())
                            Spacer()
                        }
                        .padding()

                        HStack {

                            let kequi:KeyEquivalent = "d"
                            PasteButtonView(keyshortcut: kequi,stateVariable:$Designation,kkey:"D")


                            Spacer()
                                .frame(width: 10)
                                .clipped()
                            Text("Designation")
                                .frame(width: 150, alignment: .leading)
                                .clipped()
                                .font(.largeTitle)
                                .multilineTextAlignment(.leading)
                            Spacer()
                                .frame(width: 10)
                                .clipped()

                            TextField("Designation", text: $Designation).textFieldStyle(CustomTextFieldStyle())
                            Spacer()
                        }
                        .padding()

                        Divider()
                        
                        

                        HStack{

                            Text("Please select the below Status :")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Spacer()


                        }.padding()

                        ScrollView {
                            LazyVGrid(columns: jobstatus_columns, spacing: 1) {

                                ForEach(arrJobStatus.indices, id: \.self) { index in

                                    let item = arrJobStatus[index]


                                    Text(item)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .frame(minWidth: 20)
                                        .clipped()
                                        .background(Color(item).opacity(0.5))
                                        .foregroundColor(.primary)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        }
                                        .padding(.bottom, 0)
                                        .font(.largeTitle)
                                        .border(.red, width: CGFloat(bwidth))
                                        .border(.red, width: CGFloat((selectedStatusButtonIndex == index) ? 5 : 0))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            print(" jobstatus pressed \(item)")
                                            JOBStatus = item
                                            bwidth = 0
                                            selectedStatusButtonIndex = index
                                            withAnimation(.default) {self.aniAttempts += 1}
                                        }


                                }

                            }
                            .padding(.horizontal)
                        }

                        Divider()
                        
                        
                        
                        
                        HStack{

                            Text("Please select the below Location ")
                                .font(.largeTitle)
                                .foregroundColor(.white)

                            Text("(From where you got the above information) :")
                                .foregroundColor(.white)

                            Spacer()

                        }.padding()
                        
                        ScrollView {
                            LazyVGrid(columns: jobfrom_columns, spacing: 1) {

                                ForEach(arrJobFrom.indices, id: \.self) { index in

                                    let item = arrJobFrom[index]


                                    Text(item)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .frame(minWidth: 20)
                                        .clipped()
                                        .background(Color(item).opacity(0.5))
                                        .foregroundColor(.primary)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        }
                                        .padding(.bottom, 0)
                                        .font(.largeTitle)
                                        .border(.red, width: CGFloat(bwidth))
                                        .border(.red, width: CGFloat((selectedFromButtonIndex == index) ? 5 : 0))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            print(" jobstatus pressed \(item)")
                                            JOBFrom = item
                                            bwidth = 0
                                            selectedFromButtonIndex = index
                                            withAnimation(.default) {self.aniAttempts += 1}
                                        }


                                }

                            }
                            .padding(.horizontal)
                        }
 
                       
                        
                        
                        

                    }
                }
                .clipped()
                .background(Color(.sRGB, red: 40/255, green: 44/255, blue: 51/255))
            }
            .padding()
            
            Text(statusInfo)
                .padding(.vertical, 12)
                .padding(.horizontal, 34)
                .foregroundColor(.yellow)
                .padding(.bottom, 0)
                .font(.largeTitle)
                .modifier(Shake(animatableData: CGFloat(aniStatusInfo)))
            
            
            
            HStack {
                Spacer()
                Button("Save") {

                    withAnimation(.default) {self.aniStatusInfo += 1}
                    
                }    .keyboardShortcut("s", modifiers: [.command])
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 34)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                
                    .background(.orange.opacity(0.5))
                    .buttonStyle(PlainButtonStyle())
                    .mask {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                    }
                    .disabled(Company=="" || Designation == "")
                Spacer()
                    .frame(width: 40)
                    .clipped()
                
                
                Button("Clear") {
                    ClearAllState()
                }    .keyboardShortcut("k", modifiers: [.command])
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 34)
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
                    .background(.orange.opacity(0.5))
                    .buttonStyle(PlainButtonStyle())
                    .mask {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                    }
                
                Spacer()
            }
            .padding()
            .padding(.bottom, 40)
            
            .clipped()
            
            
        }
        
    }
    
}


struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height:35)
            .clipped()
            .font(.largeTitle)
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color("ClrTxtField"), Color("ClrTxtField")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.black)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 4)
        
    }
}


struct JOBCapture_Previews: PreviewProvider {
    static var previews: some View {
        MainView().frame(width:700,height: 1000,alignment: .center)
    }
}


struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                              y: 0))
    }
}



